function udpExplorer
    % UDPEXPLORER Starts the UDP Explorer app.

    % Copyright 2021-2022 The MathWorks, Inc

    % Check whether the application is called from a desktop platform
    import matlab.internal.capability.Capability;
    Capability.require(Capability.LocalClient);

    pluginClass = "matlab.hwmgr.plugins.UdpportPlugin";
    appClass = "transportapp.udpport.internal.UdpportApp";

    % Launch UDP Explorer app in Hardware Manager.
    matlab.hwmgr.internal.launchApplet(appClass, pluginClass);
end