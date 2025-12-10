classdef Spi < instrument.interface.spi.Spi
    %SPI Construct SPI communication object.
    %
    %   S = SPI('Vendor', BoardIndex, Port) constructs a SPI communication
    %   object associated with Vendor, BoardIndex and RemoteAddress.
    %
    %   When the SPI object is constructed, the object's ConnectionStatus
    %   property is disconnected. Once the object is connected to the bus
    %   with the CONNECT function, the ConnectionStatus property is
    %   configured to connected. Only one RemoteAddress may be connected
    %   with a board at a time.
    %
    %   If an invalid property name or property value is specified the
    %   object will not be created.
    %
    %
    %   Example:
    %       % Construct a spi interface object.
    %       s = spi('aardvark', 0, 0);
    %
    %       % Connect to the device.
    %       connect(s);
    %
    %       % The data to write.
    %       dataToWrite = [2 0 0 255]
    %
    %       % Write and read the data from the device.
    %       data = writeAndRead(s, dataToWrite);
    %
    %       % Disconnect from the instrument and clean up.
    %       disconnect(s);
    %       clear('s');
    
    %   Copyright 2013-2021 The MathWorks, Inc.
    
    properties
        %BitRate - The speed of communication.
        BitRate
        % ClockPhase - Indicates when the data should be sampled.
        ClockPhase
        % ClockPolarity - Indicates the level of the clock signal when
        % idle.
        ClockPolarity
        % ChipSelect - Connection from the controller to a peripheral that signals
        % the peripheral to listen for SPI clock and data signals.
        ChipSelect
        % Port - Specifies the physical port associated with the object and
        % the device.
        Port
    end
    
    properties (GetAccess = 'private', SetAccess = 'protected')
        % DeviceHandle - The handle to the vendor device
        DeviceHandle
        % AsyncIOChannel - The low level engine which acts as a
        %   buffer between the channel and the connected device.
        AsyncIOChannel
    end
    
    methods
        function obj = set.BitRate(obj, value)
            try
                % Validate the value
                validateattributes(value,{'numeric'}, {'scalar','finite','nonnegative'});
                
                % Validate the value to be equal to one of the Aardvark
                % supported birates
                if (~ismember(value, instrument.interface.spi.aardvark.Utility.AardvarkSupportedBitRates))
                    error(message('instrument:spi:invalidPropertyValue',...
                        num2str(instrument.interface.spi.aardvark.Utility.AardvarkSupportedBitRates),...
                        num2str(value)));
                end
                
            catch validationException
                throwAsCaller(MException('instrument:spi:invalidPropertyValue',...
                    validationException.message));
            end
            
            % Set SPI bitrate
            obj.BitRate = setBitRate(obj, value);
        end
        
        function obj = set.Port(obj, value)
            
            % This property cannot be set if the object is connected to the
            % instrument.
            if(strcmpi(obj.ConnectionStatus, 'connected'))
                error(message('instrument:spi:setopfailed'));
            end
            
            try
                % Validate the value
                validateattributes(value,{'numeric'}, {'scalar','finite','nonnegative'});
                
                % For Aardvark only acceptable value is 0
                if (value ~= 0)
                    error(message('instrument:spi:invalidPropertyValue', '0', num2str(value)));
                end
                
            catch validationException
                throwAsCaller(MException('instrument:spi:invalidPropertyValue',...
                    validationException.message));
            end
            
            % Set Port value
            obj.Port = value;
        end
        
        function obj = set.ClockPhase(obj, value)
            try
                % Validate the value
                obj.ClockPhase = instrument.internal.util.getEnumerationFromString(value, 'instrument.interface.spi.ClockPhase');
                
            catch validationException
                throwAsCaller(MException('instrument:spi:invalidPropertyValue',...
                    validationException.message));
            end
            
            % Configure the SPI
            configureSpi(obj);
        end
        
        function obj = set.ClockPolarity(obj, value)
            try
                % Validate the value
                obj.ClockPolarity = instrument.internal.util.getEnumerationFromString(value, 'instrument.interface.spi.ClockPolarity');
                
            catch validationException
                throwAsCaller(MException('instrument:spi:invalidPropertyValue',...
                    validationException.message));
            end
            
            % Configure the SPI
            configureSpi(obj);
        end
        
        function obj = set.ChipSelect(obj, value)
            try
                % Validate the value
                validateattributes(value,{'numeric'}, {'scalar','finite','nonnegative'});
                
                % For Aardvark only acceptable value is 0
                if (value ~= 0)
                    error(message('instrument:spi:invalidPropertyValue', '0', num2str(value)));
                end
                
            catch validationException
                throwAsCaller(MException('instrument:spi:invalidPropertyValue',...
                    validationException.message));
            end
            
            % Set the Chip Select
            obj.ChipSelect = value;
        end
        
        function value = get.ClockPhase(obj)
            %Convert the enum to char
            value = char(obj.ClockPhase);
        end
        
        function value = get.ClockPolarity(obj)
            %Convert the enum to char
            value = char(obj.ClockPolarity);
        end

        function disconnect(obj)
            %DISCONNECT Disconnects the interface object from instrument.
            %
            %   DISCONNECT(OBJ) disconnects the interface object, OBJ, from
            %   the instrument. OBJ must be a 1-by-1 interface object.
            %
            %   If OBJ was successfully disconnected from the instrument,
            %   its ConnectionStatus property is configured to
            %   disconnected. OBJ can be reconnected to the instrument with
            %   the CONNECT function.
            %
            %   Example:
            %       % Construct a spi interface object.
            %       s = spi('aardvark', 0, 0);
            %
            %       % Connect to the device.
            %       connect(s);
            %
            %       % The data to write.
            %       dataToWrite = [2 0 0 255]
            %
            %       % Write and read the data from the device.
            %       data = writeAndRead(s, dataToWrite);
            %
            %       % Disconnect from the instrument and clean up.
            %       disconnect(s);
            %       clear('s');
            
            if length(obj)>1
                throwAsCaller(MException('instrument:spi:invalidOBJDim',...
                    message('instrument:spi:invalidOBJDim').getString()));
            end
            
            try
                % g939005 - The channel will be closed even if we take
                % exception during the Close() execution. Review geck for
                % more information.
                % Update the ConnectionStatus
                obj.ConnectionStatus = instrument.interface.ConnectionStatus.Disconnected;
                
                % Close the AsyncIO channel
                obj.AsyncIOChannel.close();
            catch asyncioError
                throwAsCaller(MException('instrument:spi:disconnectFailed',...
                    message('instrument:spi:disconnectFailed', asyncioError.message).getString()));
            end
        end
        
        function connect(obj)
            %CONNECT Connects the interface object to instrument by
            %establishing a communication link.
            %
            %   CONNECT(OBJ) connects the interface object, OBJ, to the
            %   instrument. OBJ must be a 1-by-1 interface object.
            %
            %   Only one interface object with the same configuration can
            %   be connected to an instrument at a time. For example, only
            %   one spi object can be connected to an Aardvark adaptor at a
            %   time. If OBJ was successfully connected to the instrument,
            %   its ConnectionStatus property is configured to connected,
            %   otherwise the Status property remains configured to
            %   disconnected.
            %
            %   Some properties are read-only while the interface object is
            %   connected and must be configured before using CONNECT.
            %   Examples include PORT.
            %
            %   An error will be returned if FOPEN is called on an
            %   interface object that has a Status property value of open.
            %
            %   Example:
            %       % Construct a spi interface object.
            %       s = spi('aardvark', 0, 0);
            %
            %       % Connect to the device.
            %       connect(s);
            %
            %       % The data to write.
            %       dataToWrite = [2 0 0 255]
            %
            %       % Write and read the data from the device.
            %       data = writeAndRead(s, dataToWrite);
            %
            %       % Disconnect from the instrument and clean up.
            %       disconnect(s);
            %       clear('s');
            
            if length(obj)>1
                throwAsCaller(MException('instrument:spi:invalidOBJDim',...
                    message('instrument:spi:invalidOBJDim').getString()));
            end
            
            % Throw error if the object is already disconnected
            if(strcmpi(obj.ConnectionStatus, 'connected'))
                throwAsCaller(MException('instrument:spi:alreadyConnectedError',...
                    message('instrument:spi:alreadyConnectedError').getString()));
            end
            
            % Flush the input and output stream
            obj.AsyncIOChannel.OutputStream.flush();
            obj.AsyncIOChannel.InputStream.flush();
            
            try
                % Open the AsyncIO channel
                obj.AsyncIOChannel.open();
                
            catch asyncioError
                throwAsCaller(MException('instrument:spi:connectFailed',...
                    message('instrument:spi:connectFailed', asyncioError.message).getString()));
            end
            
            % Update the ConnectionStatus
            obj.ConnectionStatus = instrument.interface.ConnectionStatus.Connected;
        end
        
        function data = read(obj, size)
            %READ Read binary data from instrument.
            %
            %   A=READ(OBJ,SIZE) reads the specified number of values,
            %   SIZE, from the SPI device connected to interface object,
            %   OBJ, and returns to A. OBJ must be a 1-by-1 interface
            %   object. By default the 'uint8' PRECISION is used.
            %
            %   The interface object must be connected to the device with
            %   the CONNECT function before any data can be read from the
            %   device otherwise an error is returned. A connected
            %   interface object has a ConnectionStatus property value of
            %   connected.
            %
            %   Available options for SIZE include:
            %
            %      N      read at most N values into a column vector.
            %
            %   SIZE cannot be set to INF.
            %
            %   SPI protocol operates in full duplex mode, input and output
            %   data transfers happen simultaneously. SPI communication
            %   requires N bytes of dummy data to be written into the
            %   device for reading N bytes of data from the device. The
            %   dummy data written is zeros.
            %
            %   Example:
            %       s = spi('aardvark', 0, 0);
            %       connect(s);
            %       data = read(s, 2);
            %       disconnect(s);
            %       clear('s');
            
            
            if length(obj)>1
                throwAsCaller(MException('instrument:spi:invalidOBJDim',...
                    message('instrument:spi:invalidOBJDim').getString()));
            end
            
            % Throw error if the object is disconnected
            if(strcmpi(obj.ConnectionStatus, 'disconnected'))
                throwAsCaller(MException('instrument:spi:invalidConnectionState',...
                    message('instrument:spi:invalidConnectionState').getString()));
            end
            
            try
                % Typecast the data to uint8 and write to the output stream.
                obj.AsyncIOChannel.OutputStream.write(uint8(zeros(1, size)));
                
                % Read the data from the input stream
                data = double(obj.AsyncIOChannel.InputStream.read(obj.AsyncIOChannel.InputStream.DataAvailable));
                
            catch asyncioError
                throwAsCaller(MException('instrument:spi:opfailed',...
                    message('instrument:spi:opfailed', asyncioError.message).getString()));
            end
        end
        
        function write(obj, dataToWrite)
            %WRITE Write binary data to instrument.
            %
            %   WRITE(OBJ, A) writes the data, A, to the instrument
            %   connected to interface object, OBJ. OBJ must be
            %   a 1-by-1 interface object. By default the 'uint8'
            %   PRECISION is used.
            %
            %   The interface object must be connected to the device with
            %   the CONNECT function before any data can be read from the
            %   device, otherwise an error is returned. A connected
            %   interface object has a ConnectionStatus property value of
            %   connected.
            %
            %   SPI protocol operates in full duplex mode, input and output
            %   data transfers happen simultaneously. For every byte written
            %   to the device, we will read a byte back from the device.
            %   This function will automatically flush the incoming data.
            %
            %   Example:
            %       s = spi('aardvark', 0, 0);
            %       connect(s);
            %       dataToWrite = [2 0 0 255]
            %       write(s, dataToWrite);
            %       disconnect(s);
            %       clear('s');
            
            
            if length(obj)>1
                throwAsCaller(MException('instrument:spi:invalidOBJDim',...
                    message('instrument:spi:invalidOBJDim').getString()));
            end
            
            % Throw error if the object is disconnected
            if(strcmpi(obj.ConnectionStatus, 'disconnected'))
                throwAsCaller(MException('instrument:spi:invalidConnectionState',...
                    message('instrument:spi:invalidConnectionState').getString()));
            end
            
            try
                % Convert the data to the required precision(uint8)
                dataToWrite = obj.convertDataPrecision(dataToWrite);
                
                % Write to the output stream.
                obj.AsyncIOChannel.OutputStream.write(dataToWrite);
                
                % Flush the input stream.
                obj.AsyncIOChannel.InputStream.flush();
                
            catch asyncioError
                throwAsCaller(MException('instrument:spi:opfailed',...
                    message('instrument:spi:opfailed', asyncioError.message).getString()));
            end
        end
        
        function data = writeAndRead(obj, dataToWrite)
            %WRITEANDREAD Write and read binary data from instrument.
            %
            %   A=WRITEANDREAD(OBJ, DATATOWRITE) writes the data,
            %   DATATOWRITE, to the instrument connected to interface
            %   object, OBJ and reads the data available from the
            %   instrument as a result of writing DATATOWRITE. OBJ must be
            %   a 1-by-1 interface object. By default the 'uint8' PRECISION
            %   is used.
            %
            %   The interface object must be connected to the device with
            %   the CONNECT function before any data can be read from the
            %   device, otherwise an error is returned. A connected
            %   interface object has a ConnectionStatus property value of
            %   connected.
            %
            %   SPI protocol operates in full duplex mode, input and output
            %   data transfers happen simultaneously. For every byte written
            %   to the device, we will read a byte back from the device.
            %
            %   Example:
            %       s = spi('aardvark', 0, 0);
            %       connect(s);
            %       dataToWrite = [2 0 0 255]
            %       data = writeAndRead(s, dataToWrite);
            %       disconnect(s);
            %       clear('s');
            
            
            if length(obj)>1
                throwAsCaller(MException('instrument:spi:invalidOBJDim',...
                    message('instrument:spi:invalidOBJDim').getString()));
            end
            
            % Throw error if the object is disconnected
            if(strcmpi(obj.ConnectionStatus, 'disconnected'))
                throwAsCaller(MException('instrument:spi:invalidConnectionState',...
                    message('instrument:spi:invalidConnectionState').getString()));
            end
            
            try
                % Convert the data to the required precision(uint8)
                dataToWrite = obj.convertDataPrecision(dataToWrite);
                
                % Write to the output stream.
                obj.AsyncIOChannel.OutputStream.write(dataToWrite);
                
                % Read the data from the input stream
                data = double(obj.AsyncIOChannel.InputStream.read(obj.AsyncIOChannel.InputStream.DataAvailable));
                
            catch asyncioError
                throwAsCaller(MException('instrument:spi:opfailed',...
                    message('instrument:spi:opfailed', asyncioError.message).getString()));
            end
        end        
    end
    
    methods(Hidden)
        function obj = Spi(vendorName, boardIndex, port)
            %SPI Construct Aardvark SPI communication object.
            
            obj@instrument.interface.spi.Spi(vendorName, boardIndex, port);
                        
            % For initializing the following properties we need to maintain
            % an active connection to the board.
            try
                % Open the connection the Aardvark board
                obj.DeviceHandle = instrument.interface.spi.aardvark.Utility.open(obj.BoardIndex);
                
                % Enable SPI subsystem
                instrument.interface.spi.aardvark.Utility.enableSpi(obj.DeviceHandle);
                
                % Initialize ClockPolarity and ClockPhase to the most
                % popular configuration
                obj.ClockPolarity = 'IdleLow';
                obj.ClockPhase = 'FirstEdge';
                obj.Port = port;
                obj.ChipSelect = 0;
            
                % Read the BoardSerial and BitRate from the Aardvark board
                obj.BoardSerial = instrument.interface.spi.aardvark.Utility.getUniqueId(obj.DeviceHandle);
                obj.BitRate = instrument.interface.spi.aardvark.Utility.getBitRate(obj.DeviceHandle);
                
                % Directory of the AsyncIO DevicePlugin and ConverterPlugin
                pluginDir = toolboxdir(fullfile('instrument',...
                    'instrumentadaptors',...
                    computer('arch')));
                
                % Passing the Aardvark DeviceHandle to the AsyncIO DevicePlugin
                options.DeviceHandle = obj.DeviceHandle;
                
                % Create an AsyncIO Channel
                obj.AsyncIOChannel = matlabshared.asyncio.internal.Channel(fullfile(pluginDir,...
                    'aardvarkspidevice'),...
                    fullfile(pluginDir, 'spimlconverter'),...
                    Options = options,...
                    StreamLimits = [Inf,0]);
                
            catch objectCreateException
                throwAsCaller(MException('instrument:spi:objectCreationError',...
                    objectCreateException.message));
            end
        end
        
        function delete(obj)
            %DELETE Deletes the SPI interface object from the memory.
            %
            %   DELETE(OBJ) Deletes the interface object, OBJ from the
            %   memory. OBJ must be a 1-by-1 interface object.
            %
            %   This function closes the handle(if valid) to the Aardvark
            %   adaptor.
            
            if(strcmpi(obj.ConnectionStatus, 'connected'))
                obj.disconnect();
            end
            
            if (obj.DeviceHandle ~= 0)
                % Close the connection to the Aardvark adaptor
                instrument.interface.spi.aardvark.Utility.close(obj.DeviceHandle);
            end
        end
    end
    
    methods (Access = 'private')
        
        function configureSpi(obj)
            %CONFIGURESPI Configures the SPI object by setting the
            %ClockPolarity and ClockPhase.
            
            % Make sure ClockPhase and ClockPolarity have valid values
            if (~isempty(obj.ClockPhase) && ~isempty(obj.ClockPolarity))
                ClkPhase = instrument.internal.util.getEnumerationFromString(obj.ClockPhase,...
                    'instrument.interface.spi.ClockPhase');
                
                ClkPolarity = instrument.internal.util.getEnumerationFromString(obj.ClockPolarity,...
                    'instrument.interface.spi.ClockPolarity');
                
                instrument.interface.spi.aardvark.Utility.configureSpi(obj.DeviceHandle,...
                    ClkPolarity,...
                    ClkPhase);
            end
        end
        
        function bitRate = setBitRate(obj, value)
            %SETBITRATE Set the SPI bitrate in hertz.            
            bitRate = instrument.interface.spi.aardvark.Utility.setBitRate(obj.DeviceHandle, value);
        end
    end
end