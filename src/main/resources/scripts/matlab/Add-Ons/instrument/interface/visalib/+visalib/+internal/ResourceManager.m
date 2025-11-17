 classdef (Hidden, Sealed) ResourceManager < handle
    %ResourceManager Static class used to manage the lifetime of the
    %channel used to issue resource-related commands/queries. These include
    %providing a cached list of available resources and means to update the
    %cache. In addition, utilities are provided for supporting visadev and
    %visadevlist.
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020-2022 The MathWorks, Inc.
    
    methods(Hidden, Static)
        function impl = getInstance()
            impl = visalib.internal.ManagerImplFactory.getResourceManagerImpl();
        end
        
        function releaseInstance()
            visalib.internal.ManagerImplFactory.releaseInstance();
        end
        
        function info = getPluginInfo()
            devicePluginName = visalib.internal.ResourceManager.getInstance().getPluginInfo();            
            pluginDir = fullfile(toolboxdir('instrument'), 'interface', 'visalib', 'bin', computer('arch'));
            info.ConverterPluginPath = fullfile(pluginDir, 'libmwvisamlconverter');
            info.DevicePluginPath = fullfile(pluginDir, devicePluginName);            
        end
    end
    
    methods (Static)
        function resources = getCachedResourceList
            % Return the last known list of resources (cached)
            resources = visalib.internal.ResourceManager.getInstance().getCachedResourceList();
        end

        function resources = getResourceList(timeout, detailedOutput)
            % Return an updated list of resources (updates cache).            
            arguments
                % Timeout, in seconds
                timeout (1, 1) double
                detailedOutput (1, 1) logical = true
            end
            
            resources = visalib.internal.ResourceManager.getInstance().getResourceList(timeout, detailedOutput);
        end
        
        function id = getResourceIDs
            % Returns a list of the resource IDs (aliases and resource
            % names) represented in the resource cache (typically, this
            % method should be invoked after the cache is updated).
            id = visalib.internal.ResourceManager.getInstance().getResourceIDs();
        end
        
        function types = getResourceTypes
            % Returns a list of the resource types represented in the
            % resource cache (typically, this method should be invoked
            % after the cache is updated).            
            types = visalib.internal.ResourceManager.getInstance().getResourceTypes();
        end
        
        function resource = getSpecifiedResource(resourceID)
            % Attempts to retrieve information about a specified
            % resourceID (resource name; aliases can be specified but probably
            % won't return valid information)
            arguments
                resourceID (1, 1) {mustBeNonzeroLengthText}
            end
            
            % Convert to a string only after it is guaranteed to be valid text.
            resourceID = convertCharsToStrings(resourceID);
            
            resource = visalib.internal.ResourceManager.getInstance().getSpecifiedResource(resourceID);
        end        
    end    
 end
