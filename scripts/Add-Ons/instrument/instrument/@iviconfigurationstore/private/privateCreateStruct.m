function s = privateCreateStruct(type, name)
%PRIVATECREATESTRUCT Create a default entry struct.
%
%   S = PRIVATECREATESTRUCT(type, name) creates a default structure for a
%   configuration store entry of type, TYPE, with name, NAME. Valid entry types
%   are:
%
%       'HardwareAsset'
%       'DriverSession'
%       'LogicalName'
%
%   TYPE is case-sensitive.
%
%   This function should not be called directly by the user. 

%   PE 10-01-03
%   Copyright 1999-2011 The MathWorks, Inc.

narginchk(2, 2);
s.Type = type;
s.Name = name;

if (~privateVerifyIsMutableEntry(type))
    error(message('instrument:iviconfigstore:invalidtype'));
end

switch type
    case 'HardwareAsset'
        s.Description = '';
        s.IOResourceDescriptor = '';
    case 'DriverSession'
        s.Description = '';
        s.HardwareAsset = '';
        s.VirtualNames = [];
        s.SoftwareModule = '';
        s.Cache = false;
        s.QueryInstrStatus = false;
        s.DriverSetup = '';
        s.InterchangeCheck = false;
        s.RangeCheck = false;
        s.RecordCoercions = false;
        s.Simulate = false;
    case 'LogicalName'
        s.Description = '';
        s.Session = '';
end
