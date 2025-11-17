function out = getIviInstruments (driverType , instrumentType)
%getIviInstruments returns available instrument which is specific driver type
% and instrument type.
% for example:
%  getIviInstruments ('ivic', 'IviScope');
%  returns a list of Ivi-C Scope instruments

% Copyright 2011 The MathWorks, Inc.

out ={};
% only take care of ivi-c driver for now.
if ~strcmpi ( driverType, 'ivic')
    return;
end

% find out the installed VISA resource
visaResources = instrument.internal.udm.InstrumentUtility.getVisaResources();

instrumentType = regexprep ( instrumentType, 'Ivi', '');

%use VISA object to send *IDN? to those resources
for i = 1 : size (visaResources, 2)
    try
        
        resource  = visaResources{i};
        % get the feedback , find out the model number and get driver name from iviconfig store using model number
        drivers = instrument.internal.udm.ConfigStoreUtility.getIVIInstrumentDriversFromResource (instrumentType, resource);
        
        % only allow ivi- c driver type
        import instrument.internal.udm.*;
        
        if ~isempty (drivers ) && bitand(drivers{1}.type , IVITypeEnum.IVIC)
            % add to the output (instrument info )
            % instrument name i.e. Agilent MSO 6104A
            instrumentId = instrument.internal.udm.InstrumentUtility.queryInstrument(resource); %#ok<*AGROW>
            out{end+1}= processInstrumentId (instrumentId , resource );
            % driver name i.e. Ag546XX
            out{end+1}= drivers{1}.Name;
            %resource   i.e. TCPIP0:XX.XX.XX.XX
            out{end+1}= resource;
        end
        
    catch e
    end
end
end

%% Combine instrument identifier and VISA resource into more intuitive
%% info
function  instrumentInfo = processInstrumentId (instrumentId , resource)

[vendor, remain] = strtok (instrumentId, ',');
[model , ~] =  strtok (remain, ',');

interface = 'UNKNOWN';
if ~isempty (strfind (resource , 'TCPIP'))
    interface = 'TCPIP';
elseif  ~isempty (strfind (resource , 'GPIB'))
    interface = 'GPIB';
elseif strfind (resource , 'ASRL')
    interface = 'Serial';
    
end
    instrumentInfo  = sprintf ('%s - %s connected via %s', vendor , model, interface );
 
end