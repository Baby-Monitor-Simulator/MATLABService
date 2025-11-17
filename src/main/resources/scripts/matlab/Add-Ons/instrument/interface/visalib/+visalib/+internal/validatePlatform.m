function validatePlatform
% Throw an error if an attempt is made to use an unsupported platform

%   Copyright 2020 The MathWorks, Inc.

    if ~(ispc || ismac)
        e = visalib.internal.ErrorProxy.getVisaException("unsupportedPlatform");
        throwAsCaller(e);
    end
end
