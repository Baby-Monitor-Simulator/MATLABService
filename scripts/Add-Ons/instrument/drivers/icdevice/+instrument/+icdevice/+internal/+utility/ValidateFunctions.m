classdef ValidateFunctions < handle
    % VALIDATEFUNCTIONS class contain functions that is used to validate
    % driver or group objects by checking for any inconsistencies or
    % errors.

    % Copyright 2024 The MathWorks, Inc.

    methods (Static)
        function isObjValid(obj, nameType, index)
            % The 'nameType' variable is utilized to identify the type of
            % object being processed. This information is required to throw
            % errors specific to the object.
            arguments
                obj
                nameType (1, 1) string {mustBeMember(nameType, ["Driver", "Group", "propinfo", "Driverconnect", "get", "set", "Devicereset", "Driverdisconnect", "geterror", "selftest"])}
                index (1, 1) double = 1
            end

            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            if ~all(isvalid(obj))
                if nameType == "Driver"
                    throw(ep.getMException(MException(message("instrument:icdevice:invoke:invalidArg")), index));
                elseif nameType == "Group"
                    throw(ep.getMException(MException(message("instrument:icgroup:invoke:invalidArgObj")), index));
                else
                    throw(ep.getMException(MException(message("instrument_icdevice:driver:opfailed")), index));
                end
            end
        end

        function validateObjectSize(obj, nameType, index)
            % validateObjectSize function checks if the provided object
            % `obj` is a scalar. It throws an error if `obj` is not a
            % scalar, based on the `nameType` provided. The `nameType`
            % parameter is used to determine the type of error message to
            % display when throwing an exception.
            arguments
                obj
                nameType (1, 1) string {mustBeMember(nameType, ["Driver", "Group", "Driverconnect", "get", "set", "Devicereset", "Driverdisconnect", "geterror", "selftest"])}
                index (1, 1) double = 1
            end

            % Check the array of obj, whether the obj is valid or empty
            if ~isscalar(obj)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                if nameType == "Driver"
                    throw(ep.getMException(MException(message("instrument_icdevice:driver:invokeInvalidArgDim")), index));
                elseif any(nameType == ["get", "set"])
                    throw(ep.getMException(MException(message("instrument_icdevice:driver:exceedingArgument", nameType)), index));
                else
                    throw(ep.getMException(MException(message("instrument_icdevice:driver:invalidOBJ")), index));
                end
            end
        end

        function validateInvokeName(methodName, group, nameType, index)
            % validateInvokeName validates the method name and its presence
            % in a group.
            %
            % This function checks if the provided methodName is a string
            % and if it exists within the methods of the specified group.
            % It uses the nameType to determine the context for the
            % validation and throws an error if the validation fails.

            arguments
                methodName
                group
                nameType (1, 1) string {mustBeMember(nameType, ["Driver", "Group"])}
                index (1, 1) double = 1
            end

            % Convert the input name to a char array
            methodName = instrument.internal.stringConversionHelpers.str2char(methodName);

            % Error, if a method is invoked with non-string input
            if ~ischar(methodName)
                if nameType == "Driver"
                    throw(group.getMException(MException(message("instrument_icdevice:driver:invokeInvalidArgName")), index));
                else
                    throw(group.getMException(MException(message("instrument_icdevice:driver:invokeGroupInvalidArgName")), index));
                end
            end

            % Retrieve the list of groups
            for g = group
                groupElements = keys(g.MethodMap)';

                % Check if the methodName is not present in the
                % groupElements if not found throw an exception
                if ~any(strcmp(methodName, groupElements))
                    if nameType == "Driver"
                        throw(group.getMException(MException(message("instrument_icdevice:driver:invokeInvalidFcn", methodName)), index));
                    else
                        throw(group.getMException(MException(message("instrument_icdevice:driver:invokeGroupInvalidFcn", methodName)), index));
                    end
                end
            end
        end

        function validatePropertyError(propertyType, propName)
            % Throw if the property does not exist. NO-OP for valid
            % property names.
            if propertyType == instrument.icdevice.internal.PropertyType.Error
                throw(MException(message("instrument_icdevice:driver:invalidProp", propName)));
            end
        end

        function val = validateRepCapIdentifier(val)
            % Validates and converts the repeated capability identifier to
            % a character.
            mustBeText(val);

            % To convert cell arrays to string. We can then use the
            % str2char function to convert everything to char.
            val = string(val);
            val = instrument.internal.stringConversionHelpers.str2char(val);
        end

        function val = validateTimeout(val)
            % Validates that the timeout value is a nonnegative, nonzero,
            % finite scalar.
            try
                validateattributes(val, "double", ["scalar", "nonnegative", "finite", ...
                    "nonzero", "nonempty"], mfilename, "Timeout");
            catch ex
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throwAsCaller(ep.getMException(MException("instrument:set:opfailed", ex.message)));
            end
        end

        function val = validateTag(val)
            % Validates that the tag is a scalar text value.
            try
                validateattributes(val, ["char", "string"], "scalartext", mfilename, "Tag");
            catch ex
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throwAsCaller(ep.getMException(MException("instrument:set:opfailed", ex.message)));
            end
        end
    end
end

