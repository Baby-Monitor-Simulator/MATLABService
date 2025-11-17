classdef CommonI2CImplementor < serialcontroller.internal.interfaces.II2CImplementor & ...
        matlabshared.transportlib.internal.ByteOrder
    % COMMONI2CIMPLEMENTOR class implements I2C methods - write, read,
    % writeRegister, readRegister, scanI2CBus.
    % It uses the asyncIO channel to complete the above I2C operations.

    % Copyright 2022 The MathWorks, Inc.

    properties (Hidden)
        % I2C properties
        I2CAddress
        BitRate
        Timeout
        ByteOrder

        % These are flags that track if I2C properties are updated.
        % These I2C properties are only updated using asyncIO channel if they were
        % updated in MATLAB since the last I2C read/write asyncIO operation.
        I2CAddressUpdated (1,1) logical = false
        BitRateUpdated (1,1) logical = false
        TimeoutUpdated (1,1) logical = false

        % Flag that allows or disallows further data validation for write
        % and writeRegister.
        ValidateDataPrecisionRange (1,1) logical = true
    end

    properties (Access = private,Constant,Hidden)
        % Property that maps given precision to byte size.
        SizeOf = struct("int8",1,"uint8",1,"int16",2,"uint16",2,"int32",4,"uint32",4,"int64",8,"uint64",8,"single",4,"double",8,"char",1)

        % Based on hwsdk specifications
        MaxRegisterAddress = 255
        MinRegisterAddress = 0

        RegisterAddressString (1,1) string = message("instrument:interface:serialcontroller:RegisterAddress").string
        DataString (1,1) string = message("instrument:interface:serialcontroller:Data").string
    end

    properties (Constant,Hidden)
        I2CPrecisions = ["int8","uint8","int16","uint16","int32","uint32","int64","uint64","char","single","double"]
    end

    properties
        % Range of I2C Bitrates supported for a controller.
        % This will be populated by the controller.
        BitRateValues = []
    end

    %% createI2CDevice API
    methods
        function createI2CDevice(~,channel)
            % Created I2C peripheral device using asyncIO that handles I2C
            % operations.
            try
                channel.execute("CreateI2CDevice");
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% scanI2CBus, read, write, readRegister, writeRegister APIs
    methods
        function i2cAddress = scanI2CBus(~,channel)
            % Returns the addresses of all I2C peripherals connected to the controller.
            try
                channel.execute("ScanI2CBus");
            catch ex
                throwAsCaller(ex);
            end

            % Convert returned addresses from char to string hexadecimal display.
            scannedi2caddress = string(dec2hex(channel.ReturnData))';
            if scannedi2caddress == "" %#ok<BDSCI>
                i2cAddress = string.empty;
            else
                i2cAddress = "0x" + scannedi2caddress;
            end
        end

        function dataOut = read(obj,channel,varargin)
            % Reads data from I2C device.
            %   See also READREGISTER, WRITE, WRITEREGISTER.
            try
                narginchk(3,4);

                % I2C properties are updated before read operation.
                updateI2CProperties(obj,channel);

                % input parsing and validation
                % Validate count and precision input
                switch nargin
                    case 3
                        precision = "uint8";
                    case 4
                        precision = obj.validatePrecision(varargin{2});
                end

                count = validateCount(obj,varargin{1});

                % calculate read count
                numBytes = count * obj.SizeOf.(precision);
                countToRead = cast(numBytes,"uint32");

                % asyncIO operation
                options.Count = countToRead;
                try
                    channel.execute("ReadI2CCommand",options);
                catch e
                    funcName = message("instrument:interface:serialcontroller:Read").string;
                    throw(MException(e.identifier,message("instrument:interface:serialcontroller:VendorErrorString",funcName,e.message).string));
                end
                dataOut = channel.ReturnData;

                % format data read based on precision specified.
                dataOut = formatReadData(obj,dataOut,precision);
            catch ex
                throwAsCaller(ex);
            end
        end

        function dataOut = readRegister(obj,channel,register,varargin)
            % Reads data from I2C device register.
            %   See also READ, WRITE, WRITEREGISTER.
            try
                narginchk(3,5);

                % I2C properties are updated before read operation.
                updateI2CProperties(obj,channel);

                % input parsing and validation
                % Validate register input
                try
                    register = serialcontroller.internal.utility.SerialControllerUtility.validateIntParameterRanged(obj.RegisterAddressString,register,obj.MinRegisterAddress,obj.MaxRegisterAddress);
                catch ex
                    throwAsCaller(ex);
                end

                % Validate count and precision input
                switch nargin
                    case 3
                        count = 1;
                        precision = "uint8";
                    case 4
                        if isnumeric(varargin{1})
                            count = varargin{1};
                            precision = "uint8";
                            count = validateCount(obj,count);
                        else
                            precision = varargin{1};
                            count = 1;
                            precision = obj.validatePrecision(precision);
                        end
                    case 5
                        count = validateCount(obj, varargin{1});
                        precision = obj.validatePrecision(varargin{2});
                end

                % asyncIO operation
                % register number is sent as data to asyncIO to point to register specified.
                data = cast(register,"uint8");
                options.Data = data;

                % calculate read count
                numBytes = count * obj.SizeOf.(precision);
                countToRead = cast(numBytes, "uint32");

                % asyncIO operation
                options.Count = countToRead;
                try
                    channel.execute("ReadRegisterCommand",options);
                catch e
                    funcName = message("instrument:interface:serialcontroller:ReadRegister").string;
                    throw(MException(e.identifier,message("instrument:interface:serialcontroller:VendorErrorString",funcName,e.message).string));
                end
                dataOut = channel.ReturnData;

                % format data read based on precision specified.
                dataOut = formatReadData(obj,dataOut,precision);
            catch ex
                throwAsCaller(ex);
            end
        end

        function write(obj,channel,dataIn,varargin)
            % Writes data to I2C device.
            %   See also READ, WRITEREGISTER, READREGISTER.
            try
                narginchk(3,4);

                % I2C properties are updated before write operation.
                updateI2CProperties(obj,channel);

                % input parsing and validation
                % Validate precision and data
                precision = "uint8";
                if nargin == 4
                    precision = obj.validatePrecision(varargin{1});
                end
                dataIn = obj.validateData(dataIn,precision);

                % format data to write based on precision specified.
                dataIn = formatWriteData(obj,dataIn,precision);

                % asyncIO operation
                options.Data = dataIn;
                try
                    channel.execute("WriteI2CCommand",options);
                catch e
                    funcName = message("instrument:interface:serialcontroller:Write").string;
                    throw(MException(e.identifier,message("instrument:interface:serialcontroller:VendorErrorString",funcName,e.message).string));
                end
            catch ex
                throwAsCaller(ex);
            end
        end

        function writeRegister(obj,channel,register,dataIn,precision)
            % Writes data to I2C device register.
            %   See also READ, WRITE, READREGISTER.
            try
                narginchk(4,5);

                % I2C properties are updated before write operation.
                updateI2CProperties(obj,channel);

                % input parsing and validation
                % Validate register input
                try
                    register = serialcontroller.internal.utility.SerialControllerUtility.validateIntParameterRanged(obj.RegisterAddressString,register,obj.MinRegisterAddress,obj.MaxRegisterAddress);
                catch ex
                    throwAsCaller(ex);
                end

                % Validate precision and data
                if nargin < 5
                    precision = "uint8";
                else
                    precision = obj.validatePrecision(precision);
                end
                dataIn = obj.validateData(dataIn,precision);

                % format data to write based on precision specified.
                dataIn = formatWriteData(obj,dataIn,precision);

                % combine register to write to and data
                register = cast(register,"uint8");
                dataIn = [register dataIn];

                % asyncIO operation
                options.Data = dataIn;
                try
                    channel.execute("WriteI2CCommand",options);
                catch e
                    funcName = message("instrument:interface:serialcontroller:WriteRegister").string;
                    throw(MException(e.identifier,message("instrument:interface:serialcontroller:VendorErrorString",funcName,e.message).string));
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Validation functions
    methods
        function validateBitRate(obj,value)
            try
                validateattributes(value,"double",["nonempty","scalar"],"","BitRate");
                mustBeMember(value,obj.BitRateValues);
            catch ex
                msg = replace(ex.message,"Value","BitRate");
                throw(MException("instrument:interface:serialcontroller:InvalidBitRate",msg));
            end
        end
    end

    methods (Access = private)
        function count = validateCount(~,count)
            % Validates I2C read count.
            % intmax("uint16") is the maximum value allowed for reads by
            % supported vendor controllers.
            try
                validateattributes(count,"numeric",{">",0,"<=",intmax("uint16"),"scalar","integer","finite","nonnan"},"","count");
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidCount",ex.message));
            end
        end

        function result = validatePrecision(obj, precision)
            % Validates I2C precision.
            try
                result = validatestring(precision, obj.I2CPrecisions,"","precision");
            catch ex
                throw(MException("instrument:interface:serialcontroller:InvalidPrecision",ex.message));
            end
        end

        function result = validateData(obj,dataIn,precision)
            % Validates data to write.
            result = 0;
            try
                % non-scalar string data should error.
                if isstring(dataIn) && ~isscalar(dataIn)
                    throw(MException(message("instrument:interface:serialcontroller:InvalidStringNonScalarData")));
                end

                dataIn = convertStringsToChars(dataIn);

                if ischar(dataIn)
                    % Convert characters to ascii decimals
                    dataIn = cast(dataIn,precision);
                end

                % convert char and numeric data to uint8 values.
                if precision == "char" && (isnumeric(dataIn) || ischar(dataIn))
                    dataIn = uint8(dataIn);
                end

                % data should be numeric at this point.
                if ~isnumeric(dataIn)
                    throw(MException(message("instrument:interface:serialcontroller:InvalidDataTypeWriteData")));
                end

                % validate numeric data range based on precision specified.
                if obj.ValidateDataPrecisionRange
                    switch precision
                        case "double"
                            result = serialcontroller.internal.utility.SerialControllerUtility.validateDoubleArrayParameterRanged(dataIn, ...
                                realmin(precision), ...
                                realmax(precision));
                        case "single"
                            result = serialcontroller.internal.utility.SerialControllerUtility.validateSingleArrayParameterRanged(dataIn, ...
                                realmin(precision), ...
                                realmax(precision));
                        case "char"
                            result = serialcontroller.internal.utility.SerialControllerUtility.validateIntArrayParameterRanged(obj.DataString, ...
                                dataIn, ...
                                intmin("uint8"), ...
                                intmax("uint8"));
                        case {"int8","uint8","int16","uint16","int32","uint32","int64","uint64"}
                            result = serialcontroller.internal.utility.SerialControllerUtility.validateIntArrayParameterRanged(obj.DataString, ...
                                dataIn, ...
                                intmin(precision), ...
                                intmax(precision));
                    end
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Format functions
    methods (Access = private)
        function dataIn = formatWriteData(obj,dataIn,precision)
            if precision == "char"
                return
            end

            dataIn = cast(dataIn,precision);
            if obj.NeedByteSwap(obj.ByteOrder)
                dataIn = swapbytes(dataIn);
            end
            dataIn = typecast(dataIn,"uint8");
        end

        function dataOut = formatReadData(obj,dataOut,precision)
            if precision ~= "char"
                dataOut = typecast(dataOut,char(precision));
                if obj.NeedByteSwap(obj.ByteOrder)
                    dataOut = swapbytes(dataOut);
                end
                if precision ~= "uint64" && precision ~= "int64"
                    dataOut = double(dataOut);
                end
            else
                % Can't typecast non-numerics so string and char are
                % handled differently.
                dataOut = char(dataOut);
            end
        end
    end

    %% Setters
    methods
        function set.I2CAddress(obj,value)
            % Update I2CAddress if the value has changed since last I2C
            % read/write operation.
            if isempty(obj.I2CAddress) || value ~= obj.I2CAddress
                obj.I2CAddress = value;
                obj.I2CAddressUpdated = true; %#ok<MCSUP>
            else
                obj.I2CAddressUpdated = false; %#ok<MCSUP>
            end
        end

        function set.BitRate(obj,value)
            % Update BitRate if the value has changed since last I2C
            % read/write operation.
            if isempty(obj.BitRate) || value ~= obj.BitRate
                obj.BitRate = value;
                obj.BitRateUpdated = true; %#ok<MCSUP>
            else
                obj.BitRateUpdated = false; %#ok<MCSUP>
            end
        end

        function set.Timeout(obj,value)
            % Update Timeout if the value has changed since last I2C
            % read/write operation.
            if isempty(obj.Timeout) || value ~= obj.Timeout
                obj.Timeout = value;
                obj.TimeoutUpdated = true; %#ok<MCSUP>
            else
                obj.TimeoutUpdated = false; %#ok<MCSUP>
            end
        end
    end

    %% Pre Read/Write Operations
    methods(Access = private)
        function updateI2CProperties(obj,channel)
            % Updates I2C properties using asyncIO if a property value change has
            % occurred since the last I2C read/write operation.
            % If a property is set to -1 then asyncIO device will treat -1
            % as an unchanged value for the property.
            if obj.I2CAddressUpdated || obj.BitRateUpdated || obj.TimeoutUpdated
                if obj.I2CAddressUpdated
                    options.I2CAddress = obj.I2CAddress;
                else
                    options.I2CAddress = -1;
                end

                if obj.BitRateUpdated
                    options.BitRateVal = obj.BitRate;
                else
                    options.BitRateVal = -1;
                end

                if obj.TimeoutUpdated
                    options.TimeoutVal = obj.Timeout;
                else
                    options.TimeoutVal = -1;
                end

                % asyncIO operation to update property values
                channel.execute("SetI2CProperties",options);
            end
        end
    end
end
