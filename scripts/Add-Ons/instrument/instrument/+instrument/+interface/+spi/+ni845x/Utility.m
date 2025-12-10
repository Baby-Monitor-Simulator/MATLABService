classdef (Hidden) Utility < instrument.interface.spi.Utility
    % Utility Supporting functionality for toolbox operations.
    %
    %   This class implements internal functionality required for toolbox
    %   operation. These methods are not intended for external use.
    %   Methods contained here are applicable to NI-845x devices only.

    % Copyright 2013-2015 The MathWorks, Inc.
    
    properties (Constant)
        % NI8451SupportedBitRates - The supported bitrates of the NI8451
        % SPI device.
        NI8451SupportedBitRates = [48000, 50000, 60000, 80000, 96000, ...
            100000, 120000, 125000, 150000, 160000, 200000, 240000, ...
            250000, 300000, 375000, 400000, 480000, 500000, 600000, ...
            750000, 800000, 1000000, 1200000, 1500000, 2000000, 2400000, ...
            3000000, 4000000, 6000000, 12000000];
        % NI8452SupportedBitRates - The supported bitrates of the NI8452
        % SPI device.
        NI8452SupportedBitRates = [25000, 32000, 40000, 50000, 80000, ...
            100000, 125000, 160000, 200000, 250000, 400000, 500000, 625000, ...
            800000, 1000000, 1250000, 2500000, 3125000, 4000000, 5000000, ...
            6250000, 10000000, 12500000, 20000000, 25000000, 33330000, 50000000];        
    end
    
    methods (Static)       
        function [numDevices, ports, serialNumbers, resourceNames] = findDevices()
            % FINDDEVICES Finds all the vendor devices connected.
            [numDevices, ports, serialNumbers, resourceNames] = instrument.interface.spi.ni845x.NI845xSPILib.ni845xFindDevices();            
        end
            
        function deviceHandle = open(port)
            % OPEN Opens a connection to the NI-845x board and returns the
            % deviceHandle to the NI-845x board which is guaranteed to be
            % greater than zero if valid.
            deviceHandle = instrument.interface.spi.ni845x.NI845xSPILib.ni845xOpen(port);
        end
        
        function [serialNumber, resourceName] = getDeviceByBoardIndex(boardIndex)
            % GETDEVICEBYBOARDINDEX Opens a connection to the NI-845x board and returns the
            % deviceHandle to the NI-845x board which is guaranteed to be
            % greater than zero if valid.
            [~, ~, serialNumbers, resourceNames] = instrument.interface.spi.ni845x.Utility.findDevices();
            
            % Ports are 0 based.
            boardIndex = boardIndex + 1;
            
            if (boardIndex <= length(serialNumbers))
                serialNumber = serialNumbers{boardIndex};
                resourceName = resourceNames{boardIndex};
            else
                serialNumber = '';
                resourceName = '';
            end            
        end
        
        function close(deviceHandle)
            % CLOSE Closes the connection to the NI-845x board specified
            % by the deviceHandle. If the deviceHandle argument is zero, the function
            % will attempt to close all possible device handles.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xClose(deviceHandle);
        end
                            
        function configurationHandle = configurationOpen()
            % CONFIGURATIONOPEN Creates a new NI-845x SPI configuration.
            configurationHandle = instrument.interface.spi.ni845x.NI845xSPILib.ni845xConfigurationOpen();
        end
        
        function configurationClose(configurationHandle)
            % CONFIGURATIONCLOSE Closes a previously opened configuration.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xConfigurationClose(configurationHandle);
        end
                
        function setBitRate(configurationHandle, bitRate)
            % SETBITRATE This function sets the SPI bitrate in hertz.
            % The power on default bitrate is 1000 kHz.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xSetBitRate(configurationHandle, bitRate);
        end
        
        function setPort(configurationHandle, port)
            % SETPORT Sets the configuration port number.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xSetPort(configurationHandle, port);
        end
                
        function setClockPolarity(configurationHandle, clockPolarity)
            % SETCLOCKPOLARITY Sets the configuration clock polarity.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xSetClockPolarity(configurationHandle, double(clockPolarity));
        end
        
        function setChipSelect(configurationHandle, chipSelect)
            % SETCHIPSELECT Sets the configuration chip select.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xSetChipSelect(configurationHandle, chipSelect);
        end
                
        function setClockPhase(configurationHandle, clockPhase)
            % SETCLOCKPHASE Sets the configuration clock phase.
            instrument.interface.spi.ni845x.NI845xSPILib.ni845xSetClockPhase(configurationHandle, double(clockPhase));
        end             
        
        function bitRate = getBitRate(configurationHandle)
            % GETBITRATE This function returns the bitrate presently set on
            % the NI-845x adapter.
            bitRate = instrument.interface.spi.ni845x.NI845xSPILib.ni845xGetBitRate(configurationHandle);            
        end           
        
        function serials = getSerialFromResource(resourceNames)
            % GETSERIALFROMRESOURCE Retrieves the serial number from the
            % VISA like resource string.
            
            serials = cell(length(resourceNames));
            
            % Split the resource name appropriately to retrieve the serial
            % number. 
            for i = 1:length(resourceNames)
                temp = strsplit(resourceNames{i}, '::');
                serials{i} = temp{4};
            end
        end
    end    
end