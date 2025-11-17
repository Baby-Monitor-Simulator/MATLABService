function out = privateValidateStruct(mStruct)
%PRIVATEVALIDATESTRUCT Validate a configuration store structure.
%
%   PRIVATEVALIDATESTRUCT(MSTRUCT) verifies that the required field are present
%   in a configuration store structure, MSTRUCT.
%
%   This function should not be called directly by the user.

%   PE 07-18-05
%   Copyright 2005 The MathWorks, Inc. 

% Apply any field/value pairs.

out = [];

required = localRequiredFieldNames(mStruct.Type);

existing = fieldnames(mStruct);

for idx = 1:length(required)
    if isempty(strmatch(required{idx}, existing, 'exact'))
        out = required{idx};
        return;
    end
end    

% ------------------------------------------------------------------------------
% Return a list of valid field names for updating for each collection type.
% ------------------------------------------------------------------------------
function out = localRequiredFieldNames(type)

out = [];

switch type
    case 'HardwareAsset'
        out = {'IOResourceDescriptor'};
    case 'DriverSession'
        out = {'HardwareAsset', 'SoftwareModule'};
    case 'LogicalName'
        out = {'Session'};
end