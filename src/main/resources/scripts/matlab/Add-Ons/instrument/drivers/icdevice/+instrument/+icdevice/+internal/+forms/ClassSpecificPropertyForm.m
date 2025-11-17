classdef ClassSpecificPropertyForm
    %CLASSSPECIFICPROPERTYFORM contains properties needed for the
    %ClassSpecificPropertiesMixin to store class specific member values.

    %   Copyright 2022 The MathWorks, Inc.

    properties
        PropertyValue = []
        SetAccess (1, 1) string {mustBeMember(SetAccess, ["public", "private"])} = "public"
        SetterValidationFcn function_handle = function_handle.empty()
        IsParentProperty (1, 1) logical = false
        DependentGetterFcn function_handle = function_handle.empty()
        DependentSetterFcn function_handle = function_handle.empty()
    end

    methods
        function obj = ClassSpecificPropertyForm(propertyValue, isParentProperty, setAccess, setterValidationFcn, dependentGetterFcn, dependentSetterFcn)
            arguments
                propertyValue
                isParentProperty (1, 1) logical = false
                setAccess (1, 1) string {mustBeMember(setAccess, ["private", "public"])} = "public"
                setterValidationFcn function_handle = function_handle.empty()
                dependentGetterFcn function_handle = function_handle.empty()
                dependentSetterFcn function_handle = function_handle.empty()
            end
            obj.PropertyValue = propertyValue;
            obj.IsParentProperty = isParentProperty;
            obj.SetAccess = setAccess;
            obj.SetterValidationFcn = setterValidationFcn;
            obj.DependentGetterFcn = dependentGetterFcn;
            obj.DependentSetterFcn = dependentSetterFcn;
        end
    end
end