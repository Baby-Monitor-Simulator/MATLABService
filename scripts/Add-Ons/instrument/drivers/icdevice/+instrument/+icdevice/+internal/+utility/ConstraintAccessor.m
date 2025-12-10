classdef ConstraintAccessor
    %CONSTRAINTACCESSOR class contains all constraints that apply to a
    %property.

    %   Copyright 2024 The MathWorks, Inc.

    properties
        % The list of constraint forms
        Constraints instrument.icdevice.internal.forms.Constraint

        % A cell array of all bounded and enum constraints
        AllConstraints = {}
    end

    properties (Constant)
        TypeFcnHandle = instrument.icdevice.internal.utility.ConstraintAccessor.populateTypeFcnHandle
        NonScalarType (1, 1) string = message("instrument_icdevice:driver:instrumentValue").string
    end

    %% Lifetime
    methods
        function obj = ConstraintAccessor(propName, allPermissibleTypes)

            % Create list of constraints
            for permissibleType = allPermissibleTypes
                c = instrument.icdevice.internal.forms.Constraint;
                c.PropertyName = propName;
                c.DataType = permissibleType.Type;
                c.Type = permissibleType.Constraint;

                switch c.Type
                    case "enum"
                        populateEnumConstraintType();
                    case "bounded"
                        range = permissibleType.ConstraintValue.Range;
                        c.RangeMax = range.MaxAttribute;
                        c.RangeMin = range.MinAttribute;

                        obj.AllConstraints{end+1} = [c.RangeMin c.RangeMax];
                    case "none"
                        % NO-OP
                end

                obj.Constraints(end+1) = c;
            end

            obj.AllConstraints = obj.AllConstraints';

            %% NESTED FUNCTION
            function populateEnumConstraintType()
                import instrument.icdevice.internal.utility.TokenReplacer

                if c.DataType == "String"
                    c.AllEnumValues = string.empty;
                else
                    c.AllEnumValues = [];
                end

                if isfield(permissibleType.ConstraintValue, "Enum")
                    % For an enum constraint type, save the enum name (called
                    % NameAttribute) and value (called ValueAttribute) in 2
                    % maps. The NameAttribute is the value that a user sets the
                    % property to. The ValueAttribute is what is returned from
                    % the instrument as a result of setting the property to the
                    % given NameAttribute.
                    %
                    % 1. The first map, EnumLookup, contains the
                    % NameAttributes as the key, and the ValueAttribute as the
                    % value.
                    %
                    % 2. The second map, EnumReverseLookup, contains the
                    % ValueAttribute as the key, and the NameAttribute as the
                    % value. It is the reverse of EnumLookup, and is used
                    % to translate the value returned by the instrument (the
                    % ValueAttribute) into the more human-readable
                    % NameAttribute.
                    %
                    % E.g. for a given driver property called CursorType
                    % <ConstraintValue>
                    %      <Enum Name="horizontalBars" Value="HBArs"/>
                    %      <Enum Name="verticalBars" Value="VBArs"/>
                    %      <Enum Name="none" Value="OFF"/>
                    %  </ConstraintValue>
                    %
                    % Here, the NameAttribute is "horizontalBars" and
                    % corresponding ValueAttribute is "HBArs". When user sets
                    % the CursorType property to "verticalBars" (say),
                    % internally, we first convert "verticalBars" to "VBArs"
                    % using the "EnumLookup" map and send "VBArs" to the
                    % instrument. When user queries the CursorType property
                    % back, the instrument returns back "VBArs" and we use the
                    % "EnumReverseLookup" map to convert "VBArs" to
                    % "verticalBars", which is then returned.

                    forwardLookup = containers.Map;
                    reverseLookup = containers.Map;

                    % Get all the NameAttributes and ValueAttributes, and
                    % create the EnumLookup and EnumReverseLookup maps.
                    for en = permissibleType.ConstraintValue.Enum
                        nameAttributeKey = TokenReplacer.replaceCustomTokensInDriverWithCode(string(en.NameAttribute));
                        valueAttributeKey = TokenReplacer.replaceCustomTokensInDriverWithCode(string(en.ValueAttribute));
                        forwardLookup(nameAttributeKey) = string(en.ValueAttribute);
                        reverseLookup(valueAttributeKey) = string(en.NameAttribute);

                        c.AllEnumValues(end+1) = nameAttributeKey;
                        c.AllEnumValues(end+1) = valueAttributeKey;

                        obj.AllConstraints{end+1} = instrument.internal.stringConversionHelpers.str2char(nameAttributeKey);
                    end

                    c.EnumLookup = forwardLookup;
                    c.EnumReverseLookup = reverseLookup;
                elseif isfield(permissibleType.ConstraintValue, "Value")
                    % this could be a double enum, or any other string enum
                    % that does not have a name-value attribute as above.

                    for v = permissibleType.ConstraintValue.Value
                        c.AllEnumValues(end+1) = v;
                        obj.AllConstraints{end+1} = instrument.internal.stringConversionHelpers.str2char(v);
                    end
                else
                    c.Value = [];
                end
            end
        end
    end

    %% APIs
    methods
        function validateConstraint(obj, val)
            % Validate input "val" against all constraints for the
            % ConstraintAccessor instance. If any constraint matches or is
            % a valid constraint for the input "val", this function is a
            % NO-OP. Error otherwise.

            mEx = [];
			allConstraintDisplay = "";
            for c = obj.Constraints
			    if ~any(c.DataType == instrument.icdevice.internal.forms.Constraint.DataTypes)
                    continue
                end
				
                fcn = obj.TypeFcnHandle(c.Type);

                % Invoke the validation function
                [str, mEx] = fcn(val, c);

                if isempty(mEx)
                    return
                end

                allConstraintDisplay = allConstraintDisplay + str + newline;
            end

			if isempty(mEx)
                return
            end
			
			% Throw if reached here. This means none of the constraints
            % were satisfied.
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;

            if isscalar(obj.Constraints)
                mEx = ep.getMException(mEx);
            else
                mEx = MException(message("instrument_icdevice:driver:constraintsNotSatisfied", ...
                    string(val), allConstraintDisplay));
                mEx = ep.getMException(mEx);
            end

            throw(mEx);
        end

        function val = getConstraintType(obj)
            % Return the constraint data type - string, double, or boolean
            % for the property.

            val = obj.getConstraintInternal("DataType");

            if val ~= obj.NonScalarType
                val = lower(val);
            end
        end

        function val = getConstraint(obj)
            % Return the constraint type - none, enum, or bounded for the
            % property.

            val = obj.getConstraintInternal();
        end

        function val = convertEnumValueToInstrumentValue(obj, val)
            % Helper function that converts user input to instrument input.

            val = obj.convertEnumValues(val);
        end

        function val = convertInstrumentValueToEnumValue(obj, val)
            % Helper function that converts instrument input to user input.

            val = obj.convertEnumValues(val, "EnumReverseLookup", "EnumLookup");
        end
    end

    methods (Access = private)

        function val = getConstraintInternal(obj, type)
            % Return the constraint type or constraint datatype for the
            % list of constraints.

            arguments
                obj
                type (1, 1) string {mustBeMember(type, ["DataType", "Type"])} = "Type"
            end

            validConstraints = string.empty;
            for c = obj.Constraints
                validConstraints(end+1) = c.(type); %#ok<*AGROW>
            end

            validConstraints = unique(validConstraints);
            if isscalar(validConstraints)
                val = validConstraints;
            else
                val = instrument.icdevice.internal.utility.ConstraintAccessor.NonScalarType;
            end

            val = instrument.internal.stringConversionHelpers.str2char(val);
        end

        function val = convertEnumValues(obj, val, mapToSearch, reverseMapToSearch)
            arguments
                obj
                val
                mapToSearch (1, 1) string {mustBeMember(mapToSearch, ["EnumLookup", "EnumReverseLookup"])} = "EnumLookup"
                reverseMapToSearch (1, 1) string {mustBeMember(reverseMapToSearch, ["EnumLookup", "EnumReverseLookup"])} = "EnumReverseLookup"
            end

            for c = obj.Constraints

                % No match - look at the next constraint
                if ~c.isEnumConstraintReplaceable()
                    continue
                end

                % There is also a possibility for the instrument to return
                % the value from the reverseMapToSearch, i.e. the
                % instrument never returned the instrument or user value
                % from the expected map, but the value from the reverse
                % map.
                %
                % e.g. querying for Language on the tektronix_tds1002
                % driver returns the user input value - "ENGLISH" instead
                % of the expected instrument return value - "ENG".
                %
                % Also, the expected user input value is "english" not
                % "ENGLISH" so we need to do the case-insensitive matching
                % as well to convert "ENGLISH" to "english" and return.
                [val, matched] = searchInMap(c.(reverseMapToSearch), val);

                % Matched - no need to convert
                if matched
                    return
                end

                % Try to find in the MapToSearch. If not matched, try the
                % next constraint.
                % NOTE - this needs to be a case-insensitive match. E.g.
                map = c.(mapToSearch);
                [val, matched] = searchInMap(map, val);

                if ~matched
                    continue
                end

                % Matched - return the converted value.
                val = map(val);
                break
            end

            %% NESTED FUNCTION
            function [val, matched] = searchInMap(map, val)
                % Returns true and the matched value if there was a match.
                % Returns false and returns the same input "val" otherwise.

                keys = string(map.keys)';
                idxMatched = strcmpi(keys, val);

                matched = any(idxMatched);
                if matched
                    val = keys(idxMatched);
                end
            end
        end

    end

    methods (Static, Hidden)

        %% Helper Functions
        function validateType(val, constraint)
            switch constraint.DataType
                case "Double"
                    mustBeNumeric(val);
                case "String"
                    mustBeText(val);
                case "Logical"
                    % Not checking - could not find a driver with a logical
                    % type to validate. Safer to let driver error later.
            end
        end

        function d = populateTypeFcnHandle()
            keys = instrument.icdevice.internal.forms.Constraint.ValidTypes;
            d = configureDictionary("string", "function_handle");
            for k = keys
                d(k) = str2func(getValidationFcn(k));
            end

            %% NESTED FUNCTION
            function str = getValidationFcn(type)
                str = sprintf("@(val, constraint) instrument.icdevice.internal.utility.ConstraintAccessor.check%s(val, constraint)", capitalizeType(type));

                %% NESTED FUNCTION - 2
                function type = capitalizeType(type)
                    type = upper(extractBetween(type, 1, 1)) + extractAfter(type, 1);
                end
            end
        end

        %% Constraint Check Functions
        % NOTE - These DO NOT throw but return the mException and a custom
        % error string.
        function [errorStr, mEx] = checkBounded(val, constraint)
            errorStr = "";
            mEx = [];
            try
                instrument.icdevice.internal.utility.ConstraintAccessor.validateType(val, constraint);
                mustBeGreaterThanOrEqual(val, constraint.RangeMin);
                mustBeLessThanOrEqual(val, constraint.RangeMax);
            catch
                errorStr = message("instrument_icdevice:driver:bounded", ...
                    string(constraint.RangeMin), string(constraint.RangeMax)).string;
                mEx = MException(message("instrument_icdevice:driver:valOutOfRange", ...
                    constraint.PropertyName, string(constraint.RangeMin), string(constraint.RangeMax)));
            end
        end

        function [errorStr, mEx] = checkEnum(val, constraint)
            errorStr = "";
            mEx = [];
            try
                instrument.icdevice.internal.utility.ConstraintAccessor.validateType(val, constraint);
                mustBeMember(val, constraint.AllEnumValues);
            catch
                enumStr = join(string(constraint.AllEnumValues), ", ");
                errorStr = message("instrument_icdevice:driver:enum", enumStr).string;
                mEx = MException(message("instrument_icdevice:driver:invalidVal", ...
                    constraint.PropertyName, enumStr));
            end
        end

        function [errorStr, mEx] = checkNone(val, constraint)
            errorStr = "";
            mEx = [];
            try
                instrument.icdevice.internal.utility.ConstraintAccessor.validateType(val, constraint);
            catch ex
                errorStr = message("instrument_icdevice:driver:none", lower(constraint.DataType)).string;
                mEx = ex;
            end
        end
    end
end