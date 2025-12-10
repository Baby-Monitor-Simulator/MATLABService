function out = fieldnames(obj, flag)
%FIELDNAMES Get instrument or device group object property names.
%
%   NAMES=FIELDNAMES(OBJ) returns a cell array of strings containing 
%   the names of the properties associated with instrument object or
%   device group object, OBJ. OBJ can be an array of instrument objects
%   or an array of device group objects.
%

%   MP 6-25-02
%   Copyright 1999-2011 The MathWorks, Inc. 

if ~isa(obj, 'icgroup')
    error(message('instrument:icgroup:fieldnames:invalidOBJGroup'));
end

% Error if invalid.
if ~all(isvalid(obj))
   error(message('instrument:icgroup:fieldnames:invalidOBJ'));
end

try
    % Extract all the objects.
    jobj = igetfield(obj, 'jobject');
    
    % Get the properties for the first object.
    props = getAllProperties(jobj(1));
    out = cell(props.size, 1);
    for i = 1:props.size
        out{i} = char(props.elementAt(i-1));
    end
catch
    error(message('instrument:icgroup:fieldnames:invalidOBJType'));
end
