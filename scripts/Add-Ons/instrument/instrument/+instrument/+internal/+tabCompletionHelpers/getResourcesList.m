function resourceList = getResourcesList(Type)
% GETRESOURCESLIST Retrieves a list of available instrument resources.
% Arguments:
%     Type - Quick-Control instrument type. Valid values are 'FGen',
%                'Oscilloscope'.
% Outputs:
%     resourceList - A list of available instrument resources.

% Copyright 2016-2023 The MathWorks, Inc.
if strcmpi(Type,'Fgen')
    qcObj = fgen;
elseif strcmpi(Type,'Oscilloscope')
    qcObj = oscilloscope;
elseif strcmpi(Type,'RFSigGen')
    qcObj = rfsiggen;
else
    me = MException(message('instrument:qcinstrument:invalidType'));
    throw(me);
end
resourceList = resources(qcObj);
clear qcObj;
end