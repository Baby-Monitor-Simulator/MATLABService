classdef CommonDIOImplementor < serialcontroller.internal.interfaces.IDIOImplementor
    % COMMONDIOIMPLEMENTOR class contains common digital IO properties and
    % implementation.

    % Copyright 2022 The MathWorks, Inc.

    methods (Abstract,Access = protected)
        % Should return an error ID when incorrect size of digital pin
        % numeric or string array is specified for the controller.
        id = getDigitalPinArraySizeErrorID(obj)
    end

    properties
        AvailableDigitalPins
    end

    properties (Hidden)
        NumericDigitalPinArray
    end

    properties (Constant,Hidden)
        DigitalPinMode = ["input","output"]
        DigitalPinAllowedValueArray = [0,1]
    end

    %% Helper methods
    methods (Access = protected)
        function pinNumber = validatePinNumericScalar(obj,pin)
            % Validates scalar numeric value for pin.
            pinNumber = double(pin);

            if ~any(pinNumber == obj.NumericDigitalPinArray)
                msg = message("instrument:interface:serialcontroller:IncorrectDigitalPinError").string + " " + string(num2str(obj.NumericDigitalPinArray));
                throw(getInvalidDigitalPinNumberException(obj,msg));
            end
        end

        function validatePinNumericNonScalar(obj,pin)
            % Validates non-scalar numeric value for pins.
            try
                validateattributes(pin,"numeric",{"size",size(obj.AvailableDigitalPins)});
            catch
                throw(MException(message(getDigitalPinArraySizeErrorID(obj))));
            end

            if ~all(double(pin) == obj.NumericDigitalPinArray)
                msg = message("instrument:interface:serialcontroller:IncorrectDigitalPinArrayError").string + " [" + string(num2str(obj.NumericDigitalPinArray)) + "].";
                throw(getInvalidDigitalPinNumberException(obj,msg));
            end
        end

        function pinNumber = validateAndConvertPinStringScalarToDouble(obj,pin)
            % Validates scalar string value for pin and converts it to
            % corresponding pin number as a double.
            try
                pin = validatestring(pin,obj.AvailableDigitalPins);
            catch ex
                msg = replace(ex.message,"input","pin");
                throw(MException("instrument:interface:serialcontroller:InvalidDigitalPinString",msg));
            end

            pinNumber = obj.PinNumeric(pin);
        end

        function validatePinStringNonScalar(obj,pin)
            % Validates non-scalar string value for pins.
            try
                validateattributes(pin,"string",{"size",size(obj.AvailableDigitalPins)});
            catch
                throw(MException(message(getDigitalPinArraySizeErrorID(obj))));
            end

            if ~all(pin == obj.AvailableDigitalPins)
                pinStr = """" + join(convertStringsToChars(obj.AvailableDigitalPins))+ """";
                newpinStr = replace(pinStr," ",""", """);
                msg = message("instrument:interface:serialcontroller:IncorrectDigitalPinArrayError").string + " [" + newpinStr + "].";
                throw(getInvalidDigitalPinNumberException(obj,msg));
            end
        end

        function data = validateData(obj,pinNumber,data,singlePinOperation)
            % Validates data for write digital operations.
            try
                if singlePinOperation
                    validateattributes(data,["numeric","logical"],{"size",size(pinNumber)});
                else
                    validateattributes(data,["numeric","logical"],{"size",size(obj.AvailableDigitalPins)});
                end
            catch
                throw(MException(message("instrument:interface:serialcontroller:IncorrectWriteDigitalPinDataSize")));
            end

            try
                mustBeMember(data,obj.DigitalPinAllowedValueArray);
                data = double(data);
            catch
                throw(MException(message("instrument:interface:serialcontroller:IncorrectWriteDigitalPinData")));
            end
        end

        function [pinNumber,singlePinOperation] = validatePin(obj,pin)
            % Validates numeric, char or string pin value.
            validateattributes(pin,["char","string","numeric"],"nonempty");

            singlePinOperation = true;
            pinNumber = [];

            % validate numeric pin
            if isnumeric(pin) && isscalar(pin)
                pinNumber = validatePinNumericScalar(obj,pin);
            elseif isnumeric(pin) && ~isscalar(pin)
                validatePinNumericNonScalar(obj,pin);
                singlePinOperation = false;
            end

            % validate string pin
            pin = convertCharsToStrings(pin);

            if isStringScalar(pin)
                pinNumber = validateAndConvertPinStringScalarToDouble(obj,pin);
            elseif isstring(pin) && ~isscalar(pin)
                validatePinStringNonScalar(obj,pin);
                singlePinOperation = false;
            end
        end

        function pinNumber = validateAndParseScalarPin(obj,pin)
            % Parses and validates scalar pin numeric or string.
            pin = convertCharsToStrings(pin);
            validateattributes(pin,["string","numeric"],["nonempty","scalar"],"","pin");

            if isstring(pin)
                pinNumber = validateAndConvertPinStringScalarToDouble(obj,pin);
            elseif isnumeric(pin)
                pinNumber = validatePinNumericScalar(obj,pin);
            end
        end

        function ex = getInvalidDigitalPinNumberException(~,msg)
            % Retuns MException for invalid digital pin number specified
            % for the controller.
            arguments
                ~
                msg (1,1) string
            end
            ex = MException("instrument:interface:serialcontroller:InvalidDigitalPinNumber",msg);
        end
    end
end
