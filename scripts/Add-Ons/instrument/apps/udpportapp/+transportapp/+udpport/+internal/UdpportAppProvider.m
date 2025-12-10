classdef UdpportAppProvider < matlab.hwmgr.internal.AppletProviderBase
    % UDPPORTAPPPROVIDER returns the UDP app supported by the
    % UDP devices.

    % Copyright 2021 The Mathworks, Inc.

    %% Abstract Method Implementation
    methods
        function appList = getApplets(~)
            % The UDP App does not have enumerable devices, return an
            % empty list.
            appList = [];
        end

        function appList = getAppletsByDevice(~, ~)
            % Returns the list of the supported apps for the UDP devices.
            appList = "transportapp.udpport.internal.UdpportApp";
        end
    end
end