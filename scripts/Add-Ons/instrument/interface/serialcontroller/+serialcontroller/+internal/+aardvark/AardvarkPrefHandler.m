classdef AardvarkPrefHandler < serialcontroller.internal.common.BasePrefHandler
    % AARDVARKPREFHANDLER handles the preferences data for the aardvark
    % object.

    %   Copyright 2022-2023 The MathWorks, Inc.

    %% Abstract properties implementation
    properties (Constant,Hidden)
        % PrefsType - The preferences name for aardvark that contains the
        % saved aardvark properties in the preferences.
        PrefsType = "aardvark"

        % Vendor - The vendor name for the aardvark controller.
        Vendor = "aardvark"

        % VendorListName - The name of the list function for the aardvark
        % controller.
        VendorListName = "aardvarklist"

        % List of properties that need to be saved in the Instrument
        % Preferences for aardvark.
        PreferencesPropertiesList = ["SerialNumber",...
            "EnablePullupResistors","EnableTargetPower", "Tag"]
    end

    %% Abstract methods implementation
    methods
        function controllerList = getList(~)
            % Returns list of aardvark controllers connected to host machine.
            controllerList = aardvarklist;
        end

        function clearPreferencesData(~)
            % Invokes the clearPreferences method for aardvark.
            serialcontroller.internal.aardvark.AardvarkPrefHandler.clearPreferences();
        end
    end

    %% Lifetime
    methods
        function obj = AardvarkPrefHandler(varargin)
            % Pass the input arguments to the base class explicitly.
            obj = obj@serialcontroller.internal.common.BasePrefHandler(varargin{:});
        end
    end

    %% Helper method
    methods (Static)
        function result = clearPreferences()
            % Clear the aardvark preferences.
            result = internal.PreferencesHelper.removePref ...
                (serialcontroller.internal.common.BasePrefHandler.GroupName,...
                serialcontroller.internal.aardvark.AardvarkPrefHandler.PrefsType);
        end
    end
end
