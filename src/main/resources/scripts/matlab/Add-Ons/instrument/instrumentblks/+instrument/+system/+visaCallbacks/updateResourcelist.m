function updateResourcelist()
% UPDATERESOURCELIST updates the resource list drop down on the dialog.
%
%   UPDATERESOURCELIST() updates the resource list with visadevlist().
%   This is a workaround for mask issue where resource list is not updated
%   when model is opened in another system or new model is constructed.
%   This block OpenFcn callback will overwrite the resource list that is constructed
%   by the mask editor xml file.

% Copyright 2023 The MathWorks, Inc.
% Get the mask Object
maskObj = Simulink.Mask.get(gcbh);

% Update the Resource name drop down list
paramName = maskObj.getParameter('ResourceName');
paramName.TypeOptions = instrument.system.visaCallbacks.getVisaResourceList;
end

