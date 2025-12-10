function visaExplorer
%VISAEXPLORER Starts the VISA Explorer app.

% Copyright 2022-2023 The MathWorks, Inc.

% Check whether the application is called from a desktop platform
import matlab.internal.capability.Capability;
Capability.require(Capability.LocalClient); 

pluginClass = "matlab.hwmgr.plugins.VisadevPlugin";
appClass = "transportapp.visadev.internal.VisadevApp";

matlab.hwmgr.internal.launchApplet(appClass, pluginClass);
end
