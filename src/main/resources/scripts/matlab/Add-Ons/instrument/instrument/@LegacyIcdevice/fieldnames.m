function out = fieldnames(obj, flag)
%FIELDNAMES Get instrument object property names.
%
%   NAMES=FIELDNAMES(OBJ) returns a cell array of strings containing 
%   the names of the properties associated with instrument object, OBJ.
%   OBJ can be an array of instrument objects of the same type.

%   Copyright 1999-2024 The MathWorks, Inc. 

if ~isa(obj, 'instrument')
    error(message('instrument:fieldnames:invalidOBJNotInstr'));
end

% Error if invalid.
if ~all(isvalid(obj))
   error(message('instrument:fieldnames:invalidOBJInstr'));
end

try
    % Extract all the objects.
    jobj = igetfield(obj, 'jobject');
    
    % Get the properties for the first object.
    props = getAllProperties(jobj(1));
    first = cell(props.size, 1);
    for i = 1:props.size
        first{i} = char(props.elementAt(i-1));
    end
    
    % Get the properties for the remaining objects and verify they
    % equal the first objects.    
    for i = 2:length(jobj)
        props = getAllProperties(jobj(i));
        temp = cell(props.size, 1);
        for i = 1:props.size
            temp{i} = char(props.elementAt(i-1));
        end
        if ~isequal(temp, first)
            error(message('instrument:fieldnames:invalidOBJMix'));
        end
    end
    out = first;
catch
    error(message('instrument:fieldnames:invalidOBJMix'));
end

