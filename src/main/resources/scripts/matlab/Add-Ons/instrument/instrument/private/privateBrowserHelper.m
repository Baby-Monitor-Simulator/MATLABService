function out = privateBrowserHelper(action, varargin)
%PRIVATEBROWSERHELPER helper function used by Instrument Control Browser.
%
%   PRIVATEBROWSERHELPER helper function used by the Instrument Control Toolbox
%   browser to:
%      1. Identify the available hardware
%      2. Identify the instruments
%      3. Create the object for communicating with instruments.
%
%   This function should not be called directly by the user.
%

%   Copyright 1999-2021 The MathWorks, Inc.

% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Initialize output.
out = [];

switch (action)
    case 'isVisaSupported'
        visaInfo = instrhwinfo('visa');
        visaAdaptor = visaInfo.InstalledAdaptors;
        if ~isempty(visaAdaptor)
            info = instrhwinfo('visa', visaAdaptor{1}, 'serial');
            out = info.SerialPorts;
        end
    case 'create'
        try
			obj = localCreateObject(varargin{1});
        catch aException
			com.mathworks.toolbox.testmeas.util.TMStringUtil.error('Connection Error', aException.message); 
        end
        if isempty(obj)
            return;
        end
        
        % If the object already existed, it may already be connected.
        if strcmp(get(obj, 'Status'), 'closed')
            try
                fopen(obj);
            catch openException
                % Object already in use.
                com.mathworks.toolbox.testmeas.util.TMStringUtil.error('Connection error', openException.message);
                return;
            end
        end
        out = java(igetfield(obj, 'jobject'));
    case 'fopen'
        obj = localGetValidObject(varargin{1});
        
        if isempty(obj)
            return;
        end
        
        % If the object already existed, it may already be connected.  Or, someone
        % could have turned off the instrument since it existed.
        if strcmp(get(obj, 'Status'), 'closed')
            try
                fopen(obj);
            catch ex
                % Object already in use.
                com.mathworks.toolbox.testmeas.util.TMStringUtil.error('Connection error', ['Unable to connect to the instrument:' sprintf('\n\n') ex.message]);
                return;
            end
        end
        
        out = get(obj, 'Status');
    case 'fclose'
        obj = localGetValidObject(varargin{1});
        
        % If the object already existed, it may already be connected.  Or, someone
        % could have turned off the instrument since it existed.
        if strcmp(get(obj, 'Status'), 'open')
            try
                fclose(obj);
            catch
                % Object already in use.
                %com.mathworks.toolbox.testmeas.util.TMStringUtil.error('Connection error', 'Unable to connect to the instrument.');
                out = null;
                return;
            end
        end
        
        out = get(obj, 'Status');
    case 'find_drivers'
        out = localFindDrivers;
    case 'find_MATLAB_drivers'
        out = localFindMATLABDrivers;
    case 'find_vxipnp_drivers'
        out = localFindVxiPnPDrivers;
    case 'identifySerial'
        out = localIdentifySerial;
    case 'identifyBluetooth'
        out = localIdentifyBluetooth;
    case 'identifyGPIB'
        out = localIdentifyGPIB;
    case 'identifyGPIBInstruments'
        vendor = varargin{1};
        bid    = str2double(varargin{2});
        out = localIdentifyGPIBInstruments(vendor, bid);
    case 'identifyVISATCPIP'
        % Return the information as vendor, BoardIndex, RemoteHost, LANName,
        % Identification.
        out = localIdentifyVISATCPIP;
    case 'identifyVISAUSB'
        % Output contains vendor, BoardIndex, ManufacturerID, ModelCode,
        % SerialNumber, InterfaceIndex and Identification string.
        out = localIdentifyVISAUSB;
    case 'identifyVISAMore'
        % Output contains vendor ...
        %  out = localIdentifyVISATCPIP;
        out = localIdentifyVISAMore;
    case 'identifyVXI'
        % Return the information as vendor, chassis index, vendor, chassis index.
        out = localIdentifyVxi('VXI');
    case 'identifyVXIInstruments'
        vendor  = varargin{1};
        chassis = str2double(varargin{2});
        out = localIdentifyVxiInstruments(vendor, chassis, 'VXI');
    case 'identifyGPIBVXI'
        out = localIdentifyVxi('GPIB-VXI');
    case 'identifyGPIB-VXIInstruments'
        vendor  = varargin{1};
        chassis = str2double(varargin{2});
        out = localIdentifyVxiInstruments(vendor, chassis, 'GPIB-VXI');
    case 'identifyTCPIPInstruments'
        out = localIdentifyNetworkInstrument('tcpip', cell(varargin{1}));
    case 'identifyUDPInstruments'
        out = localIdentifyNetworkInstrument('udp', cell(varargin{1}));
    case 'recreate'
        localRecreateObject(cell(varargin{1}));
    case 'connect'
        try
            connect(varargin{1});
        catch
            com.mathworks.toolbox.testmeas.util.TMStringUtil.error('Connection error', 'Unable to connect to the instrument.');
        end
    case 'disconnect'
        disconnect(varargin{1});
    case 'executeFunction'
        out = localExecuteFunction(varargin{:});
    case 'getFunction'
        out = localGetFunction(varargin{:});
    case 'setFunction'
        out = localSetFunction(varargin{:});
    case 'workspace'
        localExportToWorkspace(varargin{:});
    case 'figure'
        localExportToFigure(varargin{:});
    case 'mat-file'
        localExportToMATFile(varargin{:});
    case 'arrayeditor'
        localExportToArrayEditor(varargin{:});
end

% --------------------------------------------
function out = localIdentifyGPIB
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Find GPIB adaptors.
gpibInfo = instrhwinfo('gpib');
adaptors = gpibInfo.InstalledAdaptors;

% Initialize output.
out = {};

if isempty(adaptors)
    return;
end

