classdef IvidevAppletProvider < matlab.hwmgr.internal.AppletProviderBase
    %IVIDEVAPPLETPROVIDER returns the Ividev app.

    % Copyright 2023 The MathWorks, Inc.

    %% Abstract Method Implementation
    methods
        function appletList = getApplets(~)
            appletList = [];
        end

        function appletList = getAppletsByDevice(~, ~)
            % Returns the list of the supported apps for IVI or VXIplug&ply
            % driver-based devices.
            appletList = "ividevapp.IvidevApp";
        end
    end
end