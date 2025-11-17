function showSelectedResourceDetails()
% SHOWSELECTEDRESOURCEDETAILS displays vendor name, model name and serial
% number of the selected resource.

% Copyright 2023 The MathWorks, Inc.

% Get the mask Object
maskObj = Simulink.Mask.get(gcbh);

% Get the resource name selected by user.
selectedRsc = get_param(gcb, "ResourceName");

% Return if no resource is selected.
if strcmpi(selectedRsc, '<Select a resource name>')
    return
end

% Get the VISA resource list
try
    visaList = visadevlist("Timeout", 30);
catch
    % Set the resource details fields to empty and return
    parametersToClear = ["VendorName", "ModelName", "SlNumber"];
    for paramName = parametersToClear
        fieldName = maskObj.getParameter(paramName);
        fieldName.Value = "";
    end
    return
end

% Find the index where selected reource is present in visadevlist.
visaListIndex = find(ismember(visaList.ResourceName', selectedRsc));

% If index not found, set the resource details fields to empty and return
if isempty(visaListIndex)
    parametersToClear = ["VendorName", "ModelName", "SlNumber"];
    for paramName = parametersToClear
        fieldName = maskObj.getParameter(paramName);
        fieldName.Value = "";
    end
    return
end

% Set the resorce details parameters vendor name, model name and Serial
% number.
fieldName = maskObj.getParameter( "VendorName");
fieldName.Value = visaList.Vendor(visaListIndex);

fieldName = maskObj.getParameter("ModelName");
fieldName.Value = visaList.Model(visaListIndex);

fieldName = maskObj.getParameter("SlNumber");
fieldName.Value = visaList.SerialNumber(visaListIndex);
end