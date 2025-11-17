classdef (Hidden) ResourceManagerImplWindows < visalib.internal.ResourceManagerImplBase
    %ResourceManagerImplWindows class for handling requests from the
    %ResourceManager on Windows. 
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020-2022 The MathWorks, Inc.
    methods
        function obj = ResourceManagerImplWindows
            % ResourceManager requests on Windows are handled by an
            % matlabshared.asyncio.internal.Channel
            obj@visalib.internal.ResourceManagerImplBase();
            obj.checkPlatform("win64");
            
            switch obj.TestMode
                case visalib.internal.VISAMode.NoVISAInstalled
                    devicePluginName = 'libmwvisainvaliddevice';
                case visalib.internal.VISAMode.NoResources
                    devicePluginName = 'libmwvisatestdevice';                    
                case visalib.internal.VISAMode.Test
                    devicePluginName = 'libmwvisatestdevice';
                case visalib.internal.VISAMode.Normal
                    devicePluginName = 'libmwvisadevice';  
            end

            pluginDir = fullfile(toolboxdir('instrument'), 'interface', 'visalib', 'bin', computer('arch'));
            converterPlugin = fullfile(pluginDir, 'libmwvisamlconverter');            
            devicePlugin = fullfile(pluginDir, devicePluginName);

            initOptions.Mode = obj.ResourceManagerMode;
            
            try
                % Output stream limit is 0 (the ResourceManager does not transfer data).
                % Input stream limit cannot be 0 because the plugin is not polled input source.
                obj.Channel = matlabshared.asyncio.internal.Channel(devicePlugin, converterPlugin, ...
                    Options = initOptions, ...
                    StreamLimits = [inf inf]);
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
        function updateList(obj)
            % Update the cached list of available resources
            obj.Channel.execute("UpdateResourceList");
        end

        function updateListWithTimeout(obj, timeout, detailedOutput)
            % Update the cached list of available resources

            narginchk(2, 3)

            if nargin == 2
                detailedOutput = true;
            end

            % Internally, timeout is specified in ms
            options.Timeout = 1000 * timeout;
            options.DetailedOutput = detailedOutput;
            obj.Channel.execute("UpdateResourceListWithTimeout", options)
        end
        
        function r = getCachedResourceList(obj)
            % Return the resource list produced by the last update
            % Remove resources with identical resource names.
            
            r = obj.Channel.Resources;
            if ~isempty(r)
                [~, ia, ~] = unique([r.ResourceName], 'stable');
                r = r(ia);
            end
        end
        
        function resource = getSpecifiedResource(obj, resourceID) 
            % Attempts to retrieve information about a specified
            % resourceID (resource name; aliases can be specified but probably
            % won't return valid information)
            options.ResourceID = resourceID;
            obj.Channel.execute("GetSpecifiedResource", options);
            resource = obj.Channel.SpecifiedResource;
        end               
    end
    
    properties (Access = private)
        Channel matlabshared.asyncio.internal.Channel
    end      
end
