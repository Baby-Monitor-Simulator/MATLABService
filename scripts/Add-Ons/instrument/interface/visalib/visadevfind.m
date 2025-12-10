function objs = visadevfind(varargin)
%

%   Copyright 2023 The MathWorks, Inc.

try
    validatePlatform();
    objs = matlabshared.testmeas.internal.objectcacher.ObjectCacher.find("visadev", varargin{:});
catch ex
    throwAsCaller(ex);
end

    function validatePlatform()
        % This function throws only for maca64 platform.
        instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);

        % Run the check for other supported platforms.
        visalib.internal.validatePlatform;
    end
end