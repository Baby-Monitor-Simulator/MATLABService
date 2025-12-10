function setPreferredVisaOnTheMac(visaSetting)
%SETPREFERREDVISAONTHEMAC Records the user's preferred VISA on the Mac
%(valid choices include "NI" and "RS")

%   Copyright 2020 The MathWorks, Inc.
arguments
    visaSetting {mustBeNonzeroLengthText}
end

try
    visalib.internal.ResourceManagerImplMac.setPreferredVISA(visaSetting);
catch e
    throwAsCaller(e);
end

end

