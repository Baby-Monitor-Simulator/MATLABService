classdef (Abstract) DriverPropInfoMixin < instrument.icdevice.internal.mixins.base.PropInfoMixin
    %DRIVERPROPINFOMIXIN is the base mixin class that handles propinfo
    %requests from the Driver class.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = DriverPropInfoMixin()
            mustBeA(obj, "instrument.icdevice.internal.Driver");
        end

        function val = propinfo(obj, names)
            arguments
                obj (1, 1) {instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "propinfo", 10)}
                names string = string.empty
            end

            % delegate to the base class method
            val = propinfo@instrument.icdevice.internal.mixins.base.PropInfoMixin(obj, names);
        end
    end

    %% Implement Abstract Methods from instrument.icdevice.internal.mixins.base.PropInfoMixin
    methods
        function prop = getPropName(obj, prop)
            if isKey(obj.PropertyExclusionList, prop)
                prop = obj.PropertyExclusionList(prop);
            end
        end

        function val = getReadOnly(obj, propName, isClassProperty)
            val = 'always';
            if isClassProperty
                prop = getPropertyDetails(obj, propName);
                if prop.SetAccess == "public"
                    val = 'never';
                end
            end
        end

        function [constraint, constraintValue] = getConstraints(obj, propName, isClassProperty)
            classType = getClassType(obj, propName, isClassProperty);
            if obj.InstrumentDriverType == "SCPIBasedMDD" && contains(propName, keys(obj.parent.PropertyMap))
                propStruct = obj.parent.PropertyMap(propName);
                constraintAccessor = propStruct.Constraint;

                constraint = constraintAccessor.getConstraint();
                constraintValue = constraintAccessor.AllConstraints;

                if isempty(constraintValue)
                    constraintValue = [];
                end
            else
                if classType == "object"
                    constraint = char(classType);
                    constraintValue = [];
                else
                    constraint = 'none';
                    constraintValue = '';
                end
            end

        end

        function classType = getClassType(obj, propName, ~)

            if contains(propName, keys(obj.parent.PropertyMap))
                propStruct = obj.parent.PropertyMap(propName);
                constraintAccessor = propStruct.Constraint;

                classType = instrument.internal.stringConversionHelpers.str2char(constraintAccessor.getConstraintType());
                return
            end

            prop = get(obj, propName);

            if ~isempty(prop) && ~isscalar(prop)
                prop = prop(1);
            end
            classType = lower(class(prop));
            if contains(classType, ".")
                classType = 'object';
            elseif classType == "char"
                classType = 'string';
            end

            classType = char(classType);
        end

        function defaultVal = getDefaultValue(obj, propName, ~)
            if obj.InstrumentDriverType == "SCPIBasedMDD" && contains(propName, keys(obj.parent.PropertyMap))
                propStruct = obj.parent.PropertyMap(propName);
                defaultVal = propStruct.DefaultValue;
            elseif any(propName == obj.PublicClassPropertyList)
                defaultVal = obj.DefaultValuesPublicClassProperty(propName);
                defaultVal = defaultVal{:};
            else
                defaultVal = get(obj, propName);
            end
        end
    end
end
