function outData = TransformationUDPLocalAddressField(inData)
% TransformationUDPLocalAddressField is used by the forwarding table for
% instrumentlib libraray to update the newly added 'LocalAddress' field, if
% the block does not contain this property.

%   Starting R2018a, UDP blocks have a new text edit field paramter called
%   LocalAddress. This represents the Localhost property of the UDP object.
%   The default value of this property is empty (hence requiring users to
%   input this value when creating a new model). This function populates
%   the field and value with a defualt value for blocks that are being
%   imported from an older version which did not have this parameter to
%   support backwards compatibility.
%
%   Copyright 2017 The MathWorks, Inc.

outData.NewBlockPath = '';
outData.NewInstanceData = [];

% Get all mask parameters for the block.
InstanceData = inData.InstanceData;

% Get current names for the block.
[ParameterNames{1:length(InstanceData)}] = InstanceData.Name;

% Cehck if the block currently contains LocalAddress Field
[localAddressParamExists, ~] = ismember('LocalAddress',ParameterNames);

% Populate LocalAddress data to a default 0.0.0.0 for blocks that did not
% contain the field. This allows backwards compatibility. LocalAddress
% field will remain empty for blocks that contain the LocalAddress fields
% already.
if ~localAddressParamExists
    InstanceData(end+1).Name = 'LocalAddress';
    InstanceData(end).Value = '0.0.0.0';
end

% Reassign updated properties to the block.
outData.NewInstanceData = InstanceData;
end