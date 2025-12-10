classdef (Abstract) BasePrefHandler < handle
% BASEPREFHANDLER handles the preferences data for the Controller
% objects.

%   Copyright 2022-2023 The MathWorks, Inc.

    properties (Abstract,Constant,Hidden)
        % PrefsType - The preferences name for the specific controller that
        % contains the saved controller properties in the preferences.
        PrefsType (1,1) string

        % Vendor - The vendor name for the specific controller.
        Vendor (1,1) string

        % VendorListName - The name of the list function for the specific
        % controller.
        VendorListName (1,1) string

        % List of properties that need to be saved in the Instrument
        % Preferences for the controller.
        PreferencesPropertiesList (1,:) string
    end

    methods (Abstract)
        % Should return a table list of controllers connected to the host
        % machine.
        controllerList = getList(obj)

        % Should clear the preferences for the controller.
        clearPreferencesData(obj)
    end

    properties (Constant,Hidden,Access = protected)
        % GroupName - The preference group name that saves the controller
        % properties in the preferences.
        GroupName (1,1) string = "instrument_preferences"
    end

    properties (Access = ...
                {?serialcontroller.internal.common.BasePrefHandler,?instrument.internal.ITestable})
        % PreferencesHandler - Handle to the PreferencesHelper utility.
        PreferencesHandler
    end

    methods
        function obj = BasePrefHandler(varargin)
        % BASEPREFHANDLER constructor instantiates the
        % internal Preferences Helper instance, or assigns the passed
        % in Preferences handler to PreferencesHandler.
            narginchk(0,1);

            if nargin == 0
                obj.PreferencesHandler = ...
                    internal.PreferencesHelper(obj.GroupName,obj.PrefsType);
            else
                obj.PreferencesHandler = varargin{1};
            end
        end

        function [serialNumber,nvPairs] = parsePreferencesHandler(obj)
        % Parse the data received from Preferences Helper,
        % validates the data, and returns it back to controller.

            try
                % Get the data from the Preferences Meta Data
                basePrefData = obj.PreferencesHandler.getData();

                % These method names need to be present in the controller
                % preferences.
                fieldsTocheck = obj.PreferencesPropertiesList;

                % Create a connection to the first available controller in
                % the list of found controllers when no last saved
                % preferences were found or when all Preferences properties
                % are not present in the data received from Preferences Handler.
                if isempty(basePrefData) || ...
                        sum(isfield(basePrefData,fieldsTocheck)) ~= length(fieldsTocheck)
                    % Returns serialNumber of first controller that is
                    % available to use in the list of found controllers.
                    serialNumber = getFirstAvailableControllerSerialNumber(obj);
                    nvPairs = {};
                else
                    % Parses controller preference data to get properties
                    % and name-value pairs.
                    [serialNumber,nvPairs] = parsePrefData(obj,basePrefData);
                end
            catch ex
                throwAsCaller(ex);
            end
        end

        function updatePreferences(obj,preferencesData)
        % Update the Preferences Handler with the latest properties
        % from the controller.
            obj.PreferencesHandler.setData(preferencesData);
        end

        function delete(obj)
            if ~isempty(obj.PreferencesHandler)
                obj.PreferencesHandler = [];
            end
        end
    end

    methods (Access = protected)
        function serialNumber = getFirstAvailableControllerSerialNumber(obj)
        % Returns serialNumber of first controller that is available to
        % use in the list of found controllers.

        % Get list of all controllers connected to host machine and
        % return the first available controller.
            controllerList = getList(obj);

            % Error if no controllers were found.
            if isempty(controllerList)
                throw(MException(message("instrument:interface:serialcontroller:UnableToFindControllers")));
            end

            serialNumber = [];

            % Loop through the controllers found connected to the host
            % machine and attempt a connection to the first available controller.
            for i = controllerList.SerialNumber'
                channelDetails = serialcontroller.internal.utility.SerialControllerUtility.getChannelCreationInfo(obj.Vendor,i);
                host = matlabshared.asyncio.internal.Host;
                channel = host.createChannel(channelDetails.DevicePlugin,channelDetails.ConverterPlugin,Options = channelDetails.Options,StreamLimits = [inf,inf]);

                try
                    % Attempt controller connection.
                    channel.execute("ControllerOpen");
                catch
                    % If current controller connection is not successful
                    % then attempt connection with the next controller found.
                    continue
                end

                % Close controller connection if connection succeeded.
                channel.execute("ControllerClose");

                % Save serialNumber of controller for successful controller
                % connection.
                serialNumber = i;
                break
            end

            % Error if no found controllers could be connected to successfully.
            if isempty(serialNumber)
                throw(MException(message("instrument:interface:serialcontroller:UnableToFindAvailableControllers")));
            end
        end

        function [serialNumber,nvPairs] = parsePrefData(obj,basePrefData)
        % Save controller preference data to properties and name-value pairs.

            if basePrefData.SerialNumber == ""
                % clear preferences and throw error that
                % preferences are corrupted.
                clearPreferencesData(obj);
                throw(MException(message("instrument:interface:serialcontroller:UnableToCreateControllerObject",obj.Vendor,obj.VendorListName)));
            end

            % Save the SerialNumber
            serialNumber = basePrefData.SerialNumber;

            % Remove the SerialNumber from other properties and keep
            % the other properties as a cell array of name-value pairs.
            basePrefData = rmfield(basePrefData,"SerialNumber");

            % propertyNames = fieldnames(basePrefData);
            propertyNames = string(fieldnames(basePrefData));

            nvPairs = {};
            for prop = propertyNames'
                if validateNonEmptyProp(obj,basePrefData.(prop))
                    nvPairs{end+1} = prop; %#ok<*AGROW>
                    nvPairs{end+1} = basePrefData.(prop);
                end
            end
        end
    end

    methods (Access = private)
        function result = validateNonEmptyProp(~,propVal)
        % Validate that property value saved in preferences is not
        % empty.
            result = ~(isempty(propVal) || ...
                       (isstring(propVal) && propVal == ""));
        end
    end
end
