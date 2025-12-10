function out = geterror(obj)
%GETERROR Check and return error message from instrument.
%
%   MSG = GETERROR(OBJ) checks the instrument associated with device object,
%   OBJ, for an error message and returns to MSG. The interpretation of MSG
%   will vary based on the instrument.

%   Copyright 1999-2024 The MathWorks, Inc. 

% Error checking.
if (length(obj) > 1)
    error(message('instrument:icdevice:geterror:invalidOBJ'));
end

% Call getError on the java object.
try
    jobj = igetfield(obj, 'jobject');    
    out = char(getError(jobj));
catch aException
    newExc = MException('instrument:icdevice:geterror:opfailed', [aException.message ' Use MIDEDIT to update the driver if appropriate.']);
    throw(newExc);
end   
