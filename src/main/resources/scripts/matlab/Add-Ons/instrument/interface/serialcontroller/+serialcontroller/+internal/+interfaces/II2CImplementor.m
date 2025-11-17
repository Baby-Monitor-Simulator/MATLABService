classdef(Abstract) II2CImplementor < handle
    % II2CIMPLEMENTOR is an interface that provides I2C methods that should
    % be implemented by a controller that wants to support I2C functionalities.

    % Copyright 2022 The MathWorks, Inc.

    methods (Abstract)
        % Should return I2C addresses of I2C peripherals connected to the
        % controller.
        i2cAddress = scanI2CBus(obj,channel)

        % Should read data from connected I2C peripheral device to controller.
        dataOut = read(obj,channel,varargin)

        % Should read data from register address of connected I2C
        % peripheral device to controller.
        dataOut = readRegister(obj,channel,register,varargin)

        % Should write data from controller to connected I2C peripheral device.
        write(obj,channel,dataIn,varargin)

        % Should write data from controller to register address of
        % connected I2C peripheral device.
        writeRegister(obj,channel,register,dataIn,precision)
    end
end

