function output = get(obj, varargin)
%GET Get IVI Configuration Store object properties.
%
%   V = GET(OBJ,'Property') returns the value, V, of the specified 
%   property, Property, for IVI Configuration Store object OBJ. 
%
%   If Property is replaced by a 1-by-N or N-by-1 cell array of strings 
%   containing property names, then GET will return a 1-by-N cell array
%   of values. If OBJ is a vector of IVI Configuration Store objects, 
%   then V will be a M-by-N cell array of property values where M is equal
%   to the length of OBJ and N is equal to the number of properties specified.
%
%   GET(OBJ) displays all property names and their current values for
%   IVI Configuration Store object OBJ.
%
%   V = GET(OBJ) returns a structure, V, where each field name is the
%   name of a property of OBJ and each field contains the value of that 
%   property.
%
%   Example:
%       h = iviconfigurationstore;
%       get(h, {'HardwareAssets','SoftwareModules'})
%       out = get(h, 'LogicalNames')
%       get(h)
%
%   See also IVICONFIGURATIONSTORE/SET.
%

%   Copyright 1999-2022 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Call builtin get if OBJ isn't an instrument object.
% Ex. get(s, s);
if ~isa(obj, 'iviconfigurationstore')
    try
        builtin('get', obj, varargin{:});
    catch aException
        rethrow(aException);
    end
    return;
end

% Parse the input.
if (nargin > 2)
    error(message('instrument:iviconfigurationstore:get:maxrhs'));
end

% Get the values that were requested.
if  ((nargout == 0) && (nargin == 1))
   % Ex. get(obj)
    if (length(obj) > 1)
        error(message('instrument:iviconfigurationstore:get:minlhs'));
    end
    
    localCreateGetDisplay(obj);
    return;    
elseif ((nargout == 1) && (nargin == 1))
   % Ex. out = get(obj);
   output = localCreateGetStruct(obj);
else
   % Ex. get(obj, 'HardwareAssets')
   output = localGet(obj, varargin{:});
end

% ---------------------------------------------------------
% Get the value of the specified property/properties of the
% specifies object/objects.
function out = localGet(obj, property)

% Initialize variables.
outputIsCell = ((iscell(property)) || (length(obj) > 1));

% If property is not a cell, make it one.
if ~iscell(property)
    property = {property};
end

% Construct the output variable.
out = cell(length(obj), length(property));

% Get the property complete names.
property = localGetPropertyCompleteNames(property);
 
% Loop through and extract the values.
for i=1:length(obj)
    for j = 1:length(property)
        out{i,j} = localGetSinglePropertyValue(obj(i), property{j});
    end
end

% Convert the output to proper format.
if outputIsCell == false
    out = out{1};
end

% ---------------------------------------------------------
% Get the value for a single object and a single property.
% The property name has already been verified.
function out = localGetSinglePropertyValue(obj, property)

switch (property)
case 'DriverSessions'
    out = localGetDriverSessions(obj.cobject.DriverSessions);
case 'HardwareAssets'
    out = localGetHardwareAssets(obj.cobject.HardwareAssets);
case 'LogicalNames'
    out = localGetLogicalNames(obj.cobject.LogicalNames);
case 'ProcessLocation'
    out = obj.cobject.ProcessDefaultLocation;
case 'PublishedAPIs'
    out = localGetPublishedApis(obj.cobject.PublishedAPIs);
case 'ServerDescription'
    out = obj.cobject.Description;
case 'Sessions'
    out = localGetDriverSessions(obj.cobject.Sessions);
case 'SoftwareModules'
    out = localGetSoftwareModules(obj.cobject.SoftwareModules);
case 'SpecificationVersion'
    out = [num2str(obj.cobject.SpecificationMajorVersion) '.' ...
        num2str(obj.cobject.SpecificationMinorVersion)];
otherwise

    if property == "DefaultLocation"
        property = "MasterLocation";
    end
    out = obj.cobject.(property);
end   

% ---------------------------------------------------------
% Return a list of properties supported by the IVI Configuration
% Store object.
function out = localGetPropertyNames

out = {'ActualLocation', 'DriverSessions', 'HardwareAssets', 'LogicalNames',...
    'DefaultLocation', 'Name', 'ProcessLocation', 'PublishedAPIs', 'Revision',...
    'ServerDescription', 'Sessions', 'SoftwareModules', 'SpecificationVersion',...
    'Vendor'};

% ---------------------------------------------------------
% Determine if the property is a structure property and therefore
% needs additional processing.
function out = localIsStructPropertyName(name)

out = any(strcmp(name, {'DriverSessions', 'HardwareAssets', 'LogicalNames', ...
    'PublishedAPIs', 'Sessions', 'SoftwareModules'}));

% ---------------------------------------------------------
function out = localGetPropertyCompleteNames(names)

% Initialize variables.
out = cell(1, length(names));

