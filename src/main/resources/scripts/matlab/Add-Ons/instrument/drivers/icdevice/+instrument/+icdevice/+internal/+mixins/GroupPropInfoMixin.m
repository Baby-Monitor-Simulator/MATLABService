classdef (Abstract) GroupPropInfoMixin < instrument.icdevice.internal.mixins.base.PropInfoMixin
    %GROUPPROPINFOMIXIN is the mixin class that handles propinfo
    %requests from the Driver class.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = GroupPropInfoMixin()
            mustBeA(obj, "instrument.icdevice.internal.Group");
        end

        function val = propinfo(obj, names)
            arguments
                obj (1, 1) {instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "propinfo", 11)}
                names string = string.empty
            end

            % Delegate to the base class method
            val = propinfo@instrument.icdevice.internal.mixins.base.PropInfoMixin(obj, names);
        end
    end

    %% Implement Abstract Methods from instrument.icdevice.internal.mixins.base.PropInfoMixin
    methods
        function propName = getPropName(~, prop)
            propName = prop;
        end

        function val = getReadOnly(obj, propName, isClassProperty)

            if isClassProperty
                val = 'always';
                prop = getPropertyDetails(obj, propName);
                if prop.SetAccess == "public"
                    val = 'never';
                end
            else
                val = obj.PropertyMap(propName);
                val = char(val.ReadOnly);
            end
        end

        function [constraint, constraintValue] = getConstraints(obj, propName, isClassProperty)
            if isClassProperty
                classType = getClassType(obj, propName, isClassProperty);
                if classType == "object"
                    constraint = char(classType);
                    constraintValue = [];
                else
                    constraint = 'none';
                    constraintValue = '';
                end
            else
                propStruct = obj.PropertyMap(propName);
                constraintAccessor = propStruct.Constraint;

                constraint = constraintAccessor.getConstraint();
                constraintValue = constraintAccessor.AllConstraints;

                if isempty(constraintValue)
                    constraintValue = [];
                end
            end
        end

        function classType = getClassType(obj, propName, isClassProperty)
            if isClassProperty
                classType = class(get(obj, propName));
                if contains(classType, ".")
                    classType = 'object';
                elseif classType == "char"
                    classType = 'string';
                end
            else
                propStruct = obj.PropertyMap(propName);
                constraintAccessor = propStruct.Constraint;
                classType = constraintAccessor.getConstraintType();
            end

            classType = instrument.internal.stringConversionHelpers.str2char(classType);
        end

        function defaultVal = getDefaultValue(obj, propName, isClassProperty)
            if isClassProperty
                defaultVal = get(obj, propName);
            else
                defaultVal = instrument.icdevice.internal.utility.InstrumentDataConverter.convertDataToSpecifiedDataType(obj.PropertyMap(propName), ...
                    obj.PropertyMap(propName).DefaultValue);
            end
        end
    end
end
