function out = selftest(obj)
%SELFTEST Run the instrument self-test.
%
%   OUT = SELFTEST(OBJ) runs the self-test for the instrument associated  
%   with device object, OBJ and returns the result of the self-test to OUT. 
%   OUT will vary based on the instrument.

%   Copyright 1999-2024 The MathWorks, Inc. 

% Error checking.
if (length(obj) > 1)
    errorID = 'instrument:icdevice:selftest:invalidOBJ';
    error(message('instrument:icdevice:selftest:invalidOBJ'));
end

% Call selftest on the java object.
try
    jobj = igetfield(obj, 'jobject');    
    out = char(selftest(jobj));
catch aException
    newExc = MException('instrument:icdevice:selftest:opfailed', [aException.message ' Use MIDEDIT to update the driver if appropriate.']);
    throw(newExc);
end   

try
    out = logical(str2double(out));
catch
end
