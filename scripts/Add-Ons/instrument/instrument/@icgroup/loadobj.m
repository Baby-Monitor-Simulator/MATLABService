function obj = loadobj(B)
%LOADOBJ Load filter for device group objects.
%
%   OBJ = LOADOBJ(B) is called by LOAD when a device group object
%   is loaded from a .MAT file. The return value, OBJ, is subsequently 
%   used by LOAD to populate the workspace.  
%
%   LOADOBJ will be separately invoked for each object in the .MAT file.
%


%   MP 3-14-00
%   Copyright 1999-2012 The MathWorks, Inc.

% Warn if java is not running.
if ~usejava('jvm')
    % Store the warn state.
    warnstate = warning('backtrace', 'off');
    
    % Warn nicely.
    warning(message('instrument:loadobj:nojvmDevice'));
    
    % Restore the warn state.
    warning(warnstate);
    
    % Return empty array.
    obj = [];
    return;
end

obj = B;

if strcmp(builtin('class', obj), 'icgroup')
    obj = struct(obj);
elseif ~isa(obj, 'struct')
    obj = struct(obj);
end

% Find the instrument package.
instrPackage = findpackage('instrument');
if isempty(instrPackage)
	instrPackage = schema.package('instrument');
end

% Get the object's instrument object's store field.
if isfield(obj, 'store')
    propInfo = obj.store;
else
    instrumentField = obj.instrument;
    propInfo = igetfield(instrumentField, 'store');
end

if isempty(propInfo)
    return;
end

% Recreate the objects.
for i = 1:length(propInfo)
	% Get the property structure.
	propVals = propInfo(i).props;

    if ischar(propVals)
        propInfo(i).obj = handle(javaObject(propVals));
        dispose(propInfo(i).obj);
	elseif isstruct(propVals)
        % Determine if the object has already been created - based on creation time.
        tempObj = instrfind('CreationTime', propVals.CreationTime);
        if ~isempty(tempObj)
            propInfo(i).obj = igetfield(tempObj, 'jobject');
            if strcmp(propVals.Type, 'icgroup')
                [propInfo(i).obj propVals parent] = localConstructDeviceChildObject(propInfo(i).obj, propVals);
            end
            continue;
        end   

		% Create the object based on the type.
        constructorArgs = propVals.ConstructorArgs;
        if isjava(constructorArgs)
	        constructorArgs = cell(constructorArgs);
        end
		[propInfo(i).obj, propVals] = localConstructDeviceObject(constructorArgs, propVals);
		
        % Add to UDD database.
		connect(propInfo(i).obj, instrPackage.DefaultDatabase, 'up');
        [propInfo(i).obj propVals parent] = localConstructDeviceChildObject(propInfo(i).obj, propVals);
        propVals = rmfield(propVals, {'Type', 'ConstructorArgs'});
        set(parent, propVals);
        
        % Reset the properties.
        propVals = rmfield(propVals, {'Type', 'ConstructorArgs'});
		set(propInfo(i).obj, propVals);
	else
		propInfo(i).obj = propVals;
    end
end

% Restore the jobject field to the correct objects.
jobject = obj.jobject;
out = icgroup(propInfo(jobject{1}).obj);
for i = 2:length(jobject)
    out = [out icgroup(propInfo(jobject{i}).obj)];
end

obj = out;

% Parse through each object's Fcn and UserData properties to determine
% if the values contain an instrument object.
localRestoreUserDataAndFcnProps(propInfo);

% **************************************************************************
% Restore the UserData and fcn properties.
function localRestoreUserDataAndFcnProps(propInfo)

for i = 1:length(propInfo)
    % Get the current location of the object.
    currentObj = propInfo(i).obj;
    allLocations = propInfo(i).location;
    
    % Loop through each location and restore the object.
    for j = 1:length(allLocations)
        loc = allLocations{j};

        if iscell(loc.ObjectIndex)
            % If a group object was saved, the ObjectIndex will be
            % the location of the device object, the group object name
            % and the indices of the group object.
            
            % Extract the device object.
            index     = loc.ObjectIndex{1};
            setObject = propInfo(index).obj;
            
            % Extract the group object.
            currentPropValue = get(setObject, loc.Property);
            setObject = get(setObject, loc.ObjectIndex{2});
            setObject = setObject(1);
            
            % Extract the elements of the group object that were saved.
            vals = loc.ObjectIndex{3};
            vals = [vals{:}];
            setObject = setObject(vals);  
            
            % Update the local variables.
            currentPropValue = setObject;            
            loc.ObjectIndex = loc.ObjectIndex{1};
        else
            setObject = propInfo(loc.ObjectIndex).obj;
            currentPropValue = get(setObject, loc.Property);
        end           
        
        if isnumeric(loc.Index)
            % Contains a direct instrument object. Ex. s.UserData = s;
            currentPropValue = localFillInArray(currentPropValue, localWrapIntoInstrument(currentObj), loc.Index);
        else
            % Instrument object is within a structure or a cell.
            if (length(loc.Index) > 2) && (isnumeric(loc.Index{end}) && strcmp(loc.Index{end-1}, '()'))
                currentPropValue = localFillInStructOrCellWithArray(currentPropValue, localWrapIntoInstrument(currentObj), loc.Index);
            else
            	currentPropValue = localFillInStructOrCell(currentPropValue, localWrapIntoInstrument(currentObj), loc.Index);
            end
        end
        
        % Update the propInfo structure.
        eval(['propInfo(' num2str(loc.ObjectIndex) ').obj.' loc.Property ' =  currentPropValue;'])
    end    
end

% ****************************************************************************
% Fill in the array according to the index value.
function currentPropValue = localFillInStructOrCell(currentPropValue, obj, index) %#ok<INUSL>

