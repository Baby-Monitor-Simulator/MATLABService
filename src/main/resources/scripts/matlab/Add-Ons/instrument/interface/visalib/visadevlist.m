function resourceList = visadevlist(varargin)
%VISADEVLIST List of available VISA resources
%
% resourceList = VISADEVLIST returns a table containing information about available
% VISA resources (devices) using an installed driver. If multiple drivers
% are installed, MATLAB uses the preferred VISA. Interface types detected
% include TCPIP, USB, SERIAL, GPIB, VXI, PXI, and TCPIP Socket.
%
% resourceList = VISADEVLIST("Timeout", TimeoutPeriod) returns all devices found
% within the specified period, in seconds. The default timeout period is
% 10 seconds.
%
%
% Examples:
%   resourceList = visadevlist
%   % Returns all devices discovered within 15 seconds.
%   resourceList = visadevlist("Timeout", 15)
%
% See also VISADEV

%   Copyright 2020-2023 The MathWorks, Inc.

    try
        % This function throws only for maca64 platform.
        instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);
        
        visalib.internal.validatePlatform;
    catch e
        throwAsCaller(e);
    end

    narginchk(0, 2);

    p = initializeParser();

    try
        parse(p, varargin{:});
        timeout = p.Results.Timeout;
        usingDefaultTimeout = ~isempty(p.UsingDefaults);
    catch e
        throwAsCaller(e);
    end

    resources = struct([]);
    
    try
        resourceList = table.empty();
        resources = getResources(timeout);
        if ~isempty(resources)
            resourceList = struct2table(resources);
            resourceList.Properties.RowNames = string(1:height(resourceList))';
        else
            e = getUnableToFindResources(usingDefaultTimeout, timeout);          
            throwAsCaller(e); 
        end
    catch e
        switch e.identifier
            case {'instrument:interface:visa:unableToFindPreferredVISA',...
                  'instrument:interface:visa:unableToFindEnabledVISA',...
                  'instrument:interface:visa:unableToGetVISAInfo',...
                  'instrument:interface:visa:timeoutExpiredEnumeration',...
                  'instrument:interface:visa:unableToEstablishPreferredVISAOnMac',...
                  'instrument:interface:visa:unableToFindResourcesDefaultTimeout',...
                  'instrument:interface:visa:unableToFindResources'}
                % do not translate error (rethrow)
            case {'instrument:interface:visa:unableToFindEntryPointInSharedLibrary',...
                  'instrument:interface:visa:sharedLibraryInitializationFailed'}
                e = visalib.internal.ErrorProxy.getVisaException("unableToFindPreferredVISA");
            otherwise
                if isempty(resources)
                    e = getUnableToFindResources(usingDefaultTimeout, timeout);
                end
        end
                
        throwAsCaller(e);        
    end
end

function resources = getResources(timeout, detailedOutput)
    arguments
        timeout
        detailedOutput (1, 1) logical = true
    end

    resources = visalib.internal.ResourceManager.getInstance().getResourceList(timeout, detailedOutput);
end

function e = getUnableToFindResources(usingDefaultTimeout, timeout)
    if usingDefaultTimeout
        id = "unableToFindResourcesDefaultTimeout";
        e = visalib.internal.ErrorProxy.getVisaException(id, timeout);
    else
        id = "unableToFindResources";
        e = visalib.internal.ErrorProxy.getVisaException(id);
    end
end

function p = initializeParser()
    id = "instrument:interface:visa:invalidTimeout";
    validateFcn = @(t) assert(validateTimeout(t), id, getString(message(id)));

    p = inputParser;
    p.CaseSensitive = false;
    addParameter(p, "Timeout", 10, validateFcn);
end

function tf = validateTimeout(t)

    if isduration(t)
        t = seconds(t);
    end
    
    tf = isnumeric(t) && isscalar(t) && isfinite(t) && (t >= 2);
end
