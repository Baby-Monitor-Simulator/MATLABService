function privateslserialsetup(obj, serialPorts, objConstructors)
%PRIVATESLSERIALSETUP Validates the current serial port selection. 
%
%    PRIVATESLSERIALSETUP(OBJ, SERIALPORTS, OBJCONSTRUCTORS) validates the
%    serial port selection contained in object, OBJ, a DDG object, using
%    SERIALPORTS, a list of all serial ports, and OBJCONSTRUCTORS, a list
%    of object constructors. 

%    SS 10-01-07
%    Copyright 2007 The MathWorks, Inc.


% If the current port is still valid, update the object constructor and
% clear out previous fields. 
[isValidPort index] = ismember(obj.ComPort, serialPorts);

if isValidPort % If choice is valid.
    obj.ComPortMenu = obj.ComPort;
    obj.ObjConstructor = objConstructors{index};
    return;
end

% Get the error message strings. 
errorStrings = privateinstrumentslstring('errorstrings');

% Different serial ports are available.
if (length(serialPorts) > 1)
    msg = sprintf(errorStrings.SerialPortUnavailable, obj.ComPort);
else
    % No serial ports are available.    
    msg = errorStrings.NoSerialPorts;
end

uiwait( errordlg( msg, errorStrings.ErrorDialogTitle, 'modal'));

% Update block settings. 
obj.ComPort = serialPorts{1};
obj.ComPortMenu = serialPorts{1};
obj.ObjConstructor = objConstructors{1};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    