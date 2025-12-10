classdef TCPIPSend< matlab.System
    % TCPIPSendObj = instrument.system.TCPIPSend creates a TCP/IP Send system object.

    % Copyright 2021-2022 The MathWorks, Inc

    % Public, non-tunable properties
    properties(Nontunable)
        % Remote address
        Host = ''
        % Port
        Port = 80
        % Byte order
        ByteOrder = 'big-endian'
        % Timeout
        Timeout = 10
    end

    % Public, non-tunable, Logical properties
    properties(Nontunable, Logical)
        % Enable blocking mode
        EnableBlockingMode = true
        % Transfer Delay
        TransferDelay = true
    end

    %#codegen
    properties (Access = 'private')
        TCPIPObj;
        InputDataType;
    end

    % Construct pop-up for ByteOrder parameter
    properties (Constant, Hidden)
        ByteOrderSet = matlab.system.StringSet({'big-endian', 'little-endian'})
    end

    methods
        %% Constructor
        function obj = TCPIPSend(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj, nargin, varargin{:})
        end

        %% Set functions to validate and set the property value.
        function set.Timeout(obj, value)
            validateattributes(value, {'numeric'}, ...
                {'real', 'nonempty', 'nonnan', 'positive', 'scalar'}, ...
                '', 'Timeout');
            obj.Timeout = value;
        end

        function set.Port(obj, value)
            validateattributes(value, {'numeric'}, ...
                { '>', 0, '<=', 65535, 'real', 'nonnan', 'integer', 'scalar'}, ...
                '', 'Port')
            obj.Port = value;
        end
    end

    methods(Static, Access = protected)
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"), ...
                'Title', 'TCP/IP Send', ...
                'Text', 'Send data over TCP/IP network to a specified remote machine', ...
                'ShowSourceLink', false );
        end

        function group = getPropertyGroupsImpl
            % Define parameter name and grouping rules
            HostProp = matlab.system.display.internal.Property('Host', 'Description', 'Remote address' );
            PortProp = matlab.system.display.internal.Property('Port', 'Description', 'Port' );
            ByteOrderProp = matlab.system.display.internal.Property('ByteOrder', 'Description', 'Byte order' );
            EnableBlockingModeProp = matlab.system.display.internal.Property('EnableBlockingMode', 'Description', 'Enable blocking mode' );
            TimeoutProp = matlab.system.display.internal.Property('Timeout', 'Description', '   Timeout' );
            TransferDelayProp = matlab.system.display.internal.Property('TransferDelay', 'Description', 'Transfer Delay' );

            % Define the order in which property should be displayed on dialog
            group = matlab.system.display.Section(mfilename("class"), 'PropertyList', {HostProp, PortProp, ByteOrderProp, ...
                EnableBlockingModeProp, TimeoutProp, TransferDelayProp});

            % Create 'Verify address and port connectivity' button.
            group.Actions = matlab.system.display.Action(@(~, obj) ...
                validateAddressAndPort(obj), 'Label', 'Verify address and port connectivity', ...
                'Placement', 'ByteOrder', ...
                'Alignment', 'right');
        end

        function flag = showSimulateUsingImpl
            flag = false;
        end
    end

    methods(Access = protected)
        function num = getNumOutputsImpl(~)
            num = 0;
        end

        function icon = getIconImpl(obj)
            % Show only block name if block is in the library, else show
            % Remote address and Port details as well.
            if bdIsLibrary(bdroot(gcb))
                icon = 'TCP/IP\nClient\nSend';
            else
                blkname = 'TCP/IP Client Send';
                if isempty(obj.Host)
                    addressVal = 'Address: (none)';
                else
                    addressVal= obj.Host;
                end
                portVal = num2str(obj.Port);
                icon = [blkname '\n' addressVal '\n' 'Port: ' portVal];
            end
        end

        function name = getInputNamesImpl(~)
            % Return output port names for System block
            name = 'Data';
        end

        function flag = isInactivePropertyImpl(obj, prop)
            % Set flag based on if property need to be visible or not on
            % the dialog
            switch prop
                case 'Timeout'
                    flag = ~obj.EnableBlockingMode;
                otherwise
                    flag  = false;
            end
        end

        function validateInputsImpl(obj, input)
            % 64 bit data types are represented as 'embedded.fi'. So
            % validating them as below.
            if strcmpi(class(input), 'embedded.fi') &&  input.FractionLength == 0 && input.WordLength == 64
                if strcmpi(input.Signedness, 'Unsigned')
                    obj.InputDataType = 'uint64';
                elseif strcmpi(input.Signedness, 'Signed')
                    obj.InputDataType = 'int64';
                end
            else
                validateattributes(input, {'double', 'single', 'int8', 'uint8', ...
                    'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64'}, {})
                obj.InputDataType = class(input);
            end
        end

        function num = getNumInputsImpl(~)
            num = 1;
        end

        function setupImpl(obj)
            % Create TCPClient object and connect.
            obj.TCPIPObj = matlabshared.network.internal.TCPClient(obj.Host, obj.Port, 'IsSharingPort', true, 'IsWriteOnly', true);
            obj.TCPIPObj.Timeout = obj.Timeout;
            obj.TCPIPObj.ByteOrder = obj.ByteOrder;
            obj.TCPIPObj.TransferDelay = obj.TransferDelay;
            obj.TCPIPObj.connect;

            % Set WriteAsync flag based on blocking or Non-blocking mode
            if obj.EnableBlockingMode
                obj.TCPIPObj.WriteAsync = false;
            else
                obj.TCPIPObj.WriteAsync = true;
            end
        end

        function stepImpl(obj, input)
            % Reshape data to 1-D.
            data = reshape(input, [1 numel(input)]);

            % Cast the data before writing if the input data type is uint64 or int64.
            % This is because uint64 or int64 data is represented as 'embedded.fi'.
            if strcmpi(obj.InputDataType,'int64')
                obj.TCPIPObj.write(int64(data));
            elseif strcmpi(obj.InputDataType,'uint64')
                obj.TCPIPObj.write(uint64(data));
            else
                obj.TCPIPObj.write(data);
            end
        end

        function releaseImpl(obj)
            obj.TCPIPObj.disconnect;
        end
    end

    methods
        function validateAddressAndPort(obj)
            % Function to validate Remote address and Port when
            % 'Verify address and port connectivity' button is pressed.

            % Check if the host specified is empty/invalid.
            [remoteName, remoteAddress] = resolvehost(obj.Host);

            if ( isempty(remoteName) && isempty(remoteAddress) )
                coder.internal.error('instrument:instrumentblks:hostinvalid')
            end

            % Try connecting to the host. If connection is not success,
            % TCPClient connect() function will throw an error.
            testConnectObj = matlabshared.network.internal.TCPClient(obj.Host, obj.Port);
            testConnectObj.connect;

            % If connection is success, disconnect and show success
            % message.
            testConnectObj.disconnect
            if ~strcmpi(obj.Host, remoteName)
                % If user provides IP, show only the IP on success message.
                msgbox(getString(message('instrument:instrumentblks:localHostAndPortCorrect', obj.Host, obj.Port)), 'Success', 'replace');
            else
                % If user provides address, append the IP the address resolves to.
                msgbox(getString(message('instrument:instrumentblks:localHostAndPortCorrectWithIP', obj.Host, remoteAddress, obj.Port)), 'Success', 'replace');
            end
        end
    end
end

