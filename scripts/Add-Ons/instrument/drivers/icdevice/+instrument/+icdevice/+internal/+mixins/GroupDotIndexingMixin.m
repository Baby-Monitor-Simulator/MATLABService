classdef (Abstract) GroupDotIndexingMixin < handle & matlab.mixin.indexing.RedefinesDot
    %GROUPDOTINDEXINGMIXIN provides dot-notation property access for
    %group properties.
    %
    % 1. Class Specific Property
    % 2. MDD Specific Property
    % 3. Local Property on the group class itself

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods
        function obj = GroupDotIndexingMixin()
            mustBeA(obj, "instrument.icdevice.internal.Group");
            mustBeA(obj, "instrument.icdevice.internal.mixins.base.PropertyFinderMixin");
        end
    end

    %% Implement abstract methods of matlab.mixin.indexing.RedefinesDot
    methods (Access = protected)
        function varargout = dotReference(obj,indexOp)
            % Dot-notation property get access.

            try
                % Set value of obj(Group class) to "newObj". newObj will be
                % changing with every iteration with indexOp's idx.
                %
                % e.g.
                % >> g = dev.Aquisition;
                % >> data = g.DriverData.maxAdcValue
                %
                % We can read the above 2 lines as - For a Group called
                % Acquisition, and indexOp values as
                %
                % 1. Type - "Dot" and Name - "DriverData"
                %
                % 2. Type - "Dot" and Name - "maxADCValue"
                %
                % Initial value of newObj = obj = Acquisition Group class.
                %
                % End of Iteration 1 of indexOp, newObj=newObj.DriverData.
                % "newObj" now points to the DriverData field of the
                % Acquisition group.
                %
                % End of Iteration 2 of indexOp, newObj=newObj.maxADCValue.
                % "newObj" now points to the maxADCValue field of the
                % DriverData field of the Acquisition group.
                newObj = obj;
                for idx = 1:length(indexOp)
                    iOp = indexOp(idx);
                    name = iOp.Name;

                    % The "newObj" is no longer a driver or group object.
                    % It is now safe to invoke MATLAB's own dot-indexing
                    % and paren support. Get the final string to eval and
                    % fetch the value doing an eval.
                    if ~isobject(newObj)
                        iOpType = indexOp(idx:end);
                        strToEval = instrument.icdevice.internal.utility.CodeEvaluator.getStringToEvalFromDotAndParen("newObj", iOpType);
                        eval("[varargout{1:nargout}] = " + strToEval + ";");
                        return
                    end

                    % Check whether the property exists.
                    [newObj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(newObj, name);
                    instrument.icdevice.internal.utility.ValidateFunctions.validatePropertyError(propertyType, prop);

                    isClassSpecific = propertyType == instrument.icdevice.internal.PropertyType.ClassSpecific;

                    if isClassSpecific
                        % Class specific property - delegate to the
                        % ClassSpecificPropertiesMixin.
                        newObj = newObj.getClassSpecificPropertyValue(prop);
                    else
                        if isempty(prop)
                            error(message("instrument_icdevice:driver:invalidICGroup", name));
                        end

                        % MDD Specific property.
                        if isstring(prop)
                            newObj = get(newObj, prop);
                        else
                            newObj = prop;
                        end
                    end
                end

                [varargout{1:nargout}] = newObj;
            catch ex
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throwAsCaller(ep.getMException(ex));
            end
        end

        function obj = dotAssign(obj,indexOp,varargin)
            % Dot-notation property set access.

            arguments
                obj
                indexOp
            end
            arguments (Repeating)
                varargin
            end

            try
                if isscalar(indexOp)
                    name = indexOp.Name;
                    value = varargin{:};
                    set(obj, name, value);

                else
                    newObj = obj;
                    previousObj = obj;
                    previousPropertyName = string.empty;
                    for idx = 1:length(indexOp)
                        iOp = indexOp(idx);
                        name = iOp.Name;

                        % The "newObj" is no longer a driver or group
                        % object. It is now safe to invoke MATLAB's own
                        % dot-indexing and paren support. Get the final
                        % string to eval.
                        if ~isobject(newObj)
                            if isempty(previousPropertyName)
                               throw(MException(message("instrument_icdevice:driver:invalidProp", name)));
                            end
                            iOpType = indexOp(idx:end);
                            strToEval = instrument.icdevice.internal.utility.CodeEvaluator.getStringToEvalFromDotAndParen("newObj", iOpType);
                            strToEval = strToEval + " = varargin{:};";
                            eval(strToEval);

                            % Set the value of newObj (newObj is a MATLAB
                            % data type) to the "parentPropertyName"
                            % variable on the driver/group "parentObj".
                            set(previousObj, previousPropertyName, newObj);
                            return
                        end

                        [newObj, prop, propertyType] = instrument.icdevice.internal.mixins.base.PropertyFinderMixin.recursivePropertyFind(newObj, name);
                        instrument.icdevice.internal.utility.ValidateFunctions.validatePropertyError(propertyType, prop);

                        % Save the current value of newObj and
                        % parentPropertyObj as previousObj and
                        % previousPropertyName. newObj and prop will be
                        % updated to a new value below.
                        previousObj = newObj;
                        previousPropertyName = prop;

                        if propertyType == instrument.icdevice.internal.PropertyType.ClassSpecific
                            newObj = newObj.getClassSpecificPropertyValue(prop);
                        elseif any(propertyType == [instrument.icdevice.internal.PropertyType.MDDSpecific, ...
                                instrument.icdevice.internal.PropertyType.ExcludedProperty])
                            newObj = newObj.getPropertyValueForMDDType(prop);
                        else
                            throw(MException(message("instrument_icdevice:driver:invalidProp", prop)));
                        end
                    end
                end
            catch ex
                throwAsCaller(ex);
            end
        end

        function n = dotListLength(~,~,~)
            n = 1;
        end
    end
end