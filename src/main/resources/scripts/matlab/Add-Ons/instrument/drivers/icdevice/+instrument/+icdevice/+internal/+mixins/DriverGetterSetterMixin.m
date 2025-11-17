classdef (Abstract) DriverGetterSetterMixin < instrument.icdevice.internal.mixins.base.AllPropertiesSetGetMixin
    %DRIVERGETTERSETTERMIXIN allows for getting and setting Driver related
    %properties using get() and set() functions.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = DriverGetterSetterMixin()
            mustBeA(obj, "instrument.icdevice.internal.Driver");
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.PropertyFinderMixin");
        end
    end

    methods
        function validateSizeHook(obj, nameType, index)
            % The value in index is explicitly specified here to align with
            % the ErrorProxyMixin's design, where a mapping has been
            % established to correlate single error IDs with multiple IDs.
            % The number denotes the specific index that this error ID
            % should correspond to, as per the predefined map in the mixin.
            % This ensures the correct error ID association.
            arguments
                obj
                nameType (1, 1) string {mustBeMember(nameType, ["get", "set"])} = "get"
                index (1, 1) double = 1
            end
            instrument.icdevice.internal.utility.ValidateFunctions.validateObjectSize(obj, nameType, index);
        end
    end

    %% Implement Abstract Methods from instrument.icdevice.internal.mixins.base.AllPropertiesSetGetMixin
    methods (Hidden)
        function prop = getPropertyValueForMDDType(obj, prop)
            prop = getMDDSpecificPropertyValue(obj, prop);
        end

        function setPropertyValueForMDDType(obj, name, value)
            % This function should always error - throw the appropriate
            % error.
            try
                if isstruct(value)
                    error(message("instrument_icdevice:driver:setStructFail"));
                end

                if ~isempty(name)
                    error(message("instrument_icdevice:driver:setFailICGroup"));
                end

                error(message("instrument_icdevice:driver:invalidPropType"));
            catch ex
                throwAsCaller(obj.getMException(ex));
            end
        end

        function displayAllLocalProperties(obj)
            % Display all the property names and possible values that the
            % property can be set to.
            % >> set(obj)
            %
            % RepCapIdentifier :
            %         UserData :
            %              Tag :
            %          Timeout :
            %         Language : [ {english}  |  french  |  german  |  italian  |  portuguese  |  spanish  |  japanese  |  korean  |  traditionalChinese  |  simplifiedChinese ]
            %             Math : [ {ch1 - ch2}  |  ch2 - ch1  |  ch1 + ch2 ]

            import instrument.icdevice.internal.mixins.DriverGetterSetterMixin

            validateSizeHook(obj, "set", 2);

            dispStr = "";
            readOnlyProps = string([]);

            propertyInfo = propinfo(obj);
            propFieldNames = string(fieldnames(propertyInfo))';

            % Iterate over all properties to determine the maximum size
            % among all read-only properties
            [maxPropertyLength, readOnlyProps] = getMaxSizeOfReadOnlyProp(obj, propFieldNames, readOnlyProps);

            parentPropertyExists = parentPropExists(obj);
            for propName = readOnlyProps
                % Check if the property is a parent property to exclude it
                % from display. Parent properties are handled separately to
                % show all possible values.
                if parentPropertyExists && ismember(propName, obj.parent.MDDRelatedPropertiesList)
                    continue
                end

                % Get number of spaces to append to the property name.
                propLength = strlength(propName);
                numSpaces = maxPropertyLength - propLength;
                spaces = string(blanks(numSpaces));
                dispStr = dispStr + spaces + propName + " : " + newline;
            end
            propValues = dispStr;
            disp(dispStr);
            
            if ~obj.ProductionMode
                setProductionMode(obj, propValues);
            end

            if ~parentPropertyExists
                return
            end

            % After configuring the object's properties, list the parent
            % object's modifiable properties.
            set(obj.parent);
        end

        function displaySinglePropertyLocal(obj, propName)
            % It throws an error when an attempt is made to use a syntax
            % that is incompatible, which is setting a property directly
            % using the 'set' function without specifying a value.
            %
            % e.g. >> set(obj, "Timeout")

            import instrument.icdevice.internal.PropertyType

            if ~isscalar(obj)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument:set:scalarHandle"))));
            end

            [~, propName, propertyType] = ...
                instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(obj, propName);

            % Throw if trying to set a read-only property.
            if propIsReadOnly(obj, propName)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:setReadOnlyError", propName))));
            end

            % Parent properties show up as class specific properties for
            % the driver. For such parent properties, delegate the set to
            % the parent group.
            if propertyType == instrument.icdevice.internal.PropertyType.ClassSpecific
                prop = obj.getPropertyDetails(propName);

                if prop.IsParentProperty
                    set(obj.parent, propName);
                    return
                end
            end

            propertyInfo = propinfo(obj, propName);

            values = propertyInfo.ConstraintValue;
            formatStringAndDisplay(values);

            %% NESTED FUNTION
            function formatStringAndDisplay(values)
                % formatStringAndDisplay formats a cell array of strings
                % into a custom string and displays it.
                outStr = "";
                for valueIndex  = 1:length(values)
                    if valueIndex == 1
                        outStr = "{" + values(valueIndex) + "}";
                    else
                        outStr = outStr + " | " + values(valueIndex);
                    end
                end
                disp(outStr);
            end
        end

        function propStruct = getAllLocalProperties(obj)
            % Display the possible values of the property specified e.g.
            % out = set(obj)
            %
            %     RepCapIdentifier: {}
            %             UserData: {}
            %                  Tag: {}
            %              Timeout: {}
            %             Language: {10×1 cell}
            %                 Math: {3×1 cell}

            import instrument.icdevice.internal.mixins.DriverGetterSetterMixin

            if ~isscalar(obj)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument:set:scalarHandleLength"))));
            end

            propStruct = struct();
            propertyInfo = propinfo(obj);
            propFieldNames = string(fieldnames(propertyInfo))';

            for propNames = propFieldNames
                % Exclude properties from display if their read-only status
                % is "always", indicating they cannot be modified.
                if verifyReadOnlyProp(obj, propNames)
                    continue
                end

                propStruct.(propNames) = {};
            end

            if ~obj.ProductionMode
                setProductionMode(obj, propStruct);
            end

            if ~parentPropExists(obj)
                return
            end

            % After configuring the object's properties, list the parent
            % object's modifiable properties.
            groupStruct = set(obj.parent);
            parentGroupProps = string(fieldnames(groupStruct))';

            for propNames = parentGroupProps
                % Exclude properties from display if their read-only status
                % is "always", indicating they cannot be modified.
                if verifyReadOnlyProp(obj, propNames)
                    continue
                end
                propStruct.(propNames) = groupStruct.(propNames);
            end
        end

        function propValue = getSinglePropertyLocal(obj, varargin)
            % Displays all possible values of a single property that is
            % specified
            %
            % >> out = set(obj, "Timeout")
            %     10
            if ~isscalar(obj)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument:set:scalarHandle"))));
            end
            propName = varargin{1};

            propDetails = propinfo(obj, propName);
            propValue = propDetails.ConstraintValue';

            if isempty(propValue)
                propValue = {};
            end

            if ~obj.ProductionMode
                setProductionMode(obj, propValue);
            end
        end

        function setProductionMode(obj, propertyValue)
            % sets a specific property on an object for production mode
            % testing.
            propObj = instrument.icdevice.internal.forms.ProductionModeForm.empty;
            prop = 'BodyMWICTCode';
            propObj(1).(prop) = propertyValue;
            setPropertyToTest(obj, propObj);
        end
    end
end