for i=1:length(adaptors)
    % Initialize variables.
    bid    = {};
    pad    = {};
    ids    = {};
    
    adaptor = adaptors{i};
    
    % Find the path to the adaptor.
    [pathToDll, errflag] = localFindAdaptor(['mw' adaptor 'gpib']);
    if errflag
        continue;
    end
    
    % Query the adaptor for the available hardware.
    jobject = javaObject(['com.mathworks.toolbox.instrument.Gpib' upper(adaptor)], pathToDll, 0, 0);
    foundBids = FindBoards(jobject);
    if isempty(foundBids)
        tempOut = [];
    else
        cmds = com.mathworks.toolbox.instrument.Instrument.getScanCommands;
        if (cmds.size > 0)
            tempOut = FindInstruments(jobject, foundBids, com.mathworks.toolbox.testmeas.util.TMStringUtil.vector2StringArray(cmds));
        else
            tempOut = [];
        end
    end
    dispose(jobject);
    
    % Build up output.
    for j = 1:3:length(tempOut)
        bid{end+1} = num2str(tempOut(j));
        pad{end+1} = num2str(tempOut(j+1));
        ids{end+1} = removeCRLF(char(tempOut(j+2)));
    end
    
    uniqueBid = cell(1, length(foundBids));
    
    for j = 1:length(foundBids)
        uniqueBid{j} = num2str(double(foundBids(j)));
    end
    
    if ~isempty(foundBids)
        out{end+1} = {adaptor, uniqueBid, bid, pad, ids};
    end
end

% --------------------------------------------
function out = localIdentifyGPIBInstruments(adaptor, boardIndex)

% Initialize variables.
out    = {};
bid    = {};
pad    = {};
ids    = {};

% Find the path to the adaptor.
[pathToDll, errflag] = localFindAdaptor(['mw' adaptor 'gpib']);
if errflag
    return;
end

% Query the adaptor for the available hardware.
jobject = javaObject(['com.mathworks.toolbox.instrument.Gpib' upper(adaptor)], pathToDll, 0, 0);

foundBids = FindBoards(jobject);
if isempty(foundBids)
    tempOut = [];
else
    cmds = com.mathworks.toolbox.instrument.Instrument.getScanCommands;
    if (cmds.size > 0)
        tempOut = FindInstruments(jobject, foundBids, com.mathworks.toolbox.testmeas.util.TMStringUtil.vector2StringArray(cmds));
    else
        tempOut = [];
    end
end

dispose(jobject);

% Build up output.
for j = 1:3:length(tempOut)
    bid{end+1} = num2str(tempOut(j));
    pad{end+1} = num2str(tempOut(j+1));
    ids{end+1} = removeCRLF(char(tempOut(j+2)));
end

for i = 1:length(bid)
    if (str2double(bid{i}) == boardIndex)
        out{end+1} = pad{i};
        out{end+1} = '0';
        out{end+1} = ids{i};
    end
end

% --------------------------------------------
function out = localIdentifyNetworkInstrument(type, info)
% Type should be either TCPIP or UDP.
% Info - information on the remote host and remote port.

% Initialize the output.
out     = cell(length(info)/2, 1);
count   = 1;

