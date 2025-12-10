classdef NI845xDIOImplementor < serialcontroller.internal.dio.CommonDIOImplementor
    % NI845XDIOIMPLEMENTOR implements DIO methods - configureDigitalPin,
    % writeDigitalPin, readDigitalPin that use NI845x controller digital
    % pins. It uses the asyncIO channel to complete the above DIO operations.

    %   Copyright 2022 The MathWorks, Inc.

    properties (Access = private)
        % initial pin state
        AllPinMode (1,1) double = double(0b00000000)
    end

    properties (Constant,Hidden)
        % Returns numeric pin numbers for corresponding pin string names.
        PinNumeric = dictionary(["P0.0","P0.1","P0.2","P0.3","P0.4","P0.5","P0.6","P0.7"],[0,1,2,3,4,5,6,7])
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
                maskVal = bitshift(1,pinNumber);

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
                    obj.AllPinMode = bitand(obj.AllPinMode,bitxor(double(0b11111111),maskVal));
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
                    % Single pin asyncIO operation
                    options.DigitalPinNumber = pinNumber;
                    options.DigitalVal = data;
                    channel.execute("WriteDigitalPin",options);
                else
                    % convert data to write from array format to decimal value.
                    data = flip(data);
                    strData = num2str(data);

                    % All pins asyncIO operation
                    options.DigitalVal = bin2dec(strData);
                    channel.execute("WriteDigitalMultiPin",options);
                end
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
                    % Single pin asyncIO operation
                    options.DigitalPinNumber = pinNumber;
                    channel.execute("ReadDigitalPin",options);
                    data = channel.ReturnData;
                else
                    % All pins asyncIO operation
                    channel.execute("ReadDigitalMultiPin");
                    dataRead = channel.ReturnData;

                    % convert dataRead from decimal value to expected array format.
                    dataReadBinary8Bits = dec2bin(dataRead,8);
                    data = char(num2cell(dataReadBinary8Bits));
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
            % numeric or string array is specified for the ni845x controller.
            id = "instrument:interface:serialcontroller:IncorrectDigitalPinArraySizeNI845x";
        end
    end

    %% Query Pin Mode API
    methods
        function pinState = getDigitalPinMode(obj,pinNumber)
            % Returns the pin mode "input" or "output" for the specified
            % pin.

            % Retrieve pinMode "output" or "input" using bit
            % operations.
            pinToRead = pinNumber + 1;
            pinMode = bitget(obj.AllPinMode,pinToRead);
            if pinMode == 1
                pinState = "output";
            else
                pinState = "input";
            end
        end
    end
end
