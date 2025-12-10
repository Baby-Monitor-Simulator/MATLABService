function out = igetfield(obj, field)
%IGETFIELD Get instrument object internal fields.
%
%   VAL = IGETFIELD(OBJ, FIELD) returns the value of object's, OBJ,
%   FIELD to VAL.
%
%   This function is a helper function for the concatenation and
%   manipulation of instrument object arrays. This function should
%   not be used directly by users.
%

%   Copyright 1999-2013 The MathWorks, Inc. 

% Return the specified field information.

out = obj.(field);
