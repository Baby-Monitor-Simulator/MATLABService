classdef IvidevPlugin < matlab.hwmgr.internal.plugins.PluginBase
    %IVIDEVPLUGIN retruns the Ividev App device and applet providers to
    % hwmgr.

    % Copyright 2023 The MathWorks, Inc.

    %% Abstract Method Implementation
    methods
        function deviceProviders = getDeviceProvider(~)
            % Return all the device providers defined for the Ividev App.
            deviceProviders = ividevapp.IvidevDeviceProvider();
        end

        function appletProviders = getAppletProvider(~)
            % Return all the applet providers defined for the Ividev App.
            appletProviders = ividevapp.IvidevAppletProvider();
        end
    end
end