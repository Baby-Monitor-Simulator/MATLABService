function privateslcbport(dialog, tag, value)
%PRIVATESLCBPORT Validates the (local)port entry in the ICT SL block.
%
%    PRIVATESLCBPORT(DIALOG, TAG, VALUE) validates the port entry field 
%    for TCPIP and UDP blocks with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for (local)port field and
%    VALUE is current value of (local)port.

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
            portEntry = Simulink.data.getVariableFromGlobal(bdroot(obj.Block.Path),value);
            % Validate the portEntry attribute
            attributeChecking(portEntry, tag);
        end
    else
        % Convert port in string to number.
        portEntry = str2double(value);
        % Validate the portEntry attribute
        attributeChecking(portEntry, tag);
    end
catch mException
    if strcmpi(mException.identifier,'portfield:invalidInputValue')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

% Assign the port value from block to the source.
obj.(tag) = obj.Block.(tag);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributeChecking(portEntry, tag)
% attributeChecking checks if the portEntry number passed to the Port or
% Local Port field is a valid number or not.

% Get all the tags.
allTags = privateinstrumentslstring('allTags');

if ~((portEntry == -1) && strcmpi(tag, allTags.LocalPort))
    
    % Check for non-scalar, non-numeric and negative values.
    if (isnan(portEntry) || isempty(portEntry) || ...
            portEntry<=0 || portEntry > 65535 || portEntry ~= floor(portEntry))
        
        % Generate and throw error with error ID and message
        throw(MException('portfield:invalidInputValue', 'Invalid value provided to the field'));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Call T&M function to display error dialog.
    tamslgate('privatesldialogbox', dialog, errorStrings.InvalidPort, ...
        errorStrings.ErrorDialogTitle, tag);
    
    % Restore the previous value on the dialog.
    obj.Block.(tag) = obj.(tag);
    
    % Set focus back to appropriate field.
    dialog.setFocus(tag);
