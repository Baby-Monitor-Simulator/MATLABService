function privateErrorHandling (libname, drivername, session, status) 
%PRIVATEERRORHANDLING(LIBNAME, DRIVERNAME, SESSION, STATUS) helper function handles special IVI-C driver errors
%
%   This function should not be called directly by the user.
%
%   Copyright 2010-2013 The MathWorks, Inc.


switch drivername
    case 'niFgen'
        niFgenErrorHanding(libname, session, status);
    otherwise
        niErrorHanding(libname, session, status);        
end
 

function niErrorHanding (libname, session, status)

errorMessage = libpointer('int8Ptr', repmat(10, 1, 512));
errorFcn = sprintf('%s_GetErrorMessage', libname);
status = calllib(libname, errorFcn, session, status, 512, errorMessage);  
if (status < 0)
    return
end
errorMessage = strtrim(char(errorMessage.Value));
error(message('instrument:privateinstr:privateerrorhandling:instrerror', errorMessage))

function niFgenErrorHanding(libname, session, status) 
errorMessage = libpointer('int8Ptr', zeros(1, 512));
status = calllib(libname, 'niFgen_ErrorHandler', session, status,  errorMessage);   
 
if (status < 0)
    return
end

errorMessage = strtrim(char(errorMessage.Value));
error(message('instrument:privateinstr:privateerrorhandling:instrerror', errorMessage))
