classdef (Hidden) ConflictManagerImplMac < visalib.internal.ConflictManagerImplBase
    %ConflictManagerImplMac class for handling requests from the
    %ConflictManager on the Mac. 
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020-2021 The MathWorks, Inc.
    
    methods
        function obj = ConflictManagerImplMac()
            % The ConflictManager is unavailable on the Mac.
            conflictManagerPath = "";
            obj@visalib.internal.ConflictManagerImplBase(conflictManagerPath);
            obj.checkPlatform("maci64");
            
            pluginDir = fullfile(toolboxdir('instrument'), 'interface', 'visalib', 'bin', computer('arch'));
            devicePlugin = fullfile(pluginDir, 'libmwvisashareddevice');
            converterPlugin = fullfile(pluginDir, 'libmwvisamlconverter');

            initOptions.ConflictManagerPath = obj.ConflictManagerPath;
            initOptions.ConflictManagerMode = obj.ConflictManagerMode;

            try
                % Stream limits are 0 because the ResourceManager does not
                % transfer data.
                obj.Channel = matlabshared.asyncio.internal.Channel(devicePlugin, converterPlugin, ...
                                            Options = initOptions, ...
                                            StreamLimits = [0 0]);
            catch e
                switch e.identifier
                    case 'asyncio:Channel:couldNotLoadDevice'
                        throwAsCaller(visalib.internal.ErrorProxy.getVisaException('unableToFindPreferredVISA'));
                    otherwise
                        rethrow(e);
                end
            end             
        end
        
        function delete(obj)
            delete(obj.Channel);
        end
    end
    
    methods
        function loadConflictManager(obj)
            % NORMAL mode: load/unload will result in an error
            % OTHER modes: use the simulated conflict manager
            try
                obj.Channel.execute("LoadConflictManager");
            catch e
                throwAsCaller(e);
            end
        end
        
        function unloadConflictManager(obj)
            % NORMAL operation: load/unload will result in an error
            % OTHER modes: use the simulated conflict manager
            try
                obj.Channel.execute("UnloadConflictManager");
            catch e
                throwAsCaller(e);
            end
        end
        
        function numInstallations = getNumVisaInstallations(obj)
            % NORMAL mode: we have to get the installation info
            % dynamically or using the presence of a specific dylib because
            % there's no ConflictManager available; look up the vendor(s)
            % (using settings or dynamically using the presence of a
            % specific dylib).
            % OTHER modes of operation: use the simulated conflict manager.
            
            switch obj.ConflictManagerMode
                case visalib.internal.VISAMode.Normal
                    % TODO: Look up the available VISA installations (either via API or
                    % via settings).
                    numInstallations = 1;
                otherwise
                    try
                        obj.Channel.execute("GetNumVisaInstallations");
                        numInstallations = double(obj.Channel.NumVisaInstallations);
                    catch e
                        throwAsCaller(e);
                    end
            end
        end
        
        function info = getVisaInstallationInfo(obj)
            % NORMAL mode: we have to get the installation info
            % dynamically or using the presence of a specific dylib because
            % there's no ConflictManager available; look up the vendor(s)
            % (using settings or dynamically using the presence of a
            % specific dylib).
            % OTHER modes of operation: use the simulated conflict manager.
           
            switch obj.ConflictManagerMode
                % Index is arbitrary: use 1 for NI, 2 for RS
                % ID is determined by the vendor
                % Preferred is determined by user's settings
                % GUID might not match this one (depends on library version)
                % Name is determined by the vendor
                case visalib.internal.VISAMode.Normal
                    info_rs = getRSInstallationInfo();
                    info_ni = getNIInstallationInfo();
                    info = [info_ni info_rs];
                otherwise
                    try
                        obj.Channel.execute("GetVisaInstallationInfo");
                        info = obj.Channel.VisaInstallationInfo;
                    catch e
                        throwAsCaller(e);
                    end
            end
        end
        
        % Inherited
        % function preferredVISA = getPreferredVisa(obj)        
        
        function visaForResource = findVisaForResource(obj, interfaceType, interfaceNum, resourceType) %#ok<INUSD>
            switch obj.ConflictManagerMode
                % Index is arbitrary: use 1 for NI, 2 for RS
                % ID is determined by the vendor
                % Preferred is determined by user's settings
                % GUID might not match this one (depends on library version)
                % Name is determined by the vendor
                case visalib.internal.VISAMode.Normal
                    preferredVISA = getpref('ICT', visalib.internal.ResourceManagerImplMac.PreferredVisaProp);
                    
                    switch preferredVISA
                        case "NI"
                            info = getNIInstallationInfo();  
                        case "RS"
                            info = getRSInstallationInfo();  
                        otherwise
                            throwAsCaller(visalib.internal.ErrorProxy.getVisaException('unableToFindPreferredVISA'));
                    end                    
                otherwise
                    try
                        obj.Channel.execute("GetVisaInstallationInfo");
                        info = obj.Channel.VisaInstallationInfo;
                    catch e
                        throwAsCaller(e);
                    end
            end
            
            visaForResource = info.Name;            
        end
    end
    
    properties (Access = private)
        Channel matlabshared.asyncio.internal.Channel
    end        
end

function infoNI = getNIInstallationInfo
infoNI = struct("Index", int32(1),...
                "ID", uint16(4086), ...
                "Preferred", true, ...
                "GUID", "C32EDE22-0AFA-4E09-B3B5-F25715B3157B", ...
                "Name", "National Instruments VISA");
                         
end

function infoRS = getRSInstallationInfo
infoRS = struct("Index", int32(2),...
                "ID", uint16(4015), ...
                "Preferred", false, ...
                "GUID", "259C8787-DFFC-42CF-AB7D-ACC220B4D98E", ...
                "Name", "R&S VISA");
end

