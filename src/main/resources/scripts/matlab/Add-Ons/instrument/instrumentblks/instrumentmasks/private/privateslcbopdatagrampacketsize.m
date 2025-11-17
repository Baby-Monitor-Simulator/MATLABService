function privateslcbopdatagrampacketsize(dialog, tag, value)
%PRIVATESLCBOPDATAGRAMPACKETSIZE Validates the UDP packet size entry in the ICT SL block.
%
%    PRIVATESLCBOPDATAGRAMPACKETSIZE(DIALOG, TAG, VALUE) validates the UDP packet size
%    entry for UDP Send block with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for UDP packet size field and
%    VALUE is current value of UDP packet size.

%    Copyright 2017-2023 The MathWorks, Inc.

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
            outputDatagramPacketSize = Simulink.data.getVariableFromGlobal(bdroot(obj.Block.Path),value);
            % Validate the OutputDatagramPacketSize attribute
            attributeChecking(outputDatagramPacketSize);
        end
    else
        % Convert sample time to number.
        outputDatagramPacketSize = str2double(value);
        % Validate the OutputDatagramPacketSize attribute
        attributeChecking(outputDatagramPacketSize);
    end
catch mException
    if strcmpi(mException.identifier,'opdatagrampacketsize:invalidInputValue')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

% Assign output datagram packet size from the block to the source.
obj.OutputDatagramPacketSize = obj.Block.OutputDatagramPacketSize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributeChecking(outputDatagramPacketSize)
% attributeChecking checks if the outputDatagramPacketSize number passed to
% the UDP packet size field is a valid number or not.

% Validate attribute outputDatagramPacketSize.
try
    validateattributes(outputDatagramPacketSize,{'numeric'}, {'nonnegative', 'nonnan', 'nonempty', 'finite', ...
      'integer', 'scalar', 'nonzero', '<=', intmax('uint16')});
catch
    % Generate and throw error with error ID and message
    throw(MException('opdatagrampacketsize:invalidInputValue', 'Invalid value provided to the field'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Create an error dialog
    tamslgate('privatesldialogbox', dialog, getString(message(errorStrings.OutputDatagramPacketSizeID)), ...
                                errorStrings.ErrorDialogTitle, tag);
    
    % Restore the previous value on the dialog.                                
    obj.Block.OutputDatagramPacketSize = obj.OutputDatagramPacketSize;
    
    % Set focus to UDP packet size field. 
    dialog.setFocus(tag);
