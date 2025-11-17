classdef(Abstract) ControllerI2CMixin < serialcontroller.internal.interfaces.II2CFunctions
    % CONTROLLERI2CMIXIN class exposes the I2C methods such as writeI2C, readI2C,
    % writeRegister and readRegister operations to be invoked on the customer facing
    % controller class by the I2CDevice class.
    % It exposes the scanI2CBus method on the customer facing
    % controller class to be invoked directly by users.

    % Copyright 2022 The MathWorks, Inc.

    properties (Access = private)
        UsedI2CAddressArray (1,:) double = []
    end

    %% scanI2CBus API
    methods
        % Returns I2C addresses of I2C peripherals connected to the
        % controller.
        function i2cAddress = scanI2CBus(obj,varargin)
            try
                try
                    narginchk(1,1);
                catch
                    throw(MException(message("instrument:interface:serialcontroller:InvalidSyntaxScanI2CBus")));
                end
                i2cAddress = scanI2CBus(obj.ChannelHandler);
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Write/ Read API
    methods (Access = {?serialcontroller.internal.interfaces.II2CFunctions,?serialcontroller.internal.i2c.I2CDevice})
        % Writes data from controller to register address of connected I2C
        % peripheral device.
        function writeRegister(obj,register,dataIn,varargin)
            writeRegister(obj.ChannelHandler,register,dataIn,varargin{:});
        end

        % Reads data from register address of connected I2C
        % peripheral device to controller.
        function dataOut = readRegister(obj,register,varargin)
            dataOut = readRegister(obj.ChannelHandler,register,varargin{:});
        end

        % Writes data from controller to connected I2C peripheral device.
        function writeI2C(obj,dataIn,varargin)
            writeI2C(obj.ChannelHandler,dataIn,varargin{:});
        end

        % Reads data from connected I2C peripheral device to controller.
        function dataOut = readI2C(obj,varargin)
            dataOut = readI2C(obj.ChannelHandler,varargin{:});
        end
    end

    %% I2C Device Creation API
    methods (Access = ?serialcontroller.internal.i2c.I2CDevice)
        function createI2CDevice(obj)
            createI2CDevice(obj.ChannelHandler);
        end
    end

    %% Properties setters
    methods (Access = ?serialcontroller.internal.i2c.I2CDevice)
        function setI2CProperty(obj,propName,value)
            setI2CDeviceProperty(obj.ChannelHandler,propName,value);
        end
    end

    %% Validation functions
    methods (Access = ?serialcontroller.internal.i2c.I2CDevice)
        function validateBitRate(obj,value)
            validateBitRate(obj.ChannelHandler,value);
        end

        function success = saveDeviceI2CAddress(obj,i2cAddress)
            success = false; %#ok<NASGU>
            if ~any(i2cAddress == obj.UsedI2CAddressArray)
                obj.UsedI2CAddressArray(end+1) = i2cAddress;
                success = true;
            else
                throwAsCaller(MException(message("instrument:interface:serialcontroller:I2CDeviceAlreadyExists")));
            end
        end

        function removeDeviceI2CAddress(obj,i2cAddress)
            obj.UsedI2CAddressArray(obj.UsedI2CAddressArray == i2cAddress) = [];
        end
    end
end

