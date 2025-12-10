classdef Spi < instrument.interface.InterfaceBase
    %SPI Construct SPI communication object.
    %
    %   S = SPI('Vendor', BoardIndex, RemoteAddress) constructs a SPI
    %   communication object associated with Vendor, BoardIndex and RemoteAddress.
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
    
    %   Copyright 2013-2020 The MathWorks, Inc.
    
    properties (Abstract)
        % ClockPhase - indicates when the data should be sampled.
        ClockPhase
        % ClockPolarity - indicates the level of the clock signal when
        % idle.
        ClockPolarity
        % ChipSelect - Connection from the controller to a peripheral that signals
        % the peripheral to listen for SPI clock and data signals.
        ChipSelect
    end
    
    properties (Abstract, GetAccess = 'private', SetAccess = 'protected')
        % DeviceHandle - The handle to the vendor device
        DeviceHandle
        % AsyncioChannel - The low level engine which acts as a
        %   buffer between the channel and the connected device.
        AsyncIOChannel
    end
    
    methods (Abstract)
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
        %       % For Aardvark change first parameter to 'aardvark'
        %       s = spi('ni845x', 0, 0);
        %       connect(s);
        %       data = read(s, 2);
        %       disconnect(s);
        %       clear('s');
        data = read(obj, size);
        %WRITE Write binary data to instrument.
        %
        %   WRITE(OBJ, A) writes the data, A, to the instrument
        %   connected to interface object, OBJ. OBJ must be
        %   a 1-by-1 interface object. By default the 'uint8'
        %   PRECISION is used.
        %
        %   The SPI interface object must be connected to the device with
        %   the CONNECT function before any data can be read from the
        %   device, otherwise an error is returned. 
        %
        %   SPI protocol operates in full duplex mode, input and output
        %   data transfers happen simultaneously. For every byte written
        %   to the device, we will read a byte back from the device.
        %   This function will automatically flush the incoming data.
        %
        %   An error will be returned if FWRITE is called on a SPI
        %   interface object.
        %
        %   Example:
        %       % For Aardvark change first parameter to 'aardvark'        
        %       s = spi('ni845x', 0, 0);
        %       connect(s);
        %       dataToWrite = [2 0 0 255]
        %       write(s, dataToWrite);
        %       disconnect(s);
        %       clear('s');
        write(obj, dataToWrite);
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
        %   'connected'.
        %
        %   SPI protocol operates in full duplex mode, input and output
        %   data transfers happen simultaneously. For every byte written
        %   to the device, we will read a byte back from the device.
        %
        %   Example:
        %       % For Aardvark change first parameter to 'aardvark'        
        %       s = spi('ni845x', 0, 0);
        %       connect(s);
        %       dataToWrite = [2 0 0 255]
        %       data = writeAndRead(s, dataToWrite);
        %       disconnect(s);
        %       clear('s');  
        data = writeAndRead(obj, dataToWrite);
    end
    
    methods (Static = true, Hidden = true)
        function out = loadobj(s)
            %LOADOBJ Creates and returns a new SPI object using the
            %deserialized data passed in.
            
            % initialize return value to empty
            out = [];
            if isstruct(s)
                out = spi(s.VendorName, s.BoardIndex, s.Port);                
                out.BoardSerial     = s.BoardSerial;
                out.BitRate         = s.BitRate;
                out.ChipSelect      = s.ChipSelect;
                out.ClockPhase      = s.ClockPhase;
                out.ClockPolarity   = s.ClockPolarity;
                out.TransferStatus  = s.TransferStatus;
                
                % If connected when saved, try reconnecting now
                if strcmpi(s.ConnectionStatus, 'Connected')
                    try
                        out.connect();
                    catch connectFailed
                        % If the connection attempt fails display a warning.
                        % Do not let the exception propogate up else all of
                        % the above restored properties are lost.
                        warning('instrument:spi:connectFailed', '%s', connectFailed.message);
                    end
                end
            end
        end
    end
    
    methods (Hidden)
        
        function obj = Spi(vendorName, boardIndex, ~)
            if(~feval(sprintf('instrument.interface.spi.%s.VendorInfo.isVendorInstalled', vendorName)))              
                if matlab.internal.display.isHot
                    tripLineMsg = message('instrument:instrument:instrument:downloadAdditionalVendors', 'SPI');
                    decoratedMsg = sprintf([message('instrument:spi:objectCreationError').getString() '\n\n' tripLineMsg.getString]);
                    decoratedException= MException('instrument:spi:objectCreationError', decoratedMsg);
                    throwAsCaller(decoratedException);
                else
                    throwAsCaller(MException('instrument:spi:objectCreationError',...
                        message('instrument:spi:objectCreationError').getString()));
                end                
            end
            
            % Initialize the default values
            obj.InterfaceType = 'SPI';
            obj.VendorName = vendorName;
            obj.BoardIndex = boardIndex;
            obj.ConnectionStatus = instrument.interface.ConnectionStatus.Disconnected;
            obj.TransferStatus = instrument.interface.TransferStatus.Idle;
        end
        
        function dispString = displayCommunicationSettings(obj)
            % displayCommunicationSettings Displays the communication settings
            % for the SPI device. This includes the SPI specific properties
            dispString = sprintf('\t\tBitRate:               %d Hz\n', obj.BitRate);
            dispString = sprintf('%s\t\tChipSelect:            %d\n',dispString, obj.ChipSelect);
            dispString = sprintf('%s\t\tClockPhase:            %s\n',dispString, char(obj.ClockPhase));
            dispString = sprintf('%s\t\tClockPolarity:         %s\n', dispString, char(obj.ClockPolarity));
            dispString = sprintf('%s\t\tPort:                  %d\n\n',dispString, obj.Port);
        end
        
        function s = saveobj(obj)
            % SAVEOBJ Returns values to serialize for this object
            
            s.BoardIndex        = obj.BoardIndex;
            s.BoardSerial       = obj.BoardSerial;
            s.VendorName        = obj.VendorName;
            s.BitRate           = obj.BitRate;
            s.ChipSelect        = obj.ChipSelect;
            s.ClockPhase        = obj.ClockPhase;
            s.ClockPolarity     = obj.ClockPolarity;
            s.Port              = obj.Port;
            s.ConnectionStatus  = obj.ConnectionStatus;
            s.TransferStatus    = obj.TransferStatus;
        end
    end
    
        
    methods (Access = protected)
               
        function data = convertDataPrecision(~, data)
            %CONVERTDATAPRECISION This function will convert the data to
            %the adaptor required precision of UINT8.
            
            % Check if the data exceeds the uint8 range
            if ((min(data) < intmin('uint8')) || (max(data) > intmax('uint8')))
                warning off backtrace
                warning(message('instrument:spi:overflowError'));
                warning on backtrace
            end
            
            data = uint8(data);
        end
    end
end

