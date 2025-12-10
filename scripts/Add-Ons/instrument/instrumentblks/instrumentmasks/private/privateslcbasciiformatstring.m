function privateslcbasciiformatstring(dialog, tag, value)
%PRIVATESLCBASCIIFORMATSTRING Validates the ASCII format string entry in the ICT SL block.
%
%    PRIVATESLCBASCIIFORMATSTRING(DIALOG, TAG, VALUE) validates the ASCII format string
%    entry for UDP and TCPIP Receive block with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for  ASCII format string field and
%    VALUE is current value of  ASCII format string.

%    Copyright 2017 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Get the error strings. 
errorStrings = privateinstrumentslstring('errorstrings');

if isempty(value) || ~contains(value, '%')    
    % Print error and return
    printErrorAndResetDialog(obj, dialog, tag, errorStrings);
    return;
else    
    % Create a copy of user input value
    tempValue = value;
    
    % Create a list of valid numeric conversion specifiers
    validASCIIFormat = {'%d', '%i', '%ld', '%li', '%u', '%o', '%x', '%lu', '%lo', '%lx', '%f', '%e', '%g'};
    
    % Iterate over all the valid numeric conversion specifiers to replace user
    % input with an empty string.
    for counter = 1:numel(validASCIIFormat)
        tempValue = strrep(tempValue, validASCIIFormat{counter}, '');
    end
    
    % Check if user input contains any more '%' character. This represents that
    % user input a conversion specifier other than a valid numeric conversion
    % specifier. For e.g. %s
    if contains(tempValue, '%')
        % Print error and return
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
    
    % Assign ASCII format string from the block to the source.
    obj.Block.ASCIIFormatting = value;
    obj.ASCIIFormatting = obj.Block.ASCIIFormatting;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Call T&M function to display error dialog.
    tamslgate('privatesldialogbox', dialog, getString(message(errorStrings.InvalidASCIIFormatStringID)), ...
                                errorStrings.ErrorDialogTitle, tag);
                            
    % Restore the previous value on the dialog.
    obj.Block.ASCIIFormatting = obj.ASCIIFormatting;
    
    % Set focus to ASCII format string field. 
    dialog.setFocus(tag);