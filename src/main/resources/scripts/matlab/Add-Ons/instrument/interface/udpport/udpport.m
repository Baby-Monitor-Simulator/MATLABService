function obj = udpport(varargin)
%UDPPORT function binds to a udp socket. You can read the data back as
%bytes or datagrams from the udpport instance.
%
%   u = UDPPORT constructs a byte type IPV4 udpport object, u.
%
%   u = UDPPORT(TYPE) constructs a udpport object, u, of the specified TYPE
%   with IPADDRESSVERSION set to IPV4. The allowed values for TYPE are
%   "byte" and "datagram".
%
%   u = UDPPORT(IPADDRESSVERSION) constructs a byte type udpport object, u,
%   and the specified IPADDRESSVERSION. The allowed values for
%   IPADDRESSVERSION are "IPV4" and "IPV6".
%
%   u = UDPPORT(TYPE,IPADDRESSVERSION) constructs a udpport object, u, of
%   the specified TYPE and IPADDRESSVERSION.  The allowed values for TYPE
%   are "byte" and "datagram". The allowed values for IPADDRESSVERSION are
%   "IPV4" and "IPV6".
%
%   u = UDPPORT("NAME","VALUE", ...) constructs a byte type IPV4 udpport
%   object, u, using one or more name-value pair arguments. If an invalid
%   property name or property value is specified the object will not be
%   created. udpport properties that can be set using name-value pair
%   arguments are LocalHost, LocalPort, Timeout, Tag, ByteOrder,
%   OutputDatagramSize, and EnablePortSharing. See properties help for
%   accepted values.
%
%   u = UDPPORT(TYPE,"NAME","VALUE", ...) constructs an IPV4 udpport
%   object, u, of the specified TYPE, and one or more name-value pair
%   arguments. The allowed values for TYPE are "byte" and "datagram". If an
%   invalid property name or property value is specified the object will
%   not be created. udpport properties that can be set using name-value
%   pairs are LocalHost, LocalPort, Tag, Timeout, ByteOrder,
%   OutputDatagramSize, and EnablePortSharing. See properties help for
%   accepted values.
%
%   u = UDPPORT(IPADDRESSVERSION,"NAME","VALUE", ...) constructs a byte
%   type udpport object, u, the specified IPADDRESSVERSION, and one or more
%   name-value pair arguments. The allowed values for IPADDRESSVERSION are
%   "IPV4" and "IPV6". If an invalid property name or property value is
%   specified the object will not be created. udpport properties that can
%   be set using name-value pair arguments are LocalHost, LocalPort,
%   Timeout, Tag, ByteOrder, OutputDatagramSize, and EnablePortSharing. See
%   properties help for accepted values.
%
%   u = UDPPORT(TYPE,IPADDRESSVERSION,"NAME","VALUE", ...) constructs a
%   udpport object, u, with the specified TYPE, the specified
%   IPADDRESSVERSION, and one or more name-value pair arguments. The
%   allowed values for TYPE are "byte" and "datagram". The allowed values
%   for IPADDRESSVERSION are "IPV4" and "IPV6".  If an invalid property
%   name or property value is specified the object will not be created.
%   udpport properties that can be set using name-value pair arguments are
%   LocalHost, LocalPort, Timeout, Tag, ByteOrder, OutputDatagramSize, and
%   EnablePortSharing. See properties help for accepted values.
%
%   UDPPORT BYTE methods:
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
%   <a href="matlab:help udpport.byte.UDPPort.configureCallback">configureCallback</a>   - Set the Bytes Available callback properties
%   <a href="matlab:help udpport.byte.UDPPort.configureTerminator">configureTerminator</a> - Set the udpport read and write terminator properties
%   <a href="matlab:help udpport.byte.UDPPort.configureMulticast">configureMulticast</a>  - Set multicast properties for the udpport socket
%   <a href="matlab:help udpport.byte.UDPPort.flush">flush</a>               - Clear the input and/or output buffers of the udpport socket
%
%   UDPPORT BYTE properties:
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
%   <a href="matlab:help matlabshared.transportlib.internal.TagAccessor.Tag">Tag</a>                     - Unique identifier name for the udpport object
%   <a href="matlab:help udpport.byte.UDPPort.NumBytesAvailable">NumBytesAvailable</a>       - Number of bytes available to be read
%   <a href="matlab:help udpport.byte.UDPPort.NumBytesWritten">NumBytesWritten</a>         - Number of bytes written to the udpport socket
%   <a href="matlab:help udpport.byte.UDPPort.Terminator">Terminator</a>              - Read and write terminator for the ASCII-terminated string communication
%   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcn">BytesAvailableFcn</a>       - Function handle to be called when a bytes available event occurs
%   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnCount">BytesAvailableFcnCount</a>  - Number of bytes in the input buffer that triggers a bytes available event
%                             (Only applicable for BytesAvailableFcnMode = "byte")
%   <a href="matlab:help udpport.byte.UDPPort.BytesAvailableFcnMode">BytesAvailableFcnMode</a>   - Condition for firing BytesAvailableFcn callback
%   <a href="matlab:help udpport.byte.UDPPort.ErrorOccurredFcn">ErrorOccurredFcn</a>        - Function handle to be called when an error event occurs
%   <a href="matlab:help udpport.byte.UDPPort.UserData">UserData</a>                - Application specific data for the udpport instance
%
%   UDPPORT DATAGRAM methods:
%
%   READ METHODS
%   <a href="matlab:help udpport.datagram.UDPPort.read">read</a>                - Read data from the udpport socket
%
%   WRITE METHODS
%   <a href="matlab:help udpport.datagram.UDPPort.write">write</a>               - Write data to the udpport socket
%
%   OTHER METHODS
%   <a href="matlab:help udpport.datagram.UDPPort.configureCallback">configureCallback</a>   - Set the Bytes Available callback properties
%   <a href="matlab:help udpport.datagram.UDPPort.configureMulticast">configureMulticast</a>  - Set multicast properties for the udpport socket
%   <a href="matlab:help udpport.datagram.UDPPort.flush">flush</a>               - Clear the input and/or output buffers of the udpport socket
%
%   UDPPORT DATAGRAM properties:
%
%   <a href="matlab:help udpport.datagram.UDPPort.IPAddressVersion">IPAddressVersion</a>            - The version type for the IP Address
%   <a href="matlab:help udpport.datagram.UDPPort.LocalHost">LocalHost</a>                   - The local hostname or the IP dotted-decimal address
%   <a href="matlab:help udpport.datagram.UDPPort.LocalPort">LocalPort</a>                   - The port value of the localhost for binding
%   <a href="matlab:help udpport.datagram.UDPPort.ByteOrder">ByteOrder</a>                   - Sequential order in which bytes are arranged into larger numerical values
%   <a href="matlab:help udpport.datagram.UDPPort.Timeout">Timeout</a>                     - Timeout period in seconds for read and write operations
%   <a href="matlab:help udpport.datagram.UDPPort.OutputDatagramSize">OutputDatagramSize</a>          - The maximum number of bytes of data to be written in a Datagram packet
%   <a href="matlab:help udpport.datagram.UDPPort.EnablePortSharing">EnablePortSharing</a>           - Allow other UDP sockets to also bind to this socket's local port
%   <a href="matlab:help udpport.datagram.UDPPort.EnableBroadcast">EnableBroadcast</a>             - Flag to set broadcasting on or off
%   <a href="matlab:help udpport.datagram.UDPPort.EnableMulticast">EnableMulticast</a>             - Flag to indicate Multicast off or on
%   <a href="matlab:help udpport.datagram.UDPPort.MulticastGroup">MulticastGroup</a>              - The IP Address group to subscribe to get multicast data
%   <a href="matlab:help udpport.datagram.UDPPort.EnableMulticastLoopback">EnableMulticastLoopback</a>     - Flag to indicate looping back of data in udpport
%                                 multicast off or on, if the sender is subscribed to the same MulticastGroup.
%   <a href="matlab:help matlabshared.transportlib.internal.TagAccessor.Tag">Tag</a>                           - Unique identifier name for the udpport object
%   <a href="matlab:help udpport.datagram.UDPPort.NumDatagramsAvailable">NumDatagramsAvailable</a>       - Number of datagrams available to be read
%   <a href="matlab:help udpport.datagram.UDPPort.NumDatagramsWritten">NumDatagramsWritten</a>         - Number of datagrams written to the udpport socket
%   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcn">DatagramsAvailableFcn</a>       - Function handle to be called when a Datagrams Available event occurs
%   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnCount">DatagramsAvailableFcnCount</a>  - Number of datagrams in the input buffer that triggers a Datagrams Available event
%   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnMode">DatagramsAvailableFcnMode</a>   - Condition for firing DatagramsAvailableFcn callback
%   <a href="matlab:help udpport.datagram.UDPPort.ErrorOccurredFcn">ErrorOccurredFcn</a>            - Function handle to be called when an error event occurs
%   <a href="matlab:help udpport.datagram.UDPPort.UserData">UserData</a>                    - Application specific data for the udpport instance
%
%   Examples for BYTE type udpport:
%
%       % Construct a udpport byte object.
%       u = udpport("IPV4")
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
%       % Set the bytes available callback properties
%       configureCallback(u,"byte",50,@myCallbackFcn);
%
%       % Flush output buffer
%       flush(u,"output");
%
%       % Disconnect and clear udpport connection
%       clear u
%
%   Examples for DATAGRAM type udpport:
%
%       % Construct a udpport datagram object.
%       u = udpport("datagram", "IPV4")
%
%       % Write 1, 2, 3, 4, 5 as "uint8" data to the destination address
%       % "125.5.1.20" and destination port 4000.
%       write(u,1:5,"uint8","125.5.1.20",4000);
%
%       % Read 1 datagram packet as "uint16"
%       data = read(u,1,"uint16");
%
%       % Subscribe to the multicast address group 226.0.0.1
%       configureMulticast(u,"226.0.0.1");
%
%       % Set the Datagrams Available Callback properties
%       configureCallback(u,"datagram",5,@myCallbackFcn);
%
%       % Flush output buffer
%       flush(u,"output");
%
%       % Disconnect and clear udpport connection
%       clear u

%   Copyright 2020-2023 The MathWorks, Inc.

varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
try
    % Parse the varargin to the udpport input parser to get the mode,
    % addressType, and the NV Pairs.
    [mode, addressType, nvPairs] = udpport.utility.InputParser.parse(varargin{:});

    % Create a udpport object
    obj = udpport.utility.Factory.getInstance(mode, addressType, nvPairs{:});
catch ex
    throwAsCaller(ex);
end
end
