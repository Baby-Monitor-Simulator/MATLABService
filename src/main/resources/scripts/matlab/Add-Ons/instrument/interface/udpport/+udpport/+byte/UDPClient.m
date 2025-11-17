classdef UDPClient < matlabshared.transportlib.internal.client.GenericClient
    %UDPCLIENT is the Custom Client class for byte.UDPPort

    %   Copyright 2020 The MathWorks, Inc.

    properties(Access = private)
        % The handle to the UDPCommon
        UDPCommon
    end

    %% Lifetime
    methods
        function obj = UDPClient(transportProperties)
            obj@matlabshared.transportlib.internal.client.GenericClient(transportProperties);

            % Create UDPCommon instance
            obj.UDPCommon = udpport.UDPPortCommon(obj.Transport);
        end

        function delete(obj)
           obj.UDPCommon = [];
        end
    end

    %% Access underlying methods
    methods
        function initProperties(obj, varargin)
            % Call through to UDPCommon's initProperties
            try
                initProperties(obj.UDPCommon, varargin{:});
            catch ex
                throw(ex)
            end
        end

        function setEnableBroadcast(obj, val)
            % Call through to internal UDP's setEnableBroadcast
            try
                setEnableBroadcast(obj.Transport, val);
            catch ex
                throw(obj.UserNotificationHandler.translateErrorId(ex));
            end
        end

        function setOutputDatagramSize(obj, val)
            % Call through to internal UDP's setOutputDatagramSize
            setOutputDatagramPacketSize(obj.Transport, val); 
        end

        function write(obj, varargin)
            %WRITE Write data to the udpport socket.
            %   WRITE(OBJ,DATA,PRECISION,DESTINATIONADDRESS,DESTINATIONPORT)
            %   sends the 1xN or Nx1 matrix of DATA to the specified
            %   DESTINATIONADDRESS and DESTINATIONPORT. The data is cast to
            %   the specified precision PRECISION regardless of the actual
            %   precision.
            %
            %   WRITE(OBJ,DATA,DESTINATIONADDRESS,DESTINATIONPORT) sends
            %   the 1xN or Nx1 matrix of DATA to the specified
            %   DESTINATIONADDRESS and DESTINATIONPORT. The default
            %   PRECISION value is "uint8".
            %
            %   WRITE(OBJ,DATA,PRECISION) sends the 1xN or Nx1 matrix of
            %   DATA to the last used DESTINATIONADDRESS and
            %   DESTINATIONPORT. Errors if DESTINATIONADDRESS and
            %   DESTINATIONPORT have not been used using a previous
            %   WRITE/WRITELINE call. The data is cast to the specified
            %   precision PRECISION regardless of the actual precision.
            %
            %   WRITE(OBJ,DATA) sends the 1xN or Nx1 matrix of DATA to the
            %   last used DESTINATIONADDRESS and DESTINATIONPORT. Errors if
            %   DESTINATIONADDRESS and DESTINATIONPORT have not been used
            %   using a previous WRITE/WRITELINE call. The default
            %   PRECISION value is "uint8".
            %
            % Input Arguments:
            %   DATA is a 1xN or Nx1 matrix of numeric or ASCII data. If
            %   size of DATA is greater than OUTPUTDATAGRAMSIZE, the DATA
            %   is broken into 2 or more packets depending on the size of
            %   DATA and the value of OUTPUTDATAGRAMSIZE.
            %
            %   PRECISION controls the number of bits written for each value
            %   and the interpretation of those bits as integer, floating-point,
            %   or character values.
            %   PRECISION must be one of 'CHAR','STRING','UINT8', 'INT8', 'UINT16',
            %   'INT16', 'UINT32', 'INT32', 'UINT64', 'INT64', 'SINGLE', or
            %   'DOUBLE'.
            %
            %   DESTINATIONADDRESS is the remote host to write to. If this
            %   value is not set, the packet will be sent to the last used
            %   destinationAddress. If writing for the first time,
            %   destinationAddress is compulsory, else error.
            %
            %   DESTINATIONPORT is the remote port to write to. If this
            %   value is not set, the packet will be sent to the already
            %   used destinationPort. If writing for the first time,
            %   destinationPort is compulsory, else error.
            %
            % Notes:
            %   WRITE waits until the requested number of values are
            %   written to the udpport socket.
            %
            % Example:
            %      % Writes 1, 2, 3, 4, 5 as uint8 (5*1 = 5 bytes total)
            %      % to the udpport socket. The data is sent to 192.1.5.15
            %      % and port 20.
            %      write(u, 1:5, "uint8", "192.1.5.15", 20);
            %
            %      % For all future writes to the same address and port,
            %      % the destinationAddress and destinationPort can be
            %      % omitted.
            %      write(u,1:10,"single");
            try
                write(obj.UDPCommon, varargin{:});
            catch ex
                throw(ex);
            end
        end

        function writeline(obj, varargin)
            %WRITELINE Write ASCII data followed by the terminator to the
            % udpport socket.
            %
            %   WRITELINE(OBJ,DATA,DESTINATIONADDRESS,DESTINATIONPORT)
            %   writes the ASCII data, followed by the terminator, to the
            %   specified DESTINATIONADDRESS and DESTINATIONPORT. 
            %
            %   WRITELINE(OBJ,DATA) writes the ASCII data, DATA, followed
            %   by the terminator, to the last used DESTINATIONADDRESS and
            %   DESTINATIONPORT. Errors if DESTINATIONADDRESS and
            %   DESTINATIONPORT have not been used using a previous
            %   WRITE/WRITELINE call.
            %
            % Input Arguments:
            %   DATA is the ASCII data that is written to the udpport
            %   socket. The DATA is automatically appended with the
            %   terminator. If the size of DATA with terminator is greater
            %   than OUTPUTDATAGRAMSIZE, the DATA is broken into 2 or more
            %   packets depending on the size of DATA and the value of
            %   OUTPUTDATAGRAMSIZE.
            %
            % Notes:
            %   WRITELINE waits until the ASCII DATA followed by terminator
            %   is written to the udpport socket.
            %
            % Example:
            %      % write "START" and add the terminator to the end of
            %      % the line. The data is sent to 192.1.5.15 and port 20.
            %      writeline(u,"START","192.1.5.15",20);
            %
            %      % For all future writes to the same address and port,
            %      % the destinationAddress and destinationPort can be
            %      % omitted.
            %      writeline(u,"START");

            if ~(nargin == 2 || nargin == 4)
                throwAsCaller(getWritelineNarginError(obj));
            end
            data = varargin{1};
            try
                switch nargin
                    case 2
                        % writeline(u, data)
                        checkEmptyRemoteHostAndPort(obj.UDPCommon, "writeline");
                    case 4
                        % writeline(u, data, "RemoteHost", RemotePort)
                        setRemoteEndpoint(obj.UDPCommon, varargin{2}, varargin{3});
                end
                writeline@matlabshared.transportlib.internal.client.GenericClient(obj, data);
            catch ex
                throwAsCaller(ex);
            end
        end

        function configureMulticast(obj, varargin)
            %CONFIGUREMULTICAST configures the multicast properties for the
            % udpport socket.
            %
            % CONFIGUREMULTICAST(OBJ, MULTICASTADDRESS, MULTICASTLOOPBACK)
            % - Sets the MulticastGroup TO MULTICASTADDRESS. Sets the
            % EnableMulticastLoopback flag to MULTICASTLOOPBACK. Sets the
            % EnableMulticast flag to true.
            %
            % CONFIGUREMULTICAST(OBJ, MULTICASTADDRESS) - Sets the
            % MulticastGroup TO MULTICASTADDRESS. Sets the
            % EnableMulticastLoopback flag to true. Sets the
            % EnableMulticast flag to true.
            %
            % CONFIGUREMULTICAST(OBJ, "off") - Sets the
            % MulticastGroup TO "". Sets the
            % EnableMulticastLoopback flag to false. Turns EnableMulticast
            % flag to false.
            %
            % Example:
            %      % Enable multicast on and subscribe to the multicast
            %      % group "226.0.0.1". If "u" is the sender, ensure that
            %      % "u" does not get the data that it sends over to the
            %      % multicast address group
            %      configureMulticast(u,"226.0.0.1", false);
            %
            %      % If "u" wants to get back the data that it wrote to the
            %      % MulticastGroup
            %      configureMulticast(u,"226.0.0.1");
            %
            %      % Unsubscribe from the MulticastGroup
            %      configureMulticast(u, "off");

            try
                configureMulticast(obj.UDPCommon, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Error handling
    methods(Access = private)
        function ex = getWritelineNarginError(~)
            % Return the writeline MException for incorrect nargin.
            validSyntaxes = message("instrument:interface:udpport:WritelineSyntax").getString;
            ex = MException(message("instrument:interface:udpport:IncorrectInputArgumentsPlural", ...
                "writeline", validSyntaxes));
        end
    end
end