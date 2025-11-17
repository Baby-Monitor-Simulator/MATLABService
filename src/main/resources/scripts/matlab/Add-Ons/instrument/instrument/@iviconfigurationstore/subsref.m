function result = subsref(obj, Struct)
%SUBSREF Subscripted reference into IVI Configuration Store objects.
%
%   SUBSREF Subscripted reference into IVI Configuration Store objects.
%
%   OBJ(I) is an array formed from the elements of OBJ specified by the
%   subscript vector I.
%
%   OBJ.PROPERTY returns the property value of PROPERTY for IVI
%   Configuration Store object OBJ.
%
%   Supported syntax for IVI Configuration Store objects:
%
%   Dot Notation:                  Equivalent Get Notation:
%   =============                  ========================
%   obj.Name                       get(obj, 'Name')
%   obj(1).Name                    get(obj(1), 'Name')
%   obj(1:4).Name                  get(obj(1:4), 'Name')
%   obj(1)
%
%   See also IVICONFIGURATIONSTORE/GET.
%

%   MP 9-30-03
%   Copyright 1999-2023 The MathWorks, Inc.


% Initialize variables.
prop1 = '';
index1 = {};

% Define possible error messages
error1 = getString(message('MATLAB:legacy_two_part:cellRefFromNonCell'));
errorId = 'instrument:iviconfigurationstore:subsref:invalidSubscriptExpression';

% Parse the input.

% The first Struct can either be:
% obj(1);
% obj.SampleRate;
switch Struct(1).type
    case '.'
        prop1 = Struct(1).subs;
    case '()'
        index1 = Struct(1).subs;
    case '{}'
        throwAsCaller(MException(errorId, error1));
    otherwise
        throwAsCaller(MException(errorId, [[message('instrument:iviconfigurationstore:subsref:subsrefErrorPrefix').getString blanks(1)], Struct(1).type,'.']));
end

% Index1 will be entire object if not specified.
if isempty(index1)
    index1 = 1:length(obj);
end

% Convert index1 to a cell if necessary.
if ~iscell(index1)
    index1 = {index1};
end

% If indexing with logicals, extract out the correct values.
if islogical(index1{1})
    % Determine which elements to extract from obj.
    indices = find(index1{1} == true);
    
    % If there are no true elements within the length of obj, return.
    if isempty(indices)
        result = [];
        return;
    end
    
    % Construct new array of doubles.
    index1 = {indices};
end

% Error if index is a non-number.
for i=1:length(index1)
    if ~isnumeric(index1{i}) && (~(ischar(index1{i}) && (strcmp(index1{i}, ':'))))
        if ischar(index1{i})
            index1{i} = double(index1{1});
        else
            throwAsCaller(MException('instrument:iviconfigurationstore:subsref:UndefinedFunction', message('instrument:iviconfigurationstore:subsref:undefinedFunction', class(index1{i})).getString));
        end
    end
end

if any(cellfun('isempty', index1))
    for i = 1:length(index1)
        if ~isempty(index1{i}) && index1{i} > size(obj, i)
            throwAsCaller(message(MException('instrument:iviconfigurationstore:subsref:exceedsdims')));
        end
    end
    result = [];
    return;
elseif length(index1{1}) ~= (numel(index1{1}))
    throwAsCaller(MException(errorId, message('instrument:iviconfigurationstore:subsref:nonMatrixConcat').getString));
elseif length(index1) == 1
    if strcmp(index1{:}, ':')
        index1 = {1:length(obj)};
    end
else
    for i=1:length(index1)
        if (strcmp(index1{i}, ':'))
            index1{i} = 1:size(obj,i);
        end
    end
end

% Return the specified value.
if ~isempty(prop1)
    % Ex. obj.Name
    % Ex. obj(2).Name
    
    % Extract the object.
    indexObj = localIndexOf(obj, index1);
    
    % Get the property value.
    try
        result = get(indexObj, prop1);
    catch aException
        throwAsCaller(localFixError(aException));
    end
else
    % Ex. obj(2);
    
    % Extract the object.
    result = localIndexOf(obj, index1);
end

% Handle the next element of the subsref structure if it exists.
if length(Struct) > 1
    Struct(1) = [];
    result = subsref(result, Struct);
end

% *********************************************************************
% Index into an instrument array.
function result = localIndexOf(obj, index1)

try
    result = obj(index1{:});
catch aException
    throwAsCaller(localFixError(aException));
end

% *************************************************************************
% Remove any extra carriage returns.
function aException = localFixError (exception)

% Initialize variables.
id = exception.identifier;
errmsg = exception.message;

% Remove the trailing carriage returns.
while errmsg(end) == sprintf('\n')
    errmsg = errmsg(1:end-1);
end

aException = MException(id, errmsg);


