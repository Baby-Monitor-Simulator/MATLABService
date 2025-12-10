function update(obj, varargin)
%UPDATE Update entry in IVI configuration store object.
%
%   UPDATE(OBJ, 'TYPE', 'NAME', P1, V1, ...) updates an entry of type, 
%   TYPE, with name, NAME, in IVI configuration store object, OBJ, using 
%   the specified param-value pairs. TYPE can be HardwareAsset,
%   DriverSession, or LogicalName.
%
%   If an entry of TYPE with NAME does not exist, an error will occur.
%
%   Valid parameters for a DriverSession are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Name                  string        A unique name for the driver session.
%     SoftwareModule        string        The name of a software module entry in the configuration store.
%     HardwareAsset         string        The name of a hardware asset entry in the configuration store.
%     VirtualNames          struct        A struct array containing virtual name mappings.
%     Description           any string    Description of driver session
%     Cache                 on/off        Enable caching if the driver supports it.
%     DriverSetup           any string    This value is software module dependent.
%     InterchangeCheck      on/off        Enable driver interchangeability checking if supported.
%     QueryInstrStatus      on/off        Enable instrument status querying by the driver.
%     RangeCheck            on/off        Enable extended range checking by the driver if supported.
%     RecordCoercions       on/off        Enable recording of coercions by the driver if supported.
%     Simulate              on/off        Enable simulation by the driver.
%
%   Valid parameters for a HardwareAsset are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Name                  string        A unique name for the hardware asset.
%     Description           any string    Description of the hardware asset.
%     IOResourceDescriptor  string        The I/O address of the hardware asset.
%
%   Valid parameters for a LogicalName are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Name                  string        A unique name for the logical name.
%     Description           any string    Description of hardware asset
%     Session               string        The name of a driver session entry in the configuration store.
%
%   UPDATE(OBJ, STRUCT) updates the entry using the fields in STRUCT. If an
%   entry with the type and name field in STRUCT does not exist, an error
%   will occur. Note that the Name field cannot be updated using this syntax.
%
%   Examples:
%       c = iviconfigurationstore;
%       update(c, 'DriverSession', 'ScopeSession', 'Description', 'A session.');
%
%   See also IVICONFIGURATIONSTORE/ADD, IVICONFIGURATIONSTORE/REMOVE,
%   IVICONFIGURATIONSTORE/COMMIT.
%

%   Copyright 1999-2016 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

narginchk(2, inf);
arg = varargin{1};

if isstruct(arg)

    % Handle update based in a struct (array) argument.
    
    if (nargin > 2)
        error(message('instrument:iviconfigurationstore:update:tooManyArgs'));
    end
    
    for idx = 1:length(arg)
        
        mStruct = arg(idx);
        
        if isfield(mStruct, 'Type') && isfield(mStruct, 'Name')
            if (~privateVerifyIsMutableEntry(mStruct.Type))
                error(message('instrument:iviconfigurationstore:update:invalidArgsField'));
            end
            
            try
                localUpdateEntry(obj.cobject, mStruct.Name, mStruct);
            catch aException
                newExc = MException('instrument:iviconfigurationstore:update:invalidEntry', aException.message);
                throw(newExc);
            end
        else
            error(message('instrument:iviconfigurationstore:update:invalidArgsStruct'));
        end
    end
elseif ischar(arg)
    
    % Handle update based on field/value pairs.
    narginchk(4, inf);
    if (~privateVerifyIsMutableEntry(arg))
        error(message('instrument:iviconfigurationstore:update:invalidArgsType'));
    end

    if (~ischar(varargin{2}))
        error(message('instrument:iviconfigurationstore:update:invalidArgsName'));
    end
    
    try
        entry.Type = arg;
        entry = privateFillStruct(entry, varargin{3:end});
        localUpdateEntry(obj.cobject, varargin{2}, entry);
    catch aException
        newExc = MException('instrument:iviconfigurationstore:update:invalidArgsException', aException.message);
        throw(newExc);
    end

else
    error(message('instrument:iviconfigurationstore:update:invalidArgsTypeStruct'));
end

% check if there is an existing session 
function localCheckSession(comObj, mStruct)

collection = comObj.Sessions;
if isempty(collection) || isstruct(collection)
    return;
end

comEntry = privateGetNamedEntry(collection, mStruct.Session);

if (isempty(comEntry))
    error(message('instrument:iviconfigurationstore:update:invalidEntry'));
end


% -------------------------------------------------------------------------
% Update the configuration store entry.
% -------------------------------------------------------------------------
function errflag = localUpdateEntry(comObj, name, mStruct)

if (strcmp(mStruct.Type ,'LogicalName'))
    localCheckSession (comObj, mStruct);
end
errflag = false;

collection = comObj.([mStruct.Type 's']);

if isempty(collection) || isstruct(collection)
    return;
end

comEntry = privateGetNamedEntry(collection, name);

if (isempty(comEntry))
    error(message('instrument:iviconfigurationstore:update:invalidArgsEntry', name, mStruct.Type));
end

privateUpdateEntry(comEntry, comObj, mStruct);
