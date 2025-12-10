function privateslcbdatasize(dialog, tag, value)
%PRIVATESLCBDATASIZE Validates the data size entry in the ICT SL block.
%
%    PRIVATESLCBDATASIZE(DIALOG, TAG, VALUE) validates the data size entry
%    for TCPIP and UDP Receive blocks with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier for data size field and
%    VALUE is current value of data size.

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
    % Check if the input value is numeric or a variable. Using str2num
    % instead of str2double here because str2double converts a string containing
    % vector to nan instead of producing a number.
    if isempty(str2num(value))%#ok<ST2NM>
        % Check if variable is defined in MATLAB WS or Simulink Data Dictionary
        if Simulink.data.existsInGlobal(bdroot(obj.Block.Path),value)
            % Evaluate the value of variable defined in MATLAB WS or Simulink Data Dictionary
            dataSize = Simulink.data.getVariableFromGlobal(bdroot(obj.Block.Path),value);
            % Validate the sampleTime attribute
            attributeChecking(obj, dataSize);
        end
    else
        % Convert the data size to number.
        dataSize = str2num(value); %#ok<ST2NM>
        % Validate the sampleTime attribute
        attributeChecking(obj, dataSize);
    end
catch mException
    if strcmpi(mException.identifier,'datasizefield:invalidInputValue')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

% Assign from the source object to the block object.
obj.DataSize = obj.Block.DataSize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributeChecking(obj, dataSize)
% attributeChecking checks if the dataSize number passed to the Data Size field is
% a valid number or not. It also assigns the data size from the block to the source.

% Check for non-scalar, non-integer and negative values.
if isempty(dataSize) || ~isnumeric(dataSize) || ...
        any(dataSize ~= floor(dataSize)) || any(isnan(dataSize)) || ...
        any(isinf(dataSize)) || any(dataSize<=0) || (size(dataSize,1)>1)
    
    % Generate and throw error with error ID and message
    throw(MException('datasizefield:invalidInputValue', 'Invalid value provided to the field'));
end

% Assign the data size from the block to the source.
if isscalar(dataSize)
    obj.Block.DataSize = sprintf('%d', dataSize);
else
    obj.Block.DataSize = sprintf('[%s]', num2str(dataSize));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Call T&M function to display error dialog.
    tamslgate('privatesldialogbox', dialog, ...
                                errorStrings.InvalidDataSize, ...
                                errorStrings.ErrorDialogTitle, tag);
                            
    % Restore the previous value on the dialog.                                
    obj.Block.DataSize = obj.DataSize;
    
    % Set focus to data size field. 
    dialog.setFocus(tag);
