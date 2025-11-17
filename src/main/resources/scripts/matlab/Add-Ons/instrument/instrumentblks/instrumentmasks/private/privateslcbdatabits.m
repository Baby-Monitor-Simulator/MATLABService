function privateslcbdatabits(dialog, value)
%PRIVATESLCBDATABITS Validates the data bits field in ICT serial SL block.
%
%    PRIVATESLCBDATABITS(DIALOG, VALUE) validates the data bits 
%    field for Serial Configuration blocks.
%

%    SS 10-03-07
%    Copyright 2007 The MathWorks, Inc.

obj = dialog.getDialogSource;

% Check the current value. 
if (value==0)
    obj.StopBits = '1.5'; % Set stop bits to 1.5.
elseif strcmp(obj.StopBits, '1.5')
    obj.StopBits = '1'; % Set stop bits to 1.
end
    
% Call dialog refresh. 
dialog.refresh();