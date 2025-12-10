classdef Constraint
    %CONSTRAINT is a form class for the ConstraintAccessor class. It
    %contains information about the type of constraints a property can
    %have.

    %   Copyright 2024 The MathWorks, Inc.

    properties
        % The property name that the constraint applies to
        PropertyName (1, 1) string

        % The data type for the constraint
        DataType (1, 1) string = "Double"

        % The type of constraint
        Type (1, 1) string {validateType(Type)} = "none"

        % For a bounded type, the max bound. For a non-bounded type, i.e.
        % enum and none, RangeMax = []
        RangeMax

        % For a bounded type, the min bound. For a non-bounded type, i.e.
        % enum and none, RangeMin = []
        RangeMin

        % Map containing the name attribute for the enum as a key, and the
        % value attribute as the corresponding value.
        % For non-enum value, EnumLookup = [].
        EnumLookup

        % Map containing the value attribute for the enum as a key, and the
        % name attribute as the corresponding value.
        % For non-enum value, EnumReverseLookup = []
        EnumReverseLookup

        % Array of all enum values. For non-enum type, AllEnumValues = []
        AllEnumValues
    end

    properties (Constant)
        ValidTypes (1, :) string = ["none", "bounded", "enum"]
        DataTypes (1, :) string = ["Boolean", "Double", "String"]
    end

    methods
        function flag = isEnumConstraintReplaceable(obj)
            flag = obj.Type == "enum" && ~isempty(obj.EnumLookup);
        end
    end
end

function validateType(val)
   mustBeMember(val, instrument.icdevice.internal.forms.Constraint.ValidTypes);
end