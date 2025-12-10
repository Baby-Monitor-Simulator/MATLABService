function out = igetfield(obj, field)
%IGETFIELD Get device group object internal fields.
%
%   VAL = IGETFIELD(OBJ, FIELD) returns the value of object's, OBJ,
%   FIELD to VAL.
%
%   This function is a helper function for the concatenation and
%   manipulation of device group object arrays. This function should
%   not be used directly by users.
%

%   MP 6-25-02
%   Copyright 1999-2011 The MathWorks, Inc. 

% Return the specified field information.
try
    out = obj.(field);
catch
   error(message('instrument:icgroup:igetfield:invalidFIELD', field));
end
