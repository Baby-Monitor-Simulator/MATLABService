function outData = transformUDPSend(inData)
% TRANSFORMUDPSEND constructs outData structure from inData
% to create parameters names and values for blocks when models
% saved in older versions are opened.

% Copyright 2022 The MathWorks, Inc.

% Output parameter variable.
outData.NewBlockPath = '';
outData.NewInstanceData = [];

instanceData = inData.InstanceData;

% Get the field type 'Name' and 'Value' from instanceData
[ParameterName{1:length(instanceData)}] = instanceData.Name;
[ParameterValue{1:length(instanceData)}] = instanceData.Value;

outIdx = 1;

% Run the for loop for all the parameters in inData.
for idx = 1:length(ParameterName)

    % Copy the parameter name.
    outData.NewInstanceData(outIdx).Name = ParameterName{idx};

    % Assign new value if the format of old value is changed.
    if strcmpi(ParameterName{idx}, 'ByteOrder')
        if strcmpi(ParameterValue{idx}, 'LittleEndian')
            outData.NewInstanceData(outIdx).Value = 'little-endian';
        elseif strcmpi(ParameterValue{idx}, 'BigEndian')
            outData.NewInstanceData(outIdx).Value = 'big-endian';
        end
    else
        % If there is no change in parameter, just copy the value.
        outData.NewInstanceData(outIdx).Value = ParameterValue{idx};
    end

    % Increase index for outData structure.
    outIdx = outIdx + 1;
end
end