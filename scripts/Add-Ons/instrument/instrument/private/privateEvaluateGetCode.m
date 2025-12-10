function propertyValue = privateEvaluateGetCode(obj, propertyName, fcn, index, group)
%PRIVATEEVALUATEGETCODE helper function used by device objects.
%
%   PRIVATEEVALUATEGETCODE helper function used by the device objects.
%
%   PRIVATEEVALUATEGETCODE is used when a device object property is 
%   queried with the GET command if the property has a Type of Code.
%   
%   This function should not be called directly by the user.
%  
 
%   MP 01-03-03
%   Copyright 1999-2012 The MathWorks, Inc.

if isempty(fcn)
    return;
end

% If the property is a group object property, extract the group
% object and assign to obj.
if (index ~= -1)
    obj = get(obj, group);
    obj = obj(index);
end

% Extract the code from the fcn to be evaluated.
indexcr  = findstr(fcn, sprintf('\n'));
indexfcn = findstr(fcn, 'function');
index    = find(indexcr>indexfcn(1));
index    = indexcr(index(1));

fcnline = fcn(1:index(1));
code    = fcn(index(1)+1:end);

if isempty(code)
    return;
end

try
    eval(code);
catch aException
    localCleanupError(aException);
end

if ~exist('propertyValue', 'var')
    error(message('instrument:get:opfailed'));
end

% ---------------------------------------------------------
function localCleanupError (exception)

id =  exception.identifier;
msg =  exception.message;
msg = strrep(msg, [getString(message('MATLAB:legacy_two_part:error_using')) ' ==> privateEvaluateGetCode' sprintf('\n')], '');
newExc = MException(id, msg);
throwAsCaller(newExc);

