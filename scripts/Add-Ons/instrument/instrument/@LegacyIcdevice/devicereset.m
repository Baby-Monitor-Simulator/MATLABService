function devicereset(obj)
%DEVICERESET Reset instrument.
% 
%   DEVICERESET(OBJ) resets the instrument associated with device
%   object, OBJ. 

%   Copyright 1999-2024 The MathWorks, Inc. 

% Error checking.
if (length(obj) > 1)
    error(message('instrument:icdevice:devicereset:invalidOBJ'));
end

% Call hwreset on the java object.
try
    jobj = igetfield(obj, 'jobject');    
    hwreset(jobj);
catch aException
    newExc =  MException('instrument:icdevice:devicereset:opfailed', [aException.message ' Use MIDEDIT to update the driver if appropriate.']);
    throw(newExc);
end   
