function privateslcbsampletime(dialog, tag, value)
% PRIVATESLCBSAMPLETIME validates the sample time entry in the ICT SL block.
%
%    PRIVATESLCBSAMPLETIME(DIALOG, TAG, VALUE) validates the sample time entry
%    for TCPIP and UDP Receive blocks with inputs:
%    DIALOG is the mask dialog handle
%    TAG is the string with unique identifier forsample time field and
%    VALUE is current value of sample time.

% Copyright 2007-2021 The MathWorks, Inc.

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
    % Check if the input value is a numeric or a variable
    if isempty(str2num(value))%#ok<ST2NM>
        % Check if variable is defined in MATLAB WS or Simulink Data Dictionary
        if Simulink.data.existsInGlobal(bdroot(obj.Block.Path),value)
            % Evaluate the value of variable defined in MATLAB WS or Simulink Data Dictionary
            sampleTime = slResolve(value, bdroot(obj.Block.Path));
            % Validate the sampleTime attribute
            attributeChecking(sampleTime);
        end
    else
        % Convert sample time to number.
        sampleTime = str2double(value);
        % Validate the sampleTime attribute
        attributeChecking(sampleTime);
    end
catch mException
    if strcmpi(mException.identifier,'sampletimefield:invalidInputValue')
        printErrorAndResetDialog(obj, dialog, tag, errorStrings);
        return;
    end
end

% Assign the sample time from the block to the source. 
obj.SampleTime = obj.Block.SampleTime;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributeChecking(sampleTime)
% attributeChecking checks if the sampleTime number passed to the Block sample
% time field is a valid number or not.

% Check for non-scalar, non-numeric and negative values.
if ~isscalar(sampleTime) || isempty(sampleTime) || ~isnumeric(sampleTime) || ...
        isnan(sampleTime) || isinf(sampleTime) || ...
        (sampleTime<=0 && sampleTime~=-1) % Sample time can be -1. 
    % G377863: -1 Sample time is required for cases in which blocks are in
    % enabled/triggered subsystems where sample time can only be -1 or inf.
    
    % Generate and throw error with error ID and message
    throw(MException('sampletimefield:invalidInputValue', 'Invalid value provided to the field'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function printErrorAndResetDialog(obj, dialog, tag, errorStrings)
% printErrorAndResetDialog prints the required error and reset the value of
% text field.
    
    % Call T&M function to display error dialog.
    tamslgate('privatesldialogbox', dialog, ...
                                errorStrings.InvalidSampleTime, ...
                                errorStrings.ErrorDialogTitle, tag);
    
    % Restore the previous value on the dialog.                                
    obj.Block.SampleTime = obj.SampleTime;
    
    % Set focus to sample time field. 
    dialog.setFocus(tag);