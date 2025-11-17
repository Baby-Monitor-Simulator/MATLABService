classdef (Hidden) NI845xSPILib
% NI845xSPILib Aardvark SPI Library function wrapping class.
%
%   This class wraps and presents the functions available in Aardvark SPI
%   Library. This is meant for internal use only and applies no input
%   validation. It does perform output validation on each call though and
%   will error should any function fail.

% Copyright 2013 The MathWorks, Inc.

    methods (Static)        
        function [numDevicesFound , ports, boardSerials, resourceNames] = ni845xFindDevices()
            % If the driver is not installed then the mex throws an
            % exception.
            try
                % Call the vendor driver function.
                [numDevicesFound , ~, resourceNames] = mexNI845x('findDevices');
            catch
                % Set numDevicesFound to -1 to signal the driver is not
                % installed
                numDevicesFound = -1;
                resourceNames = '';
            end
            
            ports = 0:numDevicesFound-1;
            if (numDevicesFound > 0)
                boardSerials =  instrument.interface.spi.ni845x.Utility.getSerialFromResource(resourceNames);
            else
                boardSerials = '';
            end
        end
        
        function deviceHandle = ni845xOpen(boardIndex)
            % Call the vendor driver function.
            [deviceHandle, status] = mexNI845x('open', boardIndex);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xOpen');            
        end
        
        function ni845xClose(deviceHandle)
            % Call the vendor driver function.
            status = mexNI845x('close', deviceHandle);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xClose');     
        end
        
        function configurationHandle = ni845xConfigurationOpen()
            % Call the vendor driver function.
            [configurationHandle, status] = mexNI845x('configurationOpen');
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xConfigurationOpen');            
        end
        
        function ni845xConfigurationClose(configurationHandle)
            % Call the vendor driver function.
            status = mexNI845x('configurationClose', configurationHandle);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xConfigurationClose');     
        end
        
        function statusText = ni845xGetStatusString(statusCode)
            % Call the vendor driver function.
            statusText = mexNI845x('getStatusString', statusCode);            
        end
                
        function bitRate = ni845xGetBitRate(configurationHandle)
            % Call the vendor driver function.
            [bitRate, status] = mexNI845x('spiGetClockRate', configurationHandle);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xGetBitRate');
            % Convert KHz to Hz 
            bitRate = bitRate*1000;
        end
        
        function ni845xSetChipSelect(configurationHandle, chipSelect)
            % Call the vendor driver function.
            status = mexNI845x('spiSetChipSelect', configurationHandle, chipSelect);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xSetChipSelect');
        end
        
        function ni845xSetClockPhase(configurationHandle, clockPhase)
            % Call the vendor driver function.
            status = mexNI845x('spiSetClockPhase', configurationHandle, clockPhase);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xSetClockPhase');
        end
        
        function ni845xSetClockPolarity(configurationHandle, clockPolarity)
            % Call the vendor driver function.
            status = mexNI845x('spiSetClockPolarity', configurationHandle, clockPolarity);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xSetClockPolarity');
        end
        
        function ni845xSetBitRate(configurationHandle, bitRate)
            % Convert Hz to KHz as required by the vendor API
            bitRate = bitRate/1000;
            % Call the vendor driver function.
            status = mexNI845x('spiSetClockRate', configurationHandle, bitRate);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xSetBitRate');
        end
        
        function ni845xSetPort(configurationHandle, port)
            % Call the vendor driver function.
            status = mexNI845x('spiSetPort', configurationHandle, port);
            % Check the return status for an error condition.
            instrument.interface.spi.ni845x.NI845xSPILib.checkErrorStatus(status, 'ni845xSetPort');
        end
        
        function checkErrorStatus(status, functionName)
            % CHECKERRORSTATUS Validates the results of the vendor driver call.
            %
            %   This method is used to validate the results of calling a vendor
            %   driver function. It throws an error if the call failed. The error
            %   will contain information from the driver on the failure mode.
            %
            %   The function inputs are as follows:
            %       status - The vendor driver function returned status code.
            %       functionName - The name of the vendor driver function whose
            %           status is being checked.
            
            % Throw error on a failed function call.
            if status < 0
                throwAsCaller(MException('instrument:spi:vendorDriverError',...
                    message('instrument:spi:vendorDriverError',...
                    status,...
                    instrument.interface.spi.ni845x.NI845xSPILib.ni845xGetStatusString(status),...                    
                    functionName).getString()))                    
            end
        end
    end    
end

