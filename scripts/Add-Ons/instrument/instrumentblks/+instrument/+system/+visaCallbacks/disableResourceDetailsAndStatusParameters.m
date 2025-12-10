function disableResourceDetailsAndStatusParameters()
% DISABLERESOURCEDETAILSANDSTATUSPARAMETERS disabled the fields that should 
% not be modified by customer.
%
%   DISABLERESOURCEDETAILSANDSTATUSPARAMETERS() is a callback function from 
%   block OpenFcn. This function disables the fields that shows resource 
%   details, instrument status and instrument response. 

% Copyright 2023 The MathWorks, Inc.

% Parameters that are disabled on dialog
parametersToDisable = ["VendorName", "ModelName", "SlNumber", "Response", "initStatus"];

% Get the mask Object
maskObj = Simulink.Mask.get(gcbh);

% Disable the parameters
for paramName = parametersToDisable
   field = maskObj.getParameter(paramName);
   field.Enabled = "off";
end

% Call the mask open command explicitly
open_system(gcbh,'mask');

end

