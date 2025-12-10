function Obj = subsasgn(Obj, Struct, Value)
%SUBSASGN Subscripted assignment into IVI Configuration Store objects.
%
%   SUBSASGN Subscripted assignment into IVI Configuration Store objects.
%
%   OBJ(I) = B assigns the values of B into the elements of OBJ specified by
%   the subscript vector I. B must have the same number of elements as I
%   or be a scalar.
%
%   Supported syntax for IVI Configuration Store objects:
%
%   Dot Notation:
%   =============
%   obj(1)=obj(2);
%   obj(2)=[];
%
%   See also IVICONFIGURATIONSTORE/SET.
%

%   MP 7-13-99
%   Copyright 1999-2013 The MathWorks, Inc.

if isempty(Obj)
    % Ex. s(1) = iviconfigurationstore;
    if isequal(Struct.type, '()') && isequal(Struct.subs{1}, 1:length(Value))
        Obj = Value;
        return;
    elseif length(Value) ~= length(Struct.subs{1})
        % Ex. s(1:2) = iviconfigurationstore;
        error(message('instrument:iviconfigurationstore:subsasgn:index_assign_element_count_mismatch'));
    elseif Struct.subs{1}(1) <= 0
        error(message('instrument:iviconfigurationstore:subsasgn:badsubscriptIndices'))
    else
        % Ex. s(2) = iviconfigurationstore; where s is originally empty.
        error(message('instrument:iviconfigurationstore:subsasgn:badsubscriptGap'));
    end
end

% Initialize variables.
oldObj = Obj;
prop1  = '';
index1 = {};

% Initialize variables for finding the object and property.
remainingStruct = [];
foundProperty   = false;
needToContinue  = true;
exception       = [];
i               = 0;

% Want to loop until there is an object and a property. There may be
% more structure elements - for indexing into the property.
while (needToContinue == true)
    % If there was an error and need to continue checking the
    % subsasgn structure, throw the error message.
    if ~isempty(exception)
        rethrow(exception);
    end
    
    % Increment the counter.
    i = i+1;
    
    switch Struct(i).type
        case '.'
            % e.g. d.Input;
            prop1   = Struct(i).subs;
            foundProperty   = true;
            remainingStruct = Struct(i+1:end);
        case '()'
            index1 = Struct(i).subs;
            index1 = localConvertIndices(Obj, index1);
            [Obj, exception] = localIndexOf(Obj, index1);
            % Don't throw error here, in case the expression is
            % x = [obj obj]; x(3) = obj; If the expression is not
            % valid, e.g. x(4).UserData, the error will be thrown
            % the next time through the while loop.
        case '{}'
            error(message('instrument:iviconfigurationstore:subsasgn:invalidSubscriptExpression'));
        otherwise
            error(message('instrument:iviconfigurationstore:subsasgn:invalidSubscriptExpressionType', Struct( i ).type));
    end
    
    % Determine if the loop needs to continue.
    if i == length(Struct)
        needToContinue = false;
    elseif (foundProperty == true)
        needToContinue = false;
    end
end

% Set the specified value.
if ~isempty(prop1)
    
    % Set the property.
    try
        if isempty(remainingStruct)
            set(Obj, prop1, Value);
        else
            tempObj   = get(Obj, prop1);
            tempValue = subsasgn(tempObj, remainingStruct, Value);
            set(Obj, prop1, tempValue);
        end
        
        % Reset the object so that it's value isn't corrupted.
        Obj = oldObj;
    catch aException
        throwAsCaller(localFixError(aException));
    end
else
    % Reset the object.
    Obj = oldObj;
    
    % Ex. obj(2) = obj(1);
    if ~(isa(Value, 'iviconfigurationstore') || isempty(Value))
        error(message('instrument:iviconfigurationstore:subsasgn:invalidConcat'));
    end
    
    % Ex. s(1) = [] and s is 1-by-1.
    if ((length(Obj) == 1) && isempty(Value))
        error(message('instrument:iviconfigurationstore:subsasgn:invalidAssignment'));
    end
    
    % Error if index is a non-number.
    for i=1:length(index1)
        if ~isnumeric(index1{i}) && (~(ischar(index1{i}) && (strcmp(index1{i}, ':'))))
            error(message('instrument:iviconfigurationstore:subsasgn:badsubscriptclass', class( index1{ i } )));
        end
    end
    
    % Error if a gap will be placed in array or if the value being assigned has an
    % incorrect size.
    for i = 1:length(index1)
        % If index is specified as ':', then the length of the value
        % must be either one or the length of size.
        if strcmp(index1{i}, ':')
            if i < 3
                if length(Value) == 1 || isempty(Value)
                    % If the length is one or is empty, do nothing.
                elseif ~(length(Value) == size(Obj, 1) || length(Value) == size(Obj, 2))
                    % If the length is greater than one, it must equal the
                    % length of the dimension.
                    error(message('instrument:iviconfigurationstore:subsasgn:index_assign_element_count_mismatch'));
                end
            end
        elseif ~isempty(index1{i}) && max(index1{i}) > size(Obj, i)
            % Determine if any of the indices specified exceeds the length
            % of the object array.
            currentIndex = index1{i};
            temp  = currentIndex(currentIndex>length(Obj));
            
            % Don't allow gaps into array.
            if ~isempty(temp)
                % Ex. x = [g g g];
                %     x([3 5]) = [g1 g1];
                temp2 = min(temp):max(temp);
                if ~isequal(temp, temp2)
                    error(message('instrument:iviconfigurationstore:subsasgn:badsubscriptGap'));
                end
            end
            
            % Verify that the index doesn't add a gap.
            if min(temp) > length(Obj)+1
                % Ex. x = [g g g];
                %     x([5 6]) = [g1 g1];
                error(message('instrument:iviconfigurationstore:subsasgn:badsubscriptGap'));
            end
            
            % If the length of the object being assigned is not one, it must
            % match the length of the index array.
            if ~isempty(Value) && length(Value) > 1
                if length(currentIndex) ~= length(Value)
                    error(message('instrument:iviconfigurationstore:subsasgn:index_assign_element_count_mismatch'));
                end
            end
        end
    end
    
    % Assign the value.
    Obj = localReplaceElement(Obj, index1, Value);
    
end

% *************************************************************************
function index = localConvertIndices(obj, index)

% Index1 will be entire object if not specified.
if isempty(index)
    index = 1:length(obj);
end

% Convert index1 to a cell if necessary.
if ~iscell(index)
    index = {index};
end

% If indexing with logicals, extract out the correct values.
if islogical(index{1})
    % Determine which elements to extract from obj.
    indices = find(index{1} == true);
    
    % If there are no true elements within the length of obj, return.
    if isempty(indices)
        index = {};
        return;
    end
    
    % Construct new array of doubles.
    index = {indices};
end

% *********************************************************************
% Replace the specified element.
function obj = localReplaceElement(obj, index, Value)

try
    % If the index is empty then there are no replacements.
    if (isempty(index))
       return; 
    end
    
    obj(index{1}) = Value;
catch aException
    throwAsCaller(localFixError(aException));
end

% *********************************************************************
% Index into an instrument array.
function [result, exception] = localIndexOf(obj, index1)

try
    % Default result, when the index1 is empty
    result = obj;
    
    % Create result with the indexed elements.
    if (~isempty(index1))
        result = obj(index1{:});
    end
catch %#ok<CTCH>
    result = [];
    exception = MException('instrument:iviconfigurationstore:subsasgn:badsubscriptDim','Index exceeds matrix dimensions.' );
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
