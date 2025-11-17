classdef AardvarkDIOImplementor < serialcontroller.internal.dio.CommonDIOImplementor
    % AARDVARKDIOIMPLEMENTOR implements DIO methods - configureDigitalPin,
    % writeDigitalPin, readDigitalPin that use Aardvark controller digital
    % pins. It uses the asyncIO channel to complete the above DIO operations.

    %   Copyright 2022 The MathWorks, Inc.

    properties (Access = private)
        % initial pin state
        AllPinMode (1,1) double = double(0b000000)

        % initial write pin value
        % This is needed as a mask for single pin operations.
        WriteDigitalVal (1,1) double = double(0b000000)
    end

    properties (Constant,Access = private)
        % Returns digital mask values for corresponding pin numbers.
        MaskVal = dictionary([1,3,5,7,8,9],[1,2,4,8,16,32])
    end

    properties (Constant,Hidden)
        % Returns numeric pin numbers for corresponding pin string names.
        PinNumeric = dictionary(["Pin1","Pin3","Pin5","Pin7","Pin8","Pin9"],[1,3,5,7,8,9])
    end

    %% Digital IO API
    methods
        function varargout = configureDigitalPin(obj,channel,varargin) %#ok<STOUT>
            % Sets the mode of a digital pin of a controller to "output" or "input".
            try
                narginchk(4,4);
                nargoutchk(0,0);
            catch
                throwAsCaller(MException(message("instrument:interface:serialcontroller:InvalidSyntaxConfigureDigitalPin")));
            end

            try
                % parse and validate pin
                pinNumber = validateAndParseScalarPin(obj,varargin{1});

                % Get corresponding mask value for specified pinNumber.
                maskVal = obj.MaskVal(pinNumber);

                % validate pinMode
                try
                    mode = validatestring(varargin{2},obj.DigitalPinMode);
                catch ex
                    throw(MException("instrument:interface:serialcontroller:InvalidDigitalPinMode",ex.message));
                end

                % Set allPinModes "output" or "input" using bit
                % operations.
                if mode == "output"
                    obj.AllPinMode = bitor(obj.AllPinMode,maskVal);
                elseif mode == "input"
                    obj.AllPinMode = bitand(obj.AllPinMode,bitxor(double(0b111111),maskVal));
                end

                % asyncIO operation
                options.MaskVal = obj.AllPinMode;
                channel.execute("ConfigureDigitalPin",options);
            catch ex
                throwAsCaller(ex);
            end
        end

        function writeDigitalPin(obj,channel,pin,data)
            % Writes digital high or low value using specified digital pin(s).
            try
                narginchk(4,4);
                [pinNumber,singlePinOperation] = validatePin(obj,pin);
                data = validateData(obj,pinNumber,data,singlePinOperation);

                if singlePinOperation
                    maskVal = obj.MaskVal(pinNumber);

                    % Single pin asyncIO operation
                    options.DigitalPinNumber = pinNumber;
                    if data == 0
                        options.DigitalVal = bitand(obj.WriteDigitalVal,bitxor(double(0b111111),maskVal));
                    elseif data == 1
                        options.DigitalVal = bitor(obj.WriteDigitalVal,maskVal);
                    end
                    channel.execute("WriteDigitalPin",options);
                else
                    % convert data to write from array format to decimal value.
                    data = flip(data);
                    strData = num2str(data);

                    % All pins asyncIO operation
                    options.DigitalVal = bin2dec(strData);
                    channel.execute("WriteDigitalMultiPin",options);
                end
                obj.WriteDigitalVal = options.DigitalVal;
            catch ex
                throwAsCaller(ex);
            end
        end

        function data = readDigitalPin(obj,channel,pin)
            % Reads digital high or low value using specified digital pin(s).
            try
                narginchk(3,3);
                [pinNumber,singlePinOperation] = validatePin(obj,pin);

                if singlePinOperation
                    maskVal = obj.MaskVal(pinNumber);

                    % Single pin asyncIO operation
                    options.DigitalPinNumber = pinNumber;
                    channel.execute("ReadDigitalPin",options);
                    data = channel.ReturnData;

                    % Retrieve value of specified pin read from data using
                    % bit operations.
                    pinValue = bitand(data,maskVal);
                    if pinValue == maskVal
                        data = 1;
                    elseif pinValue == 0
                        data = 0;
                    end
                else
                    % All pins asyncIO operation
                    channel.execute("ReadDigitalMultiPin");
                    dataRead = channel.ReturnData;

                    % convert dataRead from decimal value to expected array format.
                    dataReadBinary6Bits = dec2bin(dataRead,6);
                    data = char(num2cell(dataReadBinary6Bits));
                    data = reshape(str2num(data),1,[]); %#ok<ST2NM>
                    data = flip(data);
                end
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    %% Helper methods
    methods (Access = protected)
        function id = getDigitalPinArraySizeErrorID(~)
            % Returns an error ID when incorrect size of digital pin
            % numeric or string array is specified for the aardvark controller.
            id = "instrument:interface:serialcontroller:IncorrectDigitalPinArraySizeAardvark";
        end
    end

    %% Query Pin Mode API
    methods
        function pinState = getDigitalPinMode(obj,pinNumber)
            % Returns the pin mode "input" or "output" for the specified
            % pin.
            maskVal = obj.MaskVal(pinNumber);

            % Retrieve pinMode "output" or "input" using bit
            % operations.
            pinMode = bitand(obj.AllPinMode,maskVal);
            if pinMode == maskVal
                pinState = "output";
            elseif pinMode == 0
                pinState = "input";
            end
        end
    end
end
