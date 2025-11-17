classdef InstrumentDataConverter
    %INSTRUMENTDATACONVERTER utility converts instrument data to user
    %readable data, and is responsible for doing the appropriate data
    %conversions for the instrument data based on the drive constraints.
    %E.g. if the instrument returned a value "1000" and the driver
    %constraints say that the value should be a double, this utility will
    %correctly convert "1000" (string) to 1000 (double)

    %   Copyright 2024 The MathWorks, Inc.

    methods (Static)
        function value = convertDataToSpecifiedDataType(details, value)
            % Handle the final data type for the getter data. The data type
            % can be an MException, a double, or a string.
            %
            % "details" needs to be a property map entry for the group's
            % sub-property that we are converting the value for.

            if isa(value, "MException")
                % If the get data is an MException, that means there was an
                % issue running the getter code for the property. In that
                % case, use the "DefaultValue" for the property, if it
                % exists.

                if defaultExists()
                    value = details.DefaultValue;
                else
                    throwAsCaller(value);
                end
            end

            if ~isfield(details.PermissibleType, "Type")
                return
            end

            if isnumeric(value)
                dataType = "double";
            else
                dataType = "char";
            end

            % Some properties can be returned as both double and string.
            % Get list of all supported types.
            allTypes = unique(lower(string({details.PermissibleType.Type})));

            % For scalar types, run the value by the corresponding convert
            % function, i.e. convertToDouble for double or convertToChar
            % for char.
            if isscalar(allTypes)
                type = allTypes;
                if type == "string"
                    type = "char";
                end

                value = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                    convertToType(type, dataType, details, value);
                return
            end

            % For multiple permissible types, if any of the permissible
            % types is double, try to convert to double first.
            % If the conversion is successful, no need to check for the
            % other types.
            if any("double" == allTypes)
                [tempVal, convertSuccessful] = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                    convertToDouble(details, value, dataType);

                if convertSuccessful
                    value = tempVal;
                    return
                end
            end

            % The conversion to double failed, or double was not one of the
            % permissible data types. Convert to char and return final
            % value.
            value = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                convertToChar(details, value, dataType);

            %% NESTED FUNCTION
            function flag = defaultExists()
                % Returns true if the property map entry has a default
                % value for the property. Returns false otherwise.

                flag = true;
                defaultFieldExists = isfield(details, "DefaultValue");

                if ~defaultFieldExists
                    flag = false;
                    return
                end

                default = details.DefaultValue;
                if isempty(default)
                    flag = false;
                    return
                end

                if isstring(default) && default == ""
                    flag = false;
                    return
                end
            end
        end
    end

    methods (Static, Access = ?instrument.internal.ITestable)
        function value = convertToType(type, dataType, details, value)
            % Convert to the final data type, "char" or "double".

            if type == "char"
                value = instrument.icdevice.internal.utility.InstrumentDataConverter.convertToChar(details, value, dataType);
            else
                [value, ~] = instrument.icdevice.internal.utility.InstrumentDataConverter.convertToDouble(details, value, dataType);
            end
        end

        function value = convertToChar(details, value, dataType)
            % Convert the final data to char. There are some properties
            % that have enum values for the get values. See if the value
            % matches any of the enum values. If it does, return the
            % corresponding enum value.

            if dataType == "char"
                value = string(value);
                value = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                    removeInvalidCharsFromString(value);
            end

            % If property is not an enum type, just convert the data to
            % char.
            constraints = details.Constraint;
            value = char(constraints.convertInstrumentValueToEnumValue(value));
        end

        function [value, convertSuccessful] = convertToDouble(~, value, dataType)
            % Convert the final data to double.

            convertSuccessful = true;
            if dataType == "double"
                value = double(value);
                return
            end

            % For numeric data represented as a string, e.g. "0" instead of
            % 0.
            if dataType == "char"
                value = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                    removeInvalidCharsFromString(value);
            end
            value = str2double(value);

            if isnan(value) || isinf(value)
                convertSuccessful = false;
                value = [];
            end
        end

        function val = removeInvalidCharsFromString(value)
            % Remove invalid characters like newline and null characters
            % from the end of the instrument output.

            val = string(value);
            invalidChars = [newline, string(char(0))];
            while endsWith(val, invalidChars)
                val = replace(val, invalidChars, "");
            end
        end
    end

    %% Private Constructor
    methods (Access = private)
        function obj = InstrumentDataConverter()
        end
    end
end