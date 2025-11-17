function privateslcbcomportchanged(dialog)
%PRIVATESLCBCOMPORTCHANGED callback to validate serial port change.
%
%    PRIVATESLCBCOMPORTCHANGED(DIALOG) is used as a callback to validate the
%    device change in the DIALOG, a dialog object.

%    SS 10-01-07
%    Copyright 2007 The MathWorks, Inc.

% Get source object from dialog object
obj = dialog.getDialogSource;

% Reflect the new port settings.
obj.ComPort = obj.ComPortMenu;
