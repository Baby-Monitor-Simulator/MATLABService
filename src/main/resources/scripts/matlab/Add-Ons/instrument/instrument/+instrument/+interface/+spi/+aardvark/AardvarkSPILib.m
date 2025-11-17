classdef (Hidden) AardvarkSPILib
% AardvarkSPILib Aardvark SPI Library function wrapping class.
%
%   This class wraps and presents the functions available in Aardvark SPI
%   Library. This is meant for internal use only and applies no input
%   validation. It does perform output validation on each call though and
%   will error should any function fail.

% Copyright 2013 The MathWorks, Inc.

    methods (Static)
        function deviceHandle = aardvarkOpen(boardIndex)
            % Call the vendor driver function.
            deviceHandle = mexAardvark('open', boardIndex);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(deviceHandle, 'aardvarkOpen');            
        end
        
        function uniqueId = aardvarkGetUniqueId(deviceHandle)
            % Call the vendor driver function.
            uniqueId = mexAardvark('getUniqueId', deviceHandle);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(uniqueId, 'aardvarkGetUniqueId');
        end
        
        function bitRate = aardvarkSpiBitRate(deviceHandle, bitRate)
            % Convert Hz to KHz as required by the vendor API
            bitRate = bitRate/1000;
            % Call the vendor driver function.
            bitRate = mexAardvark('spiBitRate', deviceHandle, bitRate);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(bitRate, 'aardvarkSpiBitRate');
            % Convert KHz to Hz as required by the F-Spec
            bitRate = bitRate*1000;
        end
        
        function aardvarkClose(deviceHandle)
            % Call the vendor driver function.
            status = mexAardvark('close', deviceHandle);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(status, 'aardvarkClose');     
        end
        
        function statusText = aardvarkGetStatusString(statusCode)
            % Call the vendor driver function.
            statusText = mexAardvark('getStatusString', statusCode);            
        end
        
        function [numDevicesFound , ports, boardSerials] = aardvarkFindDevices()
            % Call the vendor driver function.
            [numDevicesFound , ports, boardSerials] = mexAardvark('findDevices');            
        end
        
        function aardvarkSpiConfigure(deviceHandle, clockPolarity, clockPhase)
            % Call the vendor driver function.
            status = mexAardvark('spiConfigure',deviceHandle, clockPolarity, clockPhase, 0);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(status, 'aardvarkSpiConfigure');
            
        end
        
        function aardvarkConfigure(deviceHandle, config)
            % Call the vendor driver function.
            status = mexAardvark('configure',deviceHandle, config);
            % Check the return status for an error condition.
            instrument.interface.spi.aardvark.AardvarkSPILib.checkErrorStatus(status, 'aardvarkConfigure');
            
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
            if status == -1
                throwAsCaller(MException('instrument:spi:vendorDriverError',...
                    message('instrument:spi:vendorDriverLoadError',...
                    'aardvark').getString()));
            elseif status == -7
                % Status -7 : AA_UNABLE_TO_OPEN
                % g938374 - Adding additional error information to help
                % users understand the unable to open Aardvark error
                throwAsCaller(MException('instrument:spi:vendorDriverError',...
                    [message('instrument:spi:vendorDriverError',...
                    status,...
                    instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkGetStatusString(status),...                    
                    functionName).getString(),...
                    '. Possible reason is another application or SPI object is connected to the device.']))
            elseif status < -1
                throwAsCaller(MException('instrument:spi:vendorDriverError',...
                    message('instrument:spi:vendorDriverError',...
                    status,...
                    instrument.interface.spi.aardvark.AardvarkSPILib.aardvarkGetStatusString(status),...                    
                    functionName).getString()))                    
            end
        end
    end    
end

