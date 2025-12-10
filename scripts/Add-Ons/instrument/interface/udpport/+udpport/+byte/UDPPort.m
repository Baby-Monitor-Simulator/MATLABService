classdef (Sealed) UDPPort < matlabshared.testmeas.internal.SetGet & ...
                            matlabshared.testmeas.CustomDisplay & ...
                            matlabshared.transportlib.internal.compatibility.LegacyUDPByte & ...
                            udpport.UDPPortBase
    % UDPPORT class creates and returns the byte type UDPPort object.
    %
    %   u = UDPPORT.BYTE.UDPPORT(IPADDRESSVERSION) constructs a udpport
    %   byte object, u, with the specified IPADDRESSVERSION. The allowed
    %   values for IPADDRESSVERSION are "IPV4" and "IPV6".
    %
    %   u = UDPPORT.BYTE.UDPPORT(IPADDRESSVERSION, "NAME","VALUE", ...)
    %   constructs a udpport byte object, u, with the specified
    %   IPADDRESSVERSION, and one or more name-value pair arguments. The
    %   allowed values for IPADDRESSVERSION are "IPV4" and "IPV6". If an
    %   invalid property name or property value is specified the object
    %   will not be created. udpport properties that can be set using
    %   name-value pair arguments are LocalHost, LocalPort, Timeout, Tag,
    %   ByteOrder, OutputDatagramSize, and EnablePortSharing. See
    %   properties help for accepted values.
    %
    %   udpport methods:
    %
    %   READ METHODS
    %   <a href="matlab:help udpport.byte.UDPPort.read">read</a>                - Read data from the udpport socket
    %   <a href="matlab:help udpport.byte.UDPPort.readline">readline</a>            - Read ASCII-terminated string data from the udpport socket
    %
    %   WRITE METHODS
    %   <a href="matlab:help udpport.byte.UDPPort.write">write</a>               - Write data to the udpport socket
    %   <a href="matlab:help udpport.byte.UDPPort.writeline">writeline</a>           - Write ASCII-terminated string data to the udpport socket
    %
    %   OTHER METHODS
    %   <a href="matlab:help udpport.byte.UDPPort.configureCallback">configureCallback</a>   - Set the bytes available callback properties
    %   <a href="matlab:help udpport.byte.UDPPort.configureTerminator">configureTerminator</a> - Set the read and write terminator properties
    %   <a href="matlab:help udpport.byte.UDPPort.configureMulticast">configureMulticast</a>  - Set multicast properties for the udpport socket
    %   <a href="matlab:help udpport.byte.UDPPort.flush">flush</a>               - Clear the input and/or output buffers of the udpport socket
    %
    %   udpport properties:
    %
    %   <a href="matlab:help udpport.byte.UDPPort.IPAddressVersion">IPAddressVersion</a>        - The version type for the IP Address
    %   <a href="matlab:help udpport.byte.UDPPort.LocalHost">LocalHost</a>               - The local hostname or the IP dotted-decimal address
    %   <a href="matlab:help udpport.byte.UDPPort.LocalPort">LocalPort</a>               - The port value of the localhost for binding
    %   <a href="matlab:help udpport.byte.UDPPort.ByteOrder">ByteOrder</a>               - Sequential order in which bytes are arranged into larger numerical values
    %   <a href="matlab:help udpport.byte.UDPPort.Timeout">Timeout</a>                 - Timeout period in seconds for read and write operations
    %   <a href="matlab:help udpport.byte.UDPPort.OutputDatagramSize">OutputDatagramSize</a>      - The maximum number of bytes of data to be written in a Datagram packet
    %   <a href="matlab:help udpport.byte.UDPPort.EnablePortSharing">EnablePortSharing</a>       - Allow other UDP sockets to also bind to this socket's local port
    %   <a href="matlab:help udpport.byte.UDPPort.EnableBroadcast">EnableBroadcast</a>         - Flag to set broadcasting on or off
    %   <a href="matlab:help udpport.byte.UDPPort.EnableMulticast">EnableMulticast</a>         - Flag to indicate Multicast off or on
    %   <a href="matlab:help udpport.byte.UDPPort.MulticastGroup">MulticastGroup</a>          - The IP Address group to subscribe to get multicast data
    %   <a href="matlab:help udpport.byte.UDPPort.EnableMulticastLoopback">EnableMulticastLoopback</a> - Flag to indicate looping back of data in udpport
    %                             Multicast off or on, if the sender is subscribed to the same MulticastGroup.
    %   <a href="matlab:help
    %   matlabshared.transportlib.internal.TagAccessor.Tag">Tag</a>                     - Unique identifier name for the udpport object
    %   <a href="matlab:help udpport.byte.UDPPort.NumBytesAvailable">NumBytesAvailable</a>       - Number of bytes available to be read
    %   <a href="matlab:help udpport.byte.UDPPort.NumBytesWritten">NumBytesWritten</a>         - Number of bytes written to the udpport socket
    %   <a href="matlab:help udpport.byte.UDPPort.Terminator">Terminator</a>              - Read and write terminator for the ASCII-terminated string communication
    %   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcn">BytesAvailableFcn</a>       - Function handle to be called when a Bytes Available event occurs
    %   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnCount">BytesAvailableFcnCount</a>  - Number of bytes in the input buffer that triggers a Bytes Available event
    %                             (Only applicable for BytesAvailableFcnMode = "byte")
    %   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnMode">BytesAvailableFcnMode</a>   - Condition for firing BytesAvailableFcn callback
    %   <a href="matlab:help udpport.byte.UDPPort.ErrorOccurredFcn">ErrorOccurredFcn</a>        - Function handle to be called when an error event occurs
    %   <a href="matlab:help udpport.byte.UDPPort.UserData">UserData</a>                - Application specific data for the udpport instance
    %
    %   Examples:
    %
    %       % Construct a udpport byte object.
    %       u = udpport.byte.UDPPort("IPV4")
    %
    %       % Write 1, 2, 3, 4, 5 as "uint8" data to the destination address
    %       % "125.5.1.20" and destination port 4000.
    %       write(u,1:5,"uint8","125.5.1.20",4000);
    %
    %       % Read 10 numbers of "uint16" data from the udpport socket.
    %       data = read(u,10,"uint16");
    %
    %       % Set the Terminator property
    %       configureTerminator(u,"CR/LF");
    %
    %       % Write "hello" to the udpport socket with the Terminator
    %       % included, to the destination address "125.5.1.20" and
    %       % destination port 4000. 
    %       writeline(u,"hello","125.5.1.20",4000);
    %
    %       % Read ASCII-terminated string from the udpport socket.
    %       data = readline(u);
    %
    %       % Subscribe to the multicast address group 226.0.0.1
    %       configureMulticast(u,"226.0.0.1");
    %
    %       % Set the Bytes Available Callback properties
    %       configureCallback(u,"byte",50,@myCallbackFcn);
    %
    %       % Flush output buffer
    %       flush(u,"output");
    %
    %       % Disconnect and clear udpport connection
    %       clear u

    %   Copyright 2020-2023 The MathWorks, Inc.

    %% Common UDP Properties
    properties (Dependent)

        % Timeout - Specifies the waiting time (in seconds) to complete
        %   read and write operations.
        % Read/Write Access - Both
        % Accepted Values - Positive numeric values
        % Default - 10
        Timeout

        % ByteOrder - Specifies the sequential order in which bytes are
        %   arranged into larger numerical values.
        % Read/Write Access - Both
        % Accepted Values - "little-endian", "big-endian" (char and string)
        % Default - "little-endian"
        ByteOrder

        % OutputDatagramSize - The maximum number of bytes to be
        %   written in a Datagram packet. If more data is to be written in
        %   a single write, the data will be broken into multiple
        %   packets, based on the OutputDatagramSize value. 
        % Read/Write Access - Both
        % Accepted Values - Positive integer values from 1 to 65507
        % Default - 512
        OutputDatagramSize

        % EnableBroadcast - Indicates whether udpport broadcasting is on or
        %   off.
        % Read/Write Access - Both
        % Accepted Values - true, false
        % Default - false
        EnableBroadcast

        % EnableMulticast - Indicates whether udpport multicast is on or
        %   off.
        % Read/Write Access - Read-only
        % Accepted Values - true, false
        % Default - false
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureMulticast">configureMulticast</a> function.
        EnableMulticast

        % EnableMulticastLoopback - Indicates whether the udpport instance
        %   receives the data that it sends to the multicast group, given 
        %   that it is subscribed to the same multicast group. If false, 
        %   the udpport instance does not receive the data that it writes
        %   to the multicast group. If true, the sender receives the data 
        %   that it writes to the multicast group.
        % Read/Write Access - Read-only
        % Accepted Values - true, false
        % Default - false
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureMulticast">configureMulticast</a> function.
        EnableMulticastLoopback

        % MulticastGroup - The IP Address group to which the udpport 
        %   instance is subscribed to get multicast data.
        % Read/Write Access - Read-only
        % Accepted Values - "224.0.0.0" to "239.255.255.255" for
        %   IPAddressVersion "IPV4", addresses starting with "ff00"
        %   (ff00::/8) for IPAddressVersion "IPV6"
        % Default - ""
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureMulticast">configureMulticast</a> function.
        MulticastGroup

        % EnablePortSharing - Indicates whether other udpport sockets can
        %   bind to this udpport socket's local port.
        % Read/Write Access - Read-only. It can be set only during object 
        %   creation using name-value pair arguments in the udpport 
        %   constructor.
        % Accepted Values - true, false
        % Default - false
        EnablePortSharing

        % IPAddressVersion - The version type for the IP Address.
        % Read/Write Access - Read-only. It can be set only during object 
        %   creation using the udpport constructor.
        % Accepted Values - "IPV4", "IPV6" (char and string)
        % Default - "IPV4"
        IPAddressVersion

        % LocalHost - The local hostname or the IP dotted-decimal address.
        % Read/Write Access - Read-only. It can be set only during object 
        %   creation using name-value pair arguments in the udpport 
        %   constructor.
        % Accepted Values - string or char values
        % Default - "0.0.0.0" for IPAddressVersion "IPV4", "::" for
        %   IPAddressVersion "IPV6"
        LocalHost

        % LocalPort - The port value of the localhost for binding.
        % Read/Write Access - Read-only. It can be set only during object 
        %   creation using name-value pair arguments in the udpport 
        %   constructor.
        % Accepted Values - Integer values from 0 to 65535
        % Default - Assigned by the operating system.
        LocalPort

        % ErrorOccurredFcn - The function that gets called when an error
        %   event occurs.
        % Read/Write Access - Both
        % Accepted Values - function_handle
        % Default - []
        ErrorOccurredFcn

        % UserData - Stores application-specific data.
        % Read/Write Access - Both
        % Accepted Values - Any MATLAB type
        % Default - []
        UserData
    end

    %% UDPPort byte-only properties
    properties (Dependent)
        % Terminator - Specifies the read and write terminator for
        %    ASCII-terminated string communication.
        % Read/Write Access - Read-only
        % Accepted Values - Integers ranging from 0 to 255
        %                   "CR", "LF", "CR/LF"
        % Default - "LF"
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureTerminator">configureTerminator</a> function.
        Terminator

        % BytesAvailableFcnCount - Number of bytes in the input buffer 
        %    that triggers BytesAvailableFcn, when BytesAvailableFcnMode is 
        %    set to "byte".
        % Accepted Values - Positive integer values
        % Read/Write Access - Read-only
        % Default - 64
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureCallback">configureCallback</a> function.
        BytesAvailableFcnCount

        % BytesAvailableFcnMode - Turns bytes available callback off or 
        %     specifies the condition for triggering the bytes available
        %     callback:
        %     a. when BytesAvailableFcnCount number of bytes are available 
        %        to be read, or
        %     b. when the terminator is reached
        % Read/Write Access - Read-only
        % Accepted Values - "byte", "terminator", "off"
        % Default - "off"
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureCallback">configureCallback</a> function.
        BytesAvailableFcnMode

        % BytesAvailableFcn - Callback function that gets triggered when a
        %     bytes available event occurs.
        % Read/Write Access - Read-only
        % Accepted Values - function_handle
        % Default - []
        %
        % To set this property, use <a href="matlab:help udpport.byte.UDPPort.configureCallback">configureCallback</a> function.
        BytesAvailableFcn

        % NumBytesAvailable - Number of bytes available to be read.
        % Read/Write Access - Read-only
        NumBytesAvailable

        % NumBytesWritten - Number of bytes written to the udpport socket.
        % Read/Write Access - Read-only
        % Default - 0
        NumBytesWritten
    end

    properties(Access = ?instrument.internal.ITestable, Dependent)
        % Returns connection state of internal transport
        Connected (1, 1) logical
    end

    properties(Access = private)
       % The handle to the udpport custom client instance.
       Client

       % Flag for whether the warning on invoking the save method has been
       % issued.
       SaveWarningIssued (1, 1) logical = false
    end

    %% Custom Display properties
    properties(Access = private, Constant)
       MainProperties = ["IPAddressVersion", "LocalHost", "LocalPort", "Tag", ...
           "NumBytesAvailable"]

       PropertiesSet1 = ["ByteOrder", "Timeout", "Terminator"]

       PropertiesSet2 = ["EnablePortSharing", "EnableBroadcast", "EnableMulticast", ...
           "EnableMulticastLoopback", "MulticastGroup"]

       PropertiesSet3 = ["BytesAvailableFcnMode", "BytesAvailableFcnCount", ...
           "BytesAvailableFcn", "OutputDatagramSize", "NumBytesWritten"]

       PropertiesSet4 = ["ErrorOccurredFcn", "UserData"]
    end

    %% Lifetime
    methods
        function obj = UDPPort(addressType, varargin)
            % Create the client instance
            try
                varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
                obj.Client = udpport.byte.UDPClient(obj.getTransportProperties(addressType));
                obj.IPAddressVersion = addressType;
                initProperties(obj.Client, varargin{:});
                parseNVPairForTag(obj, varargin{:});

                % Set properties necessary for udpport custom display.
                setCustomDisplay(obj);
                connect(obj.Client);
            catch ex
                throwAsCaller(ex);
            end
        end

        function delete(obj)
           obj.Client = [];
        end
    end

    %% API methods
    methods
        function data = read(obj, varargin)
            %READ Read data from the udpport socket.
            %
            %   DATA = READ(OBJ,COUNT) reads the specified number of
            %   values, COUNT, with the precision set to "UINT8", from the
            %   udpport socket, OBJ, and returns to DATA. DATA is
            %   represented as a DOUBLE array in row format.
            %
            %   DATA = READ(OBJ,COUNT,PRECISION) reads the specified number
            %   of values, COUNT, with the precision specified by
            %   PRECISION, from the udpport socket, OBJ, and returns to
            %   DATA. For numeric PRECISION types DATA is represented as a
            %   DOUBLE array in row format. For char and string PRECISION
            %   types, DATA is represented as is.
            %
            % Input Arguments:
            %   COUNT indicates the number of items to read. COUNT cannot
            %   be set to 0, INF, or NAN. If COUNT is greater than the
            %   NumBytesAvailable property of OBJ, then this function waits
            %   until the specified amount of data, COUNT, is read or a
            %   timeout occurs.
            %
            %   PRECISION indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   PRECISION must be one of "UINT8", "INT8", "UINT16",
            %   "INT16", "UINT32", "INT32", "UINT64", "INT64", "SINGLE",
            %   "DOUBLE", "CHAR", or "STRING".
            %
            % Output Arguments:
            %   DATA is a 1xN matrix of numeric or ASCII data. If no data
            %   is returned, this is an empty array.
            %
            % Note:
            %   READ waits until the requested number of values are read
            %   from the udpport socket.
            %
            % Example:
            %      % Read 5 count of data as "uint32" (5*4 = 20 bytes).
            %      data = read(u,5,"uint32");
            try
                data = read(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function write(obj, varargin)
            %WRITE Write data to the udpport socket.
            %
            %   WRITE(OBJ,DATA,PRECISION,DESTINATIONADDRESS,DESTINATIONPORT)
            %   sends the 1xN or Nx1 matrix of DATA to the specified
            %   DESTINATIONADDRESS and DESTINATIONPORT. The data is cast to
            %   the specified PRECISION regardless of the actual precision.
            %
            %   WRITE(OBJ,DATA,DESTINATIONADDRESS,DESTINATIONPORT) sends
            %   the 1xN or Nx1 matrix of DATA to the specified
            %   DESTINATIONADDRESS and DESTINATIONPORT as "UINT8"
            %   precision.
            %
            %   WRITE(OBJ,DATA,PRECISION) sends the 1xN or Nx1 matrix of
            %   DATA to the last used DESTINATIONADDRESS and
            %   DESTINATIONPORT. Error occurs if DESTINATIONADDRESS and
            %   DESTINATIONPORT have not been specified in a previous
            %   WRITE/WRITELINE call for OBJ. The data is cast to the
            %   specified PRECISION regardless of the actual precision.
            %
            %   WRITE(OBJ,DATA) sends the 1xN or Nx1 matrix of DATA to the
            %   last used DESTINATIONADDRESS and DESTINATIONPORT. Error
            %   occurs if DESTINATIONADDRESS and DESTINATIONPORT have not
            %   been specified in a previous WRITE/WRITELINE call for OBJ.
            %   The default PRECISION value is "UINT8".
            %
            % Input Arguments:
            %   DATA is a 1xN or Nx1 matrix of numeric or ASCII data. If
            %   size of DATA is greater than OUTPUTDATAGRAMSIZE property,
            %   the DATA is broken into multiple packets depending on the
            %   size of DATA and the value of OUTPUTDATAGRAMSIZE.
            %
            %   PRECISION specifies the number of bits written for each
            %   value and the interpretation of those bits as integer,
            %   floating-point, or character values. PRECISION must be one
            %   of "CHAR", "STRING", "UINT8", "INT8", "UINT16", "INT16",
            %   "UINT32", "INT32", "UINT64", "INT64", "SINGLE", or
            %   "DOUBLE".
            %
            %   DESTINATIONADDRESS is the remote host to which DATA is
            %   sent. If this value is not set, the packet will be sent to
            %   the last used DESTINATIONADDRESS. If writing for the first
            %   time, DESTINATIONADDRESS is required.
            %
            %   DESTINATIONPORT is the remote port to which DATA is sent.
            %   If this value is not set, the packet will be sent to the
            %   already used DESTINATIONPORT. If writing for the first
            %   time, DESTINATIONPORT is required.
            %
            % Notes:
            %   WRITE waits until the requested number of values are
            %   written to the udpport socket.
            %
            % Example:
            %      % Writes 1, 2, 3, 4, 5 as uint8 (5*1 = 5 bytes total)
            %      % to the udpport socket. The data is sent to address
            %      % 192.1.5.15 and port 20.
            %      write(u, 1:5, "uint8", "192.1.5.15", 20);
            %
            %      % For all future writes to the same address and port for
            %      % the udpport object u, omit the DESTINATIONADDRESS and
            %      % DESTINATIONPORT.
            %      write(u,1:10,"single");
            try
                write(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function data = readline(obj, varargin)
            %READLINE Read ASCII-terminated string data from the udpport
            %   socket.
            %
            %   DATA = READLINE(OBJ) reads until the first occurrence of the
            %          terminator and returns the data back as a STRING.
            %
            % Output Arguments:
            %   DATA is a string of ASCII data. If no data is returned,
            %   this is an empty string.
            %
            % Note:
            %   READLINE waits until the terminator is read or a timeout
            %   occurs.
            %
            % Example:
            %      % Reads all data up to the first occurrence of the 
            %      % terminator. Returns the data as a string with the
            %      % terminator removed.
            %      data = readline(u);
            try
                data = readline(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function writeline(obj, varargin)
            %WRITELINE Write ASCII data followed by the terminator to the
            % udpport socket.
            %
            %   WRITELINE(OBJ,DATA,DESTINATIONADDRESS,DESTINATIONPORT)
            %   writes the ASCII data, DATA, followed by the terminator, to
            %   the specified DESTINATIONADDRESS and DESTINATIONPORT.
            %
            %   WRITELINE(OBJ,DATA) writes the ASCII data, DATA, followed
            %   by the terminator, to the last specified DESTINATIONADDRESS
            %   and DESTINATIONPORT. Error occurs if DESTINATIONADDRESS and
            %   DESTINATIONPORT have not been specified in a previous
            %   WRITE/WRITELINE call for OBJ.
            %
            % Input Arguments:
            %   DATA is the ASCII data that is written to the udpport
            %   socket. The terminator is automatically appended to DATA.
            %   If the size of DATA with terminator is greater than the
            %   OUTPUTDATAGRAMSIZE property, the DATA is broken into
            %   multiple packets depending on the size of DATA and the
            %   value of OUTPUTDATAGRAMSIZE.
            %
            % Notes:
            %   WRITELINE waits until the ASCII DATA followed by terminator
            %   is written to the udpport socket.
            %
            % Example:
            %      % Write "START" and add the terminator to the end of
            %      % the line. The data is sent to address 192.1.5.15 and
            %      % port 20.
            %      writeline(u,"START","192.1.5.15",20);
            %
            %      % For all future writes to the same address and port for
            %      % the udpport object u, omit the DESTINATIONADDRESS and
            %      % DESTINATIONPORT.
            %      writeline(u,"START");

            try
                writeline(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureTerminator(obj, varargin)
            %CONFIGURETERMINATOR Set the <a href="matlab:help udpport.byte.UDPPort.Terminator">Terminator</a> property for
            %  ASCII-terminated string communication. 
            %
            % CONFIGURETERMINATOR(OBJ,TERMINATOR) sets the values of Read
            % and Write Terminators to TERMINATOR.
            %
            % CONFIGURETERMINATOR(OBJ,READTERMINATOR,WRITETERMINATOR) sets
            % the Terminator property to a cell array of
            % {READTERMINATOR,WRITETERMINATOR}. It sets the Read Terminator
            % to READTERMINATOR and the Write Terminator to
            % WRITETERMINATOR.
            %
            % Input Arguments:
            %   TERMINATOR is the terminating character for
            %   ASCII-terminated communication. This sets both Read and
            %   Write Terminators to TERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            %   READTERMINATOR is the read terminating character for
            %   ASCII-terminated communication. This sets the Read
            %   Terminator to READTERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            %   WRITETERMINATOR is the write terminating character for
            %   ASCII-terminated communication. This sets the write
            %   Terminator to WRITETERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            % Example:
            %      % Set both read and write terminators to "CR/LF".
            %      configureTerminator(u,"CR/LF")
            %
            %      % Set read terminator to "CR" and write terminator to
            %      % value of 10.
            %      configureTerminator(u,"CR",10)
            try
                configureTerminator(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureCallback(obj, varargin)
            %CONFIGURECALLBACK Set the BytesAvailable properties:
            % 1. <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnMode">BytesAvailableFcnMode</a>
            % 2. <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnCount">BytesAvailableFcnCount</a>
            % 3. <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcn">BytesAvailableFcn</a>
            %
            % CONFIGURECALLBACK(OBJ,"off") turns the BytesAvailable
            % callbacks off.
            %
            % CONFIGURECALLBACK(OBJ,"terminator",CALLBACKFCN) sets the
            % BytesAvailableFcnMode property to "terminator". CALLBACKFCN
            % is the function handle that is assigned to the
            % BytesAvailableFcn property. CALLBACKFCN is triggered whenever
            % a terminator is available to be read.
            %
            % CONFIGURECALLBACK(OBJ,"byte",COUNT,CALLBACKFCN) sets the
            % BytesAvailableFcnMode property to "byte". CALLBACKFCN is the
            % function handle that is assigned to the BytesAvailableFcn
            % property. CALLBACKFCN is triggered whenever COUNT number of
            % bytes are available to be read. BytesAvailableFcnCount
            % property is set to COUNT.
            %
            % Input Arguments:
            %   COUNT sets the BytesAvailableFcnCount property and can be
            %   specified as any positive integer value.
            %
            %   CALLBACKFCN sets the BytesAvailableFcn property and can be
            %   specified as any function_handle.
            %
            % Example:
            %      % Turn the callback off
            %      configureCallback(u,"off")
            %
            %      % Set the BytesAvailableFcnMode to "terminator". This
            %      % triggers the callback function "callbackFcn" when a
            %      % terminator is available to be read.
            %      configureCallback(u,"terminator",@callbackFcn)
            %
            %      % Set the BytesAvailableFcnMode to "byte". This
            %      % triggers the callback function "callbackFcn" when 50
            %      % bytes of data are available to be read.
            %      configureCallback(u,"byte",50,@callbackFcn)

           try
               configureCallback(obj.Client, varargin{:});
           catch ex
               throwAsCaller(ex);
           end
        end

        function configureMulticast(obj, varargin)
            %CONFIGUREMULTICAST Set the multicast properties for the
            % udpport socket:
            % 1. <a href="matlab:help udpport.byte.UDPPort.EnableMulticast">EnableMulticast</a> 
            % 2. <a href="matlab:help udpport.byte.UDPPort.MulticastGroup">MulticastGroup</a>
            % 3. <a href="matlab:help udpport.byte.UDPPort.EnableMulticastLoopback">EnableMulticastLoopback</a>
            %
            % CONFIGUREMULTICAST(OBJ, MULTICASTADDRESS, MULTICASTLOOPBACK)
            % sets the MulticastGroup property to MULTICASTADDRESS, the
            % EnableMulticastLoopback property to MULTICASTLOOPBACK, and
            % the EnableMulticast property to true.
            %
            % CONFIGUREMULTICAST(OBJ, MULTICASTADDRESS) sets the
            % MulticastGroup property to MULTICASTADDRESS, the
            % EnableMulticastLoopback property to true, and the
            % EnableMulticast property to true.
            %
            % CONFIGUREMULTICAST(OBJ, "off") sets the MulticastGroup
            % property to "", the EnableMulticastLoopback property to
            % false, and the EnableMulticast property to false.
            %
            % Example:
            %      % Turn multicast on and subscribe to the multicast
            %      % group "226.0.0.1". If "u" is the sender, ensure that
            %      % "u" does not get the data that it sends over to the
            %      % multicast address group by setting MULTICASTLOOPBACK
            %      % to false.
            %      configureMulticast(u,"226.0.0.1", false);
            %
            %      % If "u" wants to get back the data that it wrote to the
            %      % multicast group.
            %      configureMulticast(u,"226.0.0.1");
            %
            %      % Unsubscribe from the multicast group.
            %      configureMulticast(u, "off");

            try
                configureMulticast(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function flush(obj, varargin)
            %FLUSH clears the input buffer, output buffer, or both.
            %
            % FLUSH(OBJ) clears both the input and output buffers.
            %
            % FLUSH(OBJ,"input") clears the input buffer.
            %
            % FLUSH(OBJ,"output") clears the output buffer.
            %
            % Example:
            %      % Flush the input buffer.
            %      flush(u,"input");
            %
            %      % Flush the output buffer.
            %      flush(u,"output");
            %
            %      % Flush both the input and output buffers.
            %      flush(u);

            try
                flush(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
    end
    
    %% Getters and Setters
    methods
        function val = get.Connected(obj)
            val = getProperty(obj.Client, "Connected");
        end

        function set.Connected(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "Connected")));
        end

        function value = get.IPAddressVersion(obj)
            value = string(getProperty(obj.Client, "AddressType"));
        end

        function set.IPAddressVersion(obj, value)
            try
                if obj.Connected
                    str = message("instrument:interface:udpport:UDPPortConstructor").getString();
                    throw(MException(message("instrument:interface:udpport:ReadOnly", "IPAddressVersion", str)));
                end
                value = validatestring(value, ["IPV4", "IPV6"], mfilename, 'IPADDRESSVERSION');
                setProperty(obj.Client, "AddressType", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.LocalHost(obj)
            value = string(getProperty(obj.Client, "LocalHost"));
        end

        function set.LocalHost(~, ~)
            % Setting LocalHost using the setter errors. The LocalHost set
            % using NV pairs is set using UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "LocalHost", str)));
        end

        function value = get.LocalPort(obj)
            value = getProperty(obj.Client, "LocalPort");
        end

        function set.LocalPort(~, ~)
            % Setting LocalPort using the setter errors. The LocalPort set
            % using NV pairs is set using UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "LocalPort", str)));
        end

        function value = get.Timeout(obj)
            value = getProperty(obj.Client, "Timeout");
        end

        function set.Timeout(obj, value)
            try
                validateattributes(value, {'double'}, {'positive'}, mfilename, "TIMEOUT");
            catch ex
                mExc = MException("instrument:interface:udpport:InvalidEntry", ex.message);
                throwAsCaller(mExc);
            end
            try
                setProperty(obj.Client, "Timeout", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.ByteOrder(obj)
            value = string(getProperty(obj.Client, "ByteOrder"));
        end

        function set.ByteOrder(obj, value)
            try
                setProperty(obj.Client, "ByteOrder", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.OutputDatagramSize(obj)
            value = getProperty(obj.Client, "OutputDatagramPacketSize");
        end

        function set.OutputDatagramSize(obj, value)
            try
                validateattributes(value,{'numeric'}, ...
                    {'scalar', 'integer', 'nonnan', 'finite', 'positive', ...
                    "<=", 65507}, "", "OUTPUTDATAGRAMSIZE");

                % Setting OutputDatagramSize using the client's
                % setOutputDatagramSize method. The OutputDatagramSize
                % using NV pairs is set using UDPPortCommon.
                setOutputDatagramSize(obj.Client, value);
            catch ex
                mExc = MException("instrument:interface:udpport:InvalidEntry", ex.message);
                throwAsCaller(mExc);
            end
        end

        function value = get.ErrorOccurredFcn(obj)
            value = getProperty(obj.Client, "ErrorOccurredFcn");
        end

        function set.ErrorOccurredFcn(obj, value)
            try
                setProperty(obj.Client, "ErrorOccurredFcn", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.UserData(obj)
            value = getProperty(obj.Client, "UserData");
        end

        function set.UserData(obj, value)
            setProperty(obj.Client, "UserData", value);
        end

        function value = get.EnableBroadcast(obj)
            value = getProperty(obj.Client, "EnableBroadcast");
        end

        function set.EnableBroadcast(obj, value)
            try
                setEnableBroadcast(obj.Client, value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.EnableMulticast(obj)
            value = getProperty(obj.Client, "EnableMulticast");
        end

        function set.EnableMulticast(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "EnableMulticast", str)));
        end

        function value = get.EnableMulticastLoopback(obj)
            value = getProperty(obj.Client, "EnableDatagramLoopback");
        end

        function set.EnableMulticastLoopback(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "EnableMulticastLoopback", str)));
        end

        function value = get.MulticastGroup(obj)
            value = string(getProperty(obj.Client, "MulticastGroup"));
        end

        function set.MulticastGroup(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "MulticastGroup", str)));
        end

        function value = get.EnablePortSharing(obj)
            value = getProperty(obj.Client, "EnablePortSharing");
        end

        function set.EnablePortSharing(~, ~)
            % Setting EnablePortSharing using the setter errors. The
            % EnablePortSharing set using NV pairs is set using
            % UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "EnablePortSharing", str)));
        end

        function value = get.Terminator(obj)
            value = getProperty(obj.Client, "Terminator");
        end

        function set.Terminator(obj, val)
            try
                setProperty(obj.Client, "Terminator", val);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcnCount(obj)
            value = getProperty(obj.Client, "BytesAvailableFcnCount");
        end

        function set.BytesAvailableFcnCount(obj, val)
            try
                setProperty(obj.Client, "BytesAvailableFcnCount", val);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcnMode(obj)
            value = getProperty(obj.Client, "BytesAvailableFcnMode");
        end

        function set.BytesAvailableFcnMode(obj, val)
            try
                setProperty(obj.Client, "BytesAvailableFcnMode", val);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcn(obj)
            value = getProperty(obj.Client, "BytesAvailableFcn");
        end

        function set.BytesAvailableFcn(obj, val)
            try
                setProperty(obj.Client, "BytesAvailableFcn", val);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.NumBytesAvailable(obj)
            value = getProperty(obj.Client, "NumBytesAvailable");
        end

        function set.NumBytesAvailable(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "NumBytesAvailable")));
        end

        function value = get.NumBytesWritten(obj)
            value = getProperty(obj.Client, "NumBytesWritten");
        end

        function set.NumBytesWritten(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "NumBytesWritten")));
        end
    end

    %% Helper Methods
    methods (Access = ?instrument.internal.ITestable)
        function setCustomDisplay(obj)
            % Prepare the property groups for disp(udpport).
            obj.PropertyGroupList = {obj.MainProperties, obj.PropertiesSet1, ...
                obj.PropertiesSet2, obj.PropertiesSet3, obj.PropertiesSet4};
            obj.PropertyGroupNames = ["" "" "" "" ""];
        end

        function transportProperties = getTransportProperties(obj, addressType)
            % Prepare and return the transport properties.
            transportProperties = ...
                matlabshared.transportlib.internal.client.PropertiesFactory.getInstance("transport");
            transportProperties.CallbackSource = obj;
            transportProperties.InterfaceName = "udpport";
            transportProperties.InterfaceObjectName = "u";
            transportProperties.Transport = matlabshared.transportlib.internal.TransportFactory.getTransport("udpbyte");
            transportProperties.Transport.CFIName = transportProperties.InterfaceName;

            % Create the error registry
            transportProperties.ErrorRegistry = ...
                matlabshared.transportlib.internal.client.utility.ErrorRegistry(obj.getErrorEntries(addressType));
        end

        function entries = getErrorEntries(~, addressType)
            % Create the error entries for UDPPort byte using the Shared
            % Implementation

            entries = containers.Map;
            entries("transportlib:client:IncorrectInputArgumentsSingular") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:IncorrectInputArgumentsSingular");

            entries("transportlib:client:IncorrectInputArgumentsPlural") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:IncorrectInputArgumentsPlural");

            entries("transportlib:client:ReadOnlyProperty") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:ReadOnly");

            entries("transportlib:client:InvalidBytesAvailableFcn") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:InvalidBytesAvailableFcn");

            entries("transportlib:client:InvalidBytesAvailableFcnCount") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:InvalidBytesAvailableFcnCount");

            entries("transportlib:client:IncorrectBytesAvailableModeSyntax") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:IncorrectBytesAvailableModeSyntax");

            entries("transportlib:client:InvalidErrorOccurredFcn") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:InvalidEntry");

            entries("transportlib:client:InvalidType") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:InvalidEntry");

            entries("MATLAB:UDP:invalidType") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry( ...
                "instrument:interface:udpport:InvalidEntry");

            entries("network:udp:connectFailed") = ...
                matlabshared.transportlib.internal.client.utility.ErrorEntry ...
                ("instrument:interface:udpport:ConnectFailed", ...
                message("instrument:interface:udpport:ConnectFailed", addressType).getString);
        end
    end

    methods (Hidden)
        function udpportInstance = saveobj(obj)
            udpportInstance = [];

            if ~obj.SaveWarningIssued
                obj.SaveWarningIssued = true;

                warningState = warning('off','backtrace');
                oc = onCleanup(@() warning(warningState));

                warning(message("instrument:interface:udpport:NoSave"));
            end
        end
    end

    methods (Static, Hidden)
        function udpportInstance = loadobj(~)
            warning(message("instrument:interface:udpport:NoLoad"));
            udpportInstance = udpport.byte.UDPPort.empty;
        end
    end
end
