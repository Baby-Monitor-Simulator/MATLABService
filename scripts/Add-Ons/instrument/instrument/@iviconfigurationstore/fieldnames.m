function out = fieldnames(obj)
%FIELDNAMES Get IVI Configuration Store object property names.
%
%   NAMES=FIELDNAMES(OBJ) returns a cell array of strings containing 
%   the names of the properties associated with IVI Configuration Store
%   object, OBJ. OBJ can be an array of IVI Configuration Store objects.
%

%   MP 9-30-03
%   Copyright 1999-2005 The MathWorks, Inc.

if ~isa(obj, 'iviconfigurationstore')
    error(message('instrument:iviconfigurationstore:fieldnames:invalidOBJ'));
end

out = fieldnames(get(obj));
