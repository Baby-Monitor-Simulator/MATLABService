function objs = icdevicefind(varargin)
%

%   Copyright 2024 The MathWorks, Inc.

try
    objs = matlabshared.testmeas.internal.objectcacher.ObjectCacher.find("icdevice", varargin{:});
catch ex
    throwAsCaller(ex);
end
end
