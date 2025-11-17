function isMutable = privateVerifyIsMutableEntry(typeName)
%PRIVATEISMUTABLEENTRY Returns whether the user allowed to change this entry type.
% 
%   PRIVATEISMUTABLEENTRY(TYPE) returns true if TYPE is a user-configurable
%   entry type in the IVI configuration store. TYPE is case-sensitive.
%
%   This function should not be called directly by the user. 

%   PE 10-01-03
%   Copyright 1999-2011 The MathWorks, Inc.

narginchk(1, 1);
isMutable = false;

if any(strcmp(typeName, {'DriverSession', 'HardwareAsset', 'LogicalName'}))
    isMutable = true;
end
