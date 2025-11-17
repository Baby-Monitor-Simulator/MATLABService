function out = set(obj, varargin)
%SET Configure or display IVI Configuration Store object properties.
%
%   IVI Configuration Store object property values cannot be configured
%   with the SET command. The following IVI Configuration Store object
%   properties are configurable with the ADD, COMMIT and REMOVE functions:
%
%       1. DriverSessions
%       2. HardwareAssets
%       3. LogicalNames
%
%   All other IVI Configuration Store object properties are read-only
%   and cannot be modified.
%
%   See also IVICONFIGURATIONSTORE/ADD, IVICONFIGURATIONSTORE/COMMIT,
%   IVICONFIGURATIONSTORE/GET, IVICONFIGURATIONSTORE/REMOVE.
%

%   Copyright 1999-2022 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Call builtin set if OBJ isn't an iviconfigurationstore object.
% Ex. set(s, 'UserData', s);
if ~isa(obj, 'iviconfigurationstore')
    try
        builtin('set', obj, varargin{:});
    catch aException
        rethrow(aException);
    end
    return;
end

% Ex. set(obj)
% Ex. out = set(obj);
if nargin == 1
    if nargout == 1
        out = [];
    end
    return;
end

% Ex. set(obj, 'Name')
if (nargin == 2)
    % Ex. set(obj, 'Name')
    prop = varargin{1};

    % Handle case when property is a string.
    if ischar(prop)
        % Get the complete name for the property.
        prop = localGetPropertyCompleteName(prop);

        % Error appropriately.
        if (localIsStructPropertyName(prop))
            error(message('instrument:iviconfigurationstore:set:invalidSetReadOnly', prop, prop));
        else
            error(message('instrument:iviconfigurationstore:set:invalidSetProp', prop));
        end
    end

    % Handle case when it is a struct.
    if isstruct(prop)
        error(message('instrument:iviconfigurationstore:set:invalidSetHelp'));
    else
        error(message('instrument:iviconfigurationstore:set:invalidSetPVPair'));
    end
else
    % Extract the properties specified.
    allProps = createArrayOfAllProps(varargin{:});

    % Get the property complete version.
    allProps = localGetPropertyCompleteNames(allProps);

    % Error appropriately.
    prop = allProps{1};
    if (localIsStructPropertyName(prop))
        error(message('instrument:iviconfigurationstore:set:invalidSet', allProps{ 1 }, prop));
    else
        error(message('instrument:iviconfigurationstore:set:invalidSetPerm', allProps{ 1 }));
    end
end

% ---------------------------------------------------------
% Create a cell of properties that are being configured.
function allProps = createArrayOfAllProps(varargin)

% Create a cell array of properties that are being configured.
index    = 1;
allProps = {};

try
    while index <= nargin
        switch class(varargin{index})
            case 'char'
                % Concatenate properties.
                prop = varargin{index};
                allProps = {allProps{:} prop};

                % Update index.
                index = index+2;
            case 'cell'
                % Concatenate properties.
                prop = varargin{index};
                if (iscell([prop{:}]))
                    newExc = MException('instrument:instrfind:invalidPVPair','Invalid param-value pairs specified.' );
                    throwAsCaller(newExc);
                end
                allProps = {allProps{:} prop{:}};

                % Update index.
                index = index+2;
            case 'struct'
                % Concatenate properties.
                propStruct = varargin{index};
                prop = fieldnames(propStruct);
                allProps = {allProps{:} prop{:}};

                % Update index.
                index = index+1;
            otherwise
                newExc = MException('instrument:instrfind:invalidPVPair','Invalid param-value pairs specified.' );
                throwAsCaller(newExc);
        end
    end
catch
    newExc = MException('instrument:instrfind:invalidPVPair','Invalid param-value pairs specified.' );
    throwAsCaller(newExc);
end

% ---------------------------------------------------------
% Return a list of properties supported by the IVI Configuration
% Store object.
function out = localGetPropertyNames

out = {'ActualLocation', 'DriverSessions', 'HardwareAssets', 'LogicalNames',...
    'DefaultLocation', 'MasterLocation', 'Name', 'ProcessLocation', 'PublishedAPIs', 'Revision',...
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

% Get the supported properties.
allPropertyNames = localGetPropertyNames;

% Find the properties that name could be.
index = strmatch(lower(name), lower(allPropertyNames));

% If more than one was found, error.
if length(index) >= 2
    newExc = MException('instrument:iviconfigurationstore:set:invalidProp', 'The ''%s'' property name is ambiguous for IVI Configuration Store objects.',name);
    throwAsCaller(newExc);
end

% If none were found, error.
if isempty(index)
    newExc = MException('instrument:iviconfigurationstore:set:invalidProp', 'There is no ''%s'' property for IVI Configuration Store objects.',name);
    throwAsCaller(newExc);
end

% Return the case sensitive name.
out = allPropertyNames{index};
