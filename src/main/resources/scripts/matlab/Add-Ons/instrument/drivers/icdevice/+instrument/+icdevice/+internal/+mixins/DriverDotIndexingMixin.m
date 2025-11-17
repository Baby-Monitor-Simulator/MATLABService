classdef (Abstract) DriverDotIndexingMixin < handle & matlab.mixin.indexing.RedefinesDot
    %DRIVERDOTINDEXINGMIXIN provides dot-notation property access for
    %driver properties.
    %
    % 1. Class Specific Property
    % 2. MDD Specific Property
    % 3. Local Property on the driver class itself

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = DriverDotIndexingMixin()
            mustBeA(obj, "instrument.icdevice.internal.Driver");
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.PropertyFinderMixin");
        end
    end

    %% Implement abstract methods of matlab.mixin.indexing.RedefinesDot
    methods (Access = protected)
        function varargout = dotReference(obj, indexOp)
            % Dot-notation property get access.
            import instrument.icdevice.internal.utility.GroupFactory
            import instrument.icdevice.internal.utility.WarningUtility
            try
                % Turn off warning for names which are longer than 63
                % characters.
                warnState = WarningUtility.cleanupStartMethod();
                c = onCleanup(@()WarningUtility.cleanupEndMethod(warnState));

                [~, warningID] = lastwarn;
                %Test warning to see if input, indexOp, has been truncated.
                if warningID == "MATLAB:namelengthmaxexceeded"
                    lastwarn('');
                    error(message("instrument_icdevice:driver:dotIndexingUnsupported"));
                end

                name = indexOp(1).Name;
                [obj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(obj, name);

                switch propertyType
                    case instrument.icdevice.internal.PropertyType.ClassSpecific

                        if isscalar(indexOp)
                            [varargout{1:nargout}] = obj.getClassSpecificPropertyValue(prop);
                            return
                        end

                        % Multiple indexOps - need to get the final string
                        % including multiple parens "()" and dots ".",
                        % (e.g. dev.channel(1).acquisition) to evaluate.
                        [~, strToEval, origPropValue] = recursiveClassSpecificPropertyAccess(obj, indexOp);
                        strToEval = "[varargout{1:nargout}] = " + strToEval + ";";
                        eval(strToEval);

                    case instrument.icdevice.internal.PropertyType.LocalProperty
                        [varargout{1:nargout}] = obj.(prop);

                    case instrument.icdevice.internal.PropertyType.Error
                        error(message("instrument_icdevice:driver:invalidICGroup", name));

                    case {instrument.icdevice.internal.PropertyType.MDDSpecific, ...
                            instrument.icdevice.internal.PropertyType.ExcludedProperty}

                        % For mdd specific or excluded list property.
                        for index = 1 : length(indexOp)
                            type = indexOp(index).Type;

                            % Get the group value.
                            if index == 1
                                val = getMDDSpecificPropertyValue(obj, prop);

                            elseif type == "Paren"
                                val = val(indexOp(index).Indices{1});

                            else
                                name = indexOp(index).Name;
                                val = get(val, name);

                            end
                        end
                        [varargout{1:nargout}] = val;
                    otherwise
                        error(message("instrument_icdevice:driver:invalidPropType"));
                end
            catch ex
                throwAsCaller(obj.getMException(ex));
            end
        end

        function obj = dotAssign(obj, indexOp, varargin)
            % Dot-notation property set access.

            try
                indexOpLength = length(indexOp);

                % Adding a safety-check that we only support 3 levels of
                % dot-indexed support for Driver.
                if indexOpLength > 4
                    error(message("instrument_icdevice:driver:indexOverload"));
                end

                name = indexOp(1).Name;
                [obj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(obj, name);

                switch propertyType
                    case instrument.icdevice.internal.PropertyType.Error
                        error(message("instrument_icdevice:driver:invalidICGroup", name));

                    case instrument.icdevice.internal.PropertyType.ClassSpecific

                        allIndexOpTypes = {indexOp.Type};
                        if isscalar(allIndexOpTypes)
                            obj.setClassSpecificPropertyValue(prop, varargin{1});
                            return
                        end

                        % Multiple indexOps - need to get the final string
                        % including multiple parens "()" and dots ".",
                        % (e.g. dev.channel(1).acquisition) to evaluate.

                        [propName, strToEval, origPropValue] = recursiveClassSpecificPropertyAccess(obj, indexOp);
                        strToEval = strToEval + " = varargin{:};";
                        eval(strToEval);

                        % Update the class specific property with the new
                        % value that was set.
                        obj.setClassSpecificPropertyValue(propName, origPropValue);
                    case instrument.icdevice.internal.PropertyType.LocalProperty
                        obj.(prop) = varargin{1};

                    case {instrument.icdevice.internal.PropertyType.MDDSpecific, ...
                            instrument.icdevice.internal.PropertyType.ExcludedProperty}

                        if indexOpLength == 1
                            error(message("instrument_icdevice:driver:setFailICGroup"));
                        end

                        group = getMDDSpecificPropertyValue(obj, prop(1));
                        groupPropertyName = indexOp(indexOpLength).Name;

                        if indexOpLength == 3
                            % Indexed into repeated capability for
                            % SCPI-Based repeated capabilities -
                            % 
                            % E.g.
                            % >> dev.channel(1).channel_count = 3;
                            %
                            % indexOp(2) will be
                            % Name = "Paren"
                            % Indices = {1};
                            %
                            % So, index = indexOp(2).Indices{:}; extracts
                            % the value 1 from
                            % 
                            % >> dev.channel(1).channel_count = 3;
                            index = indexOp(2).Indices{:};
                            group = group(index);
                        end

                        set(group, groupPropertyName, varargin{:});

                    otherwise
                        error(message("instrument_icdevice:driver:invalidPropType"));
                end
            catch ex
                throwAsCaller(obj.getMException(ex));
            end
        end

        function n = dotListLength(~, ~, ~)
            n = 1;
        end

        function [propName, strToEval, origPropValue] = recursiveClassSpecificPropertyAccess(obj, iOpType)
            % Build the string required to access (get or set) the property
            % value. It is a combination of Dots and Parens.

            arguments
                obj
                iOpType (1, :) matlab.indexing.IndexingOperation
            end

            % iOpType(1) has to be of Dot Type as it is a class
            % property.
            assert(iOpType(1).Type == "Dot");

            propName = iOpType(1).Name;
            origPropValue = obj.getClassSpecificPropertyValue(propName);

            % This will contain the final string to be evaluated to access
            % the property. See the help for the
            % getStringToEvalFromDotAndParen method for more information.
            %
            % NOTE: Make sure that the seed name is the same as the output
            % variable name containing output of
            % getClassSpecificPropertyValue() above.
            strToEval = instrument.icdevice.internal.utility.CodeEvaluator. ...
                getStringToEvalFromDotAndParen("origPropValue", iOpType(2:end));
        end
    end
end
