classdef (Sealed) TCPServer < matlabshared.testmeas.internal.SetGet & ...
                              matlabshared.testmeas.CustomDisplay & ...
                              matlabshared.transportlib.internal.compatibility.LegacyTcpserver & ...
                              matlabshared.testmeas.internal.mixins.CacheEnabler & ...
                              matlabshared.transportlib.internal.TagAccessor

    %TCPSERVER creates a TCP/IP server that binds to the specified IP
    % address and port number. The server listens for TCP/IP client connection
    % requests and communicates with the client after establishing a connection.
    %
    %   OBJ = TCPSERVER.INTERNAL.TCPSERVER("SERVERADDRESS",SERVERPORT)
    %   constructs a TCPServer object, OBJ, that binds to and listens for
    %   client connections at IP address SERVERADDRESS and port number
    %   SERVERPORT.
    %
    %   OBJ = TCPSERVER.INTERNAL.TCPSERVER(SERVERPORT) constructs a
    %   TCPServer object, OBJ, that binds to and listens for client
    %   connections at IP address "::" and port number SERVERPORT.
    %
    %   OBJ = TCPSERVER.INTERNAL.TCPSERVER("SERVERADDRESS",SERVERPORT,"NAME","VALUE",...)
    %   constructs a TCPServer object, OBJ, using one or more optional
    %   name-value pair arguments. If an invalid property name or property
    %   value is specified, then the object is not created.
    %   TCPServer properties that can be set using name-value pair
    %   arguments are Timeout, Tag, ByteOrder, and ConnectionChangedFcn.
    %
    %   OBJ = TCPSERVER.INTERNAL.TCPSERVER(SERVERPORT,"NAME","VALUE",...)
    %   constructs a TCPServer object, OBJ, using one or more optional
    %   name-value pair arguments. If an invalid property name or property
    %   value is specified, then the object is not created. TCPServer
    %   properties that can be set using name-value pair arguments are
    %   Timeout, Tag, ByteOrder, and ConnectionChangedFcn.
    %
    % Input Arguments:
    %   SERVERADDRESS specifies the IP address that the server binds to.
    %   The server listens for TCP/IP client connections at this IP
    %   address. If SERVERADDRESS is specified as a host name, then it is
    %   internally resolved to an IPV4 or IPV6 address, and SERVERADDRESS
    %   is set to the resolved IP address.
    %         Examples:
    %         IPV4 address - "144.212.100.10"
    %         IPV6 address - "fe80::e9b7:559:9b8d:6ba9"
    %         Host name     - "testhost"
    %
    %   SERVERPORT specifies the port number that the server binds to.
    %   The server listens for TCP/IP client connections at this port number.
    %   Port number should be an integer between 1 and 65535 inclusive.
    %
    % TCPSERVER methods:
    %
    %   READ METHODS
    %   read                - Read data from the connected client
    %   readline            - Read ASCII-terminated string data from the connected client
    %   readbinblock        - Read one binblock of data from the connected client
    %
    %   WRITE METHODS
    %   write               - Write data to the connected client
    %   writeline           - Write ASCII-terminated string data to the connected client
    %   writebinblock       - Write one binblock of data to the connected client
    %
    %   OTHER METHODS
    %   flush               - Clear the input and/or output buffers
    %   configureTerminator - Set the read and write terminator properties
    %   configureCallback   - Set the Bytes Available callback properties
    %
    % TCPSERVER properties:
    %
    %   ServerAddress          - IP address that the server binds to. The server listens for TCP/IP client connections at this IP address
    %   ServerPort             - Port number that the server binds to. The server listens for TCP/IP client connections at this port number
    %   Connected              - Connection status of the server
    %   ClientAddress          - IP address of the TCP/IP client connected to the server
    %   ClientPort             - Port number of the TCP/IP client connected to the server
    %   Tag                    - Unique identifier name for the server
    %   NumBytesAvailable      - Number of bytes available to be read from the input buffer
    %   NumBytesWritten        - Number of bytes written to the output buffer
    %   Timeout                - Waiting time to complete read and write operations
    %   ByteOrder              - Sequential order in which bytes are arranged into larger numerical values
    %   UserData               - Application specific data for TCPServer
    %   Terminator             - Read and write terminator for the ASCII-terminated string communication
    %   BytesAvailableFcn      - Callback Function that gets triggered when a Bytes Available event occurs
    %   BytesAvailableFcnCount - Number of bytes in the input buffer that triggers a Bytes Available event
    %                            (Only applicable for BytesAvailableFcnMode = "byte")
    %   BytesAvailableFcnMode  - Condition for firing BytesAvailableFcn callback
    %   ErrorOccurredFcn       -  Callback function that gets triggered when an error event occurs.
    %   ConnectionChangedFcn   - Callback function that gets triggered when a connection or disconnection event occurs.
    %
    % Examples:
    %
    %       % Construct a TCPServer object to bind to port 4000 and IP address "::".
    %       % Verify that the ClientAddress and ClientPort properties are empty and that the Connected property is false.
    %       server = tcpserver.internal.TCPServer(4000)
    %
    %       % Construct a tcpclient object to connect to the existing TCPServer object
    %       client = tcpclient("localhost", 4000);
    %
    %       % View the server object to see the ClientAddress and ClientPort properties are populated.
    %       % Verify that the client is connected to the server. The Connected property should be true.
    %       server
    %
    %       % Write 1 to 10 as "uint8" data from the server to the client
    %       write(server, 1:10, "uint8")
    %
    %       % Read 10 values of "uint8" data from the client
    %       data = read(client, 10, "uint8");
    %
    %       % Write 1 to 5 as "uint16" data from the client to the server
    %       write(client, 1:5, "uint16")
    %
    %       % Read 5 values of "uint16" data from the server
    %       data = read(server, 5, "uint16");
    %
    %       % Set the Terminator property on the server
    %       configureTerminator(server, "CR/LF")
    %
    %       % Set the Terminator property on the client
    %       configureTerminator(client, "CR/LF")
    %
    %       % Write "hello" from the server to the client with the Terminator included
    %       writeline(server, "hello")
    %
    %       % Read ASCII-terminated string data from the client
    %       data = readline(client);
    %
    %       % Write 1, 2, 3, 4, 5 as a binblock of "uint8" data from the server to the client
    %       writebinblock(server, 1:5, "uint8")
    %
    %       % Read binblock of "uint8" data from the client
    %       data = readbinblock(client, "uint8");
    %
    %       % Set the Bytes Available Callback properties for the server
    %       configureCallback(server, "byte", 50, @myCallbackFcn)
    %
    %       % Flush input and output buffer
    %       flush(server)
    %
    %       % Disconnect and clear client and server
    %       clear client
    %       clear server
    %
    %   See also TCPCLIENT.

    %   Copyright 2020-2023 The MathWorks, Inc.

    properties (GetAccess = public, SetAccess = private, Dependent)
        % ServerAddress - Specifies the IP address that the server binds to.
        %   The server listens for TCP/IP client connections at this IP address.
        % Read/Write Access - Read-only. It can be set only during object
        %   creation using the tcpserver constructor.
        % Accepted values - Valid IPV4 address, IPV6 address, or host name
        %   of the network adaptor on the machine, specified as a character
        %   vector or string scalar.
        % Default - "::"
        ServerAddress

        % ServerPort - Specifies the port number that the server binds to.
        %   The server listens for TCP/IP client connections at this port.
        % Read/Write Access - Read-only. It can be set only during object
        %   creation using the tcpserver constructor.
        % Accepted Values - Positive integer between 1 and 65535, inclusive.
        % Default - N/A
        ServerPort

        % Connected - The connection status of the server. Indicates if a
        %   TCP/IP client is connected to the server.
        % Read/Write Access - Read-only
        % Default - false
        Connected

        % ClientAddress - Specifies the IP address of the TCP/IP client
        %   connected to the server. If no client is connected to the server,
        %   then the value is empty.
        % Read/Write Access - Read-only
        % Default - ""
        ClientAddress

        % ClientPort - Specifies the port number of the TCP/IP client
        %   connected to the server. If no client is connected to the server,
        %   then the value is empty.
        % Read/Write Access - Read-only
        % Default - []
        ClientPort

        % NumBytesAvailable - Specifies the number of bytes available to be
        %   read from the input buffer.
        % Read/Write Access - Read-only
        % Default - 0
        NumBytesAvailable

        % NumBytesWritten - Specifies the number of bytes written to the
        %   output buffer.
        % Read/Write Access - Read-only
        % Default - 0
        NumBytesWritten
    end

    properties (Access = public, Dependent)
        % Timeout - Specifies the waiting time (in seconds) to complete
        %   read and write operations.
        % Read/Write Access - Both
        % Accepted Values - Positive numeric values
        % Default - 10
        Timeout

        % ByteOrder - Sequential order in which bytes are arranged into
        %   larger numerical values.
        % Read/Write Access - Both
        % Accepted Values - "little-endian" or "big-endian" specified as
        %   char or string
        % Default - "little-endian"
        ByteOrder

        % Terminator - Specifies the read and write terminator for
        %   ASCII-terminated string communication.
        % Read/Write Access - Read-only
        % Accepted Values - Integers ranging from 0 to 255
        %                   "CR", "LF", "CR/LF"
        % Default - "LF"
        %
        % To set this property, use <a href="matlab:help tcpserver.internal.TCPServer.configureTerminator">configureTerminator</a> function.
        Terminator

        % BytesAvailableFcnMode - Turns bytes available callback off or
        %   specifies the condition for triggering the bytes available
        %   callback:
        %   a. when BytesAvailableFcnCount number of bytes are available
        %      to be read, or
        %   b. when the terminator is reached
        % Read/Write Access - Read-only
        % Accepted Values - "byte", "terminator", "off"
        % Default - "off"
        %
        % To set this property, use <a href="matlab:help tcpserver.internal.TCPServer.configureCallback">configureCallback</a> function.
        BytesAvailableFcnMode

        % BytesAvailableFcnCount - Number of bytes in the input buffer that
        %   triggers BytesAvailableFcn, when BytesAvailableFcnMode is set
        %   to "byte".
        % Accepted Values - Positive integer values
        % Read/Write Access - Read-only
        % Default - 64
        %
        % To set this property, use <a href="matlab:help tcpserver.internal.TCPServer.configureCallback">configureCallback</a> function.
        BytesAvailableFcnCount

        % BytesAvailableFcn - Callback function that gets triggered when a
        %   bytes available event occurs.
        % Read/Write Access - Read-only
        % Accepted Values - any function_handle
        % Default - []
        %
        % To set this property, use <a href="matlab:help tcpserver.internal.TCPServer.configureCallback">configureCallback</a> function.
        BytesAvailableFcn

        % ErrorOccurredFcn - The callback function that gets triggered when
        %   an error event occurs.
        % Read/Write Access - Both
        % Accepted Values - any function_handle
        % Default - []
        ErrorOccurredFcn

        % UserData - To store application specific data for TCPServer.
        % Read/Write Access - Both
        % Accepted Values - any MATLAB data type
        % Default - []
        UserData

        % ConnectionChangedFcn - The callback function that gets triggered
        %   when a connection or disconnection event occurs.
        % Read/Write Access - Both
        % Accepted Values - any function_handle
        % Default - []
        ConnectionChangedFcn
    end

    properties (Access = private)
        % The handle to the tcpserver CustomClient instance.
        Client

        % True once the saveobj method has been called
        HasSaveWarningBeenIssued = false
    end

    properties (Hidden, Constant)
        % To set the object display
        DefaultPropertyDisplay = ["ServerAddress", "ServerPort", "Connected", ...
                                  "ClientAddress", "ClientPort", "Tag", "NumBytesAvailable"]

        CommunicationPropertiesList = ["Timeout", "ByteOrder", "Terminator"]

        BytesAvailablePropertiesList = ["BytesAvailableFcnMode", ...
            "BytesAvailableFcnCount", "BytesAvailableFcn", "NumBytesWritten"]

        AdditionalPropertiesList = ["ErrorOccurredFcn", "UserData", "ConnectionChangedFcn"]

        % For caching
        ObjectType = "tcpserver"
    end

    %% Getters/Setters
    methods
        function value = get.ServerAddress(obj)
            value = obj.Client.ServerAddress;
        end

        function value = get.ServerPort(obj)
            value = obj.Client.ServerPort;
        end

        function value = get.NumBytesAvailable(obj)
            value = getProperty(obj.Client,"NumBytesAvailable");
        end

        function value = get.NumBytesWritten(obj)
            value = getProperty(obj.Client,"NumBytesWritten");
        end

        function value = get.Connected(obj)
            value = obj.Client.Connected;
        end

        function value = get.ClientAddress(obj)
            value = obj.Client.ClientAddress;
        end

        function value = get.ClientPort(obj)
            value = obj.Client.ClientPort;
        end

        function value = get.ConnectionChangedFcn(obj)
            value = obj.Client.ConnectionChangedFcn;
        end

        function set.ConnectionChangedFcn(obj,value)
            if isnumeric(value) && isempty(value)
                obj.Client.ConnectionChangedFcn = function_handle.empty();
            elseif isa(value,'function_handle')
                obj.Client.ConnectionChangedFcn = value;
            else
                error(message('instrument:interface:tcpserver:InvalidConnectionChangedFcn'));
            end
        end

        function value = get.ByteOrder(obj)
            value = getProperty(obj.Client,"ByteOrder");
        end

        function set.ByteOrder(obj,value)
            try
                setProperty(obj.Client,"ByteOrder",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.Timeout(obj)
            value = getProperty(obj.Client,"Timeout");
        end

        function set.Timeout(obj,value)
            try
                setProperty(obj.Client,"Timeout",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.Terminator(obj)
            value = getProperty(obj.Client,"Terminator");
        end

        function set.Terminator(obj,value)
            try
                setProperty(obj.Client,"Terminator",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.UserData(obj)
            value = getProperty(obj.Client,"UserData");
        end

        function set.UserData(obj,value)
            try
                setProperty(obj.Client,"UserData",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.ErrorOccurredFcn(obj)
            value = getProperty(obj.Client,"ErrorOccurredFcn");
        end

        function set.ErrorOccurredFcn(obj,value)
            try
                setProperty(obj.Client,"ErrorOccurredFcn",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcn(obj)
            value = getProperty(obj.Client,"BytesAvailableFcn");
        end

        function set.BytesAvailableFcn(obj,value)
            try
                setProperty(obj.Client,"BytesAvailableFcn",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcnMode(obj)
            value = getProperty(obj.Client,"BytesAvailableFcnMode");
        end

        function set.BytesAvailableFcnMode(obj,value)
            try
                setProperty(obj.Client,"BytesAvailableFcnMode",value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.BytesAvailableFcnCount(obj)
            value = getProperty(obj.Client,"BytesAvailableFcnCount");
        end

        function set.BytesAvailableFcnCount(obj,value)
            try
                setProperty(obj.Client,"BytesAvailableFcnCount",value);
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Lifetime
    methods
        function obj = TCPServer(varargin)
            %TCPSERVER constructs the TCPServer object.
            %
            %   OBJ = TCPSERVER('SERVERADDRESS', SERVERPORT) constructs a
            %   TCPServer object, OBJ, that binds to and listens for client
            %   connections at IP address SERVERADDRESS and port number SERVERPORT.
            %
            %   OBJ = TCPSERVER(SERVERPORT) constructs a TCPServer object,
            %   OBJ, that binds to and listens for client connections at
            %   IP address "::" and port number SERVERPORT.
            %
            %   OBJ = TCPSERVER('SERVERADDRESS', SERVERPORT, 'NAME', 'VALUE', ...)
            %   constructs a TCPServer object, OBJ, using one or more
            %   optional name-value pair arguments. If an invalid property
            %   name or property value is specified, then the object is
            %   not created. TCPServer properties that can be set using name-value
            %   pair arguments are Timeout, ByteOrder, and ConnectionChangedFcn.
            %
            %   OBJ = TCPSERVER(SERVERPORT, 'NAME', 'VALUE', ...) constructs a
            %   TCPServer object, OBJ, using one or more optional
            %   name-value pair arguments. If an invalid property name or
            %   property value is specified, then the object is
            %   not created. TCPServer properties that can be set using name-value
            %   pair arguments are Timeout, ByteOrder, and ConnectionChangedFcn.
            %
            % Input Arguments:
            %   SERVERADDRESS specifies the IP address that the server
            %   binds to. The server listens for TCP/IP client connections
            %   at this IP address. If SERVERADDRESS is specified as a
            %   host name, then it is internally resolved to an IPV4 or IPV6
            %   address, and SERVERADDRESS is set to the resolved IP address.
            %         Examples:
            %         IPV4 address - "144.212.100.10"
            %         IPV6 address - "fe80::e9b7:559:9b8d:6ba9"
            %         Host name     - "testhost"
            %
            %   SERVERPORT specifies the port number that the server binds to.
            %   The server listens for TCP/IP client connections at this port number.
            %   Port number should be an integer between 1 and 65535 inclusive.
            %
            % Examples:
            %      % Create a tcpserver listening at IP address "::" AND port number 5000
            %      t = tcpserver("::", 5000);
            %
            %      % Create a tcpserver listening at port number 6000 and at the default IP address "::"
            %      % and set Byte Order to "big-endian".
            %      t = tcpserver(5000, "ByteOrder", "big-endian");
            %
            %      % Create a tcpserver listening at IP address "::" AND port number 7000,
            %      % and set Timeout to 1 and ConnectionChangedFcn to @connectionFcn.
            %      t = tcpserver("::", 7000, "Timeout", 1, "ConnectionChangedFcn", @connectionFcn);

            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            try
                % Parses the input arguments
                [address, port, nvPairs] = tcpserver.internal.InputParser.parse(varargin{:});

                % Creates CustomClient instance
                obj.Client = getCustomClient(obj,address,port);

                % Parses name-value pair input arguments and assigns to properties
                initProperties(obj,nvPairs);

                % Sets the TCPServer object display
                setCustomDisplay(obj);
            catch creationException
                throwAsCaller(MException('instrument:interface:tcpserver:cannotCreateObject', ...
                    creationException.message));
            end

            try
                % Connects to the CustomClient instance
                connect(obj.Client);
            catch connectException
                throwAsCaller(MException('instrument:interface:tcpserver:cannotConnect', ...
                    connectException.message));
            end
        end

        function delete(obj)
            obj.Client = [];
        end
    end

    %% API
    methods (Access = public)
        function data = read(obj,varargin)
            %READ Reads data sent by the connected TCP/IP client.
            %
            %   DATA = READ(OBJ, COUNT) reads the specified number of values,
            %   COUNT, as UINT8 from the TCPServer object connected to the
            %   client, OBJ, and returns to DATA.
            %
            %   DATA = READ(OBJ, COUNT, DATATYPE) reads the specified
            %   number of values, COUNT, with the specified data
            %   type, DATATYPE, from the TCPServer object connected to the
            %   connected client, OBJ, and returns to DATA.
            %   For numeric DATATYPE types DATA is returned as a row vector
            %   of doubles. For char and string DATATYPE types, DATA is
            %   returned as a character vector or string scalar, as specified.
            %
            % Input Arguments:
            %   COUNT indicates the number of items to read, specified as a
            %   positive integer value. If COUNT is greater than the OBJ's
            %   NumBytesAvailable property, then this function waits until
            %   the specified amount of data is read.
            %
            %   DATATYPE indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   DATATYPE must be one of "UINT8", "INT8", "UINT16", "INT16",
            %   "UINT32", "INT32", "UINT64", "INT64", "SINGLE", "DOUBLE",
            %   "CHAR", or "STRING".
            %
            %   Default DATATYPE: "UINT8"
            %
            % Output Argument:
            %   DATA is a 1xN matrix of numeric or ASCII data. If no data
            %   was returned this will be an empty array.
            %
            % Notes:
            %   READ waits until the requested number of values are read
            %   from the connected client or a timeout occurs.
            %
            % Examples:
            %      % Read 5 values of data as "uint8".
            %      data = read(t,5);
            %
            %      % Read 5 values of "uint32" data or 20 bytes.
            %      % (5 values * 4 bytes = 20 bytes)
            %      data = read(t,5,"uint32");

            try
                data = read(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function data = readline(obj,varargin)
            %READLINE Reads ASCII-terminated string data sent by the
            %   connected TCP/IP client.
            %
            %   DATA = READLINE(OBJ) reads until the first occurrence of the
            %   terminator and returns the DATA back as a string without
            %   the terminator.
            %
            % Output Argument:
            %   DATA is a string of ASCII data. If no data is returned,
            %   this is an empty string.
            %
            % Note:
            %   READLINE waits until the terminator is read from the input
            %   buffer or a timeout occurs.
            %
            % Example:
            %      % Read all data up to the first occurrence of the
            %      % terminator. Return the data as a string with the
            %      % terminator removed.
            %      data = readline(t);

            try
                data = readline(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function data = readbinblock(obj,varargin)
            %READBINBLOCK Reads one binblock of data sent by the connected
            %   TCP/IP client.
            %
            %   DATA = READBINBLOCK(OBJ) reads the binblock data as UINT8
            %   and returns to DATA
            %
            %   DATA = READBINBLOCK(OBJ, DATATYPE) reads the binblock data
            %   as DATATYPE type. For numeric DATATYPE types DATA is
            %   returned as a row vector of doubles.
            %   For char and string DATATYPE types, DATA is returned as a
            %   character vector or string scalar, as specified.
            %
            % Input Arguments:
            %   DATATYPE indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   DATATYPE must be one of "UINT8", "INT8", "UINT16", "INT16",
            %   "UINT32", "INT32", "UINT64", "INT64", "SINGLE", "DOUBLE",
            %   "CHAR", or "STRING".
            %
            %   Default DATATYPE: "UINT8"
            %
            % Output Argument:
            %   DATA is a 1xN matrix of numeric or ASCII data. If no data
            %   was returned this is an empty array.
            %
            % Notes:
            %   READBINBLOCK waits until a binblock is read from the input
            %   buffer or a timeout occurs.
            %
            % Examples:
            %      % Read the raw bytes in the binblock as uint8 and
            %      % represent them as a double array in row format.
            %      data = readbinblock(t);
            %
            %      % Read the raw bytes in the binblock as uint16 and
            %      % represent them as a double array in row format.
            %      data = readbinblock(t,"uint16")

            try
                data = readbinblock(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function write(obj,varargin)
            %WRITE Writes data to the connected TCP/IP client.
            %
            %   WRITE(OBJ, DATA) sends the 1xN or Nx1 matrix of data as
            %   UINT8 to the connected client.
            %
            %   WRITE(OBJ, DATA, DATATYPE) sends the 1xN or Nx1 matrix of data
            %   to the connected client. The data is cast to the specified
            %   data type DATATYPE regardless of the data type of DATA.
            %
            % Input Arguments:
            %   DATA is a 1xN or Nx1 matrix of numeric or ASCII data.
            %   ASCII data is applicable only when the data type is specified.
            %
            %   DATATYPE determines the number of bits written for each value
            %   and the interpretation of those bits as integer, floating-point,
            %   or character values.
            %   DATATYPE must be one of "UINT8", "INT8", "UINT16", "INT16",
            %   "UINT32", "INT32", "UINT64", "INT64", "SINGLE", "DOUBLE",
            %   "CHAR", or "STRING".
            %
            % Notes:
            %   WRITE waits until the requested number of values are
            %   written to the connected client.
            %
            % Examples:
            %      % Write 1, 2, 3, 4, 5 as "uint8" (5*1 = 5 bytes total)
            %      % to the connected client.
            %      write(t,1:5);
            %
            %      % Write 1, 2, 3, 4, 5 as "double" (5*8 = 40 bytes total)
            %      % to the connected client.
            %      write(t,1:5,"double");

            try
                obj.validateConnected;
                write(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function writeline(obj,varargin)
            %WRITELINE Writes ASCII data followed by the terminator to the
            %   connected TCP/IP client.
            %
            %   WRITELINE(OBJ, DATA) writes the ASCII data, DATA, followed
            %   by the terminator, to the connected client.
            %
            % Input Arguments:
            %   DATA is the ASCII data that is written to the connected
            %   client. This DATA is always followed by the write
            %   terminator character(s).
            %
            % Notes:
            %   WRITELINE waits until the ASCII DATA and the terminator are
            %   written to the connected client.
            %
            % Example:
            %      % Write "*IDN?" and append the terminator to the end of
            %      % the line before writing to the connected client.
            %      writeline(t,"*IDN?");

            try
                obj.validateConnected;
                writeline(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function writebinblock(obj,varargin)
            %WRITEBINBLOCK Writes a binblock of data to the connected
            %   TCP/IP client.
            %
            %   WRITEBINBLOCK(OBJ, DATA, DATATYPE) writes DATA to the
            %   connected client using the binblock protocol (IEEE 488.2
            %   Definite Length Arbitrary Block Response Data). The data is
            %   cast to the specified data type DATATYPE regardless of the
            %   data type of DATA.
            %
            %   WRITEBINBLOCK(OBJ, DATA, DATATYPE, HEADER) writes DATA to
            %   the connected client using the binblock protocol (IEEE
            %   488.2 Definite Length Arbitrary Block Response Data). The
            %   data is cast to the specified datatype DATATYPE regardless
            %   of the actual type. The HEADER is prepended to the binblock
            %   before writing.
            %
            % Input Arguments:
            %   DATA is a 1xN matrix of numeric or ASCII data that is
            %   written as a binblock to the connected client.
            %
            %   DATATYPE determines the number of bits written for each value
            %   and the interpretation of those bits as integer, floating-point,
            %   or character values.
            %   DATATYPE must be one of "UINT8", "INT8", "UINT16", "INT16",
            %   "UINT32", "INT32", "UINT64", "INT64", "SINGLE", "DOUBLE",
            %   "CHAR", or "STRING".
            %
            %   HEADER is the optional custom header to prepend to the
            %   binblock before writing. HEADER must be an ASCII string.
            %
            % Notes:
            %   WRITEBINBLOCK waits until the binblock DATA is written
            %   to the connected client.
            %
            % Example:
            %      % Convert 1, 2, 3, 4, 5 to a binblock and write it to
            %      % the connected client as "uint8".
            %      writebinblock(t,1:5,"uint8");
            %
            %      % Converts 1, 2, 3, 4, 5 to a binblock and writes it to
            %      % the connected client as uint8 with the custom header
            %      % "MyHeader" prepended to the binblock packet before
            %      % writing. 
            %      writebinblock(t,1:5,"uint8","MyHeader");

            try
                obj.validateConnected;
                writebinblock(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureTerminator(obj,varargin)
            %CONFIGURETERMINATOR Sets the Terminator property for
            %   ASCII-terminated string communication on the TCPServer object.
            %
            %   CONFIGURETERMINATOR(OBJ, TERMINATOR) - Sets the Terminator
            %   property to TERMINATOR for the TCPServer object. TERMINATOR
            %   applies to both Read and Write Terminators.
            %
            %   CONFIGURETERMINATOR(OBJ, READTERMINATOR, WRITETERMINATOR) -
            %   Sets the Terminator property of the TCPServer object to a
            %   cell array of {READTERMINATOR,WRITETERMINATOR}. It sets the
            %   Read Terminator to READTERMINATOR and the Write Terminator
            %   to WRITETERMINATOR for the TCPServer object.
            %
            % Input Arguments:
            %   TERMINATOR: The terminating character for ASCII-terminated
            %   communication. This sets both Read and Write Terminators to
            %   TERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            %   READTERMINATOR: The read terminating character for
            %   ASCII-terminated communication. This sets the Read
            %   Terminator to READTERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            %   WRITETERMINATOR: The write terminating character for
            %   ASCII-terminated communication. This sets the write
            %   Terminator to WRITETERMINATOR.
            %   Accepted Values - Integers ranging from 0 to 255
            %                     "CR", "LF", "CR/LF"
            %
            % Examples:
            %      % Set both read and write terminators to "CR/LF"
            %      configureTerminator(t,"CR/LF")
            %
            %      % Set read terminator to "CR" and write terminator to
            %      % ASCII value of 10
            %      configureTerminator(t,"CR",10)

            try
                configureTerminator(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureCallback(obj,varargin)
            %CONFIGURECALLBACK Sets the BytesAvailable properties:
            %   1. <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcnMode">BytesAvailableFcnMode</a>
            %   2. <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcnCount">BytesAvailableFcnCount</a>
            %   3. <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcn">BytesAvailableFcn</a>
            %
            %   CONFIGURECALLBACK(OBJ, MODE) - For this syntax, the only
            %   possible value for MODE is "off". This turns the
            %   BytesAvailable callbacks off.
            %
            %   CONFIGURECALLBACK(OBJ, MODE, CALLBACKFCN) - For this syntax,
            %   the only possible value for MODE is "terminator". This sets
            %   the BytesAvailableFcnMode property to "terminator".
            %   CALLBACKFCN is the function handle that is assigned to
            %   BytesAvailableFcn. CALLBACKFCN is triggered whenever a
            %   terminator is available to be read.
            %
            %   CONFIGURECALLBACK(OBJ, MODE, COUNT, CALLBACKFCN) - For this
            %   syntax, the only possible value for MODE is "BYTE". This sets
            %   the BytesAvailableFcnMode property to "BYTE". CALLBACKFCN is
            %   the function handle that is assigned to BytesAvailableFcn.
            %   CALLBACKFCN is triggered whenever COUNT number of bytes are
            %   available to be read. BytesAvailableFcnCount is set to COUNT.
            %
            % Input Arguments:
            %   MODE: The BytesAvailableFcnMode property. Possible values
            %   are "off", "terminator", and "byte".
            %
            %   COUNT: The BytesAvailableFcnCount property. This can be set
            %   to any positive integer value. Valid only for MODE = "byte".
            %
            %   CALLBACKFCN: The BytesAvailableFcn property. This can be
            %   set to a function_handle.
            %
            % Examples:
            %      % Turn the callback off
            %      configureCallback(t,"off")
            %
            %      % Set the BytesAvailableFcnMode to "terminator". This
            %      % triggers the callback function "callbackFcn" when a
            %      % terminator is available to be read.
            %      configureCallback(t,"terminator",@callbackFcn)
            %
            %      % Set the BytesAvailableFcnMode to "byte". This triggers
            %      % the callback function "callbackFcn" when 50 bytes of
            %      % data are available to be read.
            %      configureCallback(t,"byte",50,@callbackFcn)

            try
                configureCallback(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function flush(obj,varargin)
            %FLUSH Clears the input buffer, output buffer, or both.
            %
            %   FLUSH(OBJ) clears both the input and output buffers.
            %
            %   FLUSH(OBJ, BUFFER) clears the input buffer or output buffer,
            %   based on the value of BUFFER.
            %
            % Input Arguments:
            %   BUFFER is the type of buffer that is flushed.
            %   Accepted Values - "input", "output".
            %
            % Example:
            %      % Flush the input buffer
            %      flush(t,"input");
            %
            %      % Flush the output buffer
            %      flush(t,"output");
            %
            %      % Flush both the input and output buffers
            %      flush(t);

            try
                flush(obj.Client,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Helper Functions
    methods (Access = private)
        function client = getCustomClient(obj,address,port)
            % Creates the TCPServerCustomClient that communicates with the
            % tcpserverdevice plugin.

            % Creates Channel Properties
            clientProperties = matlabshared.transportlib.internal.client.PropertiesFactory.getInstance("channel");

            % Fills Channel Properties
            clientProperties.DevicePlugin = fullfile(toolboxdir(fullfile('shared','networklib','bin',computer('arch'))),'tcpserverdevice');
            clientProperties.ConverterPlugin = fullfile(toolboxdir(fullfile('shared','networklib','bin',computer('arch'))),'networkarrayconverter');
            clientProperties.InterfaceName = "tcpserver";
            clientProperties.InterfaceObjectName = "t";

            if ~isempty(address)
                options = struct("ServerType",1,"PortNumber",double(port),"MaxConnections",1,"Address",address);
            else
                % Default address "::" will be used
                options = struct("ServerType",1,"PortNumber",double(port),"MaxConnections",1);
            end

            % Assigns options to create AsyncIO Channel for TCPServer
            clientProperties.AsyncIOOptions = options;

            % Creates and stores custom EventHandler for handling
            % connection/disconnection events.
            clientProperties.EventHandler = tcpserver.internal.EventHandler;

            % Creates and stores handle to TCPServer to fire connection and
            % data callback functions with the required source.
            clientProperties.CallbackSource = obj;

            client = tcpserver.internal.TCPServerCustomClient(clientProperties);
        end

        function obj = setCustomDisplay(obj)
            % The list of properties to display under each corresponding
            % group name. The first group will be shown by default.
            obj.PropertyGroupList = {obj.DefaultPropertyDisplay,obj.CommunicationPropertiesList, ...
                obj.BytesAvailablePropertiesList,obj.AdditionalPropertiesList};

            % The group names for the above PropertyGroupList.
            obj.PropertyGroupNames = strings(1,length(obj.PropertyGroupList));
        end

        function initProperties(obj,nvPairs)
            % Parses name-value pair input arguments and assigns to properties

            p = inputParser;
            p.PartialMatching = true;

            addParameter(p,'Timeout',getProperty(obj.Client,"Timeout"),@(x) validateattributes(x,{'numeric'},{'nonempty'}));
            addParameter(p,'ByteOrder',getProperty(obj.Client,"ByteOrder"),@(x) validateattributes(x,{'char','string'},{'nonempty'}));
            addParameter(p,'ConnectionChangedFcn',obj.Client.ConnectionChangedFcn);
            addParameter(p,'Tag',"", @(x) isstring(x) || ischar(x));

            parse(p,nvPairs{:});
            output = p.Results;
            obj.Timeout = output.Timeout;
            obj.ByteOrder = output.ByteOrder;
            obj.ConnectionChangedFcn = output.ConnectionChangedFcn;
            obj.Tag = output.Tag;
        end

        function validateConnected(obj)
            % Throws error if no client is connected to the server when
            % write, writeline or writebinblock is called.
            if ~obj.Connected
                throwAsCaller(MException(message('instrument:interface:tcpserver:NotConnectedWrite')));
            end
        end
    end

    %% Save / Load
    % Save and Load are both disabled
    methods (Sealed, Hidden)
        function info = saveobj(obj)
            info = [];

            if ~obj.HasSaveWarningBeenIssued
                obj.HasSaveWarningBeenIssued = true;

                warningState = warning('off','backtrace');
                oc = onCleanup(@() warning(warningState));

                warning(message("instrument:interface:tcpserver:NoSave"));
            end
        end
    end

    methods (Hidden, Static)
        function resource = loadobj(~)
            warning(message("instrument:interface:tcpserver:NoLoad"));
            resource = tcpserver.internal.TCPServer.empty;
        end
    end
end