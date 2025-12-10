classdef (Hidden) ResourceManagerImplBase < handle
    %ResourceManagerImplBase class for handling requests from the
    %ResourceManager. By default the operations are no-ops.
    %
    %    This undocumented class may be removed in a future release.
    
    % Services provided:
    %
    % updateListWithTimout
    %   Updates the cached list of all the resources found by the currently set
    %   preferred VISA within a specified period.
    %
    % updateList
    %   Updates the cached list of all the resources found by the currently
    %   set preferred VISA; no timeout is observed.
    %
    % getCachedResourceList
    %   Returns the cached list of all the resources available using the
    %   current set preferred VISA.
    %
    % getResourceIDs
    %   Returns the IDs (aliases and resource names) associated with each
    %   resource listed in the cache (a list of all the resources available
    %   using the current set preferred VISA).
    %
    % getResourceTypes
    %   Returns the types (visalib.internal.InterfaceType)
    %   associated with each resource listed in the cache (a list of all
    %   the resources available using the current set preferred VISA).
    %
    % getSpecifiedResource    
    %   Attempts to retrieve information about a specified
    %   resourceID (resource name; aliases can be specified but probably
    %   won't return valid information).
    
    %    Copyright 2020-2022 The MathWorks, Inc.

    methods
        function obj = ResourceManagerImplBase()
             % By default, the resource manager should not operate in test mode.          
            resourceManagerMode = "Normal";
            testMode = visalib.internal.TestModeManager.getTestMode();
            
            switch testMode
                case visalib.internal.VISAMode.NoVISAInstalled
                    resourceManagerMode = "NoVISAInstalled";
                case visalib.internal.VISAMode.NoResources
                    resourceManagerMode = "NoResources";                    
                case visalib.internal.VISAMode.Test
                    resourceManagerMode = "Test";
                case visalib.internal.VISAMode.Normal
                    resourceManagerMode = "Normal";                    
            end            

            obj.TestMode = testMode;
            obj.ResourceManagerMode = resourceManagerMode;
        end
    end
    
    % Override
    methods
        function updateList(obj)  %#ok<MANU>
            % Update the cached list of available resources
            
            % does nothing by default
        end
        
        function updateListWithTimeout(obj, timeout, detailedOutput) %#ok<INUSD>
            % Updates the current list of available resources
            
            % does nothing by default
        end
        
        function resources = getCachedResourceList(obj) %#ok<MANU>
            % Return the last known list of resources (cached)
            
            % By default, the cache is empty
            resources = struct("Name", strings(1, 0),...
                               "Alias", strings(0),...
                               "Vendor", strings(0),...
                               "Model", strings(0),...
                               "SerialNumber", strings(0),...
                               "InterfaceType", visalib.InterfaceType.unset);            
        end
    end
    
    methods
        function resources = getResourceList(obj, timeout, detailedOutput)
            % Return an updated list of resources
            narginchk(1, 3);
            if nargin == 1 || timeout == 0
                obj.updateList();
            elseif nargin == 2
                obj.updateListWithTimeout(timeout);
            else
                obj.updateListWithTimeout(timeout, detailedOutput);
            end
            
            resources = obj.getCachedResourceList();
        end
        
        function id = getResourceIDs(obj)
            % Return a list of the IDs (aliases and resource names)
            % represented in the resource cache.
            resourceList = obj.getCachedResourceList();
            if isempty(resourceList)
                id = [];
            else
                alias = [resourceList.Alias];
                alias(alias == "") = [];
                id = [alias resourceList.ResourceName];
            end
        end
        
        function types = getResourceTypes(obj)
            % Return a list of the interface types represented in the
            % resource cache.
            
            resourceList = obj.getCachedResourceList();
            if isempty(resourceList)
                types = [];
            else
                types = [resourceList.Type];
            end
        end
        
        function resource = getSpecifiedResource(obj, resourceID) %#ok<INUSD>
            % Attempts to retrieve information about a specified
            % resourceID (resource name; aliases can be specified but probably
            % won't return valid information)
            
            resource = struct("Name", "",...
                              "Alias", "",...
                              "Vendor", "",...
                              "Model", "",...
                              "SerialNumber", "",...
                              "InterfaceType", visalib.InterfaceType.unset);
        end        
    end
    
    methods (Hidden, Sealed)
        function devicePluginName = getPluginInfo(obj)
            % Returns the correct device plugin name
            
            mode = visalib.internal.TestModeManager.getTestMode();

            switch mode
                case visalib.internal.VISAMode.NoVISAInstalled
                    devicePluginName = 'libmwvisainvaliddevice';
                case visalib.internal.VISAMode.NoResources
                    devicePluginName = 'libmwvisatestdevice';                    
                case visalib.internal.VISAMode.Test
                    devicePluginName = 'libmwvisatestdevice';
                case visalib.internal.VISAMode.Normal
                    devicePluginName = obj.getPluginInfoHook();
            end
        end
    end
    
    methods (Access = protected)
        function devicePluginName = getPluginInfoHook(obj)
            devicePluginName = 'libmwvisadevice'; 
        end
    end
    
    methods (Static, Access = protected)
        function checkPlatform(platform)
            arguments
                platform (1, 1) string
            end
            
            if string(computer('arch')) ~= platform
                throw(MException(message("instrument:interface:visa:codeDoesNotMatchPlatform", platform, computer('arch'))));
            end            
        end
    end
    
    properties (GetAccess = protected, SetAccess = private)
        % Mode set by the test mode manager
        TestMode
        % ResourceManager mode corresponding to the TestMode
        ResourceManagerMode
    end    
end

