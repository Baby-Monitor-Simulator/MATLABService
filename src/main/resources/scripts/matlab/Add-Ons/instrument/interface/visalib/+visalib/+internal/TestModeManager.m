classdef (Hidden) TestModeManager
%TESTMODEMANAGER - Utility for maintaining and using modes of operation for
%the purpose of testing.

% Copyright 2020 The MathWorks, Inc.

    % Shared options
    methods(Static)
        function varargout = getOptions(varargin)
            %getOptions Return the current set of active options for the visalib
            %interface
            %   [options] = getOptions(option1name, option1setting,...) returns a
            %   structure, OPTIONS, that contains the currently selected options for
            %   the visalib interface.  Each option is set using the
            %   following sequence:
            %     1. The default setting for the option
            %     2. The options specified as PV pairs parameter to getOptions
            %
            %   These options are typically determined once - all subsequent calls
            %   to getOptions will return the cached options (until reset).
            %
            %  
            %
            %    getOptions("reset") reset the cached options to a default set of
            %    values.
            %    getOptions("clear") clears the cached options completely.
            %
            %   [~, usingCachedValues] = getOptions(_);
            %
            %   usingCachedValues is
            %       true when options are looked up and
            %       false when options haven't been explicitly set
            %
            %   Clients can use this value to determine whether to restore
            %   existing options or clear them.
            
            % Copyright 2020 The MathWorks, Inc.
            nargoutchk(0, 2)
            
            if nargin > 0
                [varargin{:}] = convertCharsToStrings(varargin{:});
            end
            
            persistent options;
            
            if isempty(options)
                usingCachedValues = false;
            else
                usingCachedValues = true;
            end
            
            % returned cached value, if available (if not, return empty)
            if nargin == 0
                varargout{1} = options;
                varargout{2} = usingCachedValues;
                return
            end            
            
            % Parse the input parameters
            [p, defaultOptions] = initializeParser();
            parse(p, varargin{:});
            resetCache = false;
            clearCache = false;            
            
            switch(p.Results.UpdateCache)
                case "default"
                    options = defaultOptions;
                case "reset"
                    resetCache = true;
                    options = defaultOptions;
                case "clear"
                    clearCache = true;
                    options = [];
                    usingCachedValues = false;
                otherwise
                    options = rmfield(p.Results, "UpdateCache");
            end
            
            if nargout > 0
                varargout{1} = options;
            end

            if nargout > 1
                varargout{2} = usingCachedValues;
            end

            % If clearing the cache, also remove the currently installed
            % VISA.
            % If resetting the cache, also restart VISA.
            % In all other cases, 'get' does not result in an update.           
            
            if clearCache
                removeVisa
            elseif resetCache
                restartVisa
            end
            
            function [p, defaultOptions] = initializeParser()
                % Initialize and specify the parser                
                nargoutchk(2, 2);
                defaultOptions = getDefaultOptions;
                
                p = inputParser();
                
                addOptional(p, "UpdateCache", "doNotReset", @validateSetCache)
                
                % If true, set up for unit tests (load test adaptors)
                addParameter(p, "UnitTestMode", defaultOptions.UnitTestMode, @islogical);
                
                % If true, simulates finding no VISA resources.
                addParameter(p, "NoResources", defaultOptions.NoResources, @islogical);
                
                % If true, simulate finding no preferred VISA
                addParameter(p, "NoPreferredVISA", defaultOptions.NoPreferredVISA, @islogical);
                
                % If true, DAQ will error on a failed adaptor load (usually,
                % that is ignored.)
                addParameter(p, "DebugMode", defaultOptions.DebugMode, @islogical);                
            end            
        end
        
        function mode = getTestMode()
            % Translate current option into a test mode (note that some
            % options take precedence over others).
            options = visalib.internal.TestModeManager.getOptions();
            
            if isempty(options)
                mode = [];
            elseif options.NoPreferredVISA
                mode = visalib.internal.VISAMode.NoVISAInstalled;
            elseif options.NoResources
                mode = visalib.internal.VISAMode.NoResources;
            elseif options.UnitTestMode
                mode = visalib.internal.VISAMode.Test;
            else
                mode = visalib.internal.VISAMode.Normal;
            end
        end
        
        function setTestMode(options)
            % Set the test mode based on the provided options structure
            % (meant to be called in a test teardown).
            narginchk(0, 1)
            
            if nargin == 0
                options = visalib.internal.TestModeManager.getOptions();
            end            
            
            if isempty(options)
                visalib.internal.TestModeManager.clearTestMode();
            elseif options.NoPreferredVISA
                visalib.internal.TestModeManager.enableNoPreferredVISAMode
            elseif options.NoResources
                visalib.internal.TestModeManager.enableNoResourceMode
            elseif options.UnitTestMode
                visalib.internal.TestModeManager.enableUnitTestMode
            else
                visalib.internal.TestModeManager.disableTestMode
            end
        end
        
        function clearTestMode
            visalib.internal.getOptions("clear");
        end
        
        function disableTestMode
            visalib.internal.getOptions("reset");
        end        
        
        function enableUnitTestMode
            setOption("UnitTestMode")
        end

        function enableNoResourceMode
            setOption("NoResources")
        end
        
        function enableNoPreferredVISAMode
            setOption("NoPreferredVISA")
        end                
    end
end    

function defaultOptions = getDefaultOptions
% Define default options
defaultOptions.UnitTestMode = false;
defaultOptions.NoResources = false;
defaultOptions.NoPreferredVISA = false;
defaultOptions.DebugMode = false;
end

function out = validateSetCache(cachingOption)
if ~isstring(cachingOption)
    out = false;
    return
end

switch lower(cachingOption)
    case {"default", "reset", "clear"}
        out = true;
    otherwise
        out = false;
end

end

function setOption(option)
% convenience method for setting the specified option and enabling the
% specified test mode
visalib.internal.getOptions(option, true);
restartVisa
end

function restartVisa
visalib.internal.ManagerImplFactory.releaseInstance();
visalib.internal.ManagerImplFactory.getInstance();
end

function removeVisa
visalib.internal.ManagerImplFactory.releaseInstance();
end
