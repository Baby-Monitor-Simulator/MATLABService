function outData = TransformationQBAgilentToKeysight(inData)
% TransformationQBAgilentToKeysight is used by the Forwarding table for
% instrumentlib library to update GPIB and VISA vendor names from Agilent
% to Keysight, if present.

%   This function uses the default required definition of creating a
%   forwarding table function. inData contains the Name - Values for block
%   object parameters. We check values for GPIB and VISA vendor to be
%   Agilent Technologies and Agilent respectively. If the values are found
%   to have the these old names, we update the GPIB and VISA vendor names
%   to Keysight Technologies and Keysight respectively. If this change is
%   made the user is notified with a corresponding message in the
%   diagnostic viewer window.
%
%   Copyright 2017 The MathWorks, Inc.

outData.NewBlockPath = '';
outData.NewInstanceData = [];

InstanceData = inData.InstanceData;
% Get current values for the block.
[ParameterValues{1:length(InstanceData)}] = InstanceData.Value;

% Check if outdated vendor names are currently being used by the model.
% Acquire the index of the element from ParameterValues cell array.
[oldGPIBVendorName, AgilentTechIndex] = ismember('Agilent Technologies',ParameterValues);
[oldVISAVendorName, AgilentIndex] = ismember('Agilent',ParameterValues);

% If outdated name used for the vendor, update GPIB Vendor name from Agilent Technologies to Keysight
% Technologies.
if oldGPIBVendorName
    disp('Starting in R2018a, the GPIB vendor Agilent Technologies has been renamed to Keysight Technologies.');
    InstanceData(AgilentTechIndex).Value = 'Keysight Technologies';
end

% If outdated name used for the vendor, update VISA Vendor name from Agilent to Keysight.
if oldVISAVendorName
    disp('Starting in R2018a, the VISA vendor Agilent has been renamed to Keysight.');
    InstanceData(AgilentIndex).Value = 'Keysight';
end

outData.NewInstanceData = InstanceData;

end