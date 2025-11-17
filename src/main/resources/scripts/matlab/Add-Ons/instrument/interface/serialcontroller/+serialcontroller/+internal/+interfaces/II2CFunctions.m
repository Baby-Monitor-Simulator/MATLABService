classdef(Abstract) II2CFunctions < handle
    % II2CFUNCTIONS is an interface that provides I2C methods to be implemented by a controller class.
    % An I2CDevice object expects a controller class to be of this interface because the I2CDevice object
    % should be able to invoke the II2CFunctions methods on the controller object.
    % The methods of this interface will not be visible on the controller object to users.

    % Copyright 2022 The MathWorks, Inc.

    methods (Abstract,Access = {?serialcontroller.internal.interfaces.II2CFunctions,?serialcontroller.internal.i2c.I2CDevice})
        % Should write data from controller to register address of connected I2C peripheral device.
        writeRegister(obj,register,dataIn,varargin)

        % Should read data from register address of connected I2C
        % peripheral device to controller.
        dataOut = readRegister(obj,register,varargin)

        % Should write data from controller to connected I2C peripheral device.
        writeI2C(obj,dataIn,varargin)

        % Should read data from connected I2C peripheral device to controller.
        dataOut = readI2C(obj,varargin)
    end
end

