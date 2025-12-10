classdef (Abstract) ClassSpecificPropertiesMixin < handle
    %CLASSSPECIFICPROPERTIESMIXIN allows for the following operations on
    % class specific properties.
    %
    % 1. Adding a property
    % 2. Getting or Setting a property
    % 3. Providing access specifier (public or private) for properties
    % 4. Allowing custom getter and setter functions for dependent
    %    properties
    % 5. Allowing custom setter validation functions for properties.
    %
    % These operations allow for creating a property system in MATLAB
    % (without using MATLAB's property system) and having the same property
    % get/set access, dependent properties, validation functions for
    % property, etc as is available in MCOS.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Hidden)
        ParentPropertyList (1, :) string
    end

    properties (Abstract, Hidden, Constant)
        PreDefinedClassPropertyList (1, :) string
    end

    properties (Dependent, SetAccess = private)
        ClassSpecificPropertiesList
    end

    properties (Access = private)
        PropertyProxy
        LastStateAccessSpecifier = []
    end

    methods (Hidden)
        function obj = ClassSpecificPropertiesMixin()
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.AllPropertiesSetGetMixin");
            obj.PropertyProxy = dictionary;

            % Add all the PreDefinedClassPropertyList properties (from
            % implementing classes) to the ClassSpecificPropertiesMixin
            % class.
            for prop = obj.PreDefinedClassPropertyList
                obj.addClassSpecificProperty(prop, []);
            end
        end

        function value = getPropertyDetails(obj, name)
            % Get the ClassSpecificPropertyForm value for the given
            % property name.
            arguments
                obj
                name (1, 1) string
            end
            validatePropertyName(obj, name);
            value = obj.PropertyProxy(name);
        end

        function addClassSpecificProperty(obj, name, varargin)
            % Add a new property to the ClassSpecificPropertiesList
            arguments
                obj
                name (1, 1) string
            end

            arguments(Repeating)
                varargin
            end

            if numEntries(obj.PropertyProxy) ~= 0 && isClassSpecificProperty(obj, name)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:propAlreadyExists"))));
            end

            value = instrument.icdevice.internal.forms.ClassSpecificPropertyForm(varargin{:});
            obj.PropertyProxy(name) = value;

            if value.IsParentProperty
                obj.ParentPropertyList(end+1) = name;
            end
        end

        function value = getClassSpecificPropertyValue(obj, name)
            % Get the value of the class specific property.

            validatePropertyName(obj, name);

            prop = obj.PropertyProxy(name);

            % For a parent property, query for the property value from the
            % parent group getter.
            if prop.IsParentProperty
                parentGroup = obj.parent; %#ok<*MCNPN>
                value = get(parentGroup, name);
            else
                value = getClassSpecificProperty(obj, prop);
            end

            %% NESTED FUNCTION
            function value = getClassSpecificProperty(~, prop)
                value = prop.PropertyValue;

                % For a Dependent property, call the getter function for
                % the property value.
                if ~isempty(prop.DependentGetterFcn)
                    value = prop.DependentGetterFcn();
                end

                % Return the char value
                value = instrument.internal.stringConversionHelpers.str2char(value);
            end
        end

        function setClassSpecificPropertyValue(obj, name, value, override)
            % For a given class specific property, set the property value
            arguments
                obj
                name (1, 1) string
                value
                override (1, 1) logical = false
            end

            validatePropertyName(obj, name);

            % Get the existing property.
            prop = obj.PropertyProxy(name);

            % The override flag allows for setting the property value,
            % irrespective of private setting, or without invoking any
            % setter validation function.
            if override
                prop.PropertyValue = value;
                obj.PropertyProxy(name) = prop;
                return
            end

            % Throw an error if trying to set a private property.
            if prop.SetAccess == "private"
                throw(obj.getMException(MException(message("instrument_icdevice:driver:readOnly", upper(name)))));
            end

            % For a parent property, delegate the property setting to the
            % "parent" group setter.
            if prop.IsParentProperty
                set(obj.parent, name, value);
                return
            end

            % If a setter validation function is set for the property,
            % invoke the function.
            if ~isempty(prop.SetterValidationFcn)
                for f = prop.SetterValidationFcn
                    value = f(value);
                end
            end

            % If the property is dependent, call the dependent setter
            % function, else set the property value normally.
            if ~isempty(prop.DependentSetterFcn)
                prop.DependentSetterFcn(value);
            else
                prop.PropertyValue = value;
                obj.PropertyProxy(name) = prop;
            end
        end

        function setAccessSpecifier(obj, name, value)
            % For a given property, change the access specifier once set.
            arguments
                obj
                name (1, 1) string
                value (1, 1) string {mustBeMember(value, ["private", "public"])} = "public"
            end

            setPropertyAttribute(obj, name, "SetAccess", value);
        end

        function setValidationFcn(obj, name, fcn)
            % For a given property, change the setter validation function
            % once set.
            arguments
                obj
                name (1, 1) string
                fcn function_handle = function_handle.empty
            end

            setPropertyAttribute(obj, name, "SetterValidationFcn", fcn);
        end

        function setDependentGetterFcn(obj, name, fcn)
            % For a given property, change the getter function for a
            % dependent property once set.
            arguments
                obj
                name (1, 1) string
                fcn function_handle = function_handle.empty
            end

            setPropertyAttribute(obj, name, "DependentGetterFcn", fcn);
        end
    end

    methods
        function val = get.ClassSpecificPropertiesList(obj)
            % Return the list of properties added to the
            % ClassSpecificPropertiesMixin.

            if numEntries(obj.PropertyProxy) == 0
                % No properties exist
                val = string.empty;
            else
                val = keys(obj.PropertyProxy)';
            end
        end
    end

    %% For MASS SET/REVERT/TAKE SCREENSHOT of Access Specifiers for properties
    % These 3 methods need to work together -
    %
    % 1. takeScreenShotAccessSpecifier() - Take a screenshot of access
    % specifier
    %
    % 2. setAllAccessSpecifier() - Set the access specifier to particular
    % state - public or private
    %
    % 3. revertAccessSpecifier() - Revert the current access specifier to
    % the screenshot from 1.
    methods (Hidden)
        function takeScreenShotAccessSpecifier(obj)
            obj.LastStateAccessSpecifier = ...
                configureDictionary("string", "string");

            for k = keys(obj.PropertyProxy)'
                obj.LastStateAccessSpecifier(k) = obj.PropertyProxy(k).SetAccess;
            end
        end

        function setAllAccessSpecifier(obj, setAccess)
            arguments
                obj
                setAccess (1, 1) string {mustBeMember(setAccess, ["public", "private"])} = "public"
            end
            for k = keys(obj.PropertyProxy)'
                obj.PropertyProxy(k).SetAccess = setAccess;
            end
        end

        function revertAccessSpecifier(obj)
            if isempty(obj.LastStateAccessSpecifier)
                return
            end

            for k = keys(obj.PropertyProxy)'
                obj.PropertyProxy(k).SetAccess = obj.LastStateAccessSpecifier(k);
            end

            obj.LastStateAccessSpecifier = [];
        end
    end

    methods (Access = private)
        function setPropertyAttribute(obj, name, fieldName, fieldValue)
            % Set the property attribute for a given
            % ClassSpecificPropertyForm field
            arguments
                obj
                name (1, 1) string
                fieldName (1, 1) string
                fieldValue
            end

            validatePropertyName(obj, name);
            propStruct = obj.PropertyProxy(name);
            propStruct.(fieldName) = fieldValue;
            obj.PropertyProxy(name) = propStruct;
        end

        function val = isClassSpecificProperty(obj, name)
            % Return true if given property name is already added to the
            % ClassSpecificPropertiesMixin.

            val = isKey(obj.PropertyProxy, name);
        end

        function validatePropertyName(obj, name)
            % Error if the specified property name has not been added to
            % the ClassSpecificPropertiesMixin.

            if ~isClassSpecificProperty(obj, name)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:nonexistentProperty"))));
            end
        end
    end
end