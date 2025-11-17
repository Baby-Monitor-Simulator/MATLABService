function clearInstrumentResponseAndStatus()
% CLEARINSTRUMENTRESPONSEANDSTATUS clears the instrument response and
% status fields.
%
%   CLEARINSTRUMENTRESPONSEANDSTATUS() clears the instrument response and
%   status fields present in 'Hardware Configuration' tab and 'Instrument
%   Initialization' tab whenever user changes resource name or when user
%   selects a different option to configure resource.
%
% Copyright 2023 The MathWorks, Inc.

% Get the mask Object
maskObj = Simulink.Mask.get(gcbh);

% Clear instrument response and status parameters
parametersToClear = ["Response", "initStatus"];
for paramName = parametersToClear
    fieldName = maskObj.getParameter(paramName);
    fieldName.Value = "";
end
end