function objs = ni845xfind(varargin)
%

%   Copyright 2023 The MathWorks, Inc.

try
    serialcontroller.internal.utility.SerialControllerUtility.validatePlatform("ni845x");
    objs = matlabshared.testmeas.internal.objectcacher.ObjectCacher.find("ni845x", varargin{:});
catch ex
    throwAsCaller(ex);
end
end