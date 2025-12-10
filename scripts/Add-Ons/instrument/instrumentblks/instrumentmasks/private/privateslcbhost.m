function privateslcbhost(dialog)
%PRIVATESLCBHOST Validates the host entry in the ICT SL block.
%
%    PRIVATESLCBHOST(DIALOG) validates the host entry
%    for TCPIP and UDP Receive blocks.
%

%    Copyright 2007-2017 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Assign the host from the block to the source.
if (strcmpi(class(obj), 'instrumentdialog.udprb') || (strcmpi(class(obj), 'instrumentdialog.udpsb')))
    obj.LocalAddress = obj.Block.LocalAddress;
end
obj.Host = obj.Block.Host;