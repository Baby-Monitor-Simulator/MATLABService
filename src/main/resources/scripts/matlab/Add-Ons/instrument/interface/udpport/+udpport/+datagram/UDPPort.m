classdef (Sealed) UDPPort < matlabshared.testmeas.internal.SetGet & ...
                            matlabshared.testmeas.CustomDisplay & ...
                            matlabshared.transportlib.internal.compatibility.LegacyUDPDatagram & ...
                            udpport.UDPPortBase
                           
    % UDPPORT class creates and returns the datagram type UDPPort object.
    %
    %   u = UDPPORT.DATAGRAM.UDPPORT(IPADDRESSVERSION) constructs a udpport
    %   datagram object, u, with the specified IPADDRESSVERSION. The
    %   allowed values for IPADDRESSVERSION are "IPV4" and "IPV6".
    %
    %   u = UDPPORT.DATAGRAM.UDPPORT(IPADDRESSVERSION,"NAME","VALUE", ...)
    %   constructs a udpport datagram object, u, with the specified
    %   IPADDRESSVERSION, and one or more name-value pair arguments. The
    %   allowed values for IPADDRESSVERSION are "IPV4" and "IPV6". If an
    %   invalid property name or property value is specified the object
    %   will not be created. udpport properties that can be set using
    %   name-value pair arguments are LocalHost, LocalPort, Timeout, Tag,
    %   ByteOrder, OutputDatagramSize, and EnablePortSharing. See
    %   properties help for accepted values.
    %
    %   UDPPORT methods:
    %
    %   READ METHODS
    %   <a href="matlab:help udpport.datagram.UDPPort.read">read</a>                - Read data from the udpport socket
    %
    %   WRITE METHODS
    %   <a href="matlab:help udpport.datagram.UDPPort.write">write</a>               - Write data to the udpport socket
    %
    %   OTHER METHODS
    %   <a href="matlab:help udpport.datagram.UDPPort.configureCallback">configureCallback</a>   - Set the datagrams available callback properties
    %   <a href="matlab:help udpport.datagram.UDPPort.configureMulticast">configureMulticast</a>  - Set multicast properties for the udpport socket
    %   <a href="matlab:help udpport.datagram.UDPPort.flush">flush</a>               - Clear the input and/or output buffers of the udpport socket
    %
    %   UDPPORT properties:
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
    %   <a href="matlab:help matlabshared.transportlib.internal.TagAccessor.Tag">Tag</a>                         - Unique identifier name for the udpport object
    %   <a href="matlab:help udpport.datagram.UDPPort.NumDatagramsAvailable">NumDatagramsAvailable</a>       - Number of datagrams available to be read
    %   <a href="matlab:help udpport.datagram.UDPPort.NumDatagramsWritten">NumDatagramsWritten</a>         - Number of datagrams written to the udpport socket
    %   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcn">DatagramsAvailableFcn</a>       - Function handle to be called when a Datagrams Available event occurs
    %   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnCount">DatagramsAvailableFcnCount</a>  - Number of datagrams in the input buffer that triggers a Datagrams Available event
    %   <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnMode">DatagramsAvailableFcnMode</a>   - Condition for firing DatagramsAvailableFcn callback
    %   <a href="matlab:help udpport.datagram.UDPPort.ErrorOccurredFcn">ErrorOccurredFcn</a>            - Function handle to be called when an error event occurs
    %   <a href="matlab:help udpport.datagram.UDPPort.UserData">UserData</a>                    - Application specific data for the udpport instance
    %
    %   Examples:
    %
    %       % Construct a udpport datagram object.
    %       u = udpport.datagram.UDPPort("datagram", "IPV4")
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

    %% Common UDP Dependent Properties
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

        % UserData - Stores application-specific data.
        % Read/Write Access - Both
        % Accepted Values - Any MATLAB type
        % Default - []
        UserData

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
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureMulticast">configureMulticast</a> function.
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
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureMulticast">configureMulticast</a> function.
        EnableMulticastLoopback

        % MulticastGroup - The IP Address group to which the udpport 
        %   instance is subscribed to get multicast data.
        % Read/Write Access - Read-only
        % Accepted Values - "224.0.0.0" to "239.255.255.255" for
        %   IPAddressVersion "IPV4", addresses starting with "ff00"
        %   (ff00::/8) for IPAddressVersion "IPV6"
        % Default - ""
        %
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureMulticast">configureMulticast</a> function.
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
    end

    %% UDPPort Datagram only dependent properties
    properties (Dependent)
        % DatagramsAvailableFcnCount - Number of datagrams in the input buffer 
        %    that triggers DatagramsAvailableFcn, when DatagramsAvailableFcnMode
        %    is set to "datagram".
        % Accepted Values - Positive integer values
        % Read/Write Access - Read-only
        % Default - 1
        %
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureCallback">configureCallback</a> function.
        DatagramsAvailableFcnCount

        % NumDatagramsAvailable - Number of datagrams available to be read.
        % Read/Write Access - Read-only
        NumDatagramsAvailable

        % NumDatagramsWritten - Number of datagrams written to the udpport
        %    socket.
        % Read/Write Access - Read-only
        % Default - 0
        NumDatagramsWritten
    end

    properties
        % DatagramsAvailableFcnMode - Turns datagrams available callback off
        %     or specifies the condition for triggering the datagrams available
        %     callback, when DatagramsAvailableFcnCount number of datagrams
        %     are available to be read.
        % Read/Write Access - Read-only
        % Accepted Values - "datagram", "off"
        % Default - "off"
        %
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureCallback">configureCallback</a> function.
        DatagramsAvailableFcnMode = "off"

        % DatagramsAvailableFcn - Callback function that gets triggered when
        %     a datagrams available event occurs.
        % Read/Write Access - Read-only
        % Accepted Values - function_handle
        % Default - []
        %
        % To set this property, use <a href="matlab:help udpport.datagram.UDPPort.configureCallback">configureCallback</a> function.
        DatagramsAvailableFcn = function_handle.empty()

        % ErrorOccurredFcn - The function that gets called when an error
        %   event occurs.
        % Read/Write Access - Both
        % Accepted Values - function_handle
        % Default - []
        ErrorOccurredFcn = function_handle.empty()
    end

    properties (Access = private, Hidden)
        % Set read-only properties like DatagramsAvailableFcnMode,
        % DatagramsAvailableFcn, and DatagramsAvailableFcnCount to be set
        % from within the configure methods.
        AllowSetReadOnlyProperty (1, 1) logical = false

        % The handle to the UDPPortCommon instance
        UDPCommon

        % The doc ID to be used in read timeout warning when no data was
        % read.
        DocIDNoData

        % The doc ID to be used in read timeout warning when some data was
        % read.
        DocIDSomeData

        % Flag for whether the warning on invoking the save method has been
        % issued.
        SaveWarningIssued (1, 1) logical = false
    end

    properties(Access = ?instrument.internal.ITestable, Hidden)
        % The handle to the internal udp transport.
        Transport
    end

    properties(Access = ?instrument.internal.ITestable, Dependent, Hidden)
        % Check whether the internal transport is connected.
        Connected (1, 1) logical
    end

    %% Custom Display Properties
    properties(Access = private, Constant, Hidden)
       MainProperties = ["IPAddressVersion", "LocalHost", "LocalPort", "Tag", ...
           "NumDatagramsAvailable"]

       PropertiesSet1 = ["ByteOrder", "Timeout"]

       PropertiesSet2 = ["EnablePortSharing", "EnableBroadcast", "EnableMulticast", ...
           "EnableMulticastLoopback", "MulticastGroup"]

       PropertiesSet3 = ["DatagramsAvailableFcnMode", "DatagramsAvailableFcnCount", ...
           "DatagramsAvailableFcn", "OutputDatagramSize", "NumDatagramsWritten"]

       PropertiesSet4 = ["ErrorOccurredFcn", "UserData"]
    end

    %% Other Properties
    properties(Constant, Hidden)
        InterfaceName (1, 1) string = "udpport"
    end

    %% Lifetime
    methods
        function obj = UDPPort(addressType, varargin)
            try
                varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
                obj.Transport = matlabshared.transportlib.internal.TransportFactory. ...
                    getTransport("udp");
                obj.Transport.CFIName = obj.InterfaceName;
                obj.IPAddressVersion = addressType;

                % Create UDPCommon instance
                obj.UDPCommon = udpport.UDPPortCommon(obj.Transport);

                % Initialize Properties
                initProperties(obj.UDPCommon, varargin{:});
                parseNVPairForTag(obj, varargin{:});

                % Set properties necessary for udpport custom display.
                setCustomDisplay(obj);

                % Set the Transport's ErrorOccuredFcn
                obj.Transport.ErrorOccurredFcn = @obj.errorCallbackFunction;

                % Get the doc id links for udpport
                [obj.DocIDNoData, obj.DocIDSomeData] = ...
                    instrument.internal.warningMessagesHelpers.getReadWarningDocLinks("udpport");
            catch ex
               throwAsCaller(ex);
            end

            try
                connect(obj.Transport);
            catch connectError
                % Throws connection errors with troubleshooting doc link appended
                throwErrorWithDocLink(obj, connectError, addressType);
            end

            obj.Transport.AllowPartialReads = true;
        end

        function delete(obj)
            obj.UDPCommon = [];
            obj.Transport = [];
        end
    end

    %% API methods
    methods
        function write(obj, varargin)
            %WRITE Write data to the udpport socket.
            %
            %   WRITE(OBJ,DATA,PRECISION,DESTINATIONADDRESS,DESTINATIONPORT)
            %   sends the 1xN or Nx1 matrix of DATA to the specified
            %   DESTINATIONADDRESS and DESTINATIONPORT. The data is cast to
            %   the specified PRECISION regardless of the actual precision.
            %
            %   WRITE(OBJ,DATA,DESTINATIONADDRESS,DESTINATIONPORT) sends
            %   the 1xN or Nx1 matrix of DATA to the specified DESTINATIONADDRESS
            %   and DESTINATIONPORT as "UINT8" precision.
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
                write(obj.UDPCommon, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
        
        function data = read(obj, varargin)
            %READ Read data from the udpport socket.
            %
            %   DATA = READ(OBJ,COUNT) reads the specified number of
            %   datagrams, COUNT, with the precision set to "UINT8", from
            %   the udpport socket, OBJ, and returns to DATA. DATA is
            %   represented as a 1xN udpport.datagram.Datagram array.
            %
            %   DATA = READ(OBJ,COUNT,PRECISION) reads the specified number
            %   of values, COUNT, with the precision specified by
            %   PRECISION, from the udpport socket, OBJ, and returns to
            %   DATA. DATA is represented as a 1xN
            %   udpport.datagram.Datagram array. DATA has the following
            %   fields - Data, SenderAddress, and SenderPort. For numeric
            %   PRECISION types DATA.Data is represented as a DOUBLE array
            %   in row format. For char and string PRECISION types,
            %   DATA.Data is represented as is.
            %
            % Input Arguments:
            %   COUNT indicates the number of datagrams to read. COUNT
            %   cannot be set to 0, INF or NAN. If COUNT is greater than
            %   the NumDatagramsAvailable property of OBJ, then this
            %   function waits until the specified number of datagrams,
            %   COUNT, is read or a timeout occurs.
            %
            %   PRECISION indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   PRECISION must be one of "UINT8", "INT8", "UINT16",
            %   "INT16", "UINT32", "INT32", "UINT64", "INT64", "SINGLE",
            %   "DOUBLE", "CHAR", or "STRING".
            %
            % Output Arguments:
            %   DATA is a 1xN array of type of udpport.datagram.Datagram.
            %   If no data was returned, this is [].
            %
            % Note:
            %   READ waits until the requested number of datagrams are read
            %   from the udpport socket.
            %
            % Example:
            %      % Read 5 datagrams as "uint32" (5*4 = 20 bytes).
            %      data = read(u,5,"uint32");
            try
                narginchk(2, 3);
            catch
                throwAsCaller(getReadNarginError(obj));
            end

            count = varargin{1};
            switch nargin
                case 2
                    precision = "uint8";
                case 3
                    precision = varargin{2};
            end
            [dataValues, senderAddress, senderPort] = read(obj.Transport, count, precision);

            % Check for totalPacketsRead. If totalPacketsRead is less than
            % count, we read less than what count was specified to - show
            % the read timeout warning.
            totalPacketsRead = length(senderPort);
            if totalPacketsRead < count
                obj.displayReadWarning(totalPacketsRead);
            end

            if totalPacketsRead == 0
                data = [];
                return
            end

            % Prepare the datagram type data.
            data = udpport.datagram.Datagram;
            for i = 1 : length(senderPort)
                dataTemp = obj.convertNumericToDouble(dataValues{i}, precision);
                addressTemp = string(senderAddress{i});
                senderPortTemp = senderPort{i};
                data(i) = udpport.datagram.Datagram(dataTemp, addressTemp, senderPortTemp);
            end
        end

        function configureMulticast(obj, varargin)
            %CONFIGUREMULTICAST Set the multicast properties for the
            % udpport socket.
            % 1. <a href="matlab:help udpport.datagram.UDPPort.EnableMulticast">EnableMulticast</a> 
            % 2. <a href="matlab:help udpport.datagram.UDPPort.MulticastGroup">MulticastGroup</a>
            % 3. <a href="matlab:help udpport.datagram.UDPPort.EnableMulticastLoopback">EnableMulticastLoopback</a>
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
                configureMulticast(obj.UDPCommon, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureCallback(obj, varargin)
            %CONFIGURECALLBACK Set the DatagramAvailable properties:
            % 1. <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnMode">DatagramsAvailableFcnMode</a> 
            % 2. <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcnCount">DatagramsAvailableFcnCount</a>
            % 3. <a href="matlab:help udpport.datagram.UDPPort.DatagramsAvailableFcn">DatagramsAvailableFcn</a>
            %
            % CONFIGURECALLBACK(OBJ,"off") turns the DatagramsAvailable
            % callbacks off.
            %
            % CONFIGURECALLBACK(OBJ,"datagram",COUNT,CALLBACKFCN) sets the
            % DatagramsAvailableFcnMode property to "datagram". CALLBACKFCN
            % is the function handle that is assigned to the
            % DatagramsAvailableFcn property. CALLBACKFCN is triggered
            % whenever COUNT number of datagrams are available to be read.
            % DatagramsAvailableFcnCount property is set to COUNT.
            %
            % Input Arguments:
            %   COUNT sets the DatagramsAvailableFcnCount property and can
            %   be specified as any positive integer value.
            %
            %   CALLBACKFCN sets the DatagramsAvailableFcn property and can
            %   be specified as any function_handle.
            %
            % Example:
            %      % Turn the callback off
            %      configureCallback(u,"off")
            %
            %      % Set the DatagramsAvailableFcnMode to "datagram". This
            %      % triggers the callback function "callbackFcn" when 5
            %      % datagrams are available to be read.
            %      configureCallback(u,"datagram",5,@callbackFcn)

            if ~(nargin == 2 || nargin == 4)
                throwAsCaller(getConfigureCallbackNarginError(obj));
            end

            try
                mode = validatestring(varargin{1}, ["datagram", "off"], "configureCallback", "MODE");

                % Validate that "datagram" or "off" is called with the
                % correct function syntax.
                obj.validateModeSyntax(mode, nargin);
            catch ex
                throwAsCaller(ex);
            end
            try
                % Allow for the class private properties
                obj.AllowSetReadOnlyProperty = true;
                obj.DatagramsAvailableFcnMode = mode;
                switch mode
                    case "off"
                        % configureCallback(u, "off");
                        obj.Transport.DatagramsAvailableFcn = function_handle.empty();
                        obj.DatagramsAvailableFcn = [];
                    case "datagram"
                        % configureCallback(u, "datagram", DatagramsAvailableFcnCount, DatagramsAvailableFcn);
                        obj.DatagramsAvailableFcnCount = varargin{2};
                        obj.DatagramsAvailableFcn = varargin{3};
                        obj.Transport.DatagramsAvailableFcn = @obj.callbackFunction;
                end
                obj.AllowSetReadOnlyProperty = false;
            catch ex
                obj.AllowSetReadOnlyProperty = false;
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
                narginchk(1, 2);
            catch
                throwAsCaller(getFlushNarginError(obj));
            end
            try
                if nargin == 1
                    % No value passed to buffer, flush both input and
                    % output.
                    flushInput(obj.Transport);
                    flushOutput(obj.Transport);
                else
                    % Validate buffer to be either "input" or "output"
                    buffer = validatestring(varargin{1}, ["input", "output"], "flush", "BUFFER", 2);

                    % flush input or output buffer.
                    if buffer == "input"
                        flushInput(obj.Transport);
                    else
                        flushOutput(obj.Transport);
                    end
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Getters and Setters
    methods
        function value = get.Connected(obj)
            value = obj.Transport.Connected;
        end

        function set.Connected(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "Connected")));
        end

        function value = get.IPAddressVersion(obj)
            value = string(obj.Transport.AddressType);
        end

        function set.IPAddressVersion(obj, value)
            if obj.Connected
                throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "IPAddressVersion", "the udpport constructor")));
            end
            try
                value = validatestring(value, ["IPV4", "IPV6"], mfilename, "IPADDRESSVERSION");
                obj.Transport.AddressType = value;
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.LocalHost(obj)
            value = string(obj.Transport.LocalHost);
        end

        function set.LocalHost(~, ~)
            % Setting LocalHost using the setter errors. The LocalHost set
            % using NV pairs is set using UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "LocalHost", str)));
        end

        function value = get.LocalPort(obj)
            value = obj.Transport.LocalPort;
        end

        function set.LocalPort(~, ~)
            % Setting LocalPort using the setter errors. The LocalPort set
            % using NV pairs is set using UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "LocalPort", str)));
        end

        function value = get.Timeout(obj)
            value = obj.Transport.Timeout;
        end

        function set.Timeout(obj, value)
            try
                validateattributes(value, {'double'}, {'positive'}, mfilename, "TIMEOUT");
                obj.Transport.Timeout = value;
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
        end

        function value = get.ByteOrder(obj)
            value = string(obj.Transport.ByteOrder);
        end

        function set.ByteOrder(obj, value)
            try
                obj.Transport.ByteOrder = value;
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
        end

        function value = get.OutputDatagramSize(obj)
            value = obj.Transport.OutputDatagramPacketSize;
        end

        function set.OutputDatagramSize(obj, value)
            try
                validateattributes(value,{'numeric'}, ...
                    {'scalar', 'integer', 'nonnan', 'finite', 'positive', ...
                    "<=", 65507}, "", "OUTPUTDATAGRAMSIZE");

                % udpport object is connected. Set the
                % OutputDatagramPacketSize property on the internal UDP
                % object. OutputDatagramSize using NV pairs is set using
                % UDPPortCommon.
                setOutputDatagramPacketSize(obj.Transport, value);
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
        end

        function set.ErrorOccurredFcn(obj, value)
            if isnumeric(value) && isempty(value)
                value = function_handle.empty();
            end
            try
                validateattributes(value,{'function_handle'},{},"UDPPort","ErrorOccurredFcn");
                obj.ErrorOccurredFcn = value;
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
        end

        function value = get.UserData(obj)
            value = obj.Transport.UserData;
        end

        function set.UserData(obj, value)
            obj.Transport.UserData = value;
        end

        function value = get.EnableBroadcast(obj)
            value = obj.Transport.EnableBroadcast;
        end

        function set.EnableBroadcast(obj, value)
            try
                setEnableBroadcast(obj.Transport, value);
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
        end

        function value = get.EnableMulticast(obj)
            value = obj.Transport.EnableMulticast;
        end

        function set.EnableMulticast(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "EnableMulticast", str)));
        end

        function value = get.EnableMulticastLoopback(obj)
            value = obj.Transport.EnableDatagramLoopback;
        end

        function set.EnableMulticastLoopback(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "EnableMulticastLoopback", str)));
        end

        function value = get.MulticastGroup(obj)
            value = string(obj.Transport.MulticastGroup);
        end

        function set.MulticastGroup(~, ~)
            str = message("instrument:interface:udpport:ConfigureMethod", "configureMulticast").getString();
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "MulticastGroup", str)));
        end

        function value = get.EnablePortSharing(obj)
            value = obj.Transport.EnablePortSharing;
        end

        function set.EnablePortSharing(~, ~)
            % Setting EnablePortSharing using the setter errors. The
            % EnablePortSharing set using NV pairs is set using
            % UDPPortCommon.
            str = message("instrument:interface:udpport:NVPairs").getString();
            throwAsCaller(MException(message("instrument:interface:udpport:ReadOnly", "EnablePortSharing", str)));
        end

        function value = get.DatagramsAvailableFcnCount(obj)
            value = obj.Transport.DatagramsAvailableEventCount;
        end

        function set.DatagramsAvailableFcnCount(obj, value)
            try
                if obj.AllowSetReadOnlyProperty
                    validateattributes(value,{'numeric'}, {'>',0, 'integer', 'scalar', 'finite', 'nonnan'},mfilename,'DatagramsAvailableFcnCount');
                    obj.Transport.DatagramsAvailableEventCount = value;
                    return
                end
            catch ex
                throwAsCaller(getInvalidEntryError(obj, ex));
            end
            str = message("instrument:interface:udpport:ConfigureMethod", "configureCallback").getString;
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "DatagramsAvailableFcnCount", str)));
        end

        function set.DatagramsAvailableFcnMode(obj, value)
            if obj.AllowSetReadOnlyProperty %#ok<MCSUP>

                % No need to validate the value - validation has been
                % done at the configureCallback method
                obj.DatagramsAvailableFcnMode = value;
                return
            end
            str = message("instrument:interface:udpport:ConfigureMethod", "configureCallback").getString;
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "DatagramsAvailableFcnMode", str)));
        end

        function value = get.DatagramsAvailableFcn(obj)
            value = obj.DatagramsAvailableFcn;
        end

        function set.DatagramsAvailableFcn(obj, value)
            try
                if obj.AllowSetReadOnlyProperty %#ok<MCSUP>
                    if isnumeric(value) && isempty(value)
                        value = function_handle.empty;
                    end
                    validateattributes(value, {'function_handle'}, {});
                    obj.DatagramsAvailableFcn = value;
                    return
                end
            catch ex
               throwAsCaller(getInvalidEntryError(obj, ex));
            end
            str = message("instrument:interface:udpport:ConfigureMethod", "configureCallback").getString;
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ReadOnly", "DatagramsAvailableFcn", str)));
        end

        function value = get.NumDatagramsAvailable(obj)
            value = obj.Transport.NumDatagramsAvailable;
        end

        function set.NumDatagramsAvailable(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "NumDatagramsAvailable")));
        end

        function value = get.NumDatagramsWritten(obj)
            value = obj.Transport.NumDatagramsWritten;
        end

        function set.NumDatagramsWritten(~, ~)
            throwAsCaller(MException( ...
                message("instrument:interface:udpport:ErrorReadOnly", "NumDatagramsWritten")));
        end
    end

    %% Helper methods for throwing errors
    methods(Access = private)
        function ex = getReadNarginError(~)
            % Return the read MException for incorrect nargin.
            validSyntaxes = message("instrument:interface:udpport:ReadSyntax").getString;
            ex = MException(message("instrument:interface:udpport:IncorrectInputArgumentsPlural", ...
                "read", validSyntaxes));
        end

        function ex = getConfigureCallbackNarginError(~)
            % Return the configureCallback MException for incorrect nargin.
            validSyntaxes = message("instrument:interface:udpport:ConfigureCallbackSyntax").getString;
            ex = MException(message("instrument:interface:udpport:IncorrectInputArgumentsPlural", ...
                "configureCallback", validSyntaxes));
        end

        function ex = getFlushNarginError(~)
            % Return the flush MException for incorrect nargin.
            validSyntaxes = message("instrument:interface:udpport:FlushSyntax").getString;
            ex = MException(message("instrument:interface:udpport:IncorrectInputArgumentsPlural", ...
                "flush", validSyntaxes));
        end

        function mExc = getInvalidEntryError(~, ex)
            % Return the invalid entry MException for setting incorrect
            % property values on the UDPPort object.
            mExc = MException("instrument:interface:udpport:InvalidEntry", ex.message);
        end
    end

    %% Other helper methods
    methods (Access = ?instrument.internal.ITestable)

        function setCustomDisplay(obj)
            % Prepare the property groups for disp(udpport).
            obj.PropertyGroupList = {obj.MainProperties, obj.PropertiesSet1, ...
                obj.PropertiesSet2, obj.PropertiesSet3, obj.PropertiesSet4};
            obj.PropertyGroupNames = ["" "" "" "" ""];
        end

        function displayReadWarning(obj, totalPacketsRead)
            if totalPacketsRead == 0
                warnData = 'nodata';
                docId = obj.DocIDNoData;
            else
                warnData = 'somedata';
                docId = obj.DocIDSomeData;
            end

            % Display the warning.
            warningstr = ...
                instrument.internal.warningMessagesHelpers. ...
                getReadWarning('', 'udpport', docId, warnData);
            warnState = warning('backtrace', 'off');
            cleanup = onCleanup(@()warning(warnState));
            messageId = "instrument:interface:udpport:ReadWarning";
            warningstr = message(messageId, warningstr).getString;
            warning(messageId, warningstr);
        end

        function data = convertNumericToDouble(~, data, precision)
            % This helper function represents numeric 'precision' type data
            % as double for any read operation.
            if string(precision) ~= "string" && string(precision) ~= "char"
                data = double(data);
            end
        end
        
        function validateModeSyntax(obj, mode, numargs)
            % This helper function checks for the proper formatting of the
            % configureCallback function.
            
            % If numargs == 2, this means the only possible
            % DatagramsAvailableFcnMode is "off". Error for other cases.
            % If numargs == 4, the only possibility of
            % DatagramsAvailableFcnMode is "datagram". Error for other cases.
            if (numargs == 2 && string(mode) ~= "off") || ...
                    (numargs == 4 && string(mode) ~= "datagram")
                validSytax = getDatagramModeSyntax(obj, mode);
                throw(MException(message ...
                    ("instrument:interface:udpport:IncorrectDatagramsAvailableModeSyntax", ...
                    validSytax)));
            end
        end
        
        function validSyntax = getDatagramModeSyntax(~, mode)
            % Returns the valid function syntax for configureCallback for
            % mode set to "off" or "datagram"
            validSyntax = "";
            switch mode
                case "off"
                    validSyntax = message("instrument:interface:udpport:DatagramFcnModeOff").getString;
                case "datagram"
                    validSyntax = message("instrument:interface:udpport:DatagramFcnModeDatagram").getString;
            end
        end
        
        function callbackFunction(obj, ~, evt)
            % This is the callback function that gets fired whenever a
            % datagrams available callback event occurs. The
            % DatagramsAvailableFcn contains the function handle for the
            % specified callback function, set in configureCallback.
            
            dataAvailableInfo = udpport.datagram.DatagramAvailableInfo( ...
                obj.DatagramsAvailableFcnCount, evt.AbsTime);
            obj.DatagramsAvailableFcn(obj, dataAvailableInfo);
        end
        
        function errorCallbackFunction(obj, ~, ex)
            % This is the callback function that gets fired whenever a
            % udpport asynchronous error occurs.

            if ~isempty(obj.ErrorOccurredFcn)
                obj.ErrorOccurredFcn(ex);
            else
                fprintf(2, ex.Message);
                fprintf('\n');
            end
        end

        function throwErrorWithDocLink(~, connectError, addressType)
            % Throws connection errors with troubleshooting doc link appended

            % Retrieves troubleshooting doc link
            docRef = instrument.internal.errorMessagesHelpers.getConnectErrorDocLink("udpport");

            if string(connectError.identifier) == "network:udp:connectFailed"
                mExcept = MException(message("instrument:interface:udpport:ConnectFailed", addressType));
                strComplete = string(mExcept.message) + newline + docRef;
                throwAsCaller(MException("instrument:interface:udpport:ConnectFailed", strComplete));
            else
                strComplete = string(connectError.message) + newline + docRef;
                throwAsCaller(MException(connectError.identifier, strComplete));
            end
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
            udpportInstance = udpport.datagram.UDPPort.empty;
        end
    end
end
