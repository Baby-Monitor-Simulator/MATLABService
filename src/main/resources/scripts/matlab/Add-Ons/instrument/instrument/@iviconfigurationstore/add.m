function add(obj, varargin)
%ADD Add entry to IVI conifiguration store object.
%
%   ADD(OBJ, 'TYPE', 'NAME', ...) adds a new entry TYPE to the IVI
%   configuration store object, OBJ with name, NAME. If an entry of
%   TYPE with NAME exists an error will occur. Based on TYPE additional
%   arguments are required. TYPE can be HardwareAsset, DriverSession or
%   LogicalName.
%
%   ADD(OBJ, 'DriverSession', 'NAME', 'MODULENAME', 'HARDWAREASSETNAME',
%   'P1', 'V1',...) adds a new driver session entry to the IVI
%   configuration  store object, OBJ with name, NAME, using the specified
%   software module name, MODULENAME and hardware asset name,
%   HARDWAREASSETNAME. Optional param-value pairs may be included. All
%   on/off properties are assumed if not specified. Valid parameters for a
%   DriverSession  are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Description           any string    Description of driver session
%     VirtualNames          struct        A struct array containing virtual
%                                         name mappings.
%     Cache                 on/off        Enable caching if the driver supports it.
%     DriverSetup           any string    This value is software module dependent.
%     InterchangeCheck      on/off        Enable driver interchangeability
%                                         checking if supported.
%     QueryInstrStatus      on/off        Enable instrument status querying
%                                         by the driver.
%     RangeCheck            on/off        Enable extended range checking by
%                                         the driver if supported.
%     RecordCoercions       on/off        Enable recording of coercions by
%                                         the driver if supported.
%     Simulate              on/off        Enable simulation by the driver.
%
%   ADD(OBJ, 'HardwareAsset', 'NAME', 'IORESOURCEDESCRIPTOR', 'P1', 'V1') adds a
%   new hardware asset entry to the IVI configuration store object, OBJ, with
%   name, NAME and resource descriptor, IORESOURCEDESCRIPTOR. Optional
%   param-value pairs may be included. Valid parameters for a HardwareAsset are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Description           any string    Description of hardware asset
%
%   ADD(OBJ, 'LogicalName', 'NAME', 'SESSIONNAME', 'P1', 'V1') adds a new
%   logical name entry to the IVI configuration store object, OBJ, with
%   name, NAME and driver session name, SESSIONNAME. Optional param-value
%   pairs may be included. Valid parameters for logical names are:
%
%     Param Name            Value         Description
%     ----------            ------        ------------
%     Description           any string    Description of logical name
%
%   ADD(OBJ, S) where S is a structure whose field names are the entry
%   parameter names, adds an entry to IVI configuration store object, OBJ,
%   of the specified type with the values contained in the structure. S 
%   must have a Type field which can be DriverSession, HardwareAsset or
%   LogicalName. S must also have a Name field which is the name of the
%   driver session, hardware asset or logical name to be added.
%
%   Additions made to the configuration store object, OBJ, can be saved
%   to the configuration store data file with the COMMIT function.
%
%   Examples:
%       % Construct IVI configuration store object, c.
%       c = iviconfigurationstore;
%
%       % Add a hardware asset with name, gpib1, and resource description
%       % GPIB0::1::INSTR.
%       add(c, 'HardwareAsset', 'gpib1', 'GPIB0::1::INSTR');
%
%       % Add a driver session with name, S1 that uses the TekScope software
%       % module and the hardware asset with name gpib1.
%       add(c, 'DriverSession', 'S1', 'TekScope', 'gpib1');
%
%       % Add a logical name to configuration store object, c, with name,
%       % MyScope, driver session name, S1 and description, A logical name.
%       add(c, 'LogicalName','MyScope', 'S1', 'Description', 'A logical name');
%
%       % Add a hardware asset with name, gpib3, and resource description,
%       % GPIB0::3::ISNTR.
%       s.Name = 'gpib3';
%       s.Type = 'HardwareAsset'; 
%       s.IOResourceDescriptor = 'GPIB0::3::INSTR'
%       add(c, s);
%
%       % Save changes to the IVI configuration store data file.
%       commit(c);
%
%   See also IVICONFIGURATIONSTORE/UPDATE, IVICONFIGURATIONSTORE/REMOVE,
%   IVICONFIGURATIONSTORE/COMMIT.
%

