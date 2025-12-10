function driversList = getDriversList(Type)
% GETDRIVERSLIST Returns a list of available instrument drivers.
% Arguments:
%     Type - Quick-Control instrument type. Valid values are 'FGen',
%                'Oscilloscope'.
% Outputs:
%     driversList - A list of supported drivers for the selected
%                   Quick-Control instrument type.

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
dList = drivers(qcObj);
driversList = cellfun(@(x) x.Name,dList,'UniformOutput',false);
clear qcObj;
end