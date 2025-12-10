function varargout = privateFindHwInfo(infoType)
%PRIVATEFINDHWINFO Find available instruments.
%
%   PRIVATEFINDHWINFO finds the available serial port, GPIB, Bluetooth and 
%   VISA instruments.
%
%   This function should not be called directly by the user.
%  

%   Copyright 1999-2021 The MathWorks, Inc.

% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

serialPorts = {};      %#ok<NASGU>
bluetoothDevices = {}; %#ok<NASGU>
gpibInfo = {};         %#ok<NASGU>
visaAdaptors = {};     %#ok<NASGU>
visaConstructors = {}; %#ok<NASGU>
matlabDrivers = {};    %#ok<NASGU>
i2cInfo = {};          %#ok<NASGU> 
varargout = {};

if strcmp (infoType, 'visa')
    [~ ,visaConstructors] = localGetVisaResource;
    varargout(1) = {visaConstructors};
    return;
end

if (~strcmp(infoType, 'device'))
    info = instrhwinfo('serial');
    serialPorts = info.SerialPorts;
    
    bluetoothDevices = {};
    % No bluetooth support in linux and MAC 10.8 or higher
    if(isempty(strfind(computer,'GLNX')))
       bluetoothDevices = localParseBluetooth;
    end
        
    gpibInfo = localParseGPIB;
    gpibInfo = modifyGpibInfo(gpibInfo, 'agilent');
    [visaAdaptors ,visaConstructors] = localGetVisaResource;
    visaAdaptors = updateVendorList(visaAdaptors, 'agilent');
    varargout(1) = {serialPorts};
    
    varargout(2) = {gpibInfo};
    varargout(3) = {visaAdaptors};
    varargout(4) = {sort(unique(visaConstructors))};
    varargout(5) = { bluetoothDevices };
    
end

if (~strcmp(infoType, 'interface'))
    out = privateBrowserHelper('find_MATLAB_drivers');
    matlabDrivers=cell(1,length(out)/3);
    for idx = 1:3:length(out)
        matlabDrivers{(idx+2)/3} = fullfile(out{idx+2}, out{idx});
    end
    varargout{end+1} = matlabDrivers;
end

% Add i2c adaptors
i2cInfo = instrhwinfo('i2c');
varargout{end+1} = localParseI2C(i2cInfo);

function gpibInfo = modifyGpibInfo(gpibInfo, name)

findName = strcmpi(gpibInfo, name);
index = find(findName);
if index
    if index == 1
        gpibInfo = gpibInfo(4:end);
    elseif index == ( size(gpibInfo, 2) - 3)
        gpibInfo = gpibInfo(1:(end-3));
    else
        gpibInfo = [gpibInfo(1:index-1) gpibInfo((index+3) : end)];
    end
end

function vendorList = updateVendorList(vendorList, toRemove)
index = strcmpi(vendorList, toRemove);
vendorList(index) = [];

%Find available VISA resources.
function  [visaAdaptors ,visaConstructors]  = localGetVisaResource
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

info = instrhwinfo('visa');
visaAdaptors = info.InstalledAdaptors;
visaConstructors = {};

% Can now have more than one VISA dll installed.
if ~isempty(visaAdaptors)
    oldEnd = 0;
    for j=1:length(visaAdaptors)
        % Get the Constructors.
        temp = instrhwinfo('visa', visaAdaptors{j});
        
        if (~isempty(temp.ObjectConstructorName))
            tempConstructors = temp.ObjectConstructorName;
            
            % Extract out the resource names.
            for i=1:numel(tempConstructors)
                index = findstr(tempConstructors{i}, ','); %#ok<FSTR>
                vconst = tempConstructors{i};
                visaConstructors{i+oldEnd} = vconst(index+3:length(vconst)-3); %#ok<AGROW>
            end
            oldEnd = length(visaConstructors);
        end
    end
else
    visaAdaptors = {};
end

    
% --------------------------------------------------------------------------
% Find the available GPIB hardware, board indices and primary addresses.
% out will be of the form: adaptor, cell array of board indices, cell array of
% cells that contain the primary addresses for each board index listed.
function out = localParseGPIB
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Initialize output.
out = {};

