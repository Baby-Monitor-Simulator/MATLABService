classdef (Abstract) GroupGetterSetterMixin < instrument.icdevice.internal.mixins.base.AllPropertiesSetGetMixin
    %GROUPGETTERSETTERMIXIN provides get and set access for the group
    %properties.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = GroupGetterSetterMixin()
            mustBeA(obj, "instrument.icdevice.internal.Group");
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.PropertyFinderMixin");
        end
    end

    %% Implement Abstract Methods from instrument.icdevice.internal.mixins.base.AllPropertiesSetGetMixin
    methods (Hidden)
        function prop = getPropertyValueForMDDType(obj, prop)
            temp = instrument.icdevice.internal.utility.CodeEvaluator.getPropCode(obj, prop);

            % If object is in production mode, set the property value as
            % usual. If object is in unit test mode, set property value as
            % empty.
            if obj.ProductionMode
                prop = instrument.icdevice.internal.utility.InstrumentDataConverter. ...
                       convertDataToSpecifiedDataType(obj.PropertyMap(prop), temp{:});
            else
                prop = [];
            end
        end

        function setPropertyValueForMDDType(obj, name, value)
            if isempty(name)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:nonexistentProperty"))));
            end

            propDetails = obj.PropertyMap(name);

            % Throw if trying to set a read-only property.
            if propIsReadOnly(obj, name)
                throw(obj.getMException(MException(message("instrument_icdevice:driver:setReadOnlyError", name))));
            end

            instrument.icdevice.internal.utility.CodeEvaluator.setPropCode(obj, name, value);
        end

        function displaySinglePropertyLocal(obj, specificPropName)
            % Display the possible values that the specified property
            % property can be set to.
            %
            % e.g. >> set(obj.acquisition, "Interpolation")
            % [ {1} | 3 | 2 ]

            if ~ismember(specificPropName, obj.MDDRelatedPropertiesList)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument_icdevice:driver:invalidPropertyName", specificPropName))));
            end
            propValue = displayAllLocalProperties(obj, specificPropName);

            % Find the position of the first colon in the propValue
            % string (e.g: Interpolation : [  {1}  |  3  |  2  ])
            colonPos = strfind(propValue, ':');

            % Extract the string after the first colon and trim any leading
            % or trailing whitespace (e.g: [  {1}  |  3  |  2  ])
            valueStr = strtrim(extractAfter(propValue, colonPos(1)));

            if valueStr ~= ""
                disp(propValue);
            else
                propertyName = obj.Name;
                exceptionMsg = message("instrument_icdevice:driver:dynamicPropertyValues", propertyName, specificPropName);
                disp(exceptionMsg.string());
            end
        end

        function localProps = displayAllLocalProperties(obj, specificPropName)
            % Display the MDD property names and possible values that the
            % property can be set to.
            %
            % e.g.
            % >> set(obj.acquisition)
            %             Control : [  {run-stop}  |  single  ]
            %               Delay :
            %                Mode : [  {sample}  |  peakDetect  |  average  ]
            %    NumberOfAverages : [  {4}  |  16  |  64  |  128  ]
            %               State : [  {stop}  |  run  ]
            %            Timebase : [  5e-09 to 50  ]
            %                View : [  {main}  |  window  |  zone  ]
            %         WindowDelay :
            %      WindowTimebase : [  5e-09 to 50  ]

            arguments
                obj (1, 1) instrument.icdevice.internal.Group
                specificPropName string = string.empty
            end
            
            import instrument.icdevice.internal.mixins.DriverGetterSetterMixin

            if ~isscalar(obj)
                obj = obj(1);
            end

            if ~isprop(obj, "PropertyMap") || isempty(obj.MDDRelatedPropertiesList)
                return
            end

            dispStr = "";
            readOnlyProps = string([]);

            % Iterate over all properties to determine the maximum size
            % among all read-only properties
            [maxPropertyLength, readOnlyProps] = getMaxSizeOfReadOnlyProp(obj, obj.MDDRelatedPropertiesList, readOnlyProps);

            for propName = readOnlyProps
                % If a specific property name is provided, skip other
                % properties or exclude properties from display if their
                % read-only status is "always", indicating they cannot be
                % modified.
                if nargin > 1 && propName ~= specificPropName
                    continue
                end

                % Get number of spaces to append to the property name.
                propLength = strlength(propName);
                numSpaces = maxPropertyLength - propLength;
                spaces = string(blanks(numSpaces));
                dispStr = dispStr + spaces + propName + " : ";

                % Extract the property and decide how to display the
                % property depending on the contraint type.
                propVal = obj.PropertyMap(propName);

                constraintAccessors = propVal.Constraint;
                allConstraints = constraintAccessors.Constraints;

                data = string.empty;
                for c = allConstraints
                    if c.Type == "none"
                        continue
                    end

                    try
                        if c.Type == "bounded"
                            data(end+1) = getDisplayBounded(obj, c); %#ok<*AGROW>
                        else
                            data(end+1) = getDisplayEnum(obj, c, propVal.DefaultValue);
                        end
                    catch ex
                        data = replace(string(ex.message), newline, " ");
                        break
                    end
                end

                if ~isempty(data)
                    data = unique(data);
                    data = join(data, " -or- ");
                    dispStr = dispStr + data + newline;
                else
                    dispStr = dispStr + newline;
                end

                % Break the loop if the current property name (propName) matches the
                % specific property name requested
                if nargin > 1 && propName == specificPropName
                    break
                end
            end

            % Display the final list of properties and possible values.
            if strlength(specificPropName) > 0
                localProps = dispStr;
            else
                disp(dispStr);
            end

            if ~obj.ProductionMode
                % Name of variables in "setPropCode" that need to be
                % tested.
                bodyMWICTCode = dispStr; %#ok<*NASGU>
                propObj = instrument.icdevice.internal.forms.ProductionModeForm.empty;
                props = "bodyMWICTCode";
                for p = props
                    value = eval(p);

                    % Capitalize the first letter of p to access the
                    % ProductionModeForm properties correctly. Here, we are
                    % doing a 1-to-1 transfer of a local variables to
                    % class-level properties which hold different naming
                    % conventions for capitalization. This adjusts for the
                    % differences between the two.
                    p = upper(extractBefore(p,2)) + extractAfter(p,1); %#ok<*FXSET>
                    propObj(1).(p) = value;
                end
                setPropertyToTest(obj, propObj);
            end

            %% NESTED FUNCTION

            function str = getDisplayEnum(~, c, defaultValue)
                % Display for an enum type - Units: [ {1.0} | 1000.0 |
                % 1001.0 | 0.0 ] The value in {} is the default value for
                % the proeprty.

                str = "[  ";

                noDefaultValue = false;

                if c.isEnumConstraintReplaceable()
                    valuesToIterateOver = string(c.EnumLookup.keys);
                else
                    valuesToIterateOver = c.AllEnumValues;
                    if ischar(defaultValue) || isstring(defaultValue)
                        defaultValue = erase(defaultValue, newline);
                        noDefaultValue = isempty(defaultValue) || defaultValue == "";
                    else
                        noDefaultValue = isempty(defaultValue);
                    end
                end

                for idx = 1 : length(valuesToIterateOver)
                    val = valuesToIterateOver(idx);

                    % Put {} around the default value, else display the
                    % value as is.
                    if (noDefaultValue && idx == 1) || areValuesEqual(val, defaultValue)
                        str = str + "{" + string(val) + "}";
                    else
                        str = str + string(val);
                    end

                    % Put a " | " separator between each property value
                    if idx ~= length(valuesToIterateOver)
                        str = str + "  |  ";
                    end
                end
                str = str + "  ]";
            end

            %% NESTED FUNCTION
            function str = getDisplayBounded(~, c)
                % Display for a bounded type - Timebase : [  5e-09 to 50  ]

                str = "[  " + string(c.RangeMin) + ...
                    " to " + string(c.RangeMax) + "  ]";
            end

            %% NESTED FUNCTION
            function flag = areValuesEqual(val1, val2)

                % Perform a strcmpi if both are char/string types, else do
                % an isequal.
                %
                % This is needed because some MDDs like the
                % tektronix_tds1002 have enum values as
                %
                % ["main", "window", "zone"],
                %
                % but DefaultValue is set to "Main"
                %
                % (and "main" ~= "Main").

                if isTextType(val1) && isTextType(val2)
                    flag = strcmpi(val1, val2);
                else
                    flag = isequal(val1, val2);
                end

                %% NESTED FUNCTION - 2
                function flag1 = isTextType(val)
                    flag1 = isstring(val) || ischar(val);
                end
            end
        end

        function propStruct = getAllLocalProperties(obj)
            % >> out = set(obj.acquisition)
            %
            %   struct with fields:
            %
            %              Control: {2×1 cell}
            %                Delay: {}
            %                 Mode: {3×1 cell}
            %     NumberOfAverages: {}
            %                State: {2×1 cell}
            %             Timebase: {}
            %                 View: {3×1 cell}
            %          WindowDelay: {}
            %       WindowTimebase: {}

            import instrument.icdevice.internal.mixins.DriverGetterSetterMixin

            if ~isscalar(obj)
                obj = obj(1);
            end

            if ~isprop(obj, "PropertyMap") || isempty(obj.MDDRelatedPropertiesList)
                propStruct = struct();
                return
            end

            propStruct = struct();

            for propName = obj.MDDRelatedPropertiesList
                propVal = obj.PropertyMap(propName);
                propNameStr = string(propName);

                % Exclude properties from display if their read-only status
                % is "always", indicating they cannot be modified.
                if verifyReadOnlyProp(obj, propNameStr)
                    continue
                end

                c = propVal.Constraint;
                propStruct.(propNameStr) = c.AllConstraints;
            end
        end

        function localProps = getSinglePropertyLocal(obj, specificPropName)
            % Displays all possible values of a single property that is
            % specified
            % e.g.
            % >> out = set(obj.display1, "Contrast")
            %
            %  1×1 cell array
            %   {'1 to 100'}

            if ~ismember(specificPropName, obj.MDDRelatedPropertiesList)
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument_icdevice:driver:invalidPropertyName", specificPropName))));
            end

            propValuesStr = displayAllLocalProperties(obj, specificPropName);
            localProps = extractPropertyValuesFromString(propValuesStr);

            %% Nested Function
            function localProps = extractPropertyValuesFromString(propValuesStr)
                % Extract the part of the string that contains the property
                % values
                matches = regexp(propValuesStr, '\[\s*\{?(.*?)\}?\s*\]', 'tokens');
                if ~isempty(matches)
                    % The first match contains the relevant group
                    propValuesStr = matches{1}{1};
                else
                    localProps = {};
                    return
                end

                propValues = split(propValuesStr, "|");

                % Trim whitespace from each property value and remove empty
                % entries
                propValues = strip(propValues);
                propValues = propValues(~cellfun('isempty',propValues));
                propValues = replace(propValues, '}', '');

                % Convert the array of strings to a cell array
                localProps = reshape(propValues, length(propValues), 1);
            end
        end
    end
end
