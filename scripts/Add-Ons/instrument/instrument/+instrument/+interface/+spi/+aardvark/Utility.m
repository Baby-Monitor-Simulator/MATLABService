classdef (Hidden) Utility < instrument.interface.spi.Utility
    % Utility Supporting functionality for toolbox operations.
    %
    %   This class implements internal functionality required for toolbox
    %   operation. These methods are not intended for external use.
    %   Methods contained here are applicable to Aardvark devices only.

    % Copyright 2013-2020 The MathWorks, Inc.
    
    properties (Constant)
        % BoardNotFree - This value is returned by the vendor DLL when the
        % board is being used by some other application.
        BoardNotFree = hex2dec('8000');
        % AardvarkSupportedBitRates - The supported bitrates of the
        % Aardvark SPI device.
        AardvarkSupportedBitRates = [125000, 250000, 500000, 1000000, 2000000, 4000000, 6000000, 8000000];
    end
    
    methods (Static)
       
        function [numDevices, ports, serials] = findDevices()
            % FINDDEVICES Finds all the vendor devices connected
            [numDevices, ports, serials] = instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkFindDevices();            
        end
            
        function deviceHandle = open(port)
            % OPEN Opens a connection to the Aardvark board and returns the
            % deviceHandle to the Aardvark board which is guaranteed to be
            % greater than zero if valid.
            deviceHandle = instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkOpen(port);
        end
        
        function close(deviceHandle)
            % CLOSE Closes the connection to the Aardvark board specified
            % by the deviceHandle. If the deviceHandle argument is zero, the function
            % will attempt to close all possible device handles.
            instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkClose(deviceHandle);
        end
        
        function uniqueId = getUniqueId(deviceHandle)
            % GETUNIQUEID This function returns the unique ID for the
            % Aardvark adaptor specified by the deviceHandle. The IDs are
            % guaranteed to be non-zero if valid.
            uniqueId = instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkGetUniqueId(deviceHandle);
        end
        
        function bitRate = getBitRate(deviceHandle)
            % GETBITRATE This function returns the bitrate presently set on
            % the Aardvark adapter.
            bitRate = instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkSpiBitRate(deviceHandle, 0);            
        end
        
        function actualBitRate = setBitRate(deviceHandle, bitRate)
            % SETBITRATE This function sets the SPI bitrate in hertz.
            % The power on default bitrate is 1000 kHz.
            actualBitRate = instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkSpiBitRate(deviceHandle, bitRate);
        end
        
        function configureSpi(deviceHandle, clockPolarity, clockPhase)
            % CONFIGURESPI This function configures the SPI controller device.
            % The Polarity option specifies which transition constitutes
            % the leading edge and which transition is the falling edge.
            % The Phase option determines whether to sample or setup on the
            % leading edge.
            instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkSpiConfigure(deviceHandle, double(clockPolarity), double(clockPhase));
        end
        
        function enableSpi(deviceHandle)
            % ENABLESPI This function enables the SPI subsystem in Aardvark
            % adaptor.
            
            % Enable both SPI and I2C subsystem
            config = 3;
            instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkConfigure(deviceHandle, config);
        end
    end    
end