% Loop through each name and extract the complete name.
for i = 1:length(names)
    compName = localGetPropertyCompleteName(names{i});
    out{i} = compName;
end    

% ---------------------------------------------------------
% Find the property complete name.
function out = localGetPropertyCompleteName(name)

% Initialize variables.
out = '';

if lower(name) == "masterlocation"
    name = 'DefaultLocation';
end

% Get the supported properties.
allPropertyNames = localGetPropertyNames;

% Find the properties that name could be.
index = strmatch(lower(name), lower(allPropertyNames));

% If more than one was found, error.
if length(index) >= 2
    newExc = MException('instrument:iviconfigurationstore:get:invalidProp', ['The ''' name ''' property name is ambiguous for IVI Configuration Store objects.']);
    throwAsCaller(newExc);
end

% If none were found, error.
if isempty(index)
    newExc = MException('instrument:iviconfigurationstore:get:invalidProp', ['There is no ''' name ''' property for IVI Configuration Store objects.']);
    throwAsCaller(newExc);
end
   
% Return the case sensitive name.
out = allPropertyNames{index};

% ---------------------------------------------------------
% Syntax: get(obj) - no output arguments.
function localCreateGetDisplay(obj)

% Get the supported properties.
allPropertyNames = localGetPropertyNames;

for i=1:length(allPropertyNames)
    % Extract the next property to display.
    name = allPropertyNames{i};
    value = localGetSinglePropertyValue(obj, name);
    
    % Define the value of the property that is displayed.
    if localIsStructPropertyName(name)
        % If an empty structure, display empty.
        if isempty(value)
            value = '';
        else
            value = ['[1x' num2str(length(value)) ' struct]'];
        end
    end
    
    fprintf('    %s = %s\n', name, value);
end

% Create a blank line after the property value listing.
fprintf('\n');

% ---------------------------------------------------------
% Syntax: out = get(obj);
function out = localCreateGetStruct(obj)

for idx = 1:length(obj)
    out(idx).ActualLocation       = obj(idx).cobject.ActualLocation;
    out(idx).DriverSessions       = localGetDriverSessions(obj(idx).cobject.DriverSessions);
    out(idx).HardwareAssets       = localGetHardwareAssets(obj(idx).cobject.HardwareAssets);
    out(idx).LogicalNames         = localGetLogicalNames(obj(idx).cobject.LogicalNames);
    out(idx).DefaultLocation      = obj(idx).cobject.MasterLocation;
    out(idx).Name                 = obj(idx).cobject.Name;
    out(idx).ProcessLocation      = obj(idx).cobject.ProcessDefaultLocation;
    out(idx).PublishedAPIs        = localGetPublishedApis(obj(idx).cobject.PublishedAPIs);
    out(idx).Revision             = obj(idx).cobject.Revision;
    out(idx).ServerDescription    = obj(idx).cobject.Description;
    out(idx).Sessions             = localGetDriverSessions(obj(idx).cobject.Sessions);
    out(idx).SoftwareModules      = localGetSoftwareModules(obj(idx).cobject.SoftwareModules);
    out(idx).SpecificationVersion = [num2str(obj(idx).cobject.SpecificationMajorVersion) '.' ...
        num2str(obj(idx).cobject.SpecificationMinorVersion)];
    out(idx).Vendor               = obj(idx).cobject.Vendor;
end

if (length(obj) == 1)
    out = out(1);
end

% ---------------------------------------------------------
function s = localGetDriverSessions(driverSessionCollection)

s = [];

if (isempty(driverSessionCollection))
    return;
end

for idx = 1:driverSessionCollection.Count
    session = driverSessionCollection.Item(idx);
    s(idx).Type = 'DriverSession';
    s(idx).Name = session.Name;
    s(idx).Description = session.Description;
    if (~isempty(session.HardwareAsset))
        s(idx).HardwareAsset = session.HardwareAsset.Name;
    else
        s(idx).HardwareAsset = '';
    end
    if (~isempty(session.SoftwareModule))
        s(idx).SoftwareModule = session.SoftwareModule.Name;
    else
        s(idx).SoftwareModule = '';
    end
    s(idx).VirtualNames = localGetVirtualNames(session.VirtualNames);
    if (~isempty(session.SoftwareModule))
        s(idx).SoftwareModule = session.SoftwareModule.Name;
    end
    
    % The following are optional so continue if they are not there.
    
    try
        s(idx).DriverSetup = session.DriverSetup;
    end
    try
        if (session.Cache)
            s(idx).Cache = 'on';
        else
            s(idx).Cache = 'off';
        end
    end
    try

        if (session.InterchangeCheck)
            s(idx).InterchangeCheck = 'on';
        else
            s(idx).InterchangeCheck = 'off';
        end
    end
    try

        if (session.QueryInstrStatus)
            s(idx).QueryInstrStatus = 'on';
        else
            s(idx).QueryInstrStatus = 'off';
        end
    end
    try

        if (session.RangeCheck)
            s(idx).RangeCheck = 'on';
        else
            s(idx).RangeCheck = 'off';
        end
    end
    try

        if (session.RecordCoercions)
            s(idx).RecordCoercions = 'on';
        else
            s(idx).RecordCoercions = 'off';
        end
    end
    try

        if (session.Simulate)
            s(idx).Simulate = 'on';
        else
            s(idx).Simulate = 'off';
        end
    end
end

% -------------------------------------------------------------------------
% Return the hardware assets contained in the configuration store.  If the
% "collection" is really a struct, we are working with sample data, which
% can simply be returned as is.
function s = localGetHardwareAssets(assetCollection)

s = [];

if (isempty(assetCollection))
    return;
end

if (isstruct(assetCollection))
    s = assetCollection;
    return;
end

for idx = 1:assetCollection.Count
    asset = assetCollection.Item(idx);
    s(idx).Type = 'HardwareAsset';
    s(idx).Name = asset.Name;
    s(idx).Description = asset.Description;
    s(idx).IOResourceDescriptor = asset.IOResourceDescriptor;
end

% -------------------------------------------------------------------------
% Return the logical names contained in the configuration store.  If the
% "collection" is really a struct, we are working with sample data, which
% can simply be returned as is.
function s = localGetLogicalNames(logicalNameCollection)

s = [];

if (isempty(logicalNameCollection))
    return;
end

if (isstruct(logicalNameCollection))
    s = logicalNameCollection;
    return;
end

for idx = 1:logicalNameCollection.Count
    logicalName = logicalNameCollection.Item(idx);
    s(idx).Type = 'LogicalName';
    s(idx).Name = logicalName.Name;
    s(idx).Description = logicalName.Description;
    if (~isempty(logicalName.Session))
        s(idx).Session = logicalName.Session.Name;
    else
        s(idx).Session = '';
    end
end

% ---------------------------------------------------------
function s = localGetPublishedApis(publishedApiCollection)

s = [];

if (isempty(publishedApiCollection))
    return;
end

for idx = 1:publishedApiCollection.Count
    api = publishedApiCollection.Item(idx, 0, 0, '');
    s(idx).Type = 'PublishedAPI';
    s(idx).Name = api.Name;
    s(idx).MajorVersion = api.MajorVersion;
    s(idx).MinorVersion = api.MinorVersion;
    s(idx).APIType = api.Type;
end

% ---------------------------------------------------------
function s = localGetSoftwareModules(softwareModuleCollection)

s = [];

if (isempty(softwareModuleCollection))
    return;
end

for idx = 1:softwareModuleCollection.Count
    module = softwareModuleCollection.Item(idx);
    s(idx).Type = 'SoftwareModule';
    s(idx).Name = module.Name;
    s(idx).Description = module.Description;
    s(idx).ProgID = module.ProgID;
    s(idx).ModulePath = module.ModulePath;
    s(idx).Prefix = module.Prefix;
    s(idx).SupportedInstrumentModels = module.SupportedInstrumentModels;
    s(idx).PhysicalNames = localGetPhysicalNames(module.PhysicalNames, '');
    s(idx).PublishedAPIs = localGetPublishedApis(module.PublishedAPIs);
end

% ---------------------------------------------------------
function s = localGetVirtualNames(virtualNameCollection)

s = [];

if (isempty(virtualNameCollection))
    return;
end

for idx = 1:virtualNameCollection.Count
    v = virtualNameCollection.Item(idx);
    s(idx).Type = 'VirtualName';
    s(idx).Name = v.Name;
    s(idx).MapTo = v.MapTo;
end

% -------------------------------------------------------------------------
% Get the complete list of physical names for a software module.  Physical
% names and ranges may be nested which can make this process recursive.
function list = localGetPhysicalNames(physicalNameCollection, rootName)

list = {};

if (isempty(physicalNameCollection))
    return;
end

for idx = 1:physicalNameCollection.Count
    p = physicalNameCollection.Item(idx);
    list = localGetSubPhysicalNames(list, p, rootName);
end

% -------------------------------------------------------------------------
function list = localGetSubPhysicalNames(list, p, rootName)

baseName = [rootName p.Name];

if (isempty(p.PhysicalRanges) || p.PhysicalRanges.Count == 0)
    list{end + 1} = baseName;
else
    for jdx = 1:p.PhysicalRanges.Count
        range = p.PhysicalRanges.Item(jdx);
        for kdx = range.Min:range.Max
            list{end + 1} = sprintf('%s%d', baseName, kdx);
        end
    end
end
if (isempty(p.PhysicalNames) ||  p.PhysicalNames.Count == 0)
    return;
end
for jdx = 1:p.PhysicalNames.Count
    list = localGetSubPhysicalNames(list, p.PhysicalNames.Item(jdx), baseName);
end
