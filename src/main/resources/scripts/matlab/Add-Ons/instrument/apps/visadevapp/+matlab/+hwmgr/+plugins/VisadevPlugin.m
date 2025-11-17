classdef VisadevPlugin < matlab.hwmgr.internal.plugins.PluginBase
    %VISADEVPLUGIN returns the VisadevApp device and applet providers to
    %hwmgr.

    % Copyright 2022 The MathWorks, Inc.
    methods
        function deviceProvider = getDeviceProvider(~)
            deviceProvider = transportapp.visadev.internal.VisadevDeviceProvider();
        end

        function appletProvider = getAppletProvider(~)
            appletProvider = transportapp.visadev.internal.VisadevAppProvider();
        end
    end
end
