function out= getIviDrivers ( driverType, instrumentType )
%getIviDrivers returns available driver which meets specific driver type
% and instrument type.
% for example:
%  getIviDrivers ('ivic', 'IviScope');
%  returns a list of Ivi-C Scope drivers

% Copyright 2011 The MathWorks, Inc.
 
out ={};
% only take care of ivi-c driver for now.
if ~strcmpi (driverType, 'ivic')
    return;
end

% get Ivi drivers with the specified instrument type
instrumentType = regexprep(instrumentType, 'Ivi', '');
ivicDrivers = instrument.internal.udm.ConfigStoreUtility.getInstalledIVIInstrumentDrivers(instrumentType) ;

% only report Ivi-C drivers
import    instrument.internal.udm.*;
for i=1: size (ivicDrivers, 2)
    
    if bitand(ivicDrivers{1}.type , IVITypeEnum.IVIC)
        % driver name
        out{end+1} = ivicDrivers{i}.Name; %#ok<*AGROW>
        % model
        out{end+1} = ivicDrivers{i}.SupportedInstrumentModels;
    end
end
end