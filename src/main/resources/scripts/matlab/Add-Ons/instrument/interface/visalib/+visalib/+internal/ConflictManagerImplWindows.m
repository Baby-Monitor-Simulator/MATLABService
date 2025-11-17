classdef (Hidden) ConflictManagerImplWindows < visalib.internal.ConflictManagerImplBase
    %ConflictManagerImplWindows class for handling requests from the
    %ConflictManager on Windows. 
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020-2021 The MathWorks, Inc.
    methods
        function obj = ConflictManagerImplWindows(conflictManagerPath)
            arguments
                % The conflict manager path and library name are defined in
                % VPP-4.3.5 (VISA Shared Components).
                conflictManagerPath (1, 1) string = "visaConfMgr.dll"
            end
            
            obj@visalib.internal.ConflictManagerImplBase(conflictManagerPath);
            obj.checkPlatform("win64");
            
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
            % Loads the VISA ConflictManager library.
            try
                obj.Channel.execute("LoadConflictManager");
            catch e
                throwAsCaller(e);
            end
        end
        
        function unloadConflictManager(obj)
            % Unloads the VISA ConflictManager library.
            try
                obj.Channel.execute("UnloadConflictManager");
            catch e
                throwAsCaller(e);
            end
        end
        
        function numInstallations = getNumVisaInstallations(obj)
            % Returns the number of visa installations tracked by the VISA
            % Conflict Manager. The loadConflictManager method must be
            % called prior to calling this method.            
            try
                obj.Channel.execute("GetNumVisaInstallations");
                numInstallations = double(obj.Channel.NumVisaInstallations);
            catch e
                throwAsCaller(e);
            end
        end
        
        function info = getVisaInstallationInfo(obj)
            % Returns information about all visa installations tracked by
            % the VISA Conflict Manager. The getNumVisaInstallations method
            % must be called prior to calling this method.
            try
                obj.Channel.execute("GetVisaInstallationInfo");
                info = obj.Channel.VisaInstallationInfo;
            catch e
                throwAsCaller(e);
            end
        end
        
        % Inherited
        % function preferredVISA = getPreferredVisa(obj)
        
        function visaForResource = findVisaForResource(obj, interfaceType, interfaceNum, resourceType)
            % Returns the name of the VISA associated with a particular
            % interface type and number, as determined by the VISA Conflict
            % Manager.             
            arguments
                obj (1, 1) visalib.internal.ConflictManagerImplWindows
                interfaceType (1, 1) uint16
                interfaceNum (1, 1) uint16
                resourceType (1, 1) string
            end            
            
            options = struct("InterfaceType", uint16(interfaceType), ...
                             "InterfaceNum", uint16(interfaceNum), ...
                             "ResourceType", resourceType);
            
            % FindVisaForResource returns the GUID corresponding to the
            % interface type/num and resource type indicated. This GUID is
            % used to lookup the name of the VISA corresponding to the
            % indicated quantities.
                         
            obj.Channel.execute("FindVisaForResource", options);
            guid = obj.Channel.VisaLibraryForResource;
            
            info = obj.getVisaInstallationInfo;
            if ~isempty(info)
                infoGUID = info(contains([info.GUID], guid));
                visaForResource = infoGUID.Name;
            else
                visaForResource = strings(0);
            end
        end
    end
    
    properties (Access = private)
        Channel matlabshared.asyncio.internal.Channel
    end      
end