% Build up the string to access the UDD object.
stringToAccessUDD = '';
for i = 1:2:length(index)
    currentDelimiter = index{i};
    switch (currentDelimiter)
    case '()'
        stringToAccessUDD = [stringToAccessUDD '(' num2str(index{i+1}) ')'];
    case '{}'
        stringToAccessUDD = [stringToAccessUDD '{' num2str(index{i+1}) '}'];
    case '.'
        stringToAccessUDD = [stringToAccessUDD '.' index{i+1}];
    end
end

% Set the property to the object.
eval(['currentPropValue' stringToAccessUDD ' = obj;']);

% ****************************************************************************
% Fill in the array according to the index value.
function currentPropValue = localFillInStructOrCellWithArray(currentPropValue, obj, index)

% Build up the string to access the UDD object.
stringToAccessUDD = '';
for i = 1:2:length(index)-2  
    currentDelimiter = index{i};
    switch (currentDelimiter)
    case '()'
        stringToAccessUDD = [stringToAccessUDD '(' num2str(index{i+1}) ')'];
    case '{}'
        stringToAccessUDD = [stringToAccessUDD '{' num2str(index{i+1}) '}'];
    case '.'
        stringToAccessUDD = [stringToAccessUDD '.' index{i+1}];
    end
end

% Set the property to the object.
if ~isempty(currentPropValue)
	val = eval(['currentPropValue' stringToAccessUDD ';']);
	val = localFillInArray(val, obj, index{end});
else
    val = localFillInArray('', obj, index{end});
end

eval(['currentPropValue' stringToAccessUDD ' = val;']);

% ****************************************************************************
% Fill in the array according to the index value.
function currentPropValue = localFillInArray(currentPropValue, obj, index)

len = length(currentPropValue);
if (len == 0)
    if (index == 1)
        currentPropValue = obj;
    else
        % Need to fill in something - Use the object.
        for i = 1:index
            currentPropValue = [currentPropValue obj];
        end
    end
else
    if (index <= len)
        currentPropValue = localReplaceElement(currentPropValue, {index}, obj);
    else
        % Need to fill in something - Use the object.
        for i=len+1:index
            currentPropValue = [currentPropValue obj];
        end
    end
end  

% ****************************************************************************
% Wrap UDD object into a OOPs object.
function obj = localWrapIntoInstrument(uddObj)

className = class(uddObj);
if isempty(findstr('javahandle.com.mathworks.toolbox.instrument.', className))
    if isempty(findstr('Device', className))
        obj = uddObj;
        return;
    end
end

if findstr('Device', class(uddObj))
    obj = icdevice(uddObj);
end

% *********************************************************************
% Replace the specified element.
function [obj, errflag] = localReplaceElement(obj, index, Value)

% Initialize variables.
errflag = 0;

try
   % Get the current state of the object.
   jobject = igetfield(obj, 'jobject');
   type = igetfield(obj, 'type');
   constructor = igetfield(obj, 'constructor');
   
   if ~iscell(type)
      type = {type};
   end
   
   if ~iscell(constructor)
       constructor = {constructor};
   end
   
   % Replace the specified index with Value.
   if ~isempty(Value)
       if ((length([index{1}]) > 1) && (length(Value) > 1))
           % Ex. y(:) = x(2:-1:1); where y and x are 1-by-2 instrument arrays.
           jobject(index{1}) = igetfield(Value, 'jobject');
      	   type(index{1}) = igetfield(Value, 'type');
           constructor(index{1}) = igetfield(Value, 'constructor');
       else
           % Ex. y(1) = x(2);
           % Ex. y(:) = x;
      	   jobject(index{1}) = igetfield(Value, 'jobject');
      	   type(index{1}) = {igetfield(Value, 'type')};
           constructor(index{1}) = {igetfield(Value, 'constructor')};
       end
   else
      jobject(index{1}) = [];
      type(index{1}) = [];
      constructor(index{1}) = [];
   end
   
   % Assign the new state back to the original object.
   obj = isetfield(obj, 'jobject', jobject);
   obj = isetfield(obj, 'type', type);
   obj = isetfield(obj, 'constructor', constructor);
catch
   errflag = 1;
   return
end
 
% *********************************************************************
% Construct the device object.
function [obj, propVals] = localConstructDeviceObject(constructorArgs, propVals)

% Determine the type of driver that is used with the device object.
constructorType = constructorArgs.type;

% Extract the driver value.
driver  = constructorArgs.driver;


% Construct the object. Go through constructor so that inputs and outputs
% are added automatically.
if strcmp(constructorType, 'MATLAB interface driver')
    hwobj   = constructorArgs.object;
    tempObj = icdevice(driver, hwobj);
else
    tempObj = icdevice(driver);
end

obj = igetfield(tempObj, 'jobject');

% Get the group properties.
groups = obj.getPropertyGroups;

% The parent group is the base icdevice object and has already been saved.
groups.removeElement('parent');

% Configure the group properties.
for i = 0:groups.size-1
    % Get the next group java object.
    groupname = groups.elementAt(i);
    jgroup    = obj.getJGroup(groupname);
    
    % Get the saved property values.
    data = propVals.(groupname);
    
    % Configure the properties.
    for j = 1:length(jgroup)
        set(jgroup(j), data(j));        
    end
    propVals = rmfield(propVals, groupname);
end

% *********************************************************************
% Construct the device child object.
function [jchild, propVals, parent] = localConstructDeviceChildObject(parent, propVals)

% Get the children from the parent.
child    = parent.(propVals.SavedType);
jchild   = igetfield(child, 'jobject');

% Extract the child that was saved.
jchild   = jchild(propVals.SavedIndex);

% Remove non-properties from propVals.
propVals = rmfield(propVals, {'SavedIndex', 'SavedType'});
