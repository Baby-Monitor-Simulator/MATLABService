function instrumentExplorer
%

%INSTRUMENTEXPLORER Starts the Instrument Explorer app.

% Copyright 2023 The MathWorks, Inc.

% Check whether the application is called from a desktop platform
import matlab.internal.capability.Capability;
Capability.require(Capability.LocalClient);

pluginClass = "matlab.hwmgr.plugins.IvidevPlugin";
appletClass = "ividevapp.IvidevApp";

% Launch Instrument Explorer in Hardware Manager.
matlab.hwmgr.internal.launchApplet(appletClass, pluginClass);
end
