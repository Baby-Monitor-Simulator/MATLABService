classdef NI845xPrefHandler < serialcontroller.internal.common.BasePrefHandler
    % NI845XPREFSHANDLER handles the preferences data for the ni845x
    % object.

    %   Copyright 2022-2023 The MathWorks, Inc.

    %% Abstract properties implementation
    properties (Constant,Hidden)
        % PrefsType - The preferences name for ni845x that contains the
        % saved ni845x properties in the preferences.
        PrefsType = "ni845x"

        % Vendor - The vendor name for the ni845x controller.
        Vendor = "ni845x"

        % VendorListName - The name of the list function for the ni845x
        % controller.
        VendorListName = "ni845xlist"

        % List of properties that need to be saved in the Instrument
        % Preferences for ni845x.
        PreferencesPropertiesList = ["SerialNumber","VoltageLevel",...
            "EnablePullupResistors","OutputDriverType", "Tag"]
    end

    %% Abstract methods implementation
    methods
        function controllerList = getList(~)
            % Returns list of ni845x controllers connected to host machine.
            controllerList = ni845xlist;
        end

        function clearPreferencesData(~)
            % Invokes the clearPreferences method for ni845x.
            serialcontroller.internal.ni845x.NI845xPrefHandler.clearPreferences();
        end
    end

    %% Lifetime
    methods
        function obj = NI845xPrefHandler(varargin)
            % Pass the input arguments to the base class explicitly.
            obj = obj@serialcontroller.internal.common.BasePrefHandler(varargin{:});
        end
    end

    %% Helper method
    methods (Static)
        function result = clearPreferences()
            % Clear the ni845x preferences.
            result = internal.PreferencesHelper.removePref ...
                (serialcontroller.internal.common.BasePrefHandler.GroupName,...
                serialcontroller.internal.ni845x.NI845xPrefHandler.PrefsType);
        end
    end
end
