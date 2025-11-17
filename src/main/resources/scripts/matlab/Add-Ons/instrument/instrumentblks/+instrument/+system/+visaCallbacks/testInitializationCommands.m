function testInitializationCommands()
% TESTINITIALIZATIONCOMMANDS is to upload the initialization commands to
% instrument and then check the status of instrument.

% Copyright 2023 The MathWorks, Inc.


% Get the mask Object
maskObj = Simulink.Mask.get(gcbh);

% Clear instrument status parameter
fieldName = maskObj.getParameter("initStatus");
fieldName.Value = "";

% Get the resource name to connect to.
rsName  = instrument.system.visaCallbacks.getResourceNameToConnect;

% Try creating the visadev object.
visaDevObj = visadev(rsName);

% Set connection configuration parameters
if contains(extractBefore(rsName,"::"), "ASRL")
    visaDevObj.BaudRate = str2double(get_param(gcb,"BaudRate"));
    visaDevObj.DataBits = str2double(get_param(gcb,"DataBits"));
    visaDevObj.StopBits = str2double(get_param(gcb,"StopBits"));
    visaDevObj.Parity = get_param(gcb,"Parity");
    visaDevObj.FlowControl = get_param(gcb,"FlowControl");
else
    visaDevObj.EOIMode = get_param(gcb,"EOIMode");
end
visaDevObj.ByteOrder = get_param(gcb,"ByteOrder");
visaDevObj.Timeout = str2double(get_param(gcb,"TimeOut"));
readTerm = get_param(gcb,"ReadTerminator");
writeTerm = get_param(gcb,"WriteTerminator");
visaDevObj.configureTerminator(readTerm, writeTerm)

% Send instrument initialization commands
if strcmpi( get_param(gcb,"InitOptions"), "Initialization commands")
    initCommands = get_param(gcb,"SendString");
    if ~isempty(initCommands)
        initCommandsString = string(initCommands);
        initCommandEntries = split(initCommandsString, newline);
        initCommandDim = size(initCommandEntries);

        for i = 1:initCommandDim(1)
            visaDevObj.writeline(initCommandEntries(i));
        end
    end
elseif strcmpi( get_param(gcb,"InitOptions"), "MATLAB Code")
    mlCommand = get_param(gcb,"ExecuteFunction");
    initCommands = replace(mlCommand,'visaObj','visaDevObj');
    eval(initCommands);
end

% Check instrument error status.
instrStatus = visaDevObj.writeread(get_param(gcb,"InitTestCommand"));
%Set the instrument error status in initStatus field.
fieldName = maskObj.getParameter("initStatus");
fieldName.Value = instrStatus;
end