%   Copyright 1999-2016 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

narginchk(2, inf);
arg = varargin{1};

if isstruct(arg)
    
    % Handle new item(s) based in a struct (array) argument.
    
    narginchk(2, 2);
    for idx = 1:length(arg)
        try
            localAddStructEntry(obj.cobject, arg(idx));
        catch aException
            newExc = MException('instrument:iviconfigurationstore:add:invalidArgsException', aException.message);
            throw (newExc);
        end
    end
elseif ischar(arg)
    
    % Handle new item based on field/value pairs.
    
    narginchk(4, inf);
    
    if (~privateVerifyIsMutableEntry(arg))
        error(message('instrument:iviconfigurationstore:add:invalidArgsType'));
    end

    if (~ischar(varargin{2}))
        error(message('instrument:iviconfigurationstore:add:invalidArgsName'));
    end

    try
        localAddPairedEntry(obj.cobject, varargin{:})
    catch aException
        rethrow(aException);
    end
else
    error(message('instrument:iviconfigurationstore:add:invalidArgsTypeStruct'));
end

% ------------------------------------------------------------------------
% Add a new entry with a struct argument.
% ------------------------------------------------------------------------
function localAddStructEntry(comObj, mStructArray)
     
try
    for idx = 1:length(mStructArray)

        mStruct = mStructArray(idx);

        if isfield(mStruct, 'Type') && isfield(mStruct, 'Name')
            
            if (~privateVerifyIsMutableEntry(mStruct.Type))
                error(message('instrument:iviconfigurationstore:add:invalidArgsField'));
            end
            
            out = privateValidateStruct(mStruct);
            
            if (~isempty(out))
                error(message('instrument:iviconfigurationstore:add:invalidArgsStructSpecial', mStruct.Type, out));
            end

            localAddEntry(comObj, mStruct);
        else
            error(message('instrument:iviconfigurationstore:add:invalidArgsStructFields'));
        end

    end
catch aException
    rethrow(aException);
end

% ------------------------------------------------------------------------
% Add a new entry with field value pair arguments.
% ------------------------------------------------------------------------
function localAddPairedEntry(comObj, varargin)

mStruct = privateCreateStruct(varargin{1}, varargin{2});

switch mStruct.Type
    case 'HardwareAsset'
        mStruct.IOResourceDescriptor = varargin{3};
        mStruct = privateFillStruct(mStruct, varargin{4:end});
        localAddEntry(comObj, mStruct);
    case 'DriverSession'
        narginchk(5, inf);
        mStruct.SoftwareModule = varargin{3};
        mStruct.HardwareAsset = varargin{4};

        mStruct = privateFillStruct(mStruct, varargin{5:end});
        localAddEntry(comObj, mStruct);
    case 'LogicalName'
        mStruct.Session = varargin{3};
        mStruct = privateFillStruct(mStruct, varargin{4:end});
        localCheckSession(comObj, mStruct);
        localAddEntry(comObj, mStruct);
end


% check if there is an existing session 
function localCheckSession(comObj, mStruct)

collection = comObj.Sessions;
if isempty(collection) || isstruct(collection)
    return;
end

comEntry = privateGetNamedEntry(collection, mStruct.Session);

if (isempty(comEntry))
    error(message('instrument:iviconfigurationstore:add:invalidEntrySession'));
end

% ------------------------------------------------------------------------
% Add a new entry to the appropriate configuration store collection.
% ------------------------------------------------------------------------
function localAddEntry(comObj, mStruct)

% Verify that an existing entry with this name does not exist.

collection = comObj.([mStruct.Type 's']);

if isempty(collection) || isstruct(collection)
    return;
end

comEntry = privateGetNamedEntry(collection, mStruct.Name);

if (~isempty(comEntry))
    error(message('instrument:iviconfigurationstore:add:invalidEntryDuplicate'));
end

% Create a new blank entry.


comEntry = actxserver(['IviConfigServer.Ivi' mStruct.Type]);


% Update the entry values based on the values provided by the user.

privateUpdateEntry(comEntry, comObj, mStruct);

% Add the new entry to the collection.

collection.Add(comEntry);
