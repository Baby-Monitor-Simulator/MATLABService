classdef (Abstract) Controller < matlabshared.transportapp.internal.toolstrip.write.Controller
    % CONTROLLER contains UDP specific properties and methods for
    % the write section of the toolstrip. Implements common functionality
    % for both byte and datagram mode.
    % NOTE: Overrides or uses the following shared-app properties and methods:
    %       - Comment (property)
    %       - EnclosingDoubleQuotes (property)
    %       - WorkspaceVariableWrite (property)
    %       - Controller()
    %       - subscribeToMediatorProperties()
    %       - writeButtonPressed()
    %       - createWriteCommentAndCode()
    %       - generateWriteCode()

    % Copyright 2021-2023 The MathWorks, Inc.

    properties(Access = {?matlabshared.transportapp.internal.utilities.ITestable, ...
            ?transportapp.udpport.internal.common.toolstrip.write.Controller})
        % Maintain copies of the destination address and destination port
        % defining the current endpoint for generating the write code and
        % comment.
        DestinationAddress (1,1) string
        DestinationPort (1,1) string

        TransportInstance   (1,1) string
    end

    properties(SetObservable)
        % Published properties to produce code for the write action.
        % NOTE: Comment property is already defined in the shared-app write
        % controller.
        Code
        NewLine
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration, additionalParams)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration

                % additionalParams contains the transport name and
                % instance, and initial Destination address and port.
                additionalParams cell
            end

            obj@matlabshared.transportapp.internal.toolstrip.write.Controller(mediator, viewConfiguration);

            obj.TransportInstance = additionalParams{1};
            obj.DestinationAddress = additionalParams{2};
            obj.DestinationPort = additionalParams{3};
        end
    end

    %% Implementing Subscriber Abstract Methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            subscribeToMediatorProperties@matlabshared.transportapp.internal.toolstrip.write.Controller(obj);

            obj.subscribe("DestinationAddress", ...
                @(src, event)obj.setDestinationAddress(event));
            obj.subscribe("DestinationPort", ...
                @(src, event)obj.setDestinationPort(event));
        end
    end

    %% Subscriber Handlers
    methods
        function setDestinationAddress(obj, event)
            % The TransportProxy already validated this address.
            obj.DestinationAddress = event.AffectedObject.DestinationAddress;
        end

        function setDestinationPort(obj, event)
            % The TransportProxy already validated this port.
            obj.DestinationPort = event.AffectedObject.DestinationPort;
        end
    end

    %% Listener Methods
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function writeButtonPressed(obj, ~, ~)
            % Check before calling superclass method to ensure that
            % destination address or port are not empty.
            try
                if obj.DestinationAddress == ""
                    throw(MException(message("transportapp:udpportapp:EmptyAddressOrPort", "DestinationAddress")));
                elseif obj.DestinationPort == ""
                    throw(MException(message("transportapp:udpportapp:EmptyAddressOrPort", "DestinationPort")));
                end
            catch ex
                showErrorDialog(obj, ex);
                return
            end

            writeButtonPressed@matlabshared.transportapp.internal.toolstrip.write.Controller(obj)
        end
    end

    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})

        function generateWriteCode(obj, action, value, precision)
            % Generate the code log entry for the Workspace Variable
            % write. Overrides the shared write section controller
            % generateWriteCode().

            if obj.WorkspaceVariableWrite
                obj.Comment = string(message("transportapp:toolstrip:write:DefineWorkspaceVariable", value).getString());
                createWriteCommentAndCode(obj, value, precision);
                return
            end
            % Remove the double-quotes around the write data entry, if
            % present.
            if obj.EnclosingDoubleQuotes
                value = value.extractBetween(2, value.strlength()-1);
            end

            % Add extra double quotes around the write data if needed. This
            % is needed for string/char type writes.
            if needDoubleQuotesAroundData(obj, action, precision)
                value = """" + value + """";
            else
                % The data being written is numeric.
                value = getNumericGenerateCodeData(obj, value);
            end
            createWriteCommentAndCode(obj, value, precision);
        end

        function createWriteCommentAndCode(obj, value, precision)
            % Generates custom comment and code for a write action.

            obj.Comment = message("transportapp:udpportapp:WriteComment", ...
                value, ...
                precision, ...
                obj.TransportInstance, ...
                obj.DestinationAddress, ...
                obj.DestinationPort).getString();

            obj.Code = sprintf("write(%s,%s,""%s"",""%s"",%s);", ...
                obj.TransportInstance, ...
                value, ...
                precision, ...
                obj.DestinationAddress, ...
                obj.DestinationPort);

            obj.NewLine = true;
        end
    end
end
