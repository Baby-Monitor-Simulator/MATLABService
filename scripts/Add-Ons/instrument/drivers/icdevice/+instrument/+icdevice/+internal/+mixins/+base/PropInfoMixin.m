classdef (Abstract) PropInfoMixin < handle
    %PROPINFOMIXIN provides propinfo() capabilities for the Driver and
    %Group classes.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods (Abstract)
        % Return the name of the property.
        propName = getPropName(obj, prop)

        % Return the associated class type for the property value.
        classType = getClassType(obj, propName, isClassProperty)

        % Return whether the property is read-only - possible values are
        % 'never' or 'always'.
        val = getReadOnly(obj, propName, isClassProperty)

        % Return the associated constraints for the property -
        %
        % 1. The list of possible values that the property can be set to
        % (for an enum), or
        %
        % 2. The range of numeric values that the property can be set to
        % (for a bounded type), or
        %
        % 3. Empty, if the property has no constraints.
        [constraint, constraintValue] = getConstraints(obj, propName, isClassProperty)

        % Return the default property value from the MDD.
        defaultVal = getDefaultValue(obj, propName, isClassProperty)
    end

    methods
        function val = propinfo(obj, names)
            % Returns a PropInfoForm with the following properties
            %
            % 1. Type
            % 2. Constraint
            % 3. ConstraintValue
            % 4. DefaultValue
            % 5. ReadOnly
            % 6. InterfaceSpecific

            arguments
                obj 
                names string = string.empty
            end

            if isempty(names)
                val = getPropInfoForAllProperties(obj);
                return
            end

            if iscolumn(names)
                names = names';
            end

            val = instrument.icdevice.internal.forms.PropInfoForm.empty;

            % "names" is an array of property names passed in by the user
            % where "name" is the individual property name from the list.
            for name = names
                finalName = [];
                [prop, propertyType] = findProperty(obj, name);

                isClassSpecificProperty = ...
                    propertyType == instrument.icdevice.internal.PropertyType.ClassSpecific;

                if isClassSpecificProperty
                    finalName = prop;
                elseif ~isempty(prop)
                    finalName = obj.getPropName(prop);
                end

                if isempty(finalName)
                    throwAsCaller(obj.getMException(MException(message("instrument_icdevice:driver:invalidProp", name))));
                end

                % Check if the property belongs to the parent object and
                % retrieve its information if true
                if isParentProperty(obj, finalName, isClassSpecificProperty)
                    gVal = propinfo(obj.parent, finalName);
                    val(end+1) = gVal;
                    continue
                end

                val(end+1).Type = char(getClassType(obj, finalName, isClassSpecificProperty));

                [val(end).Constraint, val(end).ConstraintValue] = getConstraints(obj, finalName, isClassSpecificProperty);
                val(end).InterfaceSpecific = ~isClassSpecificProperty;
                val(end).ReadOnly = getReadOnly(obj, finalName, isClassSpecificProperty);
                val(end).DefaultValue = getDefaultValue(obj, finalName, isClassSpecificProperty);
            end

            if ~isscalar(val)
                % Convert val to cell array.
                tempVal = val;
                val = {};
                for v = tempVal
                    val{end+1} = v;
                end
            end
        end
    end

    methods (Access = private)
        function val = getPropInfoForAllProperties(obj)
            % Combine Class and MDD properties to gather all properties
            % related to the object. Remove any properties longer than the
            % maximum allowable size.
            [isAdjusted, allProps] = constructValidPropertyList(obj);

            % Warn users if the list does not contain all properties on
            % the driver or group for propinfo and tell them how to access
            % those properties' propinfo form.
            if isAdjusted
                warning(message("instrument_icdevice:driver:propInfoAdjustedList"));
            end

            val = struct;
            for f = allProps
                val.(f) = obj.propinfo(f);
            end

            % Add PropInfo to PropertyToTest when the code is in unit test
            % mode.
            if ~obj.ProductionMode
                propObj = instrument.icdevice.internal.forms.ProductionModeForm.empty;
                propObj(1).PropInfo = val;
                setPropertyToTest(obj, propObj);
            end
        end

        function flag = isParentProperty(obj, propName, isClassSpecific)
            % isParentProperty determines if a given property is a parent
            % property.
            if ~isClassSpecific
                flag = false;
                return
            end

            propDetails = getPropertyDetails(obj, propName);
            flag = propDetails.IsParentProperty;
        end
    end
end
