classdef (Hidden) ResourceManagerImplMac < visalib.internal.ResourceManagerImplBase
    %ResourceManagerImplMac class for handling requests from the
    %ResourceManager on Mac. 
    %
    %    This undocumented class may be removed in a future release.
    
    %    Copyright 2020-2022 The MathWorks, Inc.
    methods
        function obj = ResourceManagerImplMac()
            % Update the cached list of available resources
            obj@visalib.internal.ResourceManagerImplBase();
            obj.checkPlatform("maci64");
            
            switch obj.TestMode
                case visalib.internal.VISAMode.NoVISAInstalled
                    devicePluginName = 'libmwvisainvaliddevice';
                case visalib.internal.VISAMode.NoResources
                    devicePluginName = 'libmwvisatestdevice';                    
                case visalib.internal.VISAMode.Test
                    devicePluginName = 'libmwvisatestdevice';
                case visalib.internal.VISAMode.Normal
                    % If we don't detect the preferred VISA preference,
                    % then establish the preferred VISA and set it
                    if ~ispref('ICT', 'PreferredVISAOnMac')
                        % Load both plugins
                        isNIPluginValid = obj.loadVisaChannel('libmwvisadevice');
                        isRSPluginValid = obj.loadVisaChannel('libmwrsvisadevice');
                        
                        if isNIPluginValid && isRSPluginValid
                            throwAsCaller(visalib.internal.ErrorProxy.getVisaException('unableToEstablishPreferredVISAOnMac'));
                        elseif ~isNIPluginValid && ~isRSPluginValid
                            throwAsCaller(visalib.internal.ErrorProxy.getVisaException('unableToFindPreferredVISA'));
                        end
                        
                        preferredVISA = "unset";
                        
                        if isNIPluginValid
                            preferredVISA = "NI";
                        elseif isRSPluginValid
                            preferredVISA = "RS";
                        end

                        addpref('ICT', obj.PreferredVisaProp, preferredVISA);                        
                    end
                    
                    devicePluginName = getDevicePluginName(obj);
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
    
    methods (Access = protected)
        function devicePluginName = getPluginInfoHook(obj)
            devicePluginName = getDevicePluginName(obj);
        end
    end
    
    methods (Hidden, Static)
        function setPreferredVISA(preferredVisaSetting)
            arguments
                preferredVisaSetting {mustBeNonzeroLengthText}
            end
            
            if ~ismac
                e = visalib.internal.ErrorProxy.getVisaException("setOnlyOnTheMac");
                throwAsCaller(e);
            end
            
            % Convert to a string only after it is guaranteed to be valid text.
            visaSetting = upper(convertCharsToStrings(preferredVisaSetting));
            
            switch visaSetting
                case {"NI", "RS"}
                    setpref('ICT', ...
                            visalib.internal.ResourceManagerImplMac.PreferredVisaProp, ...
                            visaSetting);                                
                otherwise
                    e = visalib.internal.ErrorProxy.getVisaException("invalidVisaForMac", preferredVisaSetting);
                    throwAsCaller(e);
            end
            
        end
    end
    
    methods (Access = private)
        function devicePluginName = getDevicePluginName(obj)
            preferredVISA = getpref('ICT', obj.PreferredVisaProp);
            
            switch preferredVISA
                case "NI"
                    devicePluginName = 'libmwvisadevice';
                case "RS"
                    devicePluginName = 'libmwrsvisadevice';
                otherwise
                    throwAsCaller(visalib.internal.ErrorProxy.getVisaException('unableToFindPreferredVISA'));
            end
        end
        
        function isValidPlugin = loadVisaChannel(obj, devicePluginName)
            isValidPlugin = false;
            pluginDir = fullfile(toolboxdir('instrument'), 'interface', 'visalib', 'bin', computer('arch'));
            converterPlugin = fullfile(pluginDir, 'libmwvisamlconverter');            
            devicePlugin = fullfile(pluginDir, devicePluginName);

            initOptions.Mode = obj.ResourceManagerMode;
            try
                % Output stream limit is 0 (the ResourceManager does not transfer data).
                % Input stream limit cannot be 0 because the plugin is not polled input source.
                channel = matlabshared.asyncio.internal.Channel(devicePlugin, converterPlugin, ...
                    Options = initOptions, ...
                    StreamLimits = [inf inf]);
                delete(channel);                
                isValidPlugin = true;
            catch e %#ok<NASGU>
                isValidPlugin = false;
            end            
        end
    end
    
    properties(Hidden, Constant)
        PreferredVisaProp = 'PreferredVISAOnMac'
    end
    
    properties (Access = private)
        Channel matlabshared.asyncio.internal.Channel
    end      
end
