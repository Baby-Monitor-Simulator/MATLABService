function objs = aardvarkfind(varargin)
%

%   Copyright 2023 The MathWorks, Inc.

try
    serialcontroller.internal.utility.SerialControllerUtility.validatePlatform("aardvark");
    objs = matlabshared.testmeas.internal.objectcacher.ObjectCacher.find("aardvark", varargin{:});
catch ex
    throwAsCaller(ex);
end
end