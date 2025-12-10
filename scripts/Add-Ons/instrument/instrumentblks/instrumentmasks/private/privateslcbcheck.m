function privateslcbcheck(dialog)
%PRIVATESLCBCHECK Checks the availability of the specified host and port
%
%    PRIVATESLCBCHECK(DIALOG) Checks the availability and connectivity to 
%    the specified host and port entered in the dialog, DIALOG. 
%

%    Copyright 2007-2023 The MathWorks, Inc.

% Get the source object from dialog.
obj = dialog.getDialogSource;

% Initialize the error to empty string.
isErr = false;

% Create a boolean value if OBJ is UDP receive block
blockIsUDP = strcmpi(class(obj), 'instrumentdialog.udprb') || strcmpi(class(obj), 'instrumentdialog.udpsb');

% Get all the widget tags.
allTags = privateinstrumentslstring('allTags');

% Get the strings from the helper file.
errorStrings = privateinstrumentslstring('errorStrings');

% Disable the dialog until check is complete.
dialog.setEnabled(allTags.ParameterPane, false);

% Check if the host (and localhost) resolves.
[networkStruct, retErr] = resolveAndVerifyHost(obj, allTags, dialog, errorStrings);
if retErr
    return;
end

switch class(obj)
    case {'instrumentdialog.tcpiprb' 'instrumentdialog.tcpipsb'} % For TCPIP blocks.
        pvPairs = sprintf('''remoteport'',%s', obj.Port);
        isErr = localCheckHostAndPort('tcpip', obj.Host, pvPairs);
    case {'instrumentdialog.udpsb' 'instrumentdialog.udprb'} % For UDP blocks.
        if strcmpi(obj.LocalPort, '-1')
            pvPairs = sprintf('''remoteport'',%s, ''localhost'', %s', ...
                                obj.Port, obj.LocalAddress);
        else
            pvPairs = sprintf('''remoteport'', %s, ''localhost'', ''%s'', ''localport'', %s', ...
                                obj.Port, obj.LocalAddress, obj.LocalPort);
        end
        isErr = localCheckHostAndPort('udp', obj.Host, pvPairs);
    otherwise 
        % Should not come into this situation.
        uiwait(errordlg(message('instrument:instrumentblks:invalidBlock').getString, message('instrument:instrumentblks:errorString').getString, 'modal'));
end

% Check if error is empty.
if isErr % Host and port incorrect.    
    % Form the user message for correct resolvement of host for UDP Receive or other blocks.
    if blockIsUDP
        [remoteAddMsg, localAddMsg]  = formUserMsg(obj, networkStruct, errorStrings, isErr);
        userMsg = [remoteAddMsg newline localAddMsg];
    else
        [userMsg, ~] = formUserMsg(obj, networkStruct, errorStrings, isErr);
    end
    
    % Form the message and generate the dialog.
    completeUserMsg = strcat(userMsg, errorStrings.HostAndPortIncorrect);
    uiwait(errordlg(completeUserMsg, errorStrings.ErrorDialogTitle, 'modal'));
    
    % Restore the parameter pane to its original state
    dialog.setEnabled(allTags.ParameterPane, true);
    return;
else % Host and port valid.
    % Generate message strings for UDP blocks or other blocks
    if blockIsUDP
        [remoteAddMsg, localAddMsg]  = formUserMsg(obj, networkStruct, errorStrings, isErr); 
        completeUserMsg = [remoteAddMsg newline localAddMsg];
    else
        [completeUserMsg, ~] = formUserMsg(obj, networkStruct, errorStrings, isErr);
    end
    uiwait(msgbox(completeUserMsg, message('instrument:instrumentblks:successString').getString, 'modal'));    
end

% Restore the parameter pane to its original state
dialog.setEnabled(allTags.ParameterPane, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function isErr = localCheckHostAndPort(fnName, host, pvPairs)

% Initialize err to empty string.
isErr = false;

evalStr = sprintf('%s(''%s'', %s)', fnName, host, pvPairs);
try 
    % Evaluate the function. 
    myObj = eval(evalStr);
    % Try to open the connection.
    fopen(myObj);
catch %#ok<CTCH>
    % Catch the error.
    isErr = true;
end

if exist('myObj', 'var') % If object exists, close and delete it.
    fclose(myObj);
    delete(myObj);
    clear myObj;
end

function [networkStruct, retErr] = resolveAndVerifyHost(obj, allTags, dialog, errorStrings)
% resolveAndVerifyHost performs resolvehost for the host (and localhost)
% assigned to the Obj. If resolvehost results in an empty output, this
% callback check errors out with a corresponding message.
% The functions outputs a networkStruct containing the outputs from
% resolvehost function. The function also output an error flag to represent
% if resolution of host resulted in an error.

retErr = false;

[remoteName, remoteAddress] = resolvehost(obj.Host);
networkStruct.remoteName = remoteName;
networkStruct.remoteAddress = remoteAddress;

% If resolvehost results in an empty name or address, error out.
if ( isempty(remoteName) && isempty(remoteAddress) )
    msg1 = sprintf(errorStrings.HostDoesNotResolve, obj.Host);
    uiwait(errordlg(msg1, errorStrings.ErrorDialogTitle, 'modal'));
    % Set focus to Host (aka Remote address).
    dialog.setFocus(allTags.Host);
    % Restore the parameter pane to its original state
    dialog.setEnabled(allTags.ParameterPane, true);
    retErr = true;
    return;
end

if strcmpi(class(obj), 'instrumentdialog.udprb') || strcmpi(class(obj), 'instrumentdialog.udpsb')
    [localName, localAddress] = resolvehost(obj.LocalAddress);
    networkStruct.localName = localName;
    networkStruct.localAddress = localAddress;
    
    % If resolvehost results in an empty name or address, error out.
    if ( isempty(localName) && isempty(localAddress) )
        msg1 = getString(message(errorStrings.LocalHostDoesNotResolveID));
        uiwait(errordlg(msg1, errorStrings.ErrorDialogTitle, 'modal'));
        % Set focus to Local Address.
        dialog.setFocus(allTags.LocalAddress);
        % Restore the parameter pane to its original state
        dialog.setEnabled(allTags.ParameterPane, true);
        retErr = true;
        return;
    end
end

function [remoteAddMsg, localAddMsg] = formUserMsg(obj, networkStruct, errorStrings, isErr)
% formUserMsg generates a message for the user visible dialog.

% Initilize localAddMsg
localAddMsg = '';

if isErr  % Host and port incorrect.
    if ~strcmpi(obj.Host, networkStruct.remoteAddress) % Append the IP the address resolves to.
        remoteAddMsg = sprintf(errorStrings.HostResolvesWithIP, obj.Host, networkStruct.remoteAddress);
    else
        % If no IP need to be appended with the message.
        remoteAddMsg = sprintf(errorStrings.HostResolves, obj.Host);
    end
    if strcmpi(class(obj), 'instrumentdialog.udprb') || strcmpi(class(obj), 'instrumentdialog.udpsb')
        if ~strcmpi(obj.LocalAddress, networkStruct.localAddress) % Append the IP the address resolves to.
            localAddMsg = getString(message(errorStrings.LocalHostResolvesWithIPID, ...
                obj.LocalAddress, networkStruct.localAddress));
        else
            % If no IP need to be appended with the message.
            localAddMsg = getString(message(errorStrings.LocalHostResolvesID, obj.LocalAddress));
        end
    end
else
    if ~strcmpi(obj.Host, networkStruct.remoteAddress) % Append the IP the address resolves to.
        remoteAddMsg = sprintf(errorStrings.HostAndPortCorrectWithIP, obj.Host, networkStruct.remoteAddress, obj.Port);
    else
        remoteAddMsg = sprintf(errorStrings.HostAndPortCorrect, obj.Host, obj.Port);
    end
    if strcmpi(class(obj), 'instrumentdialog.udprb') || strcmpi(class(obj), 'instrumentdialog.udpsb')
        if ~strcmpi(obj.LocalAddress, networkStruct.localAddress) % Append the IP the address resolves to.
            localAddMsg = getString(message(errorStrings.LocalHostAndPortCorrectWithIPID, ...
                obj.LocalAddress, networkStruct.localAddress, obj.LocalPort));
        else
            localAddMsg = getString(message(errorStrings.LocalHostAndPortCorrectID, obj.LocalAddress, obj.LocalPort));
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