gpibInfo = instrhwinfo('gpib');
gpibAdaptors = gpibInfo.InstalledAdaptors;

for i = 1:length(gpibAdaptors)
    info = instrhwinfo('gpib', gpibAdaptors{i});
    
    % Extract the BoardIndex and Primary Address information.
    bids         = info.InstalledBoardIds;
    constructors = info.ObjectConstructorName;
    
    % Convert board indices to cell if necessary.
    bids = localFormatBoardIndices(bids);
    
    % Loop through each board index and find the associated primary
    % addresses.   
    pads = {};
    command = ['gpib(''' gpibAdaptors{i} ''', '];
    
    for j=1:length(bids)
        pad = {};
        commandWithBid = [command num2str(bids{j}) ', '];
        for k=1:length(constructors)
            constructor = constructors{k};
            if ~isempty(findstr(commandWithBid, constructor))
                constructor = strrep(constructor, commandWithBid, '');
                constructor = strrep(constructor, ');', '');
                pad = {pad{:}, constructor};  
            end
        end
        pads = {pads{:} pad};
    end
    
    % Out consists of adaptor, unique board indices and a cell array of 
    % primary addresses for each board index.
    out = {out{:} gpibAdaptors{i} bids, pads}; 
end

% --------------------------------------------------------------------------
% Format the Board Indices into a cell array of string.
function bids = localFormatBoardIndices(bid)

bids = cell(1, length(bid));
for i = 1:length(bid)
    bids{i} = num2str(bid(i));
end


function out = getChannelString(in)
    if in == '0'
        out=' [check device, rescan]';
    else
        out=[' [Channel: ' in ']' ];
    end


function bt = localParseBluetooth
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

bluetoothInfo = instrhwinfo('Bluetooth');
ids = bluetoothInfo.RemoteIDs;
bt={};
for k=1:length(ids)
    device=instrhwinfo('Bluetooth', ids{k});
    if isempty(device.Channels)
        device.Channels = {'0'};
    end
    for l=1;length(device.Channels)
        if(~isempty(device.RemoteName))
            bt{end+1} = [ device.RemoteName getChannelString(device.Channels{l}) ' (' device.RemoteID ')']; %#ok<AGROW>
        elseif (~isempty(bluetoothInfo.RemoteNames{k}))
            bt{end+1} = [  bluetoothInfo.RemoteNames{k} getChannelString(device.Channels{l}) ];%#ok<AGROW>
        else
            bt{end+1} = [  bluetoothInfo.RemoteIDs{k} getChannelString(device.Channels{l}) ];%#ok<AGROW>
        end
    end
end

function out = localParseI2C(info)


%for each vendor, loop through and check to see if more than one board is
%detected
out = {};

for vendorIdx=1:length(info.InstalledAdaptors)
    detailedInfo = instrhwinfo('i2c', info.InstalledAdaptors{vendorIdx});    
    % The number of boards is at least 1, even if there is no hardware.
    % This is because we allow the CLI to create the object even the
    % hardware is not connected
    MAX_BOARDS = max(1,numel(detailedInfo.InstalledBoardIDs) + numel(detailedInfo.BoardIdsInUse));
    for boardIdx = 0:(MAX_BOARDS-1)
        %create an I2C object and check if a valid serial is provided
        foundSerial = [];
        try
        obj = i2c(info.InstalledAdaptors{vendorIdx}, boardIdx, 0); %remote address is irrelevant here 
        foundSerial = obj.BoardSerial; % Get the serial from the newly created temp object
        catch
           % We could not create the object 
        end
        if strcmpi(foundSerial, num2str(0)) %board serial is returned as zero if the board index is invalid
           % Check if the object already exists and is open: get the serial from the
           % obj
           foundObj = instrfind('Type', 'i2c', 'BoardIndex', boardIdx, 'Status', 'open');
           if ~isempty(foundObj) %We found an object that is reserving the hardware
               foundSerial = foundObj.BoardSerial;
           end
        end
        out{end+1} = [ info.InstalledAdaptors{vendorIdx} '/' num2str(boardIdx) '/' foundSerial ];
        delete(obj); %Delete the temp object
    end
end




