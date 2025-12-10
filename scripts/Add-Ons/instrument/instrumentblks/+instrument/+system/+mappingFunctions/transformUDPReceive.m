function outData = transformUDPReceive(inData)
%TRANSFORMSUDPRECEIVE constructs outData structure from inData
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
    switch ParameterName{idx}
        case 'ByteOrder'
            outData.NewInstanceData(outIdx).Name = ParameterName{idx};
            if strcmpi(ParameterValue{idx}, 'LittleEndian')
                outData.NewInstanceData(outIdx).Value = 'little-endian';
            elseif strcmpi(ParameterValue{idx}, 'BigEndian')
                outData.NewInstanceData(outIdx).Value = 'big-endian';
            end
        case 'Terminator'
            % Set the parameter names.
            outData.NewInstanceData(outIdx).Name = ParameterName{idx};
            outData.NewInstanceData(outIdx+1).Name = 'CustomTerminator';
            termStr = ParameterValue{idx};
            switch termStr
                case {'LF', 'CR', 'LF/CR', 'CR/LF'} % Default combo values.
                    outData.NewInstanceData(outIdx).Value = termStr ;
                    % Set default value of Custom Terminator field to 10 (value corresponding to 'LF'). 
                    % This wont be used in simulation.
                    outData.NewInstanceData(outIdx+1).Value = '10';
                otherwise
                    if isempty(termStr) || strcmpi(termStr, '<none>')
                        outData.NewInstanceData(outIdx).Value = termStr;
                        outData.NewInstanceData(outIdx+1).Value = '[]';
                    else % Custom value.
                        val = uint8(termStr);
                        outData.NewInstanceData(outIdx).Value = 'Custom terminator';
                        outData.NewInstanceData(outIdx+1).Value = join(["[", num2str(val), "]"]);
                    end
            end
            % Increment outIdx by 1 for 'Custom terminator', which is a newly added
            % parameter.
            outIdx = outIdx + 1;
        otherwise
            % Assign the parameter name and value.
            outData.NewInstanceData(outIdx).Name = ParameterName{idx};
            outData.NewInstanceData(outIdx).Value = ParameterValue{idx};
    end

    % Increase index for outData structure.
    outIdx = outIdx + 1;
end
end