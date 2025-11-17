classdef DescriptorValidator < handle
    % DESCRIPTORVALIDATOR class contains methods which validate user input
    % from the Modal tab and returns a valid value to populate the updated field,
    % as well as the corresponding error if necessary.

    % Copyright 2021 The MathWorks, Inc.

    %% Validation Functions
    methods (Static)
        function isEmpty = isFieldEmpty(paramMap)
            % Check whether all Modal Tab fields are non-empty.
            isEmpty = false;

            % Get all configuration tab properties
            keys = paramMap.keys;
            for key = string(keys)
                % Check whether the Modal tab property is
                % non-empty.
                if isKey(paramMap, key) && isempty(paramMap(key).NewValue)
                    isEmpty = true;
                    return
                end
            end
        end

        function [value, ex] = validateEditField(paramMap, fieldName, errorID, defaultValue)
            % Validates the EditFields in the Modal Tab, including the
            % EditableDropDownLists.

            import transportapp.udpport.internal.DescriptorValidator

            % Error exception if any
            ex = MException.empty;

            % Save the new value if the key exists
            if isKey(paramMap, fieldName)
                value = paramMap(fieldName).NewValue;
            else
                return
            end

            if isempty(value) || value == ""
                % If the value is empty, get either the OldValue if valid,
                % or the default value if OldValue is also empty.
                value = ...
                    DescriptorValidator.getValueForEmptyNewValue(paramMap(fieldName), defaultValue);
                return
            end

            if isequal(value, defaultValue)
                return
            end

            % If field should contain an IP address, use validateIPAddress
            % for validation, otherwise use validatePort
            if any(fieldName == ["LocalHost", "DestinationAddress"])
                [value, ex] = DescriptorValidator.validateIPAddress( ...
                    fieldName, value, errorID, defaultValue, paramMap("IPAddressVersion").NewValue);
            else
                [value, ex] = DescriptorValidator.validatePort( ...
                    fieldName, value, errorID, defaultValue);
            end

            % If there was an error use the last good value.
            if ~isempty(ex)
                value = paramMap(fieldName).OldValue;
            end
        end

        function ex = validateUdpport(ipAddressVersion, localHost, localPort, enablePortSharing)
            % Validates that a udpport instance with these host,
            % port and portSharing parameters can be instantiated. This
            % catches errors such as attempting to bind a udpport object to
            % a port already in use.
            arguments
                ipAddressVersion
                localHost (1,1) string
                localPort (1,1) string
                enablePortSharing (1,1) logical
            end

            import transportapp.udpport.internal.DescriptorValidator

            ex = MException.empty;

            transportParams = {ipAddressVersion};

            if ~DescriptorValidator.isAuto(localHost)
                transportParams(end+1:end+2) = {"LocalHost", localHost};
            end

            if ~DescriptorValidator.isAuto(localPort)
                transportParams(end+1:end+2) = {"LocalPort", str2double(localPort)};
            end

            transportParams(end+1:end+2) = {"EnablePortSharing", enablePortSharing};

            try
                udpport(transportParams{:});
            catch 
                % Add custom exception here.
                % Use "Local Address" and "Local Port"
                ex = MException(message("transportapp:udpportapp:UnableToCreatePort", ipAddressVersion));
            end
        end

        function [value, ex] = validateIPAddress(fieldName, value, errorID, defaultValue, ipAddressVersion)
            % Ensure value is a string (mex.resolve requires a string) and
            % remove all " and ' from the value. A user may enter a correct
            % IP address surrounded by (double)quotes. The edit field reads
            % these (double)quotes as part of the string.
            value = string(value);
            value = replace(value, ["""", "''"], "");

            ex = MException.empty;

            if isempty(value) || value == "" || isequal(value, defaultValue)
                % Ensure that empty or default values are not evaluated by
                % mex.resolve.
                value = defaultValue;
                return
            end

            resolveStruct = matlabshared.network.internal.mex.resolve(value);

            % Check that either Address or Hostname are non-empty. If
            % both are empty, then IPAddress/Hostname could not be
            % resolved.
            if resolveStruct.Address == "" && resolveStruct.Error ~= ""
                % Could not resolve hostname/IP address or IP address
                % version was invalid.
                if fieldName == "LocalHost"
                    errorText =  message("transportapp:udpportapp:LocalAddressErrorText").getString;
                else
                    errorText = message("transportapp:udpportapp:DestinationAddressErrorText").getString;
                end
                % errorText is used twice in the error message, once in the
                % middle of a sentence, and once at the beginning of a
                % sentence. Two versions of the string are passed in to the
                % message: a lowercase version and one that begins with a
                % capital letter.
                ex = MException(message(errorID, lower(errorText), value, errorText, ipAddressVersion));
            end
        end

        function [value, ex] = validatePort(fieldName, value, errorID, defaultValue)
            ex = MException.empty;
            if isempty(value) || isequal(value, defaultValue)
                return
            end
            try
                % Valid values passed in may be either numeric or string
                % representation of numeric values. If the latter, convert
                % value to double (if this fails, value will be "NaN).
                % Use temporary variable portValue to keep types consistent
                % between parameter and return value.
                if ~isnumeric(value)
                    portValue = str2double(value);
                else
                    portValue = value;
                end

                % Local Port is allowed to be 0 because it indicates a random 
                % port selection (similar to selecting "Auto").
                % Destination Port may not be 0, the user should not be
                % writing to a random port.
                if fieldName == "LocalPort"
                    validInitialPort = 0;
                    errorText = message("transportapp:udpportapp:LocalPortErrorText").getString;
                else
                    validInitialPort = 1;
                    errorText = message("transportapp:udpportapp:DestinationPortErrorText").getString;
                end

                validateattributes(portValue, "numeric", {">=", validInitialPort, "<=", 65535, "scalar","integer"}, "", fieldName);
            catch
                ex = MException(message(errorID, errorText, validInitialPort));
            end
        end

        function val = isAuto(parameter)
           val = string(parameter) == message("transportapp:udpportapp:Auto").getString();
        end

        function val = isOptional(parameter)
            val = string(parameter) == string(message("transportapp:udpportapp:Optional").getString());
        end
    end

    %% Helper Methods
    methods (Access = private, Static)
        function value = getValueForEmptyNewValue(map, defaultValue)
            % When the paramMap NewValue is empty, return the appropriate
            % replacement value; either the paramMap OldValue, or the
            % default value.

            value = map.OldValue;

            if isempty(value) || value == ""
                value = defaultValue;
            end
            value = num2str(value);
        end
    end
end