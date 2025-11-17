classdef (Abstract) MDDSpecificPropertiesMixin < handle
    %MDDSPECIFICPROPERTIESMIXIN allows accessing MDD specific properties
    %for the Driver and Group objects.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Dependent, SetAccess = private)
        MDDRelatedPropertiesList
    end

    properties (Hidden)
        PropertyExclusionList
    end

    properties (Access = private)
        MDDRelatedProperties
    end

    properties (Constant, Access = private)
        PropNamesMatchingMATLABFunctions (1, :) string = ["display"];
    end

    methods
        function obj = MDDSpecificPropertiesMixin()
            obj.MDDRelatedProperties = containers.Map;
            obj.PropertyExclusionList = containers.Map;
        end
    end

    methods (Hidden)
        function addMDDSpecificProperty(obj, name, value)
            % Add the MDD specific property name and the associated
            % property value.

            try
                if validMDDPropertyName(obj, name)
                    obj.MDDRelatedProperties(name) = value;
                else
                    createUpdatedMDDRelatedProperty(obj, name, value);
                end
            catch ex
                throwAsCaller(ex);
            end

            %% NESTED FUNCTION
            function flag = validMDDPropertyName(obj, name)
                % Return true if the name can be added as a new MDD
                % Specific property. Return false otherwise. Returns true
                % if the property has not already been added and the
                % property is not one of PropNamesMatchingMATLABFunctions.

                flag = ~isProperty(obj, name) && ...
                    ~any(name == obj.PropNamesMatchingMATLABFunctions);
            end

            %% NESTED FUNCTION
            function createUpdatedMDDRelatedProperty(obj, propertyName, propertyValue)
                % For the case where the property name as is cannot be
                % added as an MDD property, update the property name. Add
                % the original property name and the new updated property
                % name to the PropertyExclusionList

                originalPropertyName = propertyName;

                index = 1;
                propertyAdded = false;

                while ~propertyAdded
                    propertyName = propertyName + string(index);

                    if isProperty(obj, propertyName)
                        index = index + 1;
                        continue
                    end

                    obj.MDDRelatedProperties(propertyName) = propertyValue;
                    propertyAdded = true;

                    obj.PropertyExclusionList(originalPropertyName) = propertyName;
                end
            end
        end

        function val = getMDDSpecificPropertyValue(obj, propertyName)
            % For an existing MDD Specific property, return the property
            % value.
            arguments
                obj
                propertyName (1, 1) string
            end

            if isExcludedProperty(obj, propertyName)
                propertyName = obj.PropertyExclusionList(propertyName);
            end

            if ~isProperty(obj, propertyName)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:invalidMDDProp"))));
            end

            val = obj.MDDRelatedProperties(propertyName);
        end
    end

    methods (Access = private)
        function flag = isProperty(obj, propertyName)
            % Returns true if the property name has already been added.

            flag = isKey(obj.MDDRelatedProperties, propertyName);
        end
        function flag = isExcludedProperty(obj, propertyName)
            % Returns true if the property name is an excluded property.

            flag = isKey(obj.PropertyExclusionList, propertyName);
        end
    end

    %% Getters/Setters
    methods
        function val = get.MDDRelatedPropertiesList(obj)
            val = string(keys(obj.MDDRelatedProperties));
        end
    end
end
