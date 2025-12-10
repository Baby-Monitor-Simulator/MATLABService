function Obj = subsasgn(Obj, Struct, Value)
%SUBSASGN Subscripted assignment into device group objects.
%
%   SUBSASGN Subscripted assignment into device group objects. 
%
%   OBJ(I) = B assigns the values of B into the elements of OBJ specified by
%   the subscript vector I. B must have the same number of elements as I
%   or be a scalar.
% 
%   OBJ(I).PROPERTY = B assigns the value B to the property, PROPERTY, of
%   device group object OBJ.
%
%   Supported syntax for device group objects:
%
%   Dot Notation:                  Equivalent Set Notation:
%   =============                  ========================
%   obj.Name='sydney';             set(obj, 'Name', 'sydney');
%   obj(1).Name='sydney';          set(obj(1), 'Name', 'sydney');
%   obj(1:4).Name='sydney';        set(obj(1:4), 'Name', 'sydney');
%   obj(1)=obj(2);               
%   obj(2)=[];
%
%   See also ICGROUP/SET, ICGROUP/PROPINFO, INSTRHELP.
%

%   MP 6-25-02
%   Copyright 1999-2013 The MathWorks, Inc.

% Error checking when input argument, Obj, is empty.
if isempty(Obj)
   % Ex. s(1) = serial('COM1');
   if isequal(Struct.type, '()') && isequal(Struct.subs{1}, 1:length(Value))
      Obj = Value;
      return;
   elseif length(Value) ~= length(Struct.subs{1})
      % Ex. s(1:2) = serial('COM1');
      error(message('instrument:icgroup:subsasgn:index_assign_element_count_mismatch'));
   elseif Struct.subs{1}(1) <= 0
      error(message('instrument:icgroup:subsasgn:badsubscriptPos'))
   else
      % Ex. s(2) = serial('COM1'); where s is originally empty.
      error(message('instrument:icgroup:subsasgn:badsubscriptGap'));
   end
end

% Initialize variables.
oldObj = Obj;
prop1  = '';
index1 = {};

% Types of indexing allowed.
% g(1)
% g(1).UserData
% g(1).UserData(1,:)
% g.UserData
% g.UserData(1,:)
% d(1).Input
% d(1).Input(1).Name
% d(1).Input(1).Name(1:3)
% d.Input(1).Name
% d.Input(1).Name(1:3)

% Initialize variables for finding the object and property.
remainingStruct = [];
foundProperty   = false;
needToContinue  = true;
exception       = [];
i               = 0;

% Want to loop until there is an object and a property. There may be
% more structure elemenets - for indexing into the property, e.g. 
% g(1).UserData(1,:) = [1 2 3];
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
        prop1           = Struct(i).subs;
        foundProperty   = true;
        remainingStruct = Struct(i+1:end);
    case '()'
        index1 = Struct(i).subs;
        index1 = localConvertIndices(Obj, index1);
        [Obj,  exception]  = localIndexOf(Obj, index1);
        % Don't throw error here, in case the expression is
        % x = [obj obj]; x(3) = obj; If the expression is not
        % valid, e.g. x(4).UserData, the error will be thrown
        % the next time through the while loop.
    case '{}'
        error(message('instrument:icgroup:subsasgn:invalidSubscriptExpression'));
    otherwise
        error(message('instrument:icgroup:subsasgn:invalidSubscriptExpressionType', Struct( i ).type));
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
   % Ex. obj.Tag = 'agilent'
   % Ex. obj(2).Tag = 'agilent'
   
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
   if ~(isa(Value, 'icgroup') || isempty(Value))
      error(message('instrument:icgroup:subsasgn:invalidConcat'));
   end
   
   % Ex. s(1) = [] and s is 1-by-1.
   if ((length(Obj) == 1) && isempty(Value))
       error(message('instrument:icgroup:subsasgn:invalidAssignment'));
   end
   
   % Error if index is a non-number.
   for i=1:length(index1)
       if ~isnumeric(index1{i}) && (~(ischar(index1{i}) && (strcmp(index1{i}, ':'))))
           error(message('instrument:icgroup:subsasgn:badsubscriptSubsindex', class( index1{ i } )));
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
                   error(message('instrument:icgroup:subsasgn:index_assign_element_count_mismatch'));
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
                   error(message('instrument:icgroup:subsasgn:badsubscriptGap'));
               end
           end
           
           % Verify that the index doesn't add a gap.
           if min(temp) > length(Obj)+1
               % Ex. x = [g g g];
               %     x([5 6]) = [g1 g1];
               error(message('instrument:icgroup:subsasgn:badsubscriptGap'));
           end
           
           % If the length of the object being assigned is not one, it must
           % match the length of the index array.
           if ~isempty(Value) && length(Value) > 1 
               if length(currentIndex) ~= length(Value)
                   error(message('instrument:icgroup:subsasgn:index_assign_element_count_mismatch'));
               end
           end
       end
   end
   
   % Assign the value.
   try
       Obj = localReplaceElement(Obj, index1, Value);
   catch aException
       throwAsCaller(localFixError(aException));
   end
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
    if (isempty(index))
        return;
    end
   % Get the current state of the object.
   jobject = igetfield(obj, 'jobject');
   type    = igetfield(obj, 'type');
   
   % Ensure that the arrays are cell arrays.
   if ~iscell(type)
      type = {type};
   end
   
   % Replace the specified index with Value.
   if isempty(Value)
      jobject(index{:})      = [];
      type(index{:})         = [];
   elseif length(Value) == 1
       jobject(index{:})     = igetfield(Value, 'jobject');
 	   type(index{:})        = {igetfield(Value, 'type')};
   else
       % Ex. y(:) = x(2:-1:1); where y and x are 1-by-2 instrument arrays.
       jobject(index{:})     = igetfield(Value, 'jobject');
  	   type(index{:})        = igetfield(Value, 'type');
   end
   
   if length(type) == 1 && iscell(type)
       type = type{:};
   end
   
   if length(type) ~= numel(type)
       newExc = MException('instrument:icgroup:subsasgn:nonMatrixConcat', 'Only a row or column vector of device group objects can be created.');
       throwAsCaller(newExc);
   end

   % Assign the new state back to the original object.
   obj = isetfield(obj, 'jobject', jobject);
   obj = isetfield(obj, 'type', type);
catch aException
    throw (aException);
end

% *********************************************************************
% Index into an instrument array.
function  [result,  exception]  = localIndexOf(obj, index1)

exception =[];
try   
    % Default result, when the index1 is empty
    result = obj;
    
    % Create result with the indexed elements.
    if (~isempty(index1))
        % Get the field information of the entire object.
        jobj = igetfield(obj, 'jobject');
        type = igetfield(obj, 'type');
        
        result = isetfield(result, 'jobject', jobj(index1{:}));
        result = isetfield(result, 'type', type(index1{:}));
    end
catch %#ok<CTCH>
   exception = MException('instrument:icgroup:subsasgn:badsubscriptExceed','Index exceeds matrix dimensions.' );
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

aException = MException(id , errmsg);
