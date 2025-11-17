function privateslcbcustomvalue(dialog, tag, value)
%PRIVATESLCBCUSTOMVALUE Validates the custom value entry in the ICT SL block.
%
%    PRIVATESLCBCUSTOMVALUE(DIALOG, TAG, VALUE) validates the ICT Simulink
%    blocks.
%

%    SS 10-03-07
%    Copyright 2007 The MathWorks, Inc.

% Get the dialog source object. 
obj = dialog.getDialogSource;

% Convert sample time to number. 
customValue = str2num(value); %#ok<ST2NM>

% Get all widget tags.
allTags = instrumentslgate('privateinstrumentslstring', 'alltags');

% Get the error strings. 
errorStrings = privateinstrumentslstring('errorstrings');

% Check if error in setting
isErr = localCheckCustomValue(customValue, obj.(allTags.DataSize));

% Error if true.
if isErr
    % Call shared error dialog.
    tamslgate('privatesldialogbox', dialog, ...
                                errorStrings.InvalidCustomValue, ...
                                errorStrings.ErrorDialogTitle, tag);
    
    % Restore the previous value on the dialog.                                
    obj.Block.CustomValue = obj.CustomValue;
    
    % Set focus to sample time field. 
    dialog.setFocus(tag);    
    
    return;
end

% Assign the sample time from the block to the source. 
obj.CustomValue = obj.Block.CustomValue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function isErr = localCheckCustomValue(customValue, dataSize)
% Checks the setting of custom value for any error. 

% Initialize to false.
isErr = false;
% Check for non-scalar, non-numeric values.
if isempty(customValue) || ~isnumeric(customValue) || ...
        ~isempty(find(isnan(customValue),1)) || ~isempty(find(isinf(customValue),1))
    isErr = true;
    return;
end

% If scalar, return.
if isscalar(customValue)
    return;
end

% If size does not match, error.
if ( numel(customValue) ~= prod(str2num(dataSize)) ) %#ok<ST2NM>
    isErr = true;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%