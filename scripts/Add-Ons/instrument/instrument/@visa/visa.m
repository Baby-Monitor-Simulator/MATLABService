classdef visa < icinterface & instrument.internal.ICTRemoveFunctionalityHelper
    %VISA Construct VISA object.
    %
    %   VISA will be removed in a future release. Use visadev instead.
    %
    %   OBJ = VISA('VENDOR', 'RSRCNAME') constructs a VISA object, OBJ, of type
    %   RSRCNAME. The possible VENDORs are:
    %
    %       VENDOR         Description
    %       ======         ===========
    %       keysight       Keysight Technologies VISA.
    %       ni             National Instruments VISA.
    %       tek            Tektronix VISA.
    %       rs             Rohde & Schwarz VISA.
    %
    %   RSRCNAME is a symbolic name for the instrument with the following
    %   format (values in brackets [] are optional):
    %
    %       Interface      RSRCNAME
    %       =========      ========
    %       GPIB           GPIB[board]::primary_address[::secondary_address]::INSTR
    %       VXI            VXI[chassis]::VXI_logical_address::INSTR
    %       PXI            PXI[bus_number]::device_number::INSTR
    %       GPIB-VXI       GPIB-VXI[chassis]::VXI_logical_address::INSTR
    %       Serial         ASRL[port_number]::INSTR
    %       TCPIP          TCPIP[board]::remote_host[::lan_device_name]::INSTR
    %       USB            USB[board]::manid::model_code::serial_No[::interface_No]::INSTR
    %       RSIB           RSIB::remote_host::INSTR  (provided by NI VISA only).
    %
    %   The following describes the parameters given above:
    %
    %       Parameter            Description
    %       =========            ===========
    %       board                Board index (optional - defaults to 0).
    %       bus_number           PCI bus number of the PXI instrument
    %       chassis              Chassis index (optional - defaults to 0).
    %       device_number        Device number of the PXI instrument
    %       interface_No         USB interface.
    %       lan_device_name      Local Area Network (LAN) device name
    %                            (optional - defaults to inst0).
    %       manid                Manufacturer ID of the USB instrument.
    %       model_code           Model code for the USB instrument.
    %       port_number          Com port number (optional - defaults to 1).
    %       primary_address      Primary address of the GPIB device.
    %       remote_host          Host name or IP address of the instrument.
    %       secondary_address    Secondary address of the GPIB device
    %                            (optional - if not specified, none is assumed).
    %       serial_No            Index of the instrument on the USB hub.
    %       VXI_logical_address  Logical address of the VXI instrument.
    %
    %   OBJ's RsrcName property is updated to reflect the RSRCNAME with default
    %   values specified where appropriate.
    %
    %   RSRCNAME can be the VISA alias for the instrument.
    %
    %   In order to communicate with the instrument, the VISA object must be
    %   connected to the instrument with the FOPEN function.
    %
    %   When the VISA object is constructed, the object's Status property
    %   is closed. Once the object is connected to the instrument with the
    %   FOPEN function, the Status property is configured to open. Only one
    %   VISA object can be connected to the same instrument at a time.
    %
    %   OBJ = VISA('VENDOR','RSRCNAME','P1',V1,'P2',V2,...) constructs a
    %   VISA object, OBJ, of type RSRCNAME and with the specified property
    %   values. If an invalid property name or property value is specified
    %   OBJ will not be created.
    %
    %   Note that the param-value pairs can be in any format supported by
    %   the SET function, i.e., param-value string pairs, structures, and
    %   param-value cell array pairs.
    %
    %   At any time you can view a complete listing of VISA functions and
    %   properties with the INSTRHELP function, i.e., instrhelp visa.
    %
    % VISA Functions
    % VISA object construction.
    %   visa           - Construct VISA object.
    %
    % Getting and setting parameters.
    %   get            - Get value of instrument object property.
    %   set            - Set value of instrument object property.
    %
    % State change.
    %   fopen          - Connect object to instrument.
    %   fclose         - Disconnect object from instrument.
    %   record         - Record data from instrument control session.
    %
    % Read and write functions.
    %   binblockread   - Read binblock from instrument.
    %   binblockwrite  - Write binblock to instrument.
    %   fprintf        - Write text to instrument.
    %   fgetl          - Read one line of text from instrument, discard terminator.
    %   fgets          - Read one line of text from instrument, keep terminator.
    %   fread          - Read binary data from instrument.
    %   fscanf         - Read data from instrument and format as text.
    %   fwrite         - Write binary data to instrument.
    %   query          - Write and read formatted data from instrument.
    %   readasync      - Read data asynchronously from instrument.
    %   scanstr        - Parse formatted data from instrument.
    %
    % VISA-GPIB functions.
    %   clrdevice      - Clear instrument buffer.
    %   trigger        - Send Group Execute Trigger message to instrument.
    %
    % VISA-GPIB-VXI functions.
    %   clrdevice      - Clear instrument buffer.
    %   memmap         - Map memory for low-level memory read and write.
    %   mempeek        - Low-level memory read from VXI register.
    %   mempoke        - Low-level memory write to VXI register.
    %   memread        - High-level memory read from VXI register.
    %   memunmap       - Unmap memory for low-level memory read and write.
    %   memwrite       - High-level memory write to VXI register.
    %
    % VISA-VXI functions.
    %   clrdevice      - Clear instrument buffer.
    %   memmap         - Map memory for low-level memory read and write.
    %   mempeek        - Low-level memory read from VXI register.
    %   mempoke        - Low-level memory write to VXI register.
    %   memread        - High-level memory read from VXI register.
    %   memunmap       - Unmap memory for low-level memory read and write.
    %   memwrite       - High-level memory write to VXI register.
    %   trigger        - Send a software or hardware trigger to VXI hardware.
    %
    % VISA-USB functions.
    %   clrdevice      - Clear instrument buffer.
    %   trigger        - Send Group Execute Trigger message to instrument.
    %
    % VISA-RSIB functions.
    %   clrdevice      - Clear instrument buffer.
    %   trigger        - Send Group Execute Trigger message to instrument.
    %
    % General.
    %   delete         - Remove instrument object from memory.
    %   flushinput     - Remove data from input buffer.
    %   flushoutput    - Remove data from output buffer.
    %   inspect        - Open inspector and inspect instrument object properties.
    %   instrcallback  - Display event information for the event.
    %   instrfind      - Find instrument objects with specified property values.
    %   instrfindall   - Find all instrument objects regardless of ObjectVisibility.
    %   instrid        - Define and retrieve commands used to identify instruments.
    %   instrnotify    - Define notification for instrument events.
    %   instrreset     - Disconnect and delete all instrument objects.
    %   isvalid        - True for instrument objects that can be connected to
    %                    instrument.
    %   obj2mfile      - Convert instrument object to MATLAB code.
    %   stopasync      - Stop asynchronous read and write operation.
    %
    % Information and Help.
    %   propinfo       - Return instrument object property information.
    %   instrhelp      - Display instrument object function and property help.
    %   instrhwinfo    - Return information on available hardware.
    %
    % Instrument Control tools.
    %   tmtool         - Tool for browsing available instruments, configuring
    %                    instrument communication and and communicating with
    %                    instrument.
    %
    % VISA Properties
    %   Alias                     - Alias for the RsrcName.
    %   ByteOrder                 - Byte order of the instrument.
    %   BytesAvailable            - Specifies number of bytes available to be read.
    %   BytesAvailableFcn         - Callback function executed when specified number
    %                               of bytes are available.
    %   BytesAvailableFcnCount    - Number of bytes to be available before
    %                               executing BytesAvailableFcn.
    %   BytesAvailableFcnMode     - Specifies whether the BytesAvailableFcn is
    %                               based on the number of bytes or terminator
    %                               being reached.
    %   BytesToOutput             - Number of bytes currently waiting to be sent.
    %   ErrorFcn                  - Callback function executed when an error occurs.
    %   InputBufferSize           - Total size of the input buffer.
    %   Name                      - Descriptive name of the serial object.
    %   ObjectVisibility          - Control access to an object by command-line users and
    %                               GUIs.
    %   OutputBufferSize          - Total size of the output buffer.
    %   OutputEmptyFcn            - Callback function executed when output buffer is
    %                               empty.
    %   RecordDetail              - Amount of information recorded to disk.
    %   RecordMode                - Specify whether data is saved to one disk file
    %                               or to multiple disk files.
    %   RecordName                - Name of disk file to which data sent and
    %                               received is recorded.
    %   RecordStatus              - Indicates if data is being written to disk.
    %   RsrcName                  - Resource name.
    %   Status                    - Indicates if the serial object is connected to
    %                               serial port.
    %   Tag                       - Label for object.
    %   Timeout                   - Seconds to wait to receive data.
    %   TimerFcn                  - Callback function executed when a timer event
    %                               occurs.
    %   TimerPeriod               - Time in seconds between timer events.
    %   TransferStatus            - Indicate the asynchronous read or write
    %                               operations that are in progress.
    %   Type                      - Object type.
    %   UserData                  - User data for object.
    %   ValuesReceived            - Number of values read from the instrument.
    %   ValuesSent                - Number of values written to instrument.
    %
    %
    % VISA-Serial properties
    %   BaudRate                  - Specify rate at which data bits are transmitted.
    %   DataBits                  - Number of data bits that are transmitted.
    %   DataTerminalReady         - State of the DataTerminalReady pin.
    %   FlowControl               - Specify the data flow control method to use.
    %   Parity                    - Error detection mechanism.
    %   PinStatus                 - State of hardware pins.
    %   Port                      - Description of a hardware port.
    %   ReadAsyncMode             - Specify whether an asynchronous read operation
    %                               is continuous or manual.
    %   RequestToSend             - State of the RequestToSend pin.
    %   StopBits                  - Number of bits transmitted to indicate the end
    %                               of data transmission.
    %   Terminator                - Character used to terminate commands sent to
    %                               serial port.
    %
    % VISA-GPIB properties
    %   BoardIndex                - Index of the access board for the object.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   PrimaryAddress            - GPIB primary address.
    %   SecondaryAddress          - GPIB secondary address.
    %
    % VISA-GPIB-VXI properties
    %   BoardIndex                - Board number of the GPIB board to which the GPIB
    %	                            VXI is attached.
    %   ChassisIndex              - Chassis index.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   LogicalAddress            - Logical address of the VXI instrument.
    %   MappedMemoryBase          - Base address of mapped memory.
    %   MappedMemorySize          - Size of mapped memory for low level memory functions.
    %   MemoryBase                - Base address of the instrument in A24 or A32.
    %   MemoryIncrement           - Specifies whether the memory registers are read as
    %                               a block or FIFO.
    %   MemorySize                - Size of the memory in A24 or A32 space.
    %   MemorySpace               - Address space used by the instrument.
    %   PrimaryAddress            - Primary address of the GPIB-VXI controller.
    %   SecondaryAddress          - Secondary address of the GPIB-VXI controller.
    %   Slot                      - Slot location of the VXI instrument.
    %
    % VISA-VXI properties
    %   ChassisIndex              - Chassis index.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   InterruptFcn              - Callback function executed when a VXI bus signal or
    %                               VXI bus interrupt is received.
    %   LogicalAddress            - Logical address of the VXI instrument.
    %   MappedMemoryBase          - Base address of mapped memory.
    %   MappedMemorySize          - Size of mapped memory for low level memory functions.
    %   MemoryBase                - Base address of the instrument in A24 or A32.
    %   MemoryIncrement           - Specifies whether the memory registers are read as
    %                               a block or FIFO.
    %   MemorySize                - Size of the memory in A24 or A32 space.
    %   MemorySpace               - Address space used by the instrument.
    %   Slot                      - Slot location of the VXI instrument.
    %   TriggerFcn                - Callback function executed when a hardware trigger
    %                               is received.
    %   TriggerLine               - VXI trigger line.
    %   TriggerType               - VXI trigger type.
    %
    % VISA-TCPIP properties
    %   BoardIndex                - Index number of the network board associated with
    %                               the instrument.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   LANName                   - Specifies the LAN (Local Area Network) device name.
    %   RemoteHost                - Specifies the host name or IP dotted decimal address.
    %
    % VISA-USB properties
    %   BoardIndex                - Index number of the USB board associated with
    %                               the instrument.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   InterfaceIndex            - Specifies the USB interface number.
    %   ManufacturerID            - Specifies the manufacturer ID of the USB instrument.
    %   ModelCode                 - Specifies the model code of the USB instrument.
    %   SerialNumber              - Specifies the index of the USB instrument on the
    %                               USB hub.
    %
    % VISA-RSIB properties
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   RemoteHost                - Specifies the local host name or IP dotted decimal
    %                               address.
    %   Example:
    %       % To construct a VISA-GPIB object connected to Board 4 with an
    %       % instrument with primary address 1 and no secondary address.
    %         g = visa('ni', 'GPIB4::1::0::INSTR');
    %
    %       % To construct a VISA-VXI object that communicates with a VXI
    %       % instrument located at logical address 8 in the first VXI system.
    %         v = visa('keysight', 'VXI0::8::INSTR');
    %
    %       % To construct a VISA-serial object that is connected to COM2.
    %         s = visa('tek', 'ASRL2::INSTR');
    %
    %       % To connect the VISA-GPIB object to the instrument:
    %         fopen(g)
    %
    %       % To query the instrument.
    %         fprintf(g, '*IDN?');
    %         idn = fscanf(g);
    %
    %       % To disconnect the VISA-GPIB object from the instrument.
    %         fclose(g);
    %
    %   See also VISADEV, VISADEVLIST, ICINTERFACE/FOPEN, INSTRUMENT/PROPINFO, INSTRHELP.
    %
    
    %   Copyright 1999-2021 The MathWorks, Inc.
    
    
    properties(Hidden, SetAccess = 'public', GetAccess = 'public')
        icinterface
    end
    
    methods
        function obj = visa(vendor, name, varargin)

            % Create the class that will throw a warning and error as part of the
            % legacy interface remove functionality "Warn" phase and "Error" phases.
            obj = obj@instrument.internal.ICTRemoveFunctionalityHelper("visa");

            obj = obj@icinterface('visa');
            
            % Create the parent class.
            try
                obj.icinterface = icinterface('visa'); %#ok<*PROP>
            catch
                error(message('instrument:visa:nojvm'));
            end
            switch (nargin)
                case 0
                    error(message('instrument:visa:invalidSyntaxVendor'));
                case 1
                    % convert to char in order to accept string datatype
                    vendor = instrument.internal.stringConversionHelpers.str2char(vendor);
                    
                    if strcmp(class(vendor), 'visa')
                        obj = vendor;
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.SerialVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.GpibVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.VxiVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.PxiVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.VxiGpibVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.TcpipVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.UsbVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.RsibVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'com.mathworks.toolbox.instrument.GenericVisa')
                        obj.jobject = handle(vendor);
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.SerialVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.GpibVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.PxiVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.VxiVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.VxiGpibVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.TcpipVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.UsbVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.RsibVisa')
                        obj.jobject = vendor;
                    elseif isa(vendor, 'javahandle.com.mathworks.toolbox.instrument.GenericVisa')
                        obj.jobject = vendor;
                    elseif ishandle(vendor)
                        % True if loading an array of objects and the first is a VISA object.
                        if contains(class(vendor(1)), 'com.mathworks.toolbox.instrument.')
                            obj.jobject = vendor;
                        else
                            error(message('instrument:visa:invalidSyntaxName'));
                        end
                    else
                        error(message('instrument:visa:invalidSyntaxName'));
                    end
                    
                    
                    if isvalid(obj)
                        % Pass the OOPs object to java. Used for callbacks.
                        obj.jobject(1).setMATLABObject(obj);
                    end
                    return;
                otherwise
                    
                    % Check and retrieve the older name for the adaptor, if it exists.
                    vendor = instrgate('getInternalVendorName',vendor);
                    
                    % convert to char in order to accept string datatype
                    vendor = instrument.internal.stringConversionHelpers.str2char(vendor);
                    name = instrument.internal.stringConversionHelpers.str2char(name);
                    varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
                    
                    % Error checking.
                    if ~ischar(vendor)
                        error(message('instrument:visa:invalidVENDORstring'));
                    end
                    if isempty(vendor)
                        error(message('instrument:visa:invalidVENDORempty'));
                    end
                    if ~ischar(name)
                        error(message('instrument:visa:invalidRSRCNAMEstring'));
                    end
                    if isempty(name)
                        error(message('instrument:visa:invalidRSRCNAMEempty'));
                    end
                    
                    % Ex. v = visa('ni', 'ASRL1::INSTR');
                    % Ex. v = visa('keysight', 'GPIB0::1::97::INSTR', 'Tag', 'visa-gpib');
                    
                    % Determine the path to the dll. If the path is given use it otherwise try
                    % to find the associated MathWorks adaptor.
                    [pathToDll, vendor, ext] = fileparts(vendor);
                    if isempty(pathToDll)
                        
                        % The adaptor is a MathWorks adaptor - verify that it exists.
                        pathToDll = localFindAdaptor(vendor, ext);
                    end
                    
                    [pathToDll, temp, ext] = fileparts(pathToDll);
                    vendor = [temp ext];
                    
                    % Parse the input name and determine which type of object is being
                    % created.
                    [type, name, alias, errflag, errType] = localParseName(name, pathToDll, vendor);
                    if (errflag == true)
                        if (errType == 0)
                            error(message('instrument:visa:invalidRSRCNAMESpecified'))
                        else
                            error(message('instrument:visa:invalidVENDOR'));
                        end
                    end
                    
                    % Call the java constructor and store the java object in the
                    % jobject field.
                    switch (type)
                        case 'serial'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.SerialVisa(pathToDll,vendor,name,alias));
                            catch %#ok<*CTCH>
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'gpib'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.GpibVisa(pathToDll, vendor,name,alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'pxi'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.PxiVisa(pathToDll, vendor, name, alias));
                            catch %#ok<CTCH>
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'vxi'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.VxiVisa(pathToDll, vendor, name, alias));
                            catch %#ok<CTCH>
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'gpib-vxi'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.VxiGpibVisa(pathToDll, vendor, name, alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'tcpip'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.TcpipVisa(pathToDll, vendor, name, alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'usb'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.UsbVisa(pathToDll, vendor, name, alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'rsib'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.RsibVisa(pathToDll, vendor, name, alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                        case 'generic'
                            try
                                obj.jobject = handle(com.mathworks.toolbox.instrument.GenericVisa(pathToDll, vendor, name, alias));
                            catch
                                error(message('instrument:visa:invalidRSRCNAME'));
                            end
                    end
                    
                    % Set the specified property-value pairs.
                    if nargin > 2
                        try
                            set(obj, varargin{:});
                        catch aException
                            delete(obj);
                            localFixError(aException);
                        end
                    end
            end
            
            % Set the doc ID for the interface object. This sets values for
            % DocIDNoData and DocIDSomeData
            obj = obj.setDocID('visa', obj.jobject.Type);
            
            setMATLABClassName( obj.jobject(1),obj.constructor);
            if isvalid(obj)
                % Pass the OOPs object to java. Used for callbacks.
                obj.jobject(1).setMATLABObject(obj);
            end
            
        end
    end
    
    % Separate Files
    methods(Static = true, Hidden = true)
        obj = loadobj(B)
    end
end

function [type, rsrcName, alias, errflag, errType] = localParseName(name, pathToDll,vendor)

% Initialize variables.
type     = '';
rsrcName = '';
alias    = '';
errflag  = false;
errType  = 0;

% Determine the resource name from the specified resource name. This will
% allow users to use an alias for their resource name.
try
    tempobj = com.mathworks.toolbox.instrument.SerialVisa(pathToDll,vendor,'ASRL1::INSTR','');
    info = getAliasInfo(tempobj, name);
    if ~isempty(info)
        info = cell(info);
    end
    tempobj.dispose;
catch
    errflag = true;
    errType = 1;
    return;
end

% If there is no information returned, then it is an invalid resource
% name/alias. If the first element is not an INSTR, error.
if isempty(info)
    errflag = true;
    return;
end

% Otherwise the alias/resource name was mapped to a resource name.
rsrcName = info{2};
alias    = info{3};

% Determine the type of object to create.
if strncmpi('ASRL', rsrcName, 4)
    % ASRL1::INSTR
    type = 'serial';
elseif strncmpi('GPIB-VXI', rsrcName, 8)
    % GPIB-VXI0::7::INSTR.
    type = 'gpib-vxi';
elseif strncmpi('GPIB', rsrcName, 4)
    % GPIB0::1::97::INSTR
    type = 'gpib';
elseif strncmpi('RSIB', rsrcName, 4)
    %RSIB::ipaddress::INSTR
    type = 'rsib';
elseif strncmpi('PXI', rsrcName, 3)
    % PXI0::1::INSTR
    type = 'pxi';
elseif strncmpi('VXI', rsrcName, 3)
    % VXI0::1::INSTR
    type = 'vxi';
elseif strncmpi('TCPIP', rsrcName, 5) && contains(rsrcName,'INSTR')
    % TCPIP::123.34.16.210::INSTR
    type = 'tcpip';
elseif strncmpi('USB',rsrcName, 3) && contains(rsrcName,'INSTR')
    % USB::0x1234::125::A22-5::INSTR
    type = 'usb';
else
    type = 'generic';
end

end

% *******************************************************************
% Fix the error message.
function localFixError (exception)

% Initialize variables.
id = exception.identifier;
errmsg = exception.message;

% Remove the trailing carriage returns from errmsg.
while errmsg(end) == newline
    errmsg = errmsg(1:end-1);
end

newExc = MException(id, errmsg);
throwAsCaller(newExc);

end

% *******************************************************************
% Find the adaptor that is being loaded. The path was not specified.
function adaptorPath = localFindAdaptor(adaptorName, adaptorExt)

% Initialize variables.
adaptorPath = ''; %#ok<NASGU>

% Define the toolbox root location.
instrRoot = which('instrgate', '-all');

% From the adaptorName construct the adaptor filename.
if isempty(adaptorExt)
    adaptorName = lower(['mw' adaptorName 'visa']);
end

dirname = instrgate('privatePlatformProperty', 'dirname');
extension = instrgate('privatePlatformProperty', 'libext');

if (isempty(dirname) || isempty(extension))
    newExc = MException('instrument:visa:unsupportedPlatform', ['The VISA adaptor on the ' computer ' platform is not supported.']);
    throwAsCaller(newExc);
end

% Define the adaptor directory location.
instrRoot = [fileparts(instrRoot{1}) 'adaptors'];
adaptorRoot = fullfile(instrRoot, dirname, [adaptorName extension]);

% Determine if the adaptor exists.
if exist(adaptorRoot,'file')
    adaptorPath = adaptorRoot;
else
    newExc = MException('instrument:visa:adaptorNotFound','The specified VENDOR adaptor could not be found.');
    throwAsCaller(newExc);
end
end

