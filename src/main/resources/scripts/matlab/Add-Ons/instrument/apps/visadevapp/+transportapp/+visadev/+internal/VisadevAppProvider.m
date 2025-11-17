classdef VisadevAppProvider < matlab.hwmgr.internal.AppletProviderBase
    %VISADEVAPPPROVIDER returns the Visadev app.

    % Copyright 2022 The MathWorks, Inc.

    methods
        function appList = getApplets(~)
            appList = [];
        end

        function appList = getAppletsByDevice(~, ~)
            % Returns the list of the supported apps for VISA devices.
            appList = "transportapp.visadev.internal.VisadevApp";
        end
    end
end

