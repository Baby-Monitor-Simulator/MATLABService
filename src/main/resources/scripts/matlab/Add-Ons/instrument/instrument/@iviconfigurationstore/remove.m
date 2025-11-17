function remove(obj, varargin)
%REMOVE Remove entry from IVI configuration store object.
%
%   REMOVE(OBJ, 'TYPE', 'NAME') removes an entry of type, TYPE, with name,
%   NAME, from the IVI configuration store object, OBJ. TYPE can be
%   HardwareAsset, DriverSession or LogicalName.
%
%   REMOVE(OBJ, STRUCT) remove an entry using the fields in STRUCT.
%
%   If a HardwareAsset is removed that is referenced by existing DriverSessions
%   in the configuration store, that reference will be removed from those
%   DriverSessions.
%
%   If a DriverSession is removed that is reference by existing LogicalNames in
%   the configuration store, that reference will be removed from those
%   DriverSessions.
%
%   Examples:
%       c = iviconfigurationstore;
%       remove(c, 'HardwareAsset', 'gpib1');
%
%   See also IVICONFIGURATIONSTORE/UPDATE, IVICONFIGURATIONSTORE/ADD,
%   IVICONFIGURATIONSTORE/COMMIT.

%   Copyright 1999-2016 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

narginchk(2, 3);

arg = varargin{1};

if isstruct(arg)
    
    % Handle remove based on struct (array).
    
    for idx = 1:length(arg)
        
        item = arg(idx);
        
        if isfield(item, 'Type') && isfield(item, 'Name')
            if (~privateVerifyIsMutableEntry(item.Type))
                error(message('instrument:iviconfigurationstore:remove:invalidArgsField'));
            end

            try
                localRemoveEntry(obj.cobject, item.Type, item.Name);
            catch aException
                rethrow(aException);
            end
        else
            error(message('instrument:iviconfigurationstore:remove:invalidArgsTypeName'));
        end
        
    end
elseif (ischar(arg))
    
    % Handle remove based on name and type.
    
    if (~privateVerifyIsMutableEntry(arg))
        error(message('instrument:iviconfigurationstore:remove:invalidArgsType'));
    end

    if (nargin < 3 || ~ischar(varargin{2}))
        error(message('instrument:iviconfigurationstore:remove:invalidArgsName'));
    end

    try
        localRemoveEntry(obj.cobject, arg, varargin{2});
    catch aException
        rethrow(aException);
    end
else
    error(message('instrument:iviconfigurationstore:remove:invalidArgsTypeStruct'));
end

% ------------------------------------------------------------------------------
% Remove the entry from the collection.
% ------------------------------------------------------------------------------
function localRemoveEntry(comObj, type, name)

collection = comObj.([type 's']);

if isempty(collection) || isstruct(collection)
    return;
end

[item, index] = privateGetNamedEntry(collection, name);

if isempty(item)
    error(message('instrument:iviconfigurationstore:remove:notFound', name, type));
    return;
end

% When removing a HardwareAsset, any DriverSessions referencing that asset must
% be updated.
% When removing a DriverSession, any LogicalNames referencing that asset must be
% updated.

switch (lower(type))
    case 'hardwareasset'
        localDereferenceDriverSessions(comObj, name);
    case 'driversession'
        localDereferenceLogicalNames(comObj, name);
end

try
    collection.Remove(index);
catch
    warning(message('instrument:iviconfigurationstore:remove:invalidArgsReferenced', name));
end

% ------------------------------------------------------------------------------
% Update any logical names referencing the DriverSession to be removed.
% ------------------------------------------------------------------------------
function localDereferenceLogicalNames(comObj, sessionName)

collection = comObj.LogicalNames;

if (isempty(collection))
    return;
end

for idx = 1:collection.Count
    if (~isempty(collection.Item(idx).Session))
        if (strcmp(collection.Item(idx).Session.Name, sessionName) == 1)
            collection.Item(idx).Session = [];
        end
    end
end

% ------------------------------------------------------------------------------
% Update any driver sessions referencing the HardwareAsset to be removed.
% ------------------------------------------------------------------------------
function localDereferenceDriverSessions(comObj, assetName)

collection = comObj.DriverSessions;

if (isempty(collection))
    return;
end

for idx = 1:collection.Count
    if (~isempty(collection.Item(idx).HardwareAsset))
        if (strcmp(collection.Item(idx).HardwareAsset.Name, assetName) == 1)
            collection.Item(idx).HardwareAsset = [];
        end
    end
end
