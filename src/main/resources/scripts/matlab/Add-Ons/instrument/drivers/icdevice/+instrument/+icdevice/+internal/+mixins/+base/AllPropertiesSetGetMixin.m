classdef (Abstract) AllPropertiesSetGetMixin < handle
    %ALLPROPERTIESSETGETMIXIN class provides support for case-insensitive
    %get and set access for Driver and Group Class Related and MDD Related
    %properties.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Constant, Hidden)
        % Margin size for spaces for the display (to be added to the
        % longest property name).
        MarginSize = 3

        DefaultPropertyForType = dictionary(["Double", "String"], {0, ''})
    end

    methods (Abstract, Hidden)
        % Return the property value for an MDD Property.
        prop = getPropertyValueForMDDType(obj, value)

        % Set the property value for an MDD Property.
        setPropertyValueForMDDType(obj, name, value)

        % Display a single property's set values
        displaySinglePropertyLocal(obj, propName)

        % Display list of possible constraints and bounds that all
        % properties must adhere to.
        displayAllLocalProperties(obj)

        % Return list of possible constraints and bounds that all
        % properties must adhere to.
        out = getAllLocalProperties(obj)
    end

    methods
        function obj = AllPropertiesSetGetMixin()
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.MDDSpecificPropertiesMixin");
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.ClassSpecificPropertiesMixin");
        end
    end

    methods
        function validateSizeHook(~, ~, ~)
            % Hook method to verify the size of the object
        end
    end

    methods
        function prop = get(objs, prop, varargin)
            arguments
                objs
                prop string = string.empty
            end

            arguments (Repeating)
                varargin
            end

            % The value '5' is explicitly specified here to align with the
            % ErrorProxyMixin's design, where a mapping has been
            % established to correlate single error IDs with multiple IDs.
            % The number '5' denotes the specific index that this error ID
            % should correspond to, as per the predefined map in the mixin.
            % This ensures the correct error ID association.
            objectType = metaclass(objs).Name;
            if objectType == "instrument.icdevice.internal.Driver"
                instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(objs, "get", 5);
            else
                instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(objs, "get", 6);
            end

            validateSizeHook(objs);

            % Verify whether the object (obj) is scalar. If so, display the
            % value of the specified property.
            if isscalar(objs)
                prop = getInternal(objs, prop, varargin{:});
                return
            end

            finalProp = {};

            % When dealing with multiple objects, ensuring that the values
            % for the property across all objects are collected and
            % displayed.
            for obj = objs
                finalProp{end+1} = instrument.internal.stringConversionHelpers.str2char(getInternal(obj, prop, varargin{:}));
            end
            prop = finalProp';

            %% Nested Funtion
            function prop = getInternal(obj, prop, varargin)

                if nargin > 2
                    throw(obj.getMException(MException(message("instrument:get:maxrhs"))));
                end

                if isempty(prop)
                    prop = getAllPropertiesStruct(obj);
                    return
                end

                % The obj might have switched from driver to group or group
                % to driver from recursivePropertyFind
                [obj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(obj, prop);
                try
                    switch propertyType
                        case instrument.icdevice.internal.PropertyType.ClassSpecific
                            prop = obj.getClassSpecificPropertyValue(prop);

                        case instrument.icdevice.internal.PropertyType.MDDSpecific
                            prop = getMDDPropValue(obj, prop);

                        case instrument.icdevice.internal.PropertyType.ExcludedProperty
                            prop = getPropertyValueForMDDType(obj, obj.PropertyExclusionList(prop));

                        case instrument.icdevice.internal.PropertyType.LocalProperty
                            prop = obj.(prop);

                        case instrument.icdevice.internal.PropertyType.Error
                            error(message("instrument_icdevice:driver:nonexistentProperty"));
                    end
                catch ex
                    throwAsCaller(obj.getMException(ex));
                end

                %% Nested Function
                function prop = getMDDPropValue(obj, prop)
                    % getMDDPropValue retrieves the current value of a
                    % specified property from the object by handling the
                    % enumeration constraints and permissible types.
                    try
                        % Directly retrieve the data from the MDD
                        prop = getPropertyValueForMDDType(obj, prop);
                    catch exc
                        % If the driver was open but getting the property
                        % fails. Throw the error.
                        %
                        % NOTE - Do not invoke "Status" on obj directly.
                        % This is because Status could also be a MDD
                        % specific property (e.g. look at
                        % Calibration.Status in tektronix_tds1002.mdd), and
                        % doing an "obj.Status" where obj is the
                        % calibration group is going to be an infinite call
                        % loop to
                        %
                        % getMDDPropValue() -> obj.Status ->
                        % getMDDPropValue() -> obj.Status (and so on).
                        %
                        % The right way is to get the parent driver object
                        % as done below and safely call driver.Status. This
                        % is safe because driver already has a
                        % Class-Specific Status property.
                        if isa(obj, "instrument.icdevice.internal.Driver")
                            statusObj = obj;
                        else
                            statusObj = obj.parent;
                        end

                        if statusObj.Status == "open"
                            if isempty(exc.identifier)
                                exc = MException("instrument:icgroup:get:opfailed", exc.message);
                            end
                            throw(exc);
                        end

                        % If driver was not connected, fetch the default
                        % value from the mdd.
                        propMap = obj.PropertyMap(prop);
                        prop = fetchPropertyDefault(obj, propMap);
                    end

                    % Return the char value
                    prop = instrument.internal.stringConversionHelpers.str2char(prop);
                    if ischar(prop) && endsWith(prop, char(0))
                        % Remove NULL-Terminating character
                        prop(end) = [];
                    end
                end

                function prop = fetchPropertyDefault(obj, propMap)
                    constraint = propMap.Constraint;
                    allConstraints = constraint.Constraints;

                    if canReturnDefaultValueFromMDD()
                        prop = constraint.convertInstrumentValueToEnumValue(propMap.DefaultValue);
                        return
                    end

                    % Default was empty. Based on the constraint type,
                    % decide the return type
                    type = allConstraints.Type;

                    switch type
                        case "enum"
                            % return the first enum value
                            prop = constraint.convertInstrumentValueToEnumValue(allConstraints.AllEnumValues(1));

                        case "bounded"
                            prop = allConstraints.RangeMin;

                        otherwise
                            % No default provided, and not an enum or
                            % bounded type, meaning constraint == "none".
                            % Return the empty representation based on the
                            % constraint type
                            dataType = allConstraints.DataType;
                            if ~isKey(obj.DefaultPropertyForType, dataType)                    
                                prop = [];
                            else
                                prop = obj.DefaultPropertyForType(dataType);
                                prop = prop{:};
                            end
                    end

                    %% NESTED FUNCTION
                    function flag = canReturnDefaultValueFromMDD()
                        % If there are multiple constraints or the
                        % constraint value is not empty for a scalar
                        % constraint, it is okay to return the default
                        % value from the MDD.

                        flag = ~isscalar(allConstraints) || ~(isequal(propMap.DefaultValue, "") || isempty(propMap.DefaultValue));
                    end
                end
            end
        end

        function out = set(obj, varargin)
            arguments
                % The value '9' is explicitly specified here to align with
                % the ErrorProxyMixin's design, where a mapping has been
                % established to correlate single error IDs with multiple
                % IDs. The number '9' denotes the specific index that this
                % error ID should correspond to, as per the predefined map
                % in the mixin. This ensures the correct error ID
                % association.
                obj {instrument.icdevice.internal.utility.ValidateFunctions.isObjValid(obj, "set", 9)}
            end

            arguments(Repeating)
                varargin
            end

            % Return all properties if no arguments are provided.
            % Here the obj can either represent a group object or a driver object.
            if isempty(varargin)
                if nargout == 0
                    % >> set(obj)
                    % >> set(obj.<groupName>)
                    displayAllLocalProperties(obj);
                else
                    % >> out = set(obj) 
                    % >> out = set(obj.<groupName>)
                    out = getAllLocalProperties(obj);
                end
                return
            end

            % Retrieval of a single value
            % Here the obj can either represent a group object or a driver object.
            if isscalar(varargin) && (ischar(varargin{1}) || isstring(varargin{1}))
                if nargout == 0
                    % To display all possible values for the specified
                    % property name
                    % e.g.
                    % >> set(obj.<groupName>, <property>) or
                    % >> set(obj, <property>)
                    displaySinglePropertyLocal(obj, varargin{1});
                else
                    % To display all possible values that can be set
                    % e.g.
                    % >> out = set(obj.<groupName>, <property>) or
                    % >> out = set(obj, <property>)
                    out = getSinglePropertyLocal(obj, varargin{1});
                end
                return
            end

            % Validate size of the object here to match the error ID's for
            % all previous scenarios
            validateSizeHook(obj, "set", 2);

            if iscell(varargin{1})
                % This block handles the scenario where multiple properties
                % are passed as a cell array.
                %
                % Syntax: set(obj, {'N1','N2'}, {V1,V2}) where (N-Name,
                % V-value)
                allPropNames = varargin{1};
                allPropValues = varargin{2};

                if ~isequal(length(allPropNames), length(allPropValues))
                    throw(obj.getMException(MException(message("instrument_icdevice:driver:invalidArgumentFormat"))));
                end

                for i = 1 : length(allPropNames)
                    name = allPropNames{i};
                    value = allPropValues{i};
                    setSingleProperty(obj, name, value);
                end

            elseif isstruct(varargin{1})
                % This block is designed to handle the case where
                % properties are passed as a struct.
                %
                % Syntax: set(obj, S) where S = struct(N1, V1, N2, V2) and
                % (N-Name, V-value)
                propStruct = varargin{1};
                propNames = string(fieldnames(propStruct))';

                for prop = propNames
                    setSingleProperty(obj, prop, propStruct.(prop));
                end

            else
                % Check for an even number of arguments to ensure
                % name-value pairs
                if rem(length(varargin), 2) ~= 0
                    throw(obj.getMException(MException(message("instrument_icdevice:driver:invalidArgumentFormat"))));
                end

                % Process name-value pairs Syntax: set(obj,'N1',V1,'N2',V2)
                for i = 1:2:length(varargin)
                    prop = varargin{i};
                    value = varargin{i+1};
                    setSingleProperty(obj, prop, value);
                end
            end
        end

        function setSingleProperty(obj, prop, value)
            try
                % The obj might have switched from driver to group or group
                % to driver from recursivePropertyFind
                [obj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(obj, prop);

                switch propertyType
                    case instrument.icdevice.internal.PropertyType.ClassSpecific
                        obj.setClassSpecificPropertyValue(prop, value);

                    case {instrument.icdevice.internal.PropertyType.MDDSpecific, ...
                            instrument.icdevice.internal.PropertyType.ExcludedProperty}
                        setPropertyValueForMDDType(obj, prop, value);

                    case instrument.icdevice.internal.PropertyType.LocalProperty
                        obj.(prop) = value;

                    case instrument.icdevice.internal.PropertyType.Error
                        throw(obj.getMException(MException(message("instrument_icdevice:driver:nonexistentProperty")), 2));
                end
            catch ex
                if isempty(ex.identifier)
                    ex = MException("instrument:set:opfailed", ex.message);
                end
                throwAsCaller(obj.getMException(ex));
            end
        end
    end

    methods (Access = private)

        function finalVal = getAllPropertiesStruct(obj)
            % Get the full struct from all class related and MDD related
            % properties.
            %
            % E.g.
            %
            % >> get(dev.channel)
            %
            % ans =
            %
            %   struct with fields:
            %
            %                        Name: 'Channel'
            %                     HwIndex: 1
            %                      HwName: 'Channel1'
            %                      Parent: [1×1 instrument.icdevice.internal.Driver]
            %               Channel_Count: 2
            %             Channel_Enabled: 1
            %             Input_Impedance: 1000000
            %     Maximum_Input_Frequency: 20000000
            %           Probe_Attenuation: 10
            %           Probe_Sense_Value: 1
            %           Vertical_Coupling: 0
            %             Vertical_Offset: 1.2000
            %              Vertical_Range: 1

            finalVal = struct.empty;

            if isscalar(obj)
                finalVal = getAllObjProperties(obj);
                return
            end

            for objInstance = obj
                val = getAllObjProperties(objInstance);
                if isempty(finalVal)
                    finalVal = val;
                else
                    finalVal(end+1) = val;
                end
            end

            function val = getAllObjProperties(obj)
                % Create the struct from all valid class and MDD properties
                % which exist on the object.

                import instrument.icdevice.internal.mixins.base.PropertyFinderMixin

                % Construct the valid property list.
                [isAdjusted, allProps] = constructValidPropertyList(obj);

                % Warn users if the list does not contain all properties on
                % the driver or group and tell them how to access those
                % properties.
                if isAdjusted
                    warning(message("instrument_icdevice:driver:getObjAdjustedList"));
                end

                for prop = allProps
                    try
                        data = get(obj, prop);
                    catch ex
                        if ex.identifier == "MATLAB:class:InvalidHandle"
                            throwAsCaller(obj.getMException(ex));
                        else
                            data = replace(string(ex.message), newline, " ");
                        end
                    end

                    val.(prop) = data;
                end
            end
        end
    end

    methods(Hidden)
        % Implemented these functions to maintain the backward compatibility with LegacyIcDevice
        % which throws the right errorID
        function igetfield(~, field)
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            throw(ep.getMException(MException(message("instrument:igetfield:invalidFIELD", field))));
        end
        
        function isetfield(~, field, ~)
            ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
            throw(ep.getMException(MException(message("instrument:isetfield:invalidFIELD", field))));
        end

        function flag = verifyReadOnlyProp(obj, propName)
            % This function checks if a property of an object is read-only.
            propertyInfo = propinfo(obj, propName);
            flag = propertyInfo.ReadOnly ~= "never" || (propertyInfo.ReadOnly == "while open" && obj.Status == "open");
        end

        function [maxPropertyLength, readOnlyProps] = getMaxSizeOfReadOnlyProp(obj, propFieldNames, readOnlyProps)
            % Iterate over all properties to determine the maximum size
            % among all read-only properties
            for propName = propFieldNames
                % Exclude properties from display if their read-only status
                % is "always", indicating they cannot be modified.
                if ~verifyReadOnlyProp(obj, propName)
                    readOnlyProps(end+1) = propName; %#ok<*AGROW>
                end
            end
            maxPropertyLength = max(strlength(readOnlyProps)) + obj.MarginSize;
        end

        function flag = propIsReadOnly(obj, propName)
            % MDD Property is read-only if -
            %
            % 1. It is always read-only, or
            %
            % 2. It is read-only but only when connected.

            propDetails = propinfo(obj, propName);

            propReadOnlyAlways = propDetails.ReadOnly == "always";
            propReadOnlyWhileOpen = obj.Status == "open" && propDetails.ReadOnly == "while open";
            flag = propReadOnlyAlways || propReadOnlyWhileOpen;
        end
    end
end