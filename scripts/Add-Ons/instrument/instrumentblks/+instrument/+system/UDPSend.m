classdef UDPSend< matlab.System
    % UDPSendObj = instrument.system.UDPSend creates a UDP Send system object.

    % Copyright 2021-2024 The MathWorks, Inc.

    % Public, non-tunable properties
    properties(Nontunable)
        % Remote address
        Host = ''
        % Remote Port
        Port = 9090
        % Local address
        LocalAddress = '0.0.0.0'
        % Local port
        LocalPort = -1
        % UDP packet size
        OutputDatagramPacketSize = 512
        % Byte order
        ByteOrder = 'big-endian'
    end

    % Public, non-tunable, Logical properties
    properties(Nontunable, Logical)
        % Enable local port sharing
        EnablePortSharing = false
        % Enable blocking mode
        EnableBlockingMode = true
    end

    properties (Access = private)
        UDPSendObj;
        InputDataType;
    end
    %#codegen

    % Construct pop-up for ByteOrder parameter
    properties (Constant, Hidden)
        ByteOrderSet = matlab.system.StringSet({'big-endian', 'little-endian'})
    end

    methods
        %% Constructor
        function obj = UDPSend(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj, nargin, varargin{:})
        end

        %% Set functions to validate and set the property value.
        function set.Port(obj, value)
            if iscell(value) || isempty(value) || any(value < 1) ...
                    || any(floor(value) ~= value) || ~isscalar(value) || any(value > 65535)
                coder.internal.error('instrument:instrumentblks:udpInvalidRemotePort');
            end
            obj.Port = value;
        end

        function set.LocalPort(obj, value)
            if iscell(value) || isempty(value)
                coder.internal.error('instrument:instrumentblks:udpInvalidLocalPort');
            end
            if value < 0 && value ~= -1
                coder.internal.error('instrument:instrumentblks:udpInvalidLocalPort');
            elseif value == 0 || (floor(value) ~= value) || ~isscalar(value) || value > 65535
                coder.internal.error('instrument:instrumentblks:udpInvalidLocalPort');
            end
            obj.LocalPort = value;
        end

        function set.OutputDatagramPacketSize(obj, value)
            validateattributes(value,{'numeric'}, {'nonnegative', 'nonnan', 'nonempty', 'finite', ...
                'integer', 'scalar', 'nonzero', '<=', intmax('uint16')});
            obj.OutputDatagramPacketSize = value;
        end
    end

    methods(Static, Access = protected)
        %% Mask display implementation
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"), ...
                'Title', 'UDP Send', ...
                'Text', 'Send data over UDP network to a specified remote machine.', ...
                'ShowSourceLink', false );
        end

        function group = getPropertyGroupsImpl
            % Define parameter name and grouping rules
            HostProp = matlab.system.display.internal.Property('Host', 'Description', 'Remote address' );
            PortProp = matlab.system.display.internal.Property('Port', 'Description', 'Remote port' );
            LocalAddressProp = matlab.system.display.internal.Property('LocalAddress', 'Description', 'Local address' );
            LocalPortProp = matlab.system.display.internal.Property('LocalPort', 'Description', 'Local port' );
            PacketSizeProp = matlab.system.display.internal.Property('OutputDatagramPacketSize', 'Description', 'UDP packet size' );
            ByteOrderProp = matlab.system.display.internal.Property('ByteOrder', 'Description', 'Byte order' );
            PortSharingProp = matlab.system.display.internal.Property('EnablePortSharing', 'Description', 'Enable local port sharing' );
            BlockingModeProp = matlab.system.display.internal.Property('EnableBlockingMode', 'Description', 'Enable blocking mode' );

            % Define the order in which property should be displayed on the dialog
            group = matlab.system.display.Section(mfilename("class"), 'PropertyList', { HostProp, PortProp, LocalAddressProp, LocalPortProp,...
                PortSharingProp, PacketSizeProp, ByteOrderProp, BlockingModeProp});

            % Create 'Verify address and port connectivity' button.
            group.Actions = matlab.system.display.Action(@(~, obj) ...
                validateAddressAndPort(obj), 'Label', 'Verify address and port connectivity', ...
                'Placement', 'OutputDatagramPacketSize', ...
                'Alignment', 'right');
        end

        function flag = showSimulateUsingImpl
            flag = false;
        end
    end

    methods(Access = protected)
        %% Block display implementation
        function num = getNumOutputsImpl(~)
            num = 0;
        end

        function icon = getIconImpl(obj)
            % Show only block name if block is in the library, else show
            % Remote address and Port details as well.
            if bdIsLibrary(bdroot(gcb))
                icon = 'UDP\nSend';
            else
                if isempty(obj.Host)
                    addressVal = 'Address: (none)';
                else
                    addressVal= obj.Host;
                end
                portVal = num2str(obj.Port);
                icon = [addressVal '\n' 'Port: ' portVal];
            end
        end

        function name = getInputNamesImpl(~)
            % Return output port names for System block
            name = 'Data';
        end

        function num = getNumInputsImpl(~)
            num = 1;
        end

        %% Algorithm implementation
        function setupImpl(obj)
            % Create UDPByte object and connect.
            obj.UDPSendObj = matlabshared.network.internal.UDPByte( ...
                'LocalHost', obj.LocalAddress, ...
                'RemoteHost', obj.Host, ...
                'RemotePort', obj.Port, ...
                'EnableSocketSharing', true, ...
                'EnablePortSharing', obj.EnablePortSharing, ...
                'ByteOrder', obj.ByteOrder, ...
                'IsWriteOnly', true);

            % Check if LocalPort setting is set to any value other than -1
            if obj.LocalPort ~= -1
                obj.UDPSendObj.LocalPort = obj.LocalPort;
            end
            obj.UDPSendObj.OutputDatagramPacketSize = obj.OutputDatagramPacketSize;

            % Set address type.
            if contains(obj.LocalAddress, ':') || contains(obj.Host, ':')
                obj.UDPSendObj.AddressType = 'IPV6';
            end

            % If running in MATLAB, we can use try-catch.
            % Otherwise, try to connect without try-catch in codegen mode.
            if coder.target('MATLAB')
                try
                    connect(obj.UDPSendObj);
                catch err
                    if (strcmp(err.identifier, "network:udp:connectFailed") && ...
                            contains(err.message, "Only UDP object with initAccess (first instance) can control underlying socking options (Multicast/Broadcast/PortSharing)"))
                        % If the connect fails because of conflicting 'Enable
                        % Socket Sharing' settings on the UDP blocks sharing a
                        % local address and local port, throw an error for the conflict.
                        coder.internal.error('instrument:instrumentblks:conflictPortSharingSettings');
                    end
                    % Otherwise, throw the general 'connectFailed' error.
                    rethrow(err)
                end
            else
                connect(obj.UDPSendObj);
            end
        end

        function stepImpl(obj, input)
            % Reshape data to 1-D.
            data = reshape(input, [1 numel(input)]);
            writeData = data;

            if obj.EnableBlockingMode
                write(obj.UDPSendObj, writeData);
            else % Non-blocking mode
                writeAsync(obj.UDPSendObj, writeData);
            end
        end

        function releaseImpl(obj)
            obj.UDPSendObj.disconnect;
        end

        function validateInputsImpl(obj, input)
            validateattributes(input, {'double', 'single', 'int8', 'uint8', ...
                'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64'}, {})
            obj.InputDataType = class(input);
        end

    end

    methods
        %% Validation algorithm
        function validateAddressAndPort(obj)
            % Function to validate Remote address and Port when
            % 'Verify address and port connectivity' button is pressed.

            % Check if the host specified is empty/invalid.
            [remoteName, remoteAddress] = resolvehost(obj.Host);

            if isempty(remoteName) && isempty(remoteAddress)
                coder.internal.error('instrument:instrumentblks:hostinvalid')
            end

            % Check if the local address specified is empty/invalid.
            [localName, localAddress] = resolvehost(obj.LocalAddress);
            if isempty(localName) && isempty(localAddress)
                coder.internal.error('instrument:instrumentblks:localhostinvalid')
            end

            % Try creating the UDPByte object with the settings given by user
            if obj.LocalPort == -1
                myObj = matlabshared.network.internal.UDPByte("LocalHost", obj.LocalAddress);
            else
                myObj = matlabshared.network.internal.UDPByte("LocalHost", obj.LocalAddress, "LocalPort", obj.LocalPort);
            end

            % If creation of UDPByte object is success, delete the object and
            % display success message
            delete(myObj);
            clear myObj;

            if ~strcmpi(obj.Host, remoteAddress) % Append the IP the address resolves to.
                remoteAddMsg = getString(message('instrument:instrumentblks:remoteHostAndPortCorrectWithIP',...
                    obj.Host, remoteAddress, obj.Port));
            else
                remoteAddMsg = getString(message('instrument:instrumentblks:remoteHostAndPortCorrect',...
                    obj.Host, obj.Port));
            end

            if ~strcmpi(obj.LocalAddress, localAddress) % Append the IP the address resolves to.
                localAddMsg = getString(message('instrument:instrumentblks:localHostAndPortCorrectWithIP', ...
                    obj.LocalAddress, localAddress, obj.LocalPort));
            else
                localAddMsg = getString(message('instrument:instrumentblks:localHostAndPortCorrect', obj.LocalAddress, obj.LocalPort));
            end

            completeUserMsg = [remoteAddMsg newline localAddMsg];
            msgbox(completeUserMsg, 'Success', 'replace');
        end
    end
end

