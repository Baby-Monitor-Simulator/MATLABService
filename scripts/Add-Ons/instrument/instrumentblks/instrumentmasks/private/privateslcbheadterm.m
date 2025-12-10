function privateslcbheadterm(dialog, tag, value)
%PRIVATESLCBHEADTERM Validates the header and terminator field in ICT serial SL block.
%
%    PRIVATESLCBHEADTERM(DIALOG, TAG, VALUE) validates the header and 
%    terminator field for Serial, UDP Receive and TCPIP Receive blocks with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for header and terminator field and
%    VALUE is current value of header and terminator.

%    Copyright 2007-2017 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Get all the tags. 
allTags = instrumentslgate('privateinstrumentslstring', 'alltags');

switch tag
    case allTags.Terminator
        % Terminator tag is used by: UDP Receive, TCPIP Receive, Serial Receive and Serial Send blocks.
        % For UDP and TCPIP blocks, the format of terminator field is a text edit field vs serial blocks 
        % primarily work on a drop down list. Hence, the error checking and assigments for them are
        % done independently in the branch below.
        % IF section, below, represents error checking for UDP and TCP receive blocks.
        % ELSE section, below, represents error checking for SERIAL blocks.
        if strcmpi(class(obj), 'instrumentdialog.udprb') || strcmpi(class(obj), 'instrumentdialog.tcpiprb')
            % Convert terminator value to number
            termNumericVal = str2double(value);            
            % Create a cell array of valid terminator strings
            validTerminationStr = {'LF', 'CR', 'LF/CR', 'CR/LF'};
            
            % Check for valid input formats and input to Terminator field is not numeric
            if isnan(termNumericVal)
                if ~any(strcmpi(value,validTerminationStr))
                    displayTerminatorErrorDlg(obj, dialog, tag);
                    return;
                end
            else % Input to Terminator field is numeric
                if isnan(termNumericVal) || isempty(termNumericVal)  || isinf(termNumericVal) || ...
                        (termNumericVal < 0) || (termNumericVal > 127)
                    displayTerminatorErrorDlg(obj, dialog, tag);
                    return;
                end
            end
        else % Verify terminator value input for serial block's specific input from drop down menu.
            if isempty(value)
                % Assign the terminator value from block to the source.
                value = '<none>';
                obj.Block.(tag) = value;
            end
            % Standard values in combo box.
            if any(strcmpi({'<none>' 'CR (''\r'')' 'LF (''\n'')' 'CR/LF (''\r\n'')' 'NULL (''\0'')'}, value))
                obj.(tag) = obj.Block.(tag);
                return;
            end
        end
    case allTags.Header
        % If the field is empty, just return.
        if (isempty(value))
            obj.(tag) = obj.Block.(tag);            
            return;
        end
end

% Assign the header value from block to the source.
obj.Block.(tag) = value;    
obj.(tag) = obj.Block.(tag);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function displayTerminatorErrorDlg(obj, dialog, tag)
% displayTerminatorErrorDlg displays an error dialog if an invalid Terminator
% value is entered in the Terminator field. It also resets the default/previous
% value to the Terminator field.

% Get the error strings. 
errorStrings = privateinstrumentslstring('errorstrings');

tamslgate('privatesldialogbox', dialog, ...
    getString(message(errorStrings.InvalidTerminatorID)), ...
    errorStrings.ErrorDialogTitle, tag);

% Restore the previous value on the dialog.
obj.Block.(tag) = obj.(tag);

% Set focus to Terminator field.
dialog.setFocus(tag);

return;