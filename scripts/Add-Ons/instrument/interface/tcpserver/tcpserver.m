function obj = tcpserver(varargin)
%TCPSERVER creates a TCP/IP server that binds to the specified IP
% address and port number. The server listens for TCP/IP client connection
% requests and communicates with the client after establishing a connection.
%
%   OBJ = TCPSERVER("SERVERADDRESS",SERVERPORT) constructs a
%   tcpserver object, OBJ, that binds to and listens for client
%   connections at IP address SERVERADDRESS and port number SERVERPORT.
%
%   OBJ = TCPSERVER(SERVERPORT) constructs a tcpserver object, OBJ,
%   that binds to and listens for client connections at IP address "::"
%   and port number SERVERPORT.
%
%   OBJ = TCPSERVER("SERVERADDRESS",SERVERPORT,"NAME","VALUE",...)
%   constructs a tcpserver object, OBJ, using one or more optional
%   name-value pair arguments. If an invalid property name or property
%   value is specified, then the object is not created.
%   tcpserver properties that can be set using name-value pair
%   arguments are Timeout, Tag, ByteOrder, and ConnectionChangedFcn.
%
%   OBJ = TCPSERVER(SERVERPORT,"NAME","VALUE",...) constructs a
%   tcpserver object, OBJ, using one or more optional name-value pair
%   arguments. If an invalid property name or property value is
%   specified, then the object is not created. tcpserver properties
%   that can be set using name-value pair arguments are Timeout, Tag,
%   ByteOrder, and ConnectionChangedFcn.
%
% Input Arguments:
%   SERVERADDRESS specifies the IP address that the server binds to.
%   The server listens for TCP/IP client connections at this IP address.
%   If SERVERADDRESS is specified as a host name, then it is internally
%   resolved to an IPV4 or IPV6 address, and SERVERADDRESS is set to
%   the resolved IP address.
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
%   <a href="matlab:help tcpserver.internal.TCPServer.read">read</a>                - Read data from the connected client
%   <a href="matlab:help tcpserver.internal.TCPServer.readline">readline</a>            - Read ASCII-terminated string data from the connected client
%   <a href="matlab:help tcpserver.internal.TCPServer.readbinblock">readbinblock</a>        - Read one binblock of data from the connected client
%
%   WRITE METHODS
%   <a href="matlab:help tcpserver.internal.TCPServer.write">write</a>               - Write data to the connected client
%   <a href="matlab:help tcpserver.internal.TCPServer.writeline">writeline</a>           - Write ASCII-terminated string data to the connected client
%   <a href="matlab:help tcpserver.internal.TCPServer.writebinblock">writebinblock</a>       - Write one binblock of data to the connected client
%
%   OTHER METHODS
%   <a href="matlab:help tcpserver.internal.TCPServer.flush">flush</a>               - Clear the input and/or output buffers
%   <a href="matlab:help tcpserver.internal.TCPServer.configureTerminator">configureTerminator</a> - Set the read and write terminator properties
%   <a href="matlab:help tcpserver.internal.TCPServer.configureCallback">configureCallback</a>   - Set the Bytes Available callback properties
%
% TCPSERVER properties:
%
%   <a href="matlab:help tcpserver.internal.TCPServer.ServerAddress">ServerAddress</a>          - IP address that the server binds to. The server listens for TCP/IP client connections at this IP address
%   <a href="matlab:help tcpserver.internal.TCPServer.ServerPort">ServerPort</a>             - Port number that the server binds to. The server listens for TCP/IP client connections at this port number
%   <a href="matlab:help tcpserver.internal.TCPServer.Connected">Connected</a>              - Connection status of the server
%   <a href="matlab:help tcpserver.internal.TCPServer.ClientAddress">ClientAddress</a>          - IP address of the TCP/IP client connected to the server
%   <a href="matlab:help tcpserver.internal.TCPServer.ClientPort">ClientPort</a>             - Port number of the TCP/IP client connected to the server
%   <a href="matlab:help matlabshared.transportlib.internal.TagAccessor.Tag">Tag</a>                    - Unique identifier name for the server
%   <a href="matlab:help tcpserver.internal.TCPServer.NumBytesAvailable">NumBytesAvailable</a>      - Number of bytes available to be read from the input buffer
%   <a href="matlab:help tcpserver.internal.TCPServer.NumBytesWritten">NumBytesWritten</a>        - Number of bytes written to the output buffer
%   <a href="matlab:help tcpserver.internal.TCPServer.Timeout">Timeout</a>                - Waiting time to complete read and write operations
%   <a href="matlab:help tcpserver.internal.TCPServer.ByteOrder">ByteOrder</a>              - Sequential order in which bytes are arranged into larger numerical values
%   <a href="matlab:help tcpserver.internal.TCPServer.UserData">UserData</a>               - Application specific data for tcpserver
%   <a href="matlab:help tcpserver.internal.TCPServer.Terminator">Terminator</a>             - Read and write terminator for the ASCII-terminated string communication
%   <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcn">BytesAvailableFcn</a>      - Callback Function that gets triggered when a Bytes Available event occurs
%   <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcnCount">BytesAvailableFcnCount</a> - Number of bytes in the input buffer that triggers a Bytes Available event
%                            (Only applicable for BytesAvailableFcnMode = "byte")
%   <a href="matlab:help tcpserver.internal.TCPServer.BytesAvailableFcnMode">BytesAvailableFcnMode</a>  - Condition for firing BytesAvailableFcn callback
%   <a href="matlab:help tcpserver.internal.TCPServer.ErrorOccurredFcn">ErrorOccurredFcn</a>       - Callback function that gets triggered when an error event occurs.
%   <a href="matlab:help tcpserver.internal.TCPServer.ConnectionChangedFcn">ConnectionChangedFcn</a>   - Callback function that gets triggered when a connection or disconnection event occurs.
%
% Examples:
%
%       % Construct a tcpserver object to bind to port 4000 and IP address "::".
%       % Verify that the ClientAddress and ClientPort properties are empty and that the Connected property is false.
%       server = tcpserver(4000)
%
%       % Construct a tcpclient object to connect to the existing tcpserver object
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
%       configureTerminator(client,  "CR/LF")
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

% Copyright 2020-2023 The MathWorks, Inc.

try
    obj = tcpserver.internal.TCPServer(varargin{:});
catch ex
    throwAsCaller(ex);
end
end