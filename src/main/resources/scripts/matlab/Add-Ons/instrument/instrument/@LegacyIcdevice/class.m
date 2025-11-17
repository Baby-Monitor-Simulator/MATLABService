function val = class(obj,varargin)
%CLASS Create object or return object class.
%
%   VAL = CLASS(OBJ) returns the class of the object OBJ.
%
%   Within a constructor method, CLASS(S,'class_name') creates an
%   object of class 'class_name' from the structure S.  This
%   syntax is only valid in a function named <class_name>.m in a
%   directory named @<class_name> (where <class_name> is the same
%   as the string passed into CLASS).
%
%   See also ISA, SUPERIORTO, INFERIORTO, STRUCT.

%   Copyright 1999-2024 The MathWorks, Inc.

% When returning the class of an object, if the object is 1-by-1, the
% class of the object is returned - icdevice, if the object
% is not 1-by-1 then 'instrument' is returned.

if nargin==1
    if length(obj) > 1
        val = 'instrument';
    else
        val = builtin('class', obj);
    end
else
    try
        % Constructing the object.  Call the builtin CLASS.
        val = builtin('class', obj, varargin{:});
    catch aException
        rethrow(aException);
    end
end

if strcmp(val, 'LegacyIcdevice')
    val = 'icdevice';
end
