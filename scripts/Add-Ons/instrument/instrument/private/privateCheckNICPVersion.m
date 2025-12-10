function privateCheckNICPVersion()
%PRIVATECHECKNICPVERSION() helper function checks installation and version
%of IVI Compliance Package.
%
%   This function should not be called directly by the user.
%
%   Copyright 2010-2011 The MathWorks, Inc.

try
    ver =  winqueryreg('HKEY_LOCAL_MACHINE', 'SOFTWARE\National Instruments\IVI\CurrentVersion',  'Version');
catch e
    errorID = 'instrument:ivic:NICPInfoNotAvailable';
    e = MException(errorID, getString(message(errorID)));
    throwAsCaller (e);
end
version = str2double(ver(1:3));
if version < 4.1
    warning(message('instrument:ivic:olderNICPVersion'));
end
end