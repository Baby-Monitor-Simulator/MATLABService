function privateslcbbaudrate(dialog, tag, value)
%PRIVATESLCBBAUDRATE Validates the baud rate entry in the ICT serial SL block.
%
%    PRIVATESLCBBAUDRATE(DIALOG, TAG, VALUE) validates the baud rate entry field 
%    for Serial blocks.
%

%    SS 10-03-07
%    Copyright 2007 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Convert port in string to number. 
baudRate = str2double(value); 

errorStrings = privateinstrumentslstring('errorstrings');

% Check for non-scalar, non-numeric and negative values.
if (isnan(baudRate) || isempty(baudRate) || ~isscalar(baudRate) || baudRate<0 || ...
    ~isnumeric(baudRate) || isinf(baudRate) || baudRate ~= floor(baudRate))
    tamslgate('privatesldialogbox', dialog, errorStrings.InvalidBaudRate, ...
                                errorStrings.ErrorDialogTitle, tag);
    % Set focus back to appropriate field.
    dialog.setFocus(tag);
    return;
end
% Assign the baud rate value from block to the source.
obj.(tag) = obj.Block.(tag);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

