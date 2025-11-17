function privateslcbtimeout(dialog, tag, value)
%PRIVATESLCBTIMEOUT Validates the timeout entry in the ICT SL block.
%
%    PRIVATESLCBTIMEOUT(DIALOG, TAG, VALUE) validates the timeout entry
%    for TCPIP and UDP Receive blocks with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for timeout field and
%    VALUE is current value of timeout.

%    Copyright 2007-2023 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Get the error strings. 
errorStrings = privateinstrumentslstring('errorstrings');

% Check if direct input to the dialog is empty or a cell. If it is neither
% then rest of the code evaluate the input accordingly. This section
% ignores if an exception of Undefined function is caught. In this case
% there could be a variable name that is not yet set, hence the code allows
% the user to apply the text.
try 
    if iscell(eval(value)) || isempty(eval(value))
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
catch mException
    if ~strcmpi(mException.identifier, 'MATLAB:UndefinedFunction')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

try
    % Check if the input value is numeric or a variable
    if isempty(str2num(value))%#ok<ST2NM>
        % Check if variable is defined in MATLAB WS or Simulink Data Dictionary
        if Simulink.data.existsInGlobal(bdroot(obj.Block.Path),value)
            % Evaluate the value of variable defined in MATLAB WS or Simulink Data Dictionary
            timeout = Simulink.data.getVariableFromGlobal(bdroot(obj.Block.Path),value);
            % Validate the timeout attribute
            attributeChecking(timeout);
        end
    else
        % Convert timeout to number.
        timeout = str2double(value);
        % Validate the sampleTime attribute
        attributeChecking(timeout);
    end
catch mException
    if strcmpi(mException.identifier,'timeoutfield:invalidInputValue')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

% Assign the sample time from the block to the source. 
obj.Timeout = obj.Block.Timeout;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributeChecking(timeout)
% attributeChecking checks if the timeout number passed to the Timeout field
% is a valid number or not.

% Check for non-scalar, non-numeric and negative values.
if ~isscalar(timeout) || isempty(timeout) || ~isnumeric(timeout) || ...
        isnan(timeout) || timeout<=0  
    
    % Generate and throw error with error ID and message
    throw(MException('timeoutfield:invalidInputValue', 'Invalid value provided to the field'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Call T&M function to display error dialog.    
    tamslgate('privatesldialogbox', dialog, errorStrings.InvalidTimeout, ...
                                errorStrings.ErrorDialogTitle, tag);
    % Restore the previous value on the dialog.                                
    obj.Block.Timeout = obj.Timeout;

    % Set focus to timeout field. 
    dialog.setFocus(tag);
