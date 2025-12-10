classdef UdpportPlugin < matlab.hwmgr.internal.plugins.PluginBase
    %UDPPORTPLUGIN returns the UdpportApp device and
    %applet providers to hwmgr.

    % Copyright 2021 The Mathworks, Inc.

    %% Abstract Method Implementation
    methods
        function deviceProviders = getDeviceProvider(~)
            %Returns device provider for UDP device.
            deviceProviders = transportapp.udpport.internal.UdpportDeviceProvider();
        end

        function appletProvider = getAppletProvider(~)
            %Returns applet provider for UDP app.
            appletProvider = transportapp.udpport.internal.UdpportAppProvider();
        end
    end
end