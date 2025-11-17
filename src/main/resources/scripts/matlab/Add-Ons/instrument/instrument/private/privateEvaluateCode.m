function privateEvaluateCode(obj, fcn)
%PRIVATEEVALUATEMCODE helper function used by device objects.
%
%   PRIVATEEVALUATEMCODE helper function used by the device objects.
%
%   PRIVATEEVALUATEMCODE is used when the device object is created and 
%   when the object is connected to the instrument with CONNECT.
%   
%   This function should not be called directly by the user.
%  
 
%   MP 01-03-03
%   Copyright 1999-2012 The MathWorks, Inc.

if isempty(fcn)
    return;
end

% Extract the code from the fcn to be evaluated.
index   = findstr(fcn, sprintf('\n'));
fcnline = fcn(1:index(1));
code    = fcn(index(1)+1:end);

if isempty(code)
    return;
end

try
    eval(code);
catch aException
    str = aException.message;
    if (findstr(str, getString(message('MATLAB:legacy_two_part:error_using'))))
        idx = strfind(str, 10);
        if (~isempty(idx) && length(str) ~= idx(1))
            str = str((idx(1) + 1):end);
        end
    end
    newExc = MException(aException.identifier, str);
    throw(newExc);
end