% Loop through and identify.
for i=1:2:length(info)
    % Reset flag.
    errflag = false;
    
    % Get information about the next object to create.
    remoteHost = info{i};
    remotePort = info{i+1};
    
    % Determine if the object already exists. If not, create it.
    obj = instrfindall('Type', lower(type), 'RemoteHost', remoteHost, 'RemotePort', remotePort);
    if isempty(obj)
        try
            % Replace any single quotes in the remoteHost with double
            % single quotes.
            remoteHost = strrep(remoteHost, '''', '''''');
            
            % Try to create the object.
            if isempty(remoteHost) && isempty(remotePort)
                eval(['obj = ' lower(type) ';']);
            elseif isempty(remotePort)
                eval(['obj = ' lower(type) '(''' remoteHost ''');']);
            else
                eval(['obj = ' lower(type) '(''' remoteHost ''',' remotePort ');']);
            end
            
            % Object was created successfully.
            errflag = false;
        catch
            % The object could not be created.
            out{count} = 'Invalid Address specified';
            count = count+1;
            errflag = true;
        end
        
        status = 'delete';
    else
        % Determine what to do with the object when browser is done with it.
        status = get(obj, 'Status');
    end
    
    % Store the identification.
    if (errflag == false)
        out{count} = localIdentifyObject(obj, status);
        count = count+1;
    end
end

% --------------------------------------------
function out = localIdentifyVxi(type)
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Type should be either VXI or GPIB-VXI.

% Use VISA to identify hardware if it exists.
visaInfo = instrhwinfo('visa');
visaAdaptor = visaInfo.InstalledAdaptors;

% Initialize output
out = {};

% No VISA is installed.
if isempty(visaAdaptor)
    return;
end

% Inititialize cell counter
count = 1;
    
% Query each installed VISA for VXI instruments
for visaIdx = 1:length(visaAdaptor)

    % Determine if there are any VXI chassis available.
    vxiInfo     = instrhwinfo('visa', visaAdaptor{visaIdx}, type);
    ids         = vxiInfo.AvailableChassis;
    adaptorName = vxiInfo.AdaptorName;

    % If there are no chassis for this adaptor move on to the next
    if isequal(length(ids), 0)
        continue;
    end
    
    % Extend the output cell array
    [~,cols] = size(out);
    out{1, cols + length(ids)*2} = [];

    for i=1:length(ids)
        out{count} = adaptorName;
        out{count+1} = num2str(ids(i));
        count = count+2;
    end
end

% --------------------------------------------
function out = localIdentifySerial
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");
warning('off',"instrument:serial:ClassToBeRemoved");

% Find ports.
serialInfo = instrhwinfo('serial');
ports = serialInfo.SerialPorts;

% Initialize variables.
count = 1;
out = cell(length(ports)*2, 1);

% Loop through the serial ports and try to identify.
for i=1:length(ports)
    port = ports{i};
    
    % Determine if the object already exists. If not, create it.
    obj = instrfindall('Port', port);
    if isempty(obj)
        obj = serial(port);
        status = 'delete';
    else
        % Determine what to do with the object when browser is done with it.
        status = get(obj, 'Status');
    end
    
    % Store the port and it's identification.
    out{count} = port;
    out{count+1} = localIdentifyObject(obj, status);
    
    % Increment the counter.
    count = count+2;
end

% --------------------------------------------
function out = localIdentifyVxiInstruments(vendor, chassis, type)
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Type should be either VXI or GPIB-VXI.

% Use VISA to identify hardware if it exists.
visaInfo = instrhwinfo('visa');
visaAdaptor = visaInfo.InstalledAdaptors;

% Initialize output.
out = {};

% No VISA is installed. Use the GPIB find routines.
if any(strcmp(vendor, visaAdaptor))
    return;
end

% Determine if there are any GPIB instruments connected to the given Board Index.
vxiInfo         = instrhwinfo('visa', vendor, type);
constructorName = vxiInfo.ObjectConstructorName;
vxiId           = [type num2str(chassis) '::'];
vxiIdLength     = length(vxiId);
count           = 1;

for i=1:length(constructorName)
    % Determine if constructor is for the given chassis index.
    name = constructorName{i};
    startIndex = findstr(vxiId, name);
    
    if ~isempty(startIndex)
        endIndex     = findstr('::', name);
        
        % Store the logical address.
        out{count}   = name(startIndex+vxiIdLength:endIndex(2)-1);
        
        % Determine if object already exists.
        obj = instrfindall('Type', lower(type), 'ChassisIndex', chassis, 'LogicalAddress', str2double(out{count}));
        if isempty(obj)
            % Construct object since it doesn't exist.
            eval(['obj = ' name ';']);
            status = 'delete';
        else
            status = get(obj, 'Status');
        end
        
        % Store the identification.
        out{count+1} = localIdentifyObject(obj, status);
        
        % Increment counter.
        count = count+2;
    end
end

% --------------------------------------------
function out = localIdentifyVISATCPIP
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Output contains vendor, boardIndex, remotehost, lanName and
% identification string.

% Use VISA to identify hardware if it exists.
visaInfo = instrhwinfo('visa');
visaAdaptor = visaInfo.InstalledAdaptors;

% Initialize output
out = {};

% No VISA is installed.
if isempty(visaAdaptor)
    return;
end

% Inititialize cell counter
count = 1;
    
% Query each installed VISA for TCPIP instruments
for visaIdx = 1:length(visaAdaptor)

    % Determine if there are any TCPIP instruments available.
    tcpipInfo    = instrhwinfo('visa', visaAdaptor{visaIdx}, 'tcpip');
    constructors = tcpipInfo.ObjectConstructorName;
    adaptorName  = tcpipInfo.AdaptorName;

    % If there are no instruments for this adaptor move on to the next
    if isequal(length(constructors), 0)
        continue;
    end
    
    % Extend the output cell array
    [~,cols] = size(out);
    out{1, cols + length(constructors)*5} = [];
    
    for i=1:length(constructors)
        % Current object's constructor.
        name = constructors{i};

        % Determine the resource name.
        startIndex = findstr(name, 'TCPIP');
        endIndex   = findstr(name, 'INSTR');
        rsrcName   = name(startIndex:endIndex+length('INSTR')-1);

        % Vendor.
        out{count} = adaptorName;

        % Determine if object already exists. If not create it.
        obj = instrfindall('Type', 'visa-tcpip', 'RsrcName', rsrcName);
        if isempty(obj)
            % Construct object since it doesn't exist.
            eval(['obj = ' name ';']);
            status = 'delete';
        else
            status = get(obj, 'Status');
        end

        % Get the RemoteHost, BoardIndex and LANName values.
        propvals = get(obj, {'BoardIndex', 'RemoteHost', 'LANName'});
        out{count+1} = num2str(propvals{1});
        out{count+2} = propvals{2};
        out{count+3} = propvals{3};

        % Store the identification.
        out{count+4} = localIdentifyObject(obj, status);

        % Increment counter.
        count = count+5;
    end
end
% --------------------------------------------
function out = localIdentifyVISAUSB
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Output contains vendor, Boardindex, ManufacturerID, ModelCode,
% SerialNumber, InterfaceIndex and Identification string.

% Use VISA to identify hardware if it exists.
visaInfo = instrhwinfo('visa');
visaAdaptor = visaInfo.InstalledAdaptors;

% No VISA is installed.
if isempty(visaAdaptor)
    out = {};
    return;
end

VISAUSB = cell (1, length(visaAdaptor));
%loop through each adaptor
for visaAdpatorIdx = 1:length(visaAdaptor)
    % Determine if there are any USB instruments available.
    usbInfo      = instrhwinfo('visa', visaAdaptor{visaAdpatorIdx}, 'usb');
    constructors = usbInfo.ObjectConstructorName;
    adaptorName  = usbInfo.AdaptorName;
    
    % Construct output.
    out = cell(1, length(constructors)*7);
    
    count = 1;
    
    for i=1:length(constructors)
        % Current object's constructor.
        name = constructors{i};
        
        % Determine the resource name.
        startIndex = findstr(name, 'USB');
        endIndex   = findstr(name, 'INSTR');
        rsrcName   = name(startIndex:endIndex+length('INSTR')-1);
        
        % Vendor.
        out{count} = adaptorName;
        
        % Determine if object already exists. If not create it.
        obj = instrfindall('Type', 'visa-usb', 'RsrcName', rsrcName);
        if isempty(obj)
            % Construct object since it doesn't exist.
            eval(['obj = ' name ';']);
            status = 'delete';
        else
            status = get(obj, 'Status');
        end
        
        % Get the BoardIndex, ManufacturerID, ModelCode, SerialNumber,
        % InterfaceIndex values.
        propvals = get(obj, {'BoardIndex', 'ManufacturerID', 'ModelCode', 'SerialNumber', 'InterfaceIndex'});
        out{count+1} = num2str(propvals{1});
        out{count+2} = propvals{2};
        out{count+3} = propvals{3};
        out{count+4} = propvals{4};
        out{count+5} = num2str(propvals{5});
        
        % Store the identification.
        out{count+6} = localIdentifyObject(obj, status);
        
        % Increment counter.
        count = count+7;
    end
    
    VISAUSB{visaAdpatorIdx} = out;
end

out = VISAUSB;


%to identify other VISA resources
function out = localIdentifyVISAMore
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

visaInfo = instrhwinfo('visa');
visaAdaptor=visaInfo.InstalledAdaptors;

% Initialize output
out = {};

% No VISA is installed.
if isempty(visaAdaptor)
    return;
end

% Inititialize cell counter
count = 1;
    
% Query each installed VISA for generic instruments
for visaIdx = 1:length(visaAdaptor)
    
    % Determine if there are any VISA-generic instruments available.
    genericInfo  = instrhwinfo('visa', visaAdaptor{visaIdx}, 'generic');
    constructors = genericInfo.ObjectConstructorName;
    adaptorName  = genericInfo.AdaptorName;

    % If there are no instruments for this adaptor move on to the next
    if isequal(length(constructors), 0)
        continue;
    end
    
    % Extend the output cell array
    [~,cols] = size(out);
    out{1, cols + length(constructors)*3} = [];

    for i=1:length(constructors)
        % Current object's constructor.
        name = constructors{i};

        % Determine the resource name.
        eval(['obj = ' name ';']);
        rsrcName=obj.RsrcName;
        delete(obj);

        % Vendor.
        out{count} = adaptorName;

        % Determine if object already exists. If not create it.
        obj = instrfindall('Type', 'visa-generic', 'RsrcName', rsrcName);
        if isempty(obj)
            % Construct object since it doesn't exist.
            eval(['obj = ' name ';']);
            status = 'delete';
        else
            status = get(obj, 'Status');
        end

        %out{count} = char(visaAdaptor{1});
        out{count+1} = rsrcName;

        % Store the identification.
        out{count+2} = localIdentifyObject(obj, status);

        % Increment counter.
        count = count+3;
    end
end

% --------------------------------------------
function id = localIdentifyObject(obj, status)

% Store the timeout.
timeout = get(obj, 'Timeout');
set(obj, 'Timeout', 1);

% Connect if need to.
try
    if ~(strcmp(status, 'open'))
        fopen(obj);
    end
    
    % Try to identify instrument.
    scanCommands = com.mathworks.toolbox.instrument.Instrument.getScanCommands;
    for i = 1:scanCommands.size
        [id, ~, msg] = query(obj, char(scanCommands.elementAt(i-1)));
        if isempty(msg)
            break;
        end
    end
    id = removeCRLF(id);
catch
    id = '';
end

% If nothing was found, indicate so.
if isempty(id)
    id = 'No instrument was identified';
end

% Clean up the object.
set(obj, 'Timeout', timeout);
switch (status)
    case 'delete'
        fclose(obj);
        delete(obj);
    case 'open'
    case 'closed'
        fclose(obj);
end

% --------------------------------------------
function obj = localFindObject(vendor, varargin)
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

% Find the objects with the specified pv pairs.
obj = instrfindall(varargin{:});

% If there are no objects return.
if isempty(obj)
    return;
end

% There is no vendor to compare and there is only one object. Return.
if isempty(vendor) && length(obj) == 1
    return;
end

% Find the object's that match the vendor.
matchVendorObj = [];
for i=1:length(obj)
    currentVendor = instrhwinfo(obj(i), 'AdaptorName');
    if strcmpi(currentVendor, vendor)
        matchVendorObj = [matchVendorObj obj(i)];
    end
end

% If no objects or one object matched the vendor return.
if isempty(matchVendorObj) || (length(matchVendorObj) == 1)
    obj = matchVendorObj;
    return;
end

% More than one object was found that matches the vendor. Return the one
% that is connected to the hardware or return the first.
connectedObj = instrfindall(matchVendorObj, 'Status', 'open');
if isempty(connectedObj)
    obj = matchVendorObj(1);
else
    obj = connectedObj;
end

% --------------------------------------------
function obj = localCreateObject(t)
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");
warning('off',"instrument:Bluetooth:ClassToBeRemoved");
warning('off',"instrument:gpib:ClassToBeRemoved");
warning('off',"instrument:serial:ClassToBeRemoved");
warning('off',"instrument:tcpip:ClassToBeRemoved");
warning('off',"instrument:udp:ClassToBeRemoved");
warning('off',"instrument:visa:ClassToBeRemoved");

createdObject = false;

% Determine if creating a VISA object.
type = char(t.getType);
if any(strcmp(type, {'GPIB', 'serial'}))
    if (t.createVISAObject)
        type = ['VISA-' type];
    end
end

switch (type)
    
    case 'i2c'
        
        %Init Constructor Variables
        vendor = char(t.getVendor);
        boardIndex = t.getBoardIndex;
        
        
        
        remoteAddress = char(t.getRemoteAddress);
        if strfind(remoteAddress, '0x')
            remoteAddress = hex2dec(remoteAddress(3:end));
        else
            remoteAddress = str2double(remoteAddress);
        end
        
        existingConnectionsToRemoteAddress = instrfindall('Type', type, 'Vendor', lower(vendor), 'BoardIndex', boardIndex, 'RemoteAddress', remoteAddress);
        
        if isempty(existingConnectionsToRemoteAddress)
            createdObject = true;
            obj = i2c(lower(vendor), boardIndex, remoteAddress);
        else
            
            %If there are existing objects with the remote address
            %specified, set that as the instrument object. We won't try to
            %do anything with the existing objects (including cleaning it
            %up/ detroying it)
            
                obj = existingConnectionsToRemoteAddress(1);
                return;                
            
           
        end
        
        % Configure the newly created object properties AND try to open the
        % object. This way, we can clean up the I2C object here itself 
        try
            set(obj, ...
                'RemoteAddress',          remoteAddress,...
                'ByteOrder',              char(t.getByteOrder),...
                'BitRate',               t.getBitRate);
            fopen(obj);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
        
    case 'GPIB'
        % Initialize constructor variables.
        vendor         = char(t.getVendor);
        boardIndex     = str2double(char(t.getBoardIndex));
        primaryAddress = str2double(char(t.getPrimaryAddress));
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'gpib', 'BoardIndex', boardIndex, 'PrimaryAddress', primaryAddress);
        
        % The object does not already exist.
        if isempty(obj)
            % Determine if a VISA-GPIB object is connected to hardware.
            otherobj = localFindObject('', 'Type', 'visa-gpib', 'BoardIndex', boardIndex, 'PrimaryAddress', primaryAddress);
            if ~isempty(otherobj) && strcmp(get(otherobj, 'Status'), 'open')
                % Open dialog to determine if user wants to use VISA object.
                msg = 'The instrument is currently connected to with the VISA driver. Do you want to use this connection?';
                title = 'Instrument Connection';
                result = questdlg(msg, title, 'Yes', 'No', 'Yes');
                
                % If the user wants to use VISA connection, update obj and disconnect
                % from the hardware so that properties can be configured.
                if strcmp(result, 'Yes')
                    obj = otherobj;
                    fclose(obj);
                else
                    return;
                end
            else
                createdObject = true;
                obj = gpib(vendor, boardIndex, primaryAddress);
            end
        else
            fclose(obj);
        end
        
        % Configure the object properties.
        try
            set(obj, 'ByteOrder',         char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'VISA-GPIB'
        % Initialize constructor variables.
        visaVendors    = instrhwinfo('visa');
        vendor         = visaVendors.InstalledAdaptors{1};
        boardIndex     = str2double(char(t.getBoardIndex));
        primaryAddress = str2double(char(t.getPrimaryAddress));
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-gpib', 'BoardIndex', boardIndex, 'PrimaryAddress', primaryAddress);
        
        % The object does not already exist.
        if isempty(obj)
            % Determine if a GPIB object is connected to hardware.
            otherobj = localFindObject('', 'Type', 'gpib', 'BoardIndex', boardIndex, 'PrimaryAddress', primaryAddress);
            if ~isempty(otherobj) && strcmp(get(otherobj, 'Status'), 'open')
                % Open dialog to determine if user wants to use VISA object.
                msg = 'The instrument is currently connected to with the GPIB board driver. Do you want to use this connection?';
                title = 'Instrument Connection';
                result = questdlg(msg, title, 'Yes', 'No', 'Yes');
                
                % If the user wants to use VISA connection, update obj and disconnect
                % from the hardware so that properties can be configured.
                if strcmp(result, 'Yes')
                    obj = otherobj;
                    fclose(obj);
                else
                    return;
                end
            else
                createdObject = true;
                obj = visa(vendor, ['GPIB' num2str(boardIndex) '::' num2str(primaryAddress) '::INSTR']);
            end
        else
            fclose(obj);
        end
        
        % Configure the object properties.
        try
            set(obj, 'ByteOrder',         char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'serial'
        % Determine if this object already exists.
        port     = char(t.getPort);
        visaPort = char(t.getVISAPort);
        obj = instrfindall('Type', 'serial', 'Port', port);
        
        % The object does not already exist.
        if isempty(obj)
            % Determine if a VISA-serial object is connected to hardware.
            otherobj = localFindObject('', 'Type', 'visa-serial', 'Port', visaPort);
            if ~isempty(otherobj) && strcmp(get(otherobj, 'Status'), 'open')
                % Open dialog to determine if user wants to use VISA object.
                msg = 'The instrument is currently connected to with the VISA driver. Do you want to use this connection?';
                title = 'Instrument Connection';
                result = questdlg(msg, title, 'Yes', 'No', 'Yes');
                
                % If the user wants to use VISA connection, update obj and disconnect
                % from the hardware so that properties can be configured.
                if strcmp(result, 'Yes')
                    obj = otherobj;
                    fclose(obj);
                else
                    return;
                end
            else
                createdObject = true;
                obj = serial(port);
            end
        else
            fclose(obj);
        end
        
        % Configure the object properties.
        try
            set(obj, 'Baudrate',             t.getBaudRate,...
                'ByteOrder',              char(t.getByteOrder),...
                'Databits',               str2double(char(t.getDataBits)),...
                'DataTerminalReady',      char(t.getDataTerminalReady),...
                'FlowControl',            char(t.getFlowControl),...
                'InputBufferSize',        t.getInputBufferSize,...
                'OutputBufferSize',       t.getOutputBufferSize,...
                'Parity',                 char(t.getParity),...
                'RequestToSend',          char(t.getRequestToSend),...
                'StopBits',               str2double(char(t.getStopBits)),...
                'Terminator',             t.getTerminator,...
                'Timeout',                t.getTimeout);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
        
    case 'VISA-serial'
        % Determine if this object already exists.
        port     = char(t.getPort);
        visaPort = char(t.getVISAPort);
        obj = instrfindall('Type', 'visa-serial', 'Port', visaPort);
        
        % The object does not already exist.
        if isempty(obj)
            % Determine if a serial object is connected to hardware.
            otherobj = localFindObject('', 'Type', 'serial', 'Port', port);
            if ~isempty(otherobj) && strcmp(get(otherobj, 'Status'), 'open')
                % Open dialog to determine if user wants to use VISA object.
                msg = 'The instrument is currently connected to with the MATLAB serial driver. Do you want to use this connection?';
                title = 'Instrument Connection';
                result = questdlg(msg, title, 'Yes', 'No', 'Yes');
                
                % If the user wants to use VISA connection, update obj and disconnect
                % from the hardware so that properties can be configured.
                if strcmp(result, 'Yes')
                    obj = otherobj;
                    fclose(obj);
                else
                    return;
                end
            else
                createdObject = true;
                visaVendors   = instrhwinfo('visa');
                vendor        = visaVendors.InstalledAdaptors{1};
                obj = visa(vendor, [visaPort '::INSTR']);
            end
        else
            fclose(obj);
        end
        
        % Configure the object properties.
        try
            set(obj, 'Baudrate',             t.getBaudRate,...
                'ByteOrder',              char(t.getByteOrder),...
                'Databits',               str2double(char(t.getDataBits)),...
                'DataTerminalReady',      char(t.getDataTerminalReady),...
                'FlowControl',            char(t.getFlowControl),...
                'InputBufferSize',        t.getInputBufferSize,...
                'OutputBufferSize',       t.getOutputBufferSize,...
                'Parity',                 char(t.getParity),...
                'RequestToSend',          char(t.getRequestToSend),...
                'StopBits',               str2double(char(t.getStopBits)),...
                'Terminator',             t.getTerminator,...
                'Timeout',                t.getTimeout);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'Bluetooth'
        % Determine if this object already exists.
        if( ~isempty(t.getRemoteID))
            obj = instrfindall('Type', 'Bluetooth', 'RemoteID', t.getRemoteID);
        else
            obj = instrfindall('Type', 'Bluetooth', 'RemoteName', t.getRemoteName);
        end
        % The object does not already exist.
        if isempty(obj)
            createdObject = true;
            if( ~isempty(t.getRemoteName))
                obj = Bluetooth(char(t.getRemoteName), t.getChannel);
            else
                obj = Bluetooth( char(t.getRemoteID), t.getChannel);
                
            end
        end
        
        % Configure the object properties.
        try
            set(obj, ...
                'ByteOrder',              char(t.getByteOrder),...
                'InputBufferSize',        t.getInputBufferSize,...
                'OutputBufferSize',       t.getOutputBufferSize,...
                'Terminator',             t.getTerminator,...
                'Timeout',                t.getTimeout);
        catch aException
            % Delete the object if it was created.
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'TCPIP'
        createdObject  = false;
        remoteHost     = char(t.getRemoteHost);
        
        % If the RemotePort was not specified, use the default value of 80.
        if (isempty(char(t.getRemotePort)))
            remotePort = 80;
        else
            remotePort = str2double(t.getRemotePort);
        end
        
        % Determine if object already exists.
        obj = localFindObject('', 'Type', 'tcpip', 'RemoteHost', remoteHost, 'RemotePort', remotePort);
        
        % Create the object.
        if isempty(obj)
            obj = tcpip(remoteHost, remotePort);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',         char(t.getByteOrder),...
                'LocalHost',             char(t.getLocalHost),...
                'LocalPortMode',         char(t.getLocalPortMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Terminator',            t.getTerminator,...
                'Timeout',               t.getTimeout,...
                'TransferDelay',         char(t.getTransferDelay));
            if ~(isempty(t.getLocalPort))
                set(obj, 'LocalPort', double(t.getLocalPort));
            end
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'UDP'
        createdObject  = false;
        remoteHost     = char(t.getRemoteHost);
        
        % If the RemotePort was not specified, use the default value of 9090.
        if (isempty(char(t.getRemotePort)))
            remotePort = 9090;
        else
            remotePort = str2double(t.getRemotePort);
        end
        
        % Determine if object already exists.
        obj = localFindObject('', 'Type', 'udp', 'RemoteHost', remoteHost, 'RemotePort', remotePort);
        
        % Create the object.
        if isempty(obj)
            obj = udp(remoteHost, remotePort);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',         char(t.getByteOrder),...
                'DatagramTerminateMode', char(t.getDatagramTerminateMode),...
                'LocalHost',             char(t.getLocalHost),...
                'LocalPortMode',         char(t.getLocalPortMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Terminator',            t.getTerminator,...
                'Timeout',               t.getTimeout);
            if ~(isempty(t.getLocalPort))
                set(obj, 'LocalPort', double(t.getLocalPort));
            end
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'VXI'
        createdObject  = false;
        chassisIndex   = char(t.getChassisIndex);
        logicalAddress = char(t.getLogicalAddress);
        vendor         = char(t.getVendor);
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-vxi', 'ChassisIndex', str2double(chassisIndex), 'LogicalAddress', str2double(logicalAddress));
        
        % Create the object.
        if isempty(obj)
            rsrcName = ['VXI' chassisIndex '::' logicalAddress '::INSTR'];
            obj = visa(vendor, rsrcName);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',             char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'MemoryIncrement',       char(t.getMemoryIncrement),...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'GPIB-VXI'
        createdObject  = false;
        chassisIndex   = char(t.getChassisIndex);
        logicalAddress = char(t.getLogicalAddress);
        vendor         = char(t.getVendor);
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-gpib-vxi', 'ChassisIndex', str2double(chassisIndex), 'LogicalAddress', str2double(logicalAddress));
        
        % Create the object.
        if isempty(obj)
            rsrcName = ['GPIB-VXI' chassisIndex '::' logicalAddress '::INSTR'];
            obj = visa(vendor, rsrcName);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',             char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'MemoryIncrement',       char(t.getMemoryIncrement),...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'VISA-TCPIP'
        createdObject  = false;
        remoteHost     = char(t.getRemoteHost);
        lanName        = char(t.getLANName);
        vendor         = char(t.getVendor);
        boardIndex      = char(t.getBoardIndex);
        
        % Construct the resource name.
        rsrcName = ['TCPIP' boardIndex '::' remoteHost '::' lanName '::INSTR'];
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-tcpip', 'RsrcName', rsrcName);
        
        % Create the object.
        if isempty(obj)
            obj = visa(vendor, rsrcName);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',           char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
    case 'VISA-USB'
        createdObject  = false;
        boardIndex     = char(t.getBoardIndex);
        manId          = char(t.getManufacturerID);
        modelCode      = char(t.getModelCode);
        serialNo       = char(t.getSerialNumber);
        interfaceIndex = char(t.getInterfaceIndex);
        vendor         = char(t.getVendor);
        
        rsrcName = [ 'USB' boardIndex '::' manId '::' modelCode '::' serialNo '::' interfaceIndex '::INSTR'];
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-usb', 'RsrcName', rsrcName);
        
        % Create the object.
        if isempty(obj)
            obj = visa(vendor, rsrcName);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            set(obj, 'ByteOrder',           char(t.getByteOrder),...
                'EOSCharCode',           t.getEOSCharCode,...
                'EOSMode',               char(t.getEOSMode),...
                'EOIMode',               char(t.getEOIMode),...
                'InputBufferSize',       t.getInputBufferSize,...
                'OutputBufferSize',      t.getOutputBufferSize,...
                'Timeout',               t.getTimeout);
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
        
    case 'Visa-Generic'
        createdObject  = false;
        vendor         = char(t.getVendor);
        rsrcName = char(t.getResource);
        
        % Determine if object already exists.
        obj = localFindObject(vendor, 'Type', 'visa-generic', 'RsrcName', rsrcName);
        
        % Create the object.
        if isempty(obj)
            obj = visa(vendor, rsrcName);
            createdObject = true;
        else
            fclose(obj);
        end
        
        % Configure the object.
        try
            % Find the type of VISA element we are creating
            rsrcElem = regexp(rsrcName,'::','split');
            if ~isempty(rsrcElem) && ~isempty(strfind(rsrcElem{1},'ASRL'))
                % VPP4.3 section 4.3 describes the potential string values
                % returned by viParseRsrc. Serial objects must have ASRL
                % in the first element. Since VISA-Serial objects do not 
                % have EOS/EOI properties we won't try to set them.
                set(obj, 'ByteOrder',        char(t.getByteOrder),...
                    'InputBufferSize',       t.getInputBufferSize,...
                    'OutputBufferSize',      t.getOutputBufferSize,...
                    'Timeout',               t.getTimeout);                
            else
                set(obj, 'ByteOrder',        char(t.getByteOrder),...
                    'EOSCharCode',           t.getEOSCharCode,...
                    'EOSMode',               char(t.getEOSMode),...
                    'EOIMode',               char(t.getEOIMode),...
                    'InputBufferSize',       t.getInputBufferSize,...
                    'OutputBufferSize',      t.getOutputBufferSize,...
                    'Timeout',               t.getTimeout);
            end
        catch aException
            if createdObject
                delete(obj);
            end
            rethrow(aException);
        end
        
end

% --------------------------------------------
% Remove any trailing carriage returns or line feeds.
function out = removeCRLF(out)

if isempty(out)
    return;
end

while out(end) == sprintf('\n')
    out = out(1:end-1);
end

while out(end) == sprintf('\r')
    out = out(1:end-1);
end

% --------------------------------------------
% Get the MATLAB OOPs object for the java instrument object.
function out = localGetValidObject(instr)

objs = instrfindall;
for i = 1:length(objs)
    obj = objs(i);
    jobj = java(igetfield(obj, 'jobject'));
    if (jobj == instr)
        out = obj;
        return;
    end
end

% --------------------------------------------
% Find the adaptor that is being loaded. The path was not specified.
% name is mwnigpib, mwnivisa, mwagilentgpib, etc.
function [adaptorPath, errflag] = localFindAdaptor(adaptorName)

% Initialize variables.
adaptorPath = '';
errflag = 0;

% Define the toolbox root location.
instrRoot = which('instrgate', '-all');

dirname = instrgate('privatePlatformProperty', 'dirname');
extension = instrgate('privatePlatformProperty', 'libext');

if (isempty(dirname) || isempty(extension))
    errflag = 1;
    return;
end

% Define the adaptor directory location.
instrRoot = [fileparts(instrRoot{1}) 'adaptors'];
adaptorRoot = fullfile(instrRoot, dirname, [adaptorName extension]);

% Determine if the adaptor exists.
if exist(adaptorRoot, 'file')
    adaptorPath = adaptorRoot;
else
    errflag = 1;
end

% --------------------------------------------
function out = localFindDrivers

out = {localFindMATLABDrivers, localFindVxiPnPDrivers};

% --------------------------------------------
function out = localFindMATLABDrivers

% Get the drivers path.
driverPath = fullfile(fileparts(which('instrhelp')), 'drivers');

% Get the MATLAB path and put in cell array with driver path.
paths = path;

% Break paths into a cell where each element of the cell contains a directory
% on the path.
allPaths = strread(paths, '%s', 'delimiter', pathsep);
allPaths = {driverPath allPaths{:}};

% Initialize output.
out = {};

% Loop through paths and extract those files that have a .mdd
% extension.
for i = 1:length(allPaths)
    currentPath = allPaths{i};
    
    info = dir([currentPath filesep '*.mdd']);
    names = {info.name};
    
    for j = 1:length(names)
        try
            parser = com.mathworks.toolbox.instrument.device.drivers.xml.Parser([currentPath filesep names{j}]);
            dispalyName = char(parser.parseForDriverTypeDisplayName);
            out = {out{:} names{j}, dispalyName, currentPath};
        catch
            % Ignore any errors parsing drivers, otherwise this will
            % prevent TMTool from populating its dialogs correctly. Just
            % keep chugging along so we can still list all the valid
            % drivers (G288006).
        end
    end
end

% --------------------------------------------
function out = localFindVxiPnPDrivers

% Initialize output.
out = {};

% Find the directories in the VXI plug-n-play root directory.
vxipnproot = instrgate('privateGetVXIPNPPath');
vxipnpdir = dir(vxipnproot);

for i = 3:length(vxipnpdir)
    if vxipnpdir(i).isdir
        dirToLookFor  = fullfile(vxipnproot, vxipnpdir(i).name);
        fileToLookFor = [fullfile(dirToLookFor, vxipnpdir(i).name) '.fp'];
        if exist(fileToLookFor, 'file') == 2
            out = {out{:} vxipnpdir(i).name, dirToLookFor};
        end
    end
end

% ------------------------------------------------------------------
function localRecreateObject(info)

for i=1:length(info)
    eval(info{i});
end

% ------------------------------------------------------------------
function out = localExecuteFunction(varargin)

try
    
    % Parse input.
    obj    = varargin{1};
    code   = varargin{2};
    output = varargin{3};
    
    % Assign the device object and evaluate the code.
    try
        eval('deviceObj =  obj;');
        eval(code);
    catch aException
        out = ['<p>An error occurred while executing the function.</p><p>' aException.message '</p>'];
        out = {out, 'no', aException.message};
        return;
    end
    
    % There are no output arguments so return a success message.
    if strcmp(output, '')
        out = '<p>Function completed successfully.</p>';
        out = {out, 'no'};
        return;
    end
    
    % There are output arguments. Return information on output arguments.
    result = '<p>Function completed successfully.</p>';
    
    % Get a list of output arguments.
    output     = strrep(output, ' ', '');
    indices    = findstr(output, ',');
    args       = cell(1, length(indices)+1);
    startIndex = 1;
    
    for i = 1:length(indices)
        args{i} = output(startIndex:indices(i)-1);
        startIndex = indices(i)+1;
    end
    
    args{end} = output(startIndex:end);
    
    % Create the display for the output arguments.
    for i = 1:length(args)
        temp = eval(args{i});
        if isnumeric(temp)
            if (numel(temp) == 1)
                result = [result '<p>' args{i} ': ' num2str(temp) '</p>'];
            else
                [sizeoutputr sizeoutputc] = size(temp);
                result = [result '<p>' args{i} ': &lt;' num2str(sizeoutputr) 'x' num2str(sizeoutputc) ' double&gt;</p>'];
            end
        elseif islogical(temp)
            temp = double(temp);
            result = [result '<p>' args{i} ': ' num2str(temp) '</p>'];
        elseif iscell(temp)
            [sizeoutputr, sizeoutputc] = size(temp);
            result = [result '<p>' args{i} ': &lt;' num2str(sizeoutputr) 'x' num2str(sizeoutputc) ' cell&gt;</p>'];
        elseif isstruct(temp)
            error(message('instrument:privateinstr:privateBrowserHelper:structNotSupported'));
        else
            result = [result '<p>' args{i} ': ' temp '</p>'];
        end
    end
    
    resultData = cell(1, length(args));
    for i = 1:length(resultData)
        eval(['resultData{i} = ' args{i} ';']);
    end
    
    % Return the result.
    out = {result, 'yes', resultData, args};
catch aException
    out = ['<p>An error occurred while executing the function.</p><p>' aException.message '</p>'];
    out = {out, 'no',aException.message };
end

% ------------------------------------------------------------------
function out = localGetFunction(varargin)

try
    
    % Parse input.
    obj    = varargin{1};
    code   = varargin{2};
    output = varargin{3};
    
    % Assign the device object and evaluate the code.
    try
        eval('deviceObj = obj;');
        eval(code);
    catch aException
        out = ['<p>An error occurred while getting the property value.</p><p>' aException.message '</p>'];
        out = {out, 'no'};
        return;
    end
    
    % Return information on output arguments.
    result = '<p>Get completed successfully.</p>';
    
    % Create the display for the output arguments.
    if ~iscell(eval(output))
        if isnumeric(eval(output))
            result = [result '<p>' output ': ' num2str(eval(output)) '</p>'];
        else
            result = [result '<p>' output ': ' eval(output) '</p>'];
        end
    else
        h = eval(output);
        for i = 1:length(h)
            if isnumeric(h{i})
                result = [result '<p>' output '{' num2str(i) '}: ' num2str(h{i}) '</p>'];
            else
                result = [result '<p>' output '{' num2str(i) '}: ' h{i} '</p>'];
            end
        end
    end
    
    resultData = cell(1, 1);
    eval(['resultData{1} = ' output ';']);
    
    % Return the result.
    out = {result, 'yes', resultData, output};
catch aException
    out = ['<p>An error occurred while getting the property value.</p><p>' aException.message '</p>'];
    out = {out, 'no'};
    return;
end

% ------------------------------------------------------------------
function out = localSetFunction(varargin)

try
    % Parse input.
    obj    = varargin{1};
    code   = varargin{2};
    
    % Assign the device object and evaluate the code.
    try
        eval('deviceObj = obj;');
        eval(code);
    catch aException
        out = ['<p>An error occurred while setting the property value.</p><p>' aException.message '</p>'];
        out = {out};
        return;
    end
    
    % Return information on output arguments.
    result = '<p>Set completed successfully.</p>';
    
    % Return the result.
    out = {result};
catch aException
    out = ['<p>An error occurred while getting the property value.</p><p>' aException.message '</p>'];
    out = {out, 'no'};
    return;
end

% ------------------------------------------------------------------
function localExportToWorkspace(varargin)

% Parse the input.
info = varargin{1};

% If there is no data return.
if info.size <= 1
    return;
end

% Assign the data to the MATLAB workspace.
for i = 0:3:info.size-1
    name  = char(info.elementAt(i));
    index = info.elementAt(i+1);
    allData  = cell(info.elementAt(i+2));
    allData = localNestedJavaArray2NestedCellArray(allData);
    data = allData{index}';
    assignin('base', name, data);
end

% ------------------------------------------------------------------
function localExportToFigure(varargin)

% Parse the input.
info = varargin{1};

% If there is no data return.
if info.size <= 1
    return;
end

% Initialize variables.
variableNames = {};
count = 1;

% Assign values that will be plotted.
for i=0:3:info.size-1;
    name     = char(info.elementAt(i));
    index   = info.elementAt(i+1);
    allData  = cell(info.elementAt(i+2));
    allData = localNestedJavaArray2NestedCellArray(allData);
    data = allData{index};
    variableNames{count} = name;
    eval([variableNames{count} ' = data;']);
    count = count+1;
end

% Get the default colors and plot each variable.
colorOrder = get(gca, 'ColorOrder');
for i=1:length(variableNames)
    plot(eval(variableNames{i}), 'Color', colorOrder(rem(i, length(colorOrder))+1,:));
    hold on;
end

% Create a legend.
legend(variableNames{:});
hold off;

% ------------------------------------------------------------------
function localExportToMATFile(varargin)

% Parse the input.
filename = varargin{1};
info     = varargin{2};

% If there is no data return.
if info.size <= 1
    return;
end

% Initialize variables.
variableNames = {};
count = 1;

% Loop through and assign each object to the user-specified variable name.
for i=0:3:info.size-1;
    name     = char(info.elementAt(i));
    index   = info.elementAt(i+1);
    allData  = cell(info.elementAt(i+2));
    allData = localNestedJavaArray2NestedCellArray(allData);
    data = allData{index};
    variableNames{count} = name;
    eval([variableNames{count} ' = data;']);
    count = count+1;
end

% Save the variables to the MAT-file.
save(filename, variableNames{:});

% ------------------------------------------------------------------
function localExportToArrayEditor(varargin)

% Parse the input.
info = varargin{1};

% If there is no data return.
if info.size <= 1
    return;
end

% Export data to workspace.
for i=0:3:info.size-1
    name  = char(info.elementAt(i));
    index = info.elementAt(i+1);
    allData  = cell(info.elementAt(i+2));
    allData = localNestedJavaArray2NestedCellArray(allData);
    data = allData{index};
    assignin('base', name, data);
    openvar(name);
end

function data = localNestedJavaArray2NestedCellArray(data)
%LOCALNESTEDJAVAARRAY2NESTEDCELLARRAY - Converts the nested java objects
%into nested cell array. This function when given cell object containing
%Java objects arrays, will recursively convert the java object array to
%cell array.

for index = 1:length(data)
    if (iscell(data))
        if (isjava(data{index}))
            data{index} = cell(data{index});
        end        
        data{index} =  localNestedJavaArray2NestedCellArray(data{index});
    end
end