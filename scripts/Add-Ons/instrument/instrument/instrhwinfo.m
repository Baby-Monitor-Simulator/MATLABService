function obj = instrhwinfo(object, adaptor, interface)
%INSTRHWINFO Return information on available hardware.
%
%   INSTRHWINFO('ivi') is not recommended. Use <a href="matlab:help ividriverlist">ividriverlist</a> and
%   <a href="matlab:help ividevlist">ividevlist</a> instead.
%   INSTRHWINFO('vxipnp') is not recommended. Use <a href="matlab:help ividriverlist">ividriverlist</a> and
%   <a href="matlab:help ividevlist">ividevlist</a> instead.
%
%   INSTRHWINFO('serial') will be removed in a future release. Use
%   <a href="matlab:help serialportlist">serialportlist</a> instead.
%   INSTRHWINFO('serialport') will be removed in a future release. Use
%   <a href="matlab:help serialportlist">serialportlist</a> instead.
%   INSTRHWINFO('Bluetooth') will be removed in a future release. Use
%   <a href="matlab:help bluetoothlist">bluetoothlist</a> instead.
%   INSTRHWINFO('visa') will be removed in a future release. Use
%   <a href="matlab:help visadevlist">visadevlist</a> instead.
%   INSTRHWINFO('gpib') will be removed in a future release. Use
%   <a href="matlab:help visadevlist">visadevlist</a> instead.
%   INSTRHWINFO('tcpip') will be removed in a future release. There is no
%   simple replacement for this.
%   INSTRHWINFO('udp') will be removed in a future release. There is no
%   simple replacement for this.
%   INSTRHWINFO('i2c') will be removed in a future release. Use 
%   <a href="matlab:help ni845xlist">ni845xlist</a> or <a href="matlab:help aardvarklist">aardvarklist</a> instead.
%
%   OUT = INSTRHWINFO returns instrument control hardware information.
%   This information includes the toolbox version, MATLAB version,
%   supported interfaces and supported driver types.
%
%   OUT = INSTRHWINFO('INTERFACE') returns information related to the
%   specified interface, INTERFACE. INTERFACE can be 'gpib', 'visa',
%   'serial', 'serialport', 'tcpip', 'udp', 'i2c', 'Bluetooth', or 'spi'.
%   For the GPIB and VISA interfaces, this information includes installed
%   adaptors. For the serial and serialport interfaces, this information
%   includes available hardware. For the TCPIP and UDP interfaces, this
%   information includes the local host address.
%
%   OUT = INSTRHWINFO('DRIVERTYPE') returns information related to the
%   specified driver type, DRIVERTYPE. DRIVERTYPE can be 'matlab',
%   'vxipnp', or 'ivi'. If DRIVERTYPE is MATLAB, this information includes
%   the MATLAB instrument drivers found on the MATLAB path. If DRIVERTYPE
%   is vxipnp, this information includes the found VXIplug&play drivers. If
%   DRIVERTYPE is ivi, this information includes the available logical
%   names and information on the IVI configuration store.
%
%   OUT = INSTRHWINFO('INTERFACE', 'ADAPTOR') returns information related
%   to the specified adaptor, ADAPTOR, for the specified INTERFACE. This
%   information includes adaptor version and available hardware. INTERFACE
%   can be set to either 'gpib' or 'visa'. Supported adaptors include:
%
%             Interface:      Adaptor:
%             ==========      ========
%             gpib            keysight, ics, ni, adlink, mcc
%             visa            keysight, ni, rs, tek
%             i2c             aardvark, ni845x
%             spi             aardvark, ni845x
%
%   OUT = INSTRHWINFO('I2C', 'ADAPTOR') or returns information related to
%   the specified adaptor.
%
%   OUT = INSTRHWINFO('SPI', 'ADAPTOR') or returns information related to
%   the specified adaptor.
%
%   OUT = INSTRHWINFO('Bluetooth', 'RemoteName') or OUT =
%   INSTRHWINFO('Bluetooth', 'RemoteID') returns information related to the
%   specified remote device.
%   INSTRHWINFO('Bluetooth') will be removed in a future release. Use bluetoothlist instead.
%
%   OUT = INSTRHWINFO('DRIVERTYPE', 'DRIVERNAME') returns information
%   related to the specified driver, DRIVERNAME for the specified
%   DRIVERTYPE. DRIVERTYPE can be set to 'matlab', 'vxipnp'. The available
%   DRIVERNAME values are returned by INSTRHWINFO('DRIVERTYPE').
%
%   OUT = INSTRHWINFO('ivi', 'LOGICALNAME') returns information related to
%   the specified logical name, LOGICALNAME. The available logical name
%   values are returned by INSTRHWINFO('ivi').
%
%   OUT = INSTRHWINFO('INTERFACE', 'ADAPTOR', 'TYPE') returns information
%   on the specified type, TYPE. INTERFACE can only be 'visa'. ADAPTOR can
%   be 'keysight', 'ni' or 'tek'. TYPE can be  'gpib', 'vxi', 'gpib-vxi',
%   'serial', 'tcpip', 'usb', 'rsib', 'pxi' or 'generic'.
%
%   OUT = INSTRHWINFO(OBJ) where OBJ is any instrument object or a device
%   group object, returns information on OBJ. For GPIB and VISA objects,
%   OUT contains adaptor and vendor supplied DLL information. For serial
%   port, tcpip and udp objects, OUT contains JAR file information. For
%   device objects and device group objects, OUT contains driver and
%   instrument information. If OBJ is an array of objects then OUT is a
%   1-by-N cell array of structures where N is the length of OBJ.
%
%   OUT = INSTRHWINFO(OBJ, 'FieldName') returns the hardware information
%   for the specified fieldname, FieldName, to OUT. FieldName can be any of
%   the fieldnames defined in the INSTRHWINFO(OBJ) structure. FieldName can
%   be a single string or a cell array of strings. OUT is a M-by-N cell
%   array where M is the length of OBJ and N is the length of FieldName.
%
%   Example:
%       out1 = instrhwinfo
%
%       out2 = instrhwinfo('serial')
%       INSTRHWINFO('serial') is not recommended. Use INSTRHWINFO('serialport') instead.
%
%       out3 = instrhwinfo('serialport')
%
%       out4 = instrhwinfo('gpib', 'ni')
%
%       out5 = instrhwinfo('visa', 'ni')
%
%       out6 = instrhwinfo('visa', 'ni', 'gpib')
%
%       obj  = visa('ni', 'ASRL1::INSTR')
%
%       out7 = instrhwinfo(obj)
%
%       out8 = instrhwinfo(obj, 'AdaptorName')
%

