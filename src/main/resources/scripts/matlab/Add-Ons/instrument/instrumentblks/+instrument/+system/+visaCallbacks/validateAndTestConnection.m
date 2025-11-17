function validateAndTestConnection()
% VALIDATEANDTESTCONNECTION tests the instrument connection 
%
%   VALIDATEANDTESTCONNECTION() tests the instrument connection by sending
%   instrument identification command to the instrument. The response will be
%   displayed on the status field

% Copyright 2023 The MathWorks, Inc.

% Get the resource name to connect to.
rsName  = instrument.system.visaCallbacks.getResourceNameToConnect;

% Try creating the visadev object.
try
    VisadevObj = visadev(rsName);
catch ex
    % If visadev errors, set the response field with the error message
    msg = ex.message;
    idx = strfind(msg, newline);
    if isempty(idx)
        return
    end
    msg = extractBefore(msg, idx(end));
    set_param(gcb,"response", msg);
    return
end

% If visadev object creation is successful, send the Identification
% command to instrument.
testCmd = get_param(gcb,"testCommand");
try
    testResponse = writeread(VisadevObj, testCmd);
catch
    msg = string(message("transportapp:visadevapp:ConnectionFailedLabelName").getString);
    set_param(gcb,"response", msg);
    return
end

% If query is successfull, set the response field with instrument's
% response. 
set_param(gcb,"response", testResponse);
end