classdef I2CDevice < matlabshared.transportlib.internal.ByteOrder & ...
        matlabshared.testmeas.CustomDisplay & ...
        matlabshared.testmeas.internal.SetGet
    %

    % I2CDEVICE is the representation of a I2C peripheral in MATLAB.
    % Many I2CDevice objects can be created in MATLAB where each represents
    % a unique I2C peripheral. It contains values for I2C properties that
    % are unique to a particular I2C peripheral (unique since each peripheral
    % has pre-defined requirements for I2C communication that can be found
    % on the peripheral's datasheet.)

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant)
        Protocol (1,1) string = "I2C"
    end

    properties (SetAccess = private)
        I2CAddress
    end

    properties
        BitRate
        ByteOrder (1,1) string = "little-endian"
    end

    properties (Access = private)
        Controller
        SaveSuccessFlag (1,1) logical = false
    end

    properties (Constant,Access = private)
        I2CAddressString (1,1) string = message("instrument:interface:serialcontroller:I2CAddress").string
    end

    properties (Hidden)
        ValidateDataPrecisionRange (1,1) logical = true
        Timeout
    end

    properties (Constant,Hidden)
        ByteOrderValues = ["little-endian","big-endian"]
    end

    %% Lifetime
    methods
        function obj = I2CDevice(controller,varargin)
            arguments
                controller (1,1) serialcontroller.internal.interfaces.II2CFunctions
            end

            arguments (Repeating)
                varargin
            end

            try
                narginchk(3,9);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxI2CDevice")));
            end

            % Validates the number of name-value pairs
            if mod(numel(varargin),2)
                throwAsCaller(MException(message("instrument:interface:serialcontroller:IncorrectNumInputArguments")));
            end

            obj.Controller = controller;
            createI2CDevice(obj.Controller);

            % input parsing
            try
                p = inputParser;
                p.PartialMatching = true;
                addParameter(p,"I2CAddress",[],@(x) validateattributes(x,["numeric","char","string"],"nonempty"));
                addParameter(p,"BitRate",100000,@(x) validateattributes(x,"numeric",["nonempty","scalar"]));
                addParameter(p,"ByteOrder","little-endian",@(x) validateattributes(x,["char","string"],"nonempty"));
                parse(p,varargin{:});
                obj.I2CAddress = p.Results.I2CAddress;
                obj.BitRate = p.Results.BitRate;
                obj.ByteOrder = p.Results.ByteOrder;

                % Saves I2C address of successfully created I2C peripheral device.
                obj.SaveSuccessFlag = saveDeviceI2CAddress(obj.Controller,obj.I2CAddress);
            catch ex
                throwAsCaller(ex);
            end

            setCustomDisplay(obj);
        end

        function delete(obj)
            if obj.SaveSuccessFlag
                % Removes I2C address of successfully created I2C peripheral device.
                removeDeviceI2CAddress(obj.Controller,obj.I2CAddress);
            end
        end
    end

    %% Setters
    methods
        function set.I2CAddress(obj,value)
            try
                value = serialcontroller.internal.utility.SerialControllerUtility.validateHexParameterRanged(obj.I2CAddressString,value,0,127);
                validFlag = checkAddressValidity(obj,double(value));
                if ~validFlag
                    throw(MException(message("instrument:interface:serialcontroller:InvalidI2CAddress")));
                end
                obj.I2CAddress = double(value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.BitRate(obj,value)
            try
                validateBitRate(obj.Controller,value); %#ok<MCSUP>
                obj.BitRate = value;
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.ByteOrder(obj,value)
            try
                value = validatestring(value,obj.ByteOrderValues);
                obj.ByteOrder = value;
            catch ex
                throwAsCaller(MException("instrument:interface:serialcontroller:InvalidByteOrder",ex.message));
            end
        end

        function set.Timeout(~,~)
            throwAsCaller(MException(message("instrument:interface:serialcontroller:TimeoutNotSupported")));
        end

        function value = get.Timeout(~) %#ok<STOUT>
            throwAsCaller(MException(message("instrument:interface:serialcontroller:TimeoutNotSupported")));
        end

        function set.ValidateDataPrecisionRange(obj,value)
            try
                setI2CProperty(obj.Controller,"ValidateDataPrecisionRange",value); %#ok<MCSUP>
                obj.ValidateDataPrecisionRange = value;
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% read, write, readRegister, writeRegister APIs
    methods (Sealed)
        function writeRegister(obj,register,dataIn,varargin)
            try
                narginchk(3,4);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxWriteRegister")));
            end

            try
                updateProperties(obj);
                writeRegister(obj.Controller,register,dataIn,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function dataOut = readRegister(obj,register,varargin)
            try
                narginchk(2,4);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxReadRegister")));
            end

            try
                updateProperties(obj);
                dataOut = readRegister(obj.Controller,register,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function write(obj,dataIn,varargin)
            try
                narginchk(2,3);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxWriteI2C")));
            end

            try
                updateProperties(obj);
                writeI2C(obj.Controller,dataIn,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end

        function dataOut = read(obj,varargin)
            try
                narginchk(2,3);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxReadI2C")));
            end

            try
                updateProperties(obj);
                dataOut = readI2C(obj.Controller,varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    methods (Access = private)
        function updateProperties(obj)
            % Updates all I2C properties on the controller object.
            setI2CProperty(obj.Controller,"I2CAddress",obj.I2CAddress);
            setI2CProperty(obj.Controller,"BitRate",obj.BitRate);
            setI2CProperty(obj.Controller,"ByteOrder",obj.ByteOrder);
        end

        function validFlag = checkAddressValidity(obj,value)
            % Checks if I2C peripheral exists at I2C address specified.
            try
                i2cAddresses = scanI2CBus(obj.Controller);
            catch
                i2cAddresses = string.empty;
            end
            i2cAddressesNumeric = double.empty;
            for address = i2cAddresses
                i2cAddressesNumeric(end+1) = serialcontroller.internal.utility.SerialControllerUtility.validateHexParameterRanged(obj.I2CAddressString,address,0,127); %#ok<AGROW>
            end
            validFlag = any(value == i2cAddressesNumeric);
        end
    end

    %% Custom display
    methods (Access = protected)
        function setCustomDisplay(obj)
            % Sets the property display for the controller object.
            obj.ShowAllPropertiesInFooter = false;
        end
    end
end