%   Copyright 1999-2022 The MathWorks, Inc.

% Show warning when instrhwinfo is called for legacy interfaces that are in warn phase.
if nargin ~= 0
    instrhwinfoInterface = "instrhwinfo" + lower(string(object));
    instrument.internal.ICTRemoveFunctionalityHelper(instrhwinfoInterface, "Warn", "Function");
end

switch nargin
    case 0
        % Ex. out = instrhwinfo

        checkoutJava();

        % Create the output structure.
        out.MATLABVersion = localGetVersion('MATLAB');
        out.SupportedInterfaces = {'gpib', 'serial', 'serialport', ...
            'tcpip', 'udp', 'visa', 'Bluetooth', 'i2c', 'spi'};
        if ispc
            out.SupportedDrivers = {'matlab', 'ivi', 'vxipnp'};
        else
            out.SupportedDrivers = {'matlab'};
        end
        out.ToolboxName = 'Instrument Control Toolbox';
        out.ToolboxVersion = localGetVersion('instrument');

    case 1
        % Ex. out = instrhwinfo('serial');

        % convert to char in order to accept string datatype
        object = instrument.internal.stringConversionHelpers.str2char(object);

        if ~ischar(object)
            error(message('instrument:instrhwinfo:invalidInterface'));
        end

        % Create the output structure.
        switch lower(object)
            case 'serial'

                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                try
                    fields = {'AvailableSerialPorts', 'JarFileVersion', ...
                        'ObjectConstructorName', 'SerialPorts'};
                    try
                        s = javaObject('com.mathworks.toolbox.instrument.SerialComm','temp');
                        tempOut = hardwareInfo(s);
                        dispose(s);
                    catch
                        tempOut = {{}, '', {}, {}}';
                    end

                    % Get all serial ports for the machine (in-use and not in-use ports)
                    allSerialPorts = cellstr(serialportlist('all'));

                    % Prepare the tempOut cell structure
                    tempOut = cell(tempOut);
                    tempOut{4} = allSerialPorts';
                    tempOut{3} = cell(0,1);
                    s = size(tempOut{4});
                    for iloop = 1 : s(1)
                        tempOut{3}{iloop, 1} = ['serial(''',tempOut{4}{iloop},''');'];
                    end
                    out = cell2struct(tempOut', fields, 2);
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'serialport'
                try
                    out = internal.SerialportHardwareInfo.GetHardwareInfo();
                catch aException
                    rethrow(aException);
                end
            case 'gpib'
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                pathToDll  = localFindPath;
                try
                    out.InstalledAdaptors = com.mathworks.toolbox.instrument.GpibDll.findValidAdaptors(pathToDll);
                    out.InstalledAdaptors = updateInstalledAdaptors(out.InstalledAdaptors, 'keysight', 'agilent');
                    out.InstalledAdaptors = out.InstalledAdaptors';
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'visa'
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                pathToDll =  localFindPath;
                try
                    out.InstalledAdaptors = com.mathworks.toolbox.instrument.SerialVisa.findValidAdaptors(pathToDll);
                    out.InstalledAdaptors = updateInstalledAdaptors(out.InstalledAdaptors, 'keysight', 'agilent');
                    out.InstalledAdaptors = out.InstalledAdaptors';
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'tcpip'
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                try
                    fields = {'LocalHost','JarFileVersion'};
                    t = com.mathworks.toolbox.instrument.TCPIP('temp',80);
                    tempOut = hardwareInfo(t);
                    dispose(t);

                    % Create the output structure.
                    tempOut = cell(tempOut);
                    out = cell2struct(tempOut', fields, 2);
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'udp'
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;
                try
                    fields = {'LocalHost','JarFileVersion'};
                    u = com.mathworks.toolbox.instrument.UDP('temp',9090);
                    tempOut = hardwareInfo(u);
                    dispose(u);

                    % Create the output structure.
                    tempOut = cell(tempOut);
                    out = cell2struct(tempOut', fields, 2);
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'bluetooth' % Ex. blueInfo = instrhwinfo('Bluetooth')
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                try
                    Fields = {'RemoteNames','RemoteIDs', 'BluecoveVersion','JarFileVersion'};
                    BluetoothDevices = com.mathworks.toolbox.instrument.BluetoothDiscovery.hardwareInfo();
                    tempOut = cell(BluetoothDevices);
                    tempOut = bluetoothCombinedDevices(tempOut);
                    out = cell2struct(tempOut', Fields, 2);
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException);
                end
            case 'i2c'
                checkoutJava();

                % Determine the jar file version.
                jarFileVersion = com.mathworks.toolbox.instrument.Instrument.jarVersion;

                try
                    pathToDll =  localFindPath;
                    out.InstalledAdaptors = cellstr(char(com.mathworks.toolbox.instrument.I2C.findValidAdaptors(pathToDll)))';
                    out.JarFileVersion = jarFileVersion;
                catch aException
                    rethrow(aException)
                end
            case 'spi'
                hwInfo = instrument.interface.spi.HardwareInfo();
                out = hwInfo.instrhwinfoDisplay();
            case 'matlab'
                out = localFindMATLABDrivers;
            case 'vxipnp'
                out = localFindVXIPnPDrivers;
            case 'ivi'
                out = localFindIVIDrivers;
            case 'modbus'
                icommLink = '<a href="www.mathworks.com/modbusinfo">Industrial Communication Toolbox</a>';
                throwAsCaller(MException(message("instrument:instrhwinfo:modbusNotSupported", icommLink)));
            otherwise
                error(message('instrument:instrhwinfo:invalidInterface'));
        end
    case 2
        % Ex. out = instrhwinfo('gpib', 'ni');
        % Ex. out = instrhwinfo('gpib', 'keithley');

        % convert to char in order to accept string datatype
        object = instrument.internal.stringConversionHelpers.str2char(object);

        % Check and retrieve the older name for the adaptor, if it exists.
        adaptor = instrgate('getInternalVendorName', adaptor);
        adaptor = instrument.internal.stringConversionHelpers.str2char(adaptor);

        if ~ischar(object)
            error(message('instrument:instrhwinfo:invalidInterface'));
        end

        if ~ischar(adaptor)
            if any(strcmp(object, {'gpib', 'serial', 'tcpip', 'udp', 'visa', 'Bluetooth', 'i2c'}))
                error(message('instrument:instrhwinfo:invalidAdaptor'));
            else
                error(message('instrument:instrhwinfo:invalidDriverName'));
            end
        end

        switch lower(object)
            case 'gpib'
                checkoutJava();
                adaptor = lower(adaptor);

                % Find the path to the dll.
                pathToDll  = localFindAdaptor(['mw' adaptor 'gpib']);

                % Create the output structure.
                try
                    fields = {'AdaptorDllName', 'AdaptorDllVersion', 'AdaptorName',...
                        'InstalledBoardIds', 'ObjectConstructorName', 'VendorDllName', ...
                        'VendorDriverDescription'};
                    jobject = javaObject(['com.mathworks.toolbox.instrument.Gpib' upper(adaptor)], pathToDll, 0, 0);
                    tempOut = hardwareInfo(jobject, pathToDll, adaptor, fileparts(pathToDll));
                    out = localCreateOutputStructure(tempOut, fields);
                    dispose(jobject);
                catch
                    error(message('instrument:instrhwinfo:adpatorNotFound'));
                end

                % Format InstalledBoardIds and ObjectConstructorName.
                out.InstalledBoardIds = unique(double(out.InstalledBoardIds))';
                if (isempty(out.ObjectConstructorName))
                    out.ObjectConstructorName = {};
                end
            case 'visa'
                checkoutJava();
                adaptor = lower(adaptor);

                % Find the path to the dll.
                pathToDll  = localFindAdaptor(['mw' adaptor 'visa']);

                % Construct the input to the SerialVisa constructor.
                [path, name, ext] = fileparts(pathToDll);
                vendor = [name ext];
                name = 'ASRL1::INSTR';

                % If a valid adaptor is specified create the output structure.
                try
                    fields = {'AdaptorDllName', 'AdaptorDllVersion', 'AdaptorName',...
                        'AvailableChassis', 'AvailableSerialPorts', 'InstalledBoardIds',...
                        'ObjectConstructorName', 'SerialPorts', 'VendorDllName',...
                        'VendorDriverDescription', 'VendorDriverVersion'};
                    jobject = com.mathworks.toolbox.instrument.SerialVisa(path,vendor,name,'');
                    tempOut = hardwareInfo(jobject, pathToDll, adaptor);
                    out = localCreateOutputStructure(tempOut, fields);
                    dispose(jobject);
                catch %#ok<*CTCH>
                    error(message('instrument:instrhwinfo:adpatorNotFound'));
                end
            case 'bluetooth' % Ex. blueInfo = instrhwinfo('Bluetooth','IRXON_WIN64')
                checkoutJava();

                %find the services available on a discovered device.
                device = lower(adaptor);
                if strcmpi(computer('arch'),'glnxa64')
                    error(message('instrument:instrhwinfo:noBluetoothSupportInLinux'));
                else
                    % If a valid adaptor is specified create the output structure.
                    try
                        fields = {'RemoteName', 'RemoteID','ObjectConstructorName','Channels'};
                        tempOut = com.mathworks.toolbox.instrument.BluetoothDiscovery.hardwareInfo(device);
                    catch
                        error(message('instrument:instrhwinfo:adpatorNotFound'));
                    end
                    out = localCreateOutputStructure(tempOut, fields);
                    if isempty(out.RemoteName)
                        % when no information returned, try one more step
                        % further to get the information from
                        % com.mathworks.toolbox.instrument.BluetoothDiscovery.hardwareInfo()
                        try
                            btDevices = com.mathworks.toolbox.instrument.BluetoothDiscovery.hardwareInfo();
                            if isempty(btDevices(1))
                                noDeviceException = MException(message('instrument:instrhwinfo:invalidAdaptor'));
                                throw(noDeviceException);
                            end
                            bt = cell(btDevices);
                            btDevices = bluetoothCombinedDevices(bt);
                            btInstrInfo = struct('RemoteNames', btDevices(1), 'RemoteIDs', btDevices(2));
                        catch aException
                            rethrow(aException);
                        end
                        if  ~isempty(btInstrInfo) % Instrument found
                            % Initialize out stucture
                            out = struct('RemoteName','','RemoteID','','ObjectConstructorName','','Channels','');
                            for Index = 1 : length(btInstrInfo.RemoteNames)
                                if strcmpi(btInstrInfo.RemoteNames(Index), adaptor)
                                    % fill out the structure
                                    out.RemoteName = [out.RemoteName; char(btInstrInfo.RemoteNames(Index))];
                                    out.RemoteID = [out.RemoteID; char(btInstrInfo.RemoteIDs(Index))];
                                    % use the RemoteIDs for the
                                    % ObjectConstructorName
                                    out.ObjectConstructorName = [out.ObjectConstructorName; {sprintf('Bluetooth(''%s'', %d);',char(btInstrInfo.RemoteIDs(Index)), 1)}];
                                    %If the bluetooth obj is created, use
                                    %its channel information. otherwise,
                                    %use '1' as default channel.
                                    remoteID = regexprep(char(btInstrInfo.RemoteIDs(Index)),'btspp://','');
                                    instrFound = instrfind('RemoteID',char(remoteID)); % remove the 'btspp://' part
                                    if ~isempty(instrFound)
                                        out.Channels = [out.Channels; {int2str(instrFound(1).Channel)}];
                                    else % isempty(instrFound)
                                        out.Channels = [out.Channels; {'1'}];
                                    end
                                end
                            end
                            if length(out.Channels) > 1
                                % if more than one bluetooth devices is
                                % found, call cellstr to convert the string
                                % array to cell array.
                                out.RemoteName= cellstr(out.RemoteName);
                                out.RemoteID = cellstr(out.RemoteID);
                            elseif length(out.Channels) == 1
                                % if only one bluetooth devices is
                                % found, use the RemoteName for the
                                % ObjectConstructorName
                                out.ObjectConstructorName = {sprintf('Bluetooth(''%s'', %d);',char(out.RemoteName), 1)};
                            end
                        end
                    end
                end
            case 'i2c'
                checkoutJava();

                % Throw an error if trying to look for I2C devices for Aardvark on MAC
                if (strcmpi(adaptor, 'aardvark') && strcmpi(computer('arch'),'maci64'))
                    error(message('instrument_aardvark:aardvark:noAardvarkSupportOnMac'));
                end

                % Find the path to the dll.
                pathToDll  = localFindAdaptor(['mw' lower(adaptor) 'i2c']);

                % Create the output structure.
                try
                    fields = {'AdaptorDllName', 'AdaptorDllVersion', 'AdaptorName',...
                        'InstalledBoardIDs', 'ObjectConstructorName', 'VendorDllName', ...
                        'VendorDriverDescription', 'BoardIdsInUse'};
                    jobject = javaObject(['com.mathworks.toolbox.instrument.I2C' upper(adaptor)],  pathToDll, adaptor, 0, 0);
                    tempOut = hardwareInfo(jobject, pathToDll, adaptor, fileparts(pathToDll));
                    jobject.dispose;
                catch ex
                    error(message('instrument:instrhwinfo:adpatorNotFound'));
                end
                % Create the output structure.
                tempOut = cell(tempOut);
                out = cell2struct(tempOut', fields, 2);

                % Format AvailableBoardIndices and ObjectConstructorName.

                out.InstalledBoardIDs = unique(double(out.InstalledBoardIDs))';
                out.BoardIdsInUse = unique(double(out.BoardIdsInUse))';
                if (isempty(out.ObjectConstructorName))
                    out.ObjectConstructorName = {};
                end
                % Retrieve board Serials if available
                numBoards = numel(out.InstalledBoardIDs) + numel(out.BoardIdsInUse);
                out.DetectedBoardSerials = cell(numBoards,1);
                for boardIndex = 0:numBoards-1
                    jobject = javaObject(['com.mathworks.toolbox.instrument.I2C' upper(adaptor)],  pathToDll, adaptor, boardIndex, 0);
                    serialNum =char(jobject.getBoardSerial());
                    %format boardSerial
                    formattedSerial = {[serialNum ' (BoardIndex: ' num2str(boardIndex) ')']};
                    out.DetectedBoardSerials(boardIndex+1) = formattedSerial;
                    dispose(jobject);
                end
                out = orderfields(out);
                perm = 1:numel(fieldnames(out));
                perm([5 6]) = perm([6 5]); % Swap the fields
                out = orderfields(out, perm);

            case 'spi'
                % Throw an error if trying to look for SPI devices for Aardvark on MAC
                if (strcmpi(adaptor, 'aardvark') && strcmpi(computer('arch'),'maci64'))
                    error(message('instrument_aardvark:aardvark:noAardvarkSupportOnMac'));
                end
                hwInfo = instrument.interface.spi.HardwareInfo();
                out = hwInfo.instrhwinfoDisplayByVendor(adaptor);
                if (isempty(out))
                    error(message('instrument:instrhwinfo:adpatorNotFound'));
                end
            case 'matlab'
                out = localGetMATLABDriverInfo(adaptor);
            case 'vxipnp'
                out = localGetVXIPnPDriverInfo(adaptor);
            case 'ivi'
                out = localGetIVIDriverInfo(adaptor);
            otherwise
                error(message('instrument:instrhwinfo:invalidInterface'));
        end

    case 3
        % Ex. instrhwinfo('visa', 'ni', 'serial');

        checkoutJava();

        % convert to char in order to accept string datatype
        object = instrument.internal.stringConversionHelpers.str2char(object);
        adaptor = instrument.internal.stringConversionHelpers.str2char(adaptor);
        interface = instrument.internal.stringConversionHelpers.str2char(interface);

        % Error checking.
        if ~strcmpi(object, 'visa')
            error(message('instrument:instrhwinfo:invalidSyntax'));
        end

        % Get the object specific information.
        out = localFindSpecificVisaInformation(adaptor, interface);

end

obj = instrument.HardwareInfo.Struct2Obj(out);
end

function checkoutJava()
% Error if java is not running.

if ~usejava("jvm")
    error(message("instrument:instrhwinfo:nojvm"));
end
end

function out = localCreateOutputStructure(tempOut, fields)
% Create the output structure.
tempOut = cell(tempOut);
out = cell2struct(tempOut', fields, 2);
end

% *********************************************************************
% Three input case.
function out  = localFindSpecificVisaInformation(adaptor, interface)

% Check and retrieve the older name for the adaptor, if it exists.
adaptor = instrgate('getInternalVendorName',adaptor);

% Find the path to the dll.
pathToDll = localFindAdaptor(['mw' adaptor 'visa']);

% Verify type of interface.
if ~ischar(interface)
    newExc =  MException ('instrument:instrhwinfo:invalidInterface','Invalid TYPE specified. Type ''instrhelp instrhwinfo'' for a list of valid TYPEs.' );
    throwAsCaller(newExc);
end

% Construct inputs to SerialVisa constructor.
[path, vendor, ext] = fileparts(pathToDll);
vendor = [vendor ext];
name = 'ASRL1::INSTR';

% Get the interface specific information.
try
    % Define the fields.
    fields = {'AdaptorDllName', 'AdaptorDllVersion', 'AdaptorName',...
        'AvailableChassis', 'AvailableSerialPorts', 'InstalledBoardIds',...
        'ObjectConstructorName', 'SerialPorts', 'VendorDllName',...
        'VendorDriverDescription', 'VendorDriverVersion'};

    % Create the object.
    jobject =  com.mathworks.toolbox.instrument.SerialVisa(path,vendor,name,'');

    % Get the information.
    switch lower(interface)
        case 'serial'
            tempOut = hardwareInfoOnSerial(jobject, pathToDll, adaptor);
        case 'gpib'
            tempOut = hardwareInfoOnGPIB(jobject, pathToDll, adaptor);
        case 'vxi'
            tempOut = hardwareInfoOnVXI(jobject, pathToDll, adaptor);
        case 'pxi'
            tempOut = hardwareInfoOnPXI(jobject, pathToDll, adaptor);
        case 'gpib-vxi'
            tempOut = hardwareInfoOnGPIBVXI(jobject, pathToDll, adaptor);
        case 'rsib'
            tempOut = hardwareInfoOn(jobject, pathToDll, adaptor, 'RSIB');
        case 'tcpip'
            tempOut = hardwareInfoOn(jobject, pathToDll, adaptor, 'TCPIP?*');
        case 'usb'
            tempOut = hardwareInfoOn(jobject, pathToDll, adaptor, 'USB?*');
        case 'generic'
            tempOut = hardwareInfoOnGeneric(jobject, pathToDll, adaptor);
        otherwise
            dispose(jobject);
            newExc = MException('instrument:instrhwinfo:invalidInterface', 'Invalid TYPE specified. Type ''instrhelp instrhwinfo'' for a list of valid TYPEs.');
            throwAsCaller(newExc);
    end

    % Get rid of the object.
    dispose(jobject);
catch r
    newExc =  MException( 'instrument:instrhwinfo:invalidAdaptor', 'Specified ADAPTOR was not found or could not be loaded.' );
    throwAsCaller(newExc);
end

% Create the output structure.
tempOut = cell(tempOut);
out = cell2struct(tempOut', fields, 2);
end

% -------------------------------------------------------------------
% Find the path to the dll.
function pathToDll = localFindPath

% Define the toolbox root location.
pathToDll = which('instrgate', '-all');

dirname = instrgate('privatePlatformProperty', 'dirname');

if (isempty(dirname))
    newExc =  MException('instrument:instrhwinfo:invalidPlatform' , 'The specified INTERFACE is not supported on this platform.' );
    throwAsCaller (newExc);
end

pathToDll = [fileparts(pathToDll{1}) 'adaptors'];
pathToDll = fullfile(pathToDll, dirname);
end

% -------------------------------------------------------------------
% Find the adaptor that is being loaded. The path was not specified.
% name is mwnigpib, mwnivisa, mwagilentgpib, etc.
function adaptorPath = localFindAdaptor(name)

% Define the toolbox root location.
instrRoot = which('instrgate', '-all');

dirname = instrgate('privatePlatformProperty', 'dirname');
extension = instrgate('privatePlatformProperty', 'libext');

if (isempty(dirname) || isempty(extension))
    newExc = MException('instrument:instrhwinfo:invalidPlatform', 'The specified INTERFACE is not supported on this platform.');
    throwAsCaller(newExc);
    
end

% Define the adaptor directory location.
instrRoot = [fileparts(instrRoot{1}) 'adaptors'];
adaptorRoot = fullfile(instrRoot, dirname, [name extension]);

% Determine if the adaptor exists.
if exist(adaptorRoot, 'file')
    adaptorPath = adaptorRoot;
else
    newExc = MException('instrument:instrhwinfo:adpatorNotFound', 'The specified VENDOR adaptor could not be found.');
    throwAsCaller(newExc);
end
end

% -------------------------------------------------------------------
% Output the version of the toolbox and MATLAB.
function str = localGetVersion(product)

try
    % Get the version information.
    verinfo = ver(product);

    % Get the version string.
    str = [verinfo(1).Version ' ' verinfo(1).Release];
catch
    str = '';
end
end

% -------------------------------------------------------------------
% Called by: instrhwinfo('matlab')
function out = localFindMATLABDrivers

% Get the list of drivers.
driverList = struct2table(getMDDInfo(false)).DriverName';
driverList = replace(driverList, ".mdd", "");

driverList(driverList == "") = [];

out.InstalledDrivers = cellstr(driverList);
end

% -------------------------------------------------------------------
% Called by: instrhwinfo('vxipnp')
function out = localFindVXIPnPDrivers

% Scan for VXIplug&play drivers. Information is of the form: Name, Directory.
driverInfo = privateBrowserHelper('find_vxipnp_drivers');

out.InstalledDrivers = '';
out.VXIPnPRootPath   = privateGetVXIPNPPath;

if isempty(driverInfo)
    return;
end

% Construct the cell of VXIplug&play driver names.
names = cell(1, length(driverInfo)/2);
count = 1;
for i=1:2:length(driverInfo)
    names{count} = driverInfo{i};
    count = count+1;
end

out.InstalledDrivers = names;
end

% -------------------------------------------------------------------
% Called by: instrhwinfo('ivi')
function out = localFindIVIDrivers

% Determine if IVI is installed.
rootPath = privateGetIviPath;

if isempty(rootPath)
    % IVI is not installed.
    out.LogicalNames = {};
    out.Modules      = {};
    out.ConfigurationServerVersion = '';
    out.MasterConfigurationStore   = '';
    out.IVIRootPath                = '';
    return;
end

% Create the configuration store object.
store = iviconfigurationstore;

% Construct the output.
out.LogicalNames               = {};
out.Modules                    = {};
out.ConfigurationServerVersion = get(store, 'Revision');
out.MasterConfigurationStore   = get(store, 'MasterLocation');
out.IVIRootPath                = rootPath;

logicalNames = get(store, 'LogicalNames');
if ~isempty(logicalNames)
    out.LogicalNames = {logicalNames.Name};
end

modules = get(store, 'SoftwareModules');

for idx = 1:length(modules)
    if (~isempty(modules(idx).ProgID))

        % empty progid is not the only criteria to differentiate a ivi-c
        % and ivi-com driver
        modulepathname = modules(idx).ModulePath;
        if (~isempty(modulepathname))
            seperator = strfind(modulepathname, '.');
            ivicDrivername = modulepathname(1:(seperator - 1));

            %32 bit or 64 bit
            if length(ivicDrivername) > 3 % Trim the suffix only if ivi-c Driver name length greater than three
                if (strcmp(ivicDrivername(end-2:end), '_32') || strcmp(ivicDrivername(end-2:end), '_64') )
                    ivicDrivername = ivicDrivername(1:end-3);
                end
            end

            ivicDriverFPFname = instrgate('privateGetIviCDriverName', ivicDrivername);
            if (~isempty(ivicDriverFPFname) && ~any(ismember (out.Modules ,ivicDrivername )))
                out.Modules{end + 1} = ivicDrivername;
            end
        end
    else
        name = modules(idx).ModulePath;
        % a workaround for g649241  since IVI.NET driver will insert a empty
        % module after installation
        if isempty (name)
            continue;
        end
        tmpidx = strfind(name, '.');
        if (~isempty(tmpidx))
            name = name(1:(tmpidx(1) - 1));
        end
        % 32 bit or 64 bit
        if (strcmp(name(end-2:end), '_32') || strcmp(name(end-2:end), '_64'))
            name = name(1:end-3);
        end

        %         if (isempty(out.Modules))
        %             out.Modules = {name};
        %         else
        if ~any (ismember (  name, out.Modules ))
            out.Modules{end + 1} = name;
        end
        %         end
    end
end
end

% --------------------------------------------------------------------------
% Parse through directories on the MATLAB path to detect MDD files. Returns
% info about the detected drivers - the driver name, the driver full path,
% and parsed details from the mdd file.
% Input - returnCachedDriver (1,1) logical.
%
% true - If there is a cached driver, return the cached driver as is.
% false - Regenerate the cache and return the new cached driver.
%
% Output is a struct array, containing the following fields -
% 1. DriverName
% 2. DriverPath
% 3. DriverDetails
% e.g >> info = getMDDInfo
%
% info =
%
%   1×20 struct array with fields:
%
%     DriverName
%     DriverFullPath
%     DriverDetails
%
% >> info(1)
%
% ans =
%
%   struct with fields:
%
%         DriverName: "OceanOptics_OmniDriver.mdd"
%     DriverFullPath: "B:\13\ssasmal.FebMidBtm\matlab\toolbox\instrument\instrument\drivers"
%      DriverDetails: [1×1 struct]
function driver = getMDDInfo(returnCachedDriver)
arguments
    returnCachedDriver (1, 1) logical = true
end

persistent persDriver

if isempty(persDriver) || ~returnCachedDriver
    instrumentDriverPath = string(fullfile(matlabroot, "toolbox", "instrument", "instrument", "drivers"));

    % Get the MATLAB path and put in cell array with driver path.
    paths = string(path);

    % Break paths into a cell where each element of the cell contains a directory
    % on the path.
    delimitter = ";";
    allPaths = [instrumentDriverPath, split(paths, delimitter)'];

    % Initialize output.
    persDriver = [];

    % Loop through paths and extract those files that have a .mdd
    % extension.
    for currentPath = allPaths
        info = dir(currentPath + filesep + "*.mdd");
        persDriver = [persDriver, prepareMDDInfo(info')];
    end
end
driver = persDriver;

    function mddlist = prepareMDDInfo(info)
        % For the mdd file, create the info about the file, including the
        % mdd file name, full path, and the parsed xml output.

        mddlist = [];
        for d = info
            driverStruct = struct("DriverName", "", "DriverFullPath", "", "DriverDetails", []);
            driverStruct.DriverFullPath = string(d.folder);
            driverStruct.DriverName = string(d.name);

            mddFile = fullfile(driverStruct.DriverFullPath, driverStruct.DriverName);

            try
                driverStruct.DriverDetails = readstruct(mddFile, "FileType", "xml");
            catch
            end
            mddlist = [mddlist, driverStruct];
        end
    end

end

% --------------------------------------------------------------------
% Called by: instrhwinfo('matlab', driver)
function out  = localGetMATLABDriverInfo(driverName)

arguments
    driverName (1, 1) string
end
% Initialize variables.
out     = [];
% Extract just the driver name and just the extension.
[~, driverName, ext] = fileparts(driverName);
if ext == ""
    ext = ".mdd";
end

driverName = driverName + ext;

% Search for the driver in a cached driver list.
foundDriver = findMDDDriver(driverName, true);
if isempty(foundDriver)
    newExc = MException("instrument:instrhwinfo:driverNotFound","The specified MATLAB instrument driver could not be found on the MATLAB path.");
    throwAsCaller(newExc);
end

% For multiple drivers found on the path, use the first index.
foundDriver = foundDriver(1);

if isempty(foundDriver.DriverDetails)
    newExc =  MException("instrument:instrhwinfo:driverInvalid", "The specified MATLAB instrument driver could not be parsed.");
    throwAsCaller(newExc);
end

% Construct the output.
driverDetails = foundDriver.DriverDetails;
out.Manufacturer  = char(driverDetails.InstrumentManufacturer);
out.Model         = char(driverDetails.InstrumentModel);
out.Type          = char(driverDetails.InstrumentType);
out.DriverType    = char(driverDetails.DriverType);
out.DriverName    = char(fullfile(foundDriver.DriverFullPath, foundDriver.DriverName));
out.DriverVersion = num2str(driverDetails.InstrumentVersion);
out.DriverDllName = '';

switch (out.DriverType)
    case 'VXIplug&play'
        driverDllName     = [char(driverDetails.DriverName) '_64.dll'];
        out.DriverDllName = fullfile(privateGetVXIPNPPath, 'bin',driverDllName);
    case 'IVI-COM'
        % COM drivers do not necessarily have a 1-1 dll mapping like the other
        % drivers.
    case 'IVI-C'
        driverDllName     = [char(driverDetails.DriverName) '.dll'];
        out.DriverDllName = fullfile(privateGetIviPath, 'bin',driverDllName);
end

    function foundDriver = findMDDDriver(driverName, useCachedValue)
        % --------------------------------------------------------------------
        % Returns the info about the mdd file found on the MATLAB path.
        % Inputs -
        % driverName (1,1) string-> The name of the driver to search on the MATLAB Path.
        % useCachedValue (1,1) logical.
        %                 true -> Search for the driverName in a cached driverList.
        %                 false -> Do a fresh search for all drivers on the path
        %                 and re-populate driverList.
        % Outputs -
        % foundDriver - A struct containing the following fields. Empty otherwise. 
        % 1. DriverName
        % 2. DriverPath
        % 3. DriverDetails
        % e.g >> info = findMDDDriver("lecroy_8600a", true)
        %
        % info =
        %
        %   struct with fields:
        %
        %         DriverName: "lecroy_8600a.mdd"
        %     DriverFullPath: "B:\13\ssasmal.FebMidBtm\matlab\toolbox\instrument\instrument\drivers"
        %      DriverDetails: [1×1 struct]

        narginchk(2, 2);
        foundDriver = [];
        driverList = getMDDInfo(useCachedValue);

        allDriverNames = struct2table(driverList).DriverName';

        driverFoundIndex = find(driverName == allDriverNames);

        % Driver was found.
        if ~isempty(driverFoundIndex)
            foundDriver = driverList(driverFoundIndex);
            return
        end

        % Driver was not found in the cache. Try to search for the driver
        % again without using the cached driver values.
        if useCachedValue
            foundDriver = findMDDDriver(driverName, false);
        end

    end
end

% -------------------------------------------------------------------
% Called by: instrhwinfo('vxipnp', driver)
function out = localGetVXIPnPDriverInfo(driverName)

arguments
    driverName (1, 1) string
end

% Initialize variables.
out     = [];

% Scan for VXIplug&play drivers. Information is of the form: Name, Directory.
driverInfo = privateBrowserHelper('find_vxipnp_drivers');

% Determine if the driver name the user specified exists.
driverLocation = -1;
for i=1:2:length(driverInfo)
    if strcmpi(driverInfo{i}, driverName)
        driverLocation = i;
        break;
    end
end

% Return if the driver is not found.
if driverLocation == -1
    newExc =  MException("instrument:instrhwinfo:driverNotFound", "The specified VXIplug&play driver could not be found.");
    throwAsCaller(newExc);
end

if computer == "PCWIN64"
    dllBitness = "_64.dll";
else
    dllBitness = "_32.dll";
end
driverDllName  = lower(driverName) + dllBitness;

% Construct the output.
out.Manufacturer   = char(getDriverManufacturer(driverName));
out.Model          = '';
out.DriverVersion  = '1.0';
out.DriverDllName  = char(fullfile(privateGetVXIPNPPath, 'bin', driverDllName));

    function manufacturer = getDriverManufacturer(driverName)
        % From the vendor driver name, get the vendor full name.

        vendorInitials = ["AQ" "AV" "AF" "AG" "AI" "AM" "AN" "AD" "AU" "AO" "AS" "AP" "BB" "BA" "BK" ...
            "BU" "CA" "CH" "CC" "CY" "DP" "DS" "EI" "FL" "GR" "GT" "GN" "HP" "IF" "IE" "IC" "KE" "KP" "KI" "KS" ...
            "MP" "MT" "MI" "MS" "NI" "NT" "NH" "NA" "PM" "PI" "PT" "RI" "RA" "RS" "SL" "SC" "SR" "SU" "ST" "SS" "TA" "TK" "TE" "TM" ...
            "TT" "VP" "VT" "VA" "WT" "WG" "XX" "YK"];
        vendorFullName = [ "Acquiris" "Advantest Corporation" "Aeroflex Laboratories" "Agilent Technologies" "AIM GmbH" "AMP Incorporated" ...
            "Analogic, Corp." "Ando Electric Company Limited" "Anritsu Company" "AOIP Instrumentation" "ASCOR Incorporated" "Audio Precision, Inc" ...
            "B&B Technologies" "BAE Systems" "Bruel & Kjaer" "Bustec Production Ltd." "CAL-AV Labs, Inc." "C&H Technologies, Inc." ...
            "Compressor Controls Corporation" "CYTEC Corporation" "Directed Perceptions, Inc." "DSP Technology, Inc." "EIP Microwave, Inc." "Fluke Company, Inc." ...
            "GenRad" "Giga-tronics, Inc." "gnubi communications, Inc." "Hewlett-Packard Company" "IFR" "Instrumentation Engineering, Inc." ...
            "Integrated Control systems" "Keithley Instruments" "Kepco, Inc." "Kikusui" "KineticSystems, Corp." "MAC Panel Company" "ManTech Test Systems" ...
            "Marconi Instruments" "Microscan" "National Instruments Corp." "NEUTRIK AG" "NH Research" "North Atlantic Instruments" "Phase Metrics" ...
            "Pickering Interfaces" "Power-Tek Inc." "Racal Instruments, Inc." "Radisys Corp." "Rohde & Schwarz GmbH" "Schlumberger Technologies" "Scicom" ...
            "Scientific Research Corporation" "Serendipity Systems, Inc." "sont/Tektronix Corporation" "Spectrum Signal Processing, Inc." "Talon Instruments" ...
            "Tektronix, Inc." "Teradyne" "Transmagnetics, Inc." "TTI Testron, Inc." "Virginia Panel, Corp." "VXI Technology, Inc." "VXIbus Associates, Inc." ...
            "Wavetek Corp." "Wandal & Goltermann" "Unknown" "Yokogawa Electric Corporation"];

        driverMap = containers.Map(vendorInitials, vendorFullName);
        % Get the first 2 characters of the driver name to create the driver
        % initials
        driverInitial = upper(extractBefore(driverName, 3));

        if isKey(driverMap, driverInitial)
            manufacturer = driverMap(driverInitial);
        else
            manufacturer = "Unknown";
        end
    end

end

% -------------------------------------------------------------------
% Called by: instrhwinfo('ivi', 'logicalName')
function out = localGetIVIDriverInfo(logicalName)

% Initialize variables.
out = [];

% Determine if IVI is installed.
rootPath = privateGetIviPath;

if isempty(rootPath)
    % IVI is not installed.
    newExc = MException('instrument:instrhwinfo:IVIInstall', 'The IVI Configuration Server could not be accessed or is not installed.');
    throwAsCaller(newExc);
end

% Initialize the output structure.
out.DriverSession             = '';
out.HardwareAsset             = '';
out.SoftwareModule            = '';
out.IOResourceDescriptor      = '';
out.SupportedInstrumentModels = '';
out.ModuleDescription         = '';
out.ModuleLocation            = '';

% Create the store.
store = iviconfigurationstore;

% Find the information for the specified logical name.
lnInfo = get(store, 'LogicalName');
info = localFindIVIInfo(lnInfo, logicalName);

% The specified logical name could not be found.
if isempty(info)
    newExc = MException('instrument:instrhwinfo:invalidLogicalName', 'Invalid logical name specified. Type ''instrhwinfo(''ivi'')'' for a list of valid logical names.');
    throwAsCaller(newExc);
end

% If no driver session is specified for this logical name, return.
out.DriverSession = info.Session;
if isempty(out.DriverSession)
    return;
end

% Find the information about the driver session.
dsInfo = get(store, 'DriverSession');
info = localFindIVIInfo(dsInfo, out.DriverSession);

% Get the software module and hardware asset used by driver session.
out.SoftwareModule = info.SoftwareModule;
out.HardwareAsset  = info.HardwareAsset;

% Fill in the hardware asset information.
if ~isempty(out.HardwareAsset)
    haInfo = get(store, 'HardwareAsset');
    info = localFindIVIInfo(haInfo, out.HardwareAsset);

    if ~isempty(info)
        out.IOResourceDescriptor = info.IOResourceDescriptor;
    end
end

% Fill in the software module fields.
if ~isempty(out.SoftwareModule)
    smInfo = get(store, 'SoftwareModule');
    info = localFindIVIInfo(smInfo, out.SoftwareModule);

    if ~isempty(info)
        out.SupportedInstrumentModels = info.SupportedInstrumentModels;
        out.ModuleDescription         = info.Description;
        out.ModuleLocation            = info.ModulePath;
    end
end
end

%------------------------------------------------------------------------
% Checks to see if the 'adaptortoFind' exists in 'installedAdaptors'. If
% yes, adds the 'adaptorToAdd' to the list of installed adaptors
% 'installedAdaptors', sorts the list and returns it.
function installedAdaptors = updateInstalledAdaptors(installedAdaptors, adaptorToFind ,adaptorToAdd)

adaptorFound = strcmpi(installedAdaptors, adaptorToFind);
if any(adaptorFound)
    installedAdaptors{end+1} = adaptorToAdd;
end
installedAdaptors = sortrows(installedAdaptors);
end

% -----------------------------------------------------------------------
function out = localFindIVIInfo(allInfo, value)

% Initialize variables.
out   = [];
found = false;

% Search for the value.
for i=1:length(allInfo)
    if strcmpi(allInfo(i).Name, value)
        found = true;
        break;
    end
end

% The value was not found. Return empty.
if (found == false)
    return;
end

% Extract the value.
out = allInfo(i);
end

% Combining instrhwinfo('Bluetooth') and instrfind
function tempOut = bluetoothCombinedDevices(tempOut)

instrF = instrfind;
sizeInstrF = size(instrF, 2);
if(sizeInstrF ~= 0)
    flag = false;
    jloop = 1;
    for iloop = 1 : sizeInstrF

        % Look for devices in instrfind of type
        % "Bluetooth" which are "open"
        if(strcmpi(instrF(iloop).Type,'bluetooth') && strcmpi(instrF(iloop).Status,'open'))

            % Capture these BT names and IDs
            instrFBTRemote{jloop,1} = instrF(iloop).RemoteName; %#ok<*AGROW>
            instrFBTRemote{jloop,2} = ['btspp://', instrF(iloop).RemoteID];
            jloop = jloop + 1;
            flag = true;
        end
    end

    % if instrfind "BT" "open" returns a value
    if(flag)
        allBTName = tempOut{1};
        allBTID = tempOut{2};
        for iloop = 1 : (jloop-1)

            % Combine intrhwinfo BT and instrfind results
            allBTName = [allBTName; instrFBTRemote{iloop,1}];
            allBTID = [allBTID; instrFBTRemote{iloop,2}];
        end

        % Find unique remote names and IDs to prevent
        % duplicate remote IDs
        [uniqueBTID, uniqueRowOrder, ~] = unique(allBTID);
        uniqueBTName = allBTName(uniqueRowOrder);
        tempOut{1} = uniqueBTName;
        tempOut{2} = uniqueBTID;
    end
end
end