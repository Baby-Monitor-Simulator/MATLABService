classdef Group < handle & ...
        instrument.icdevice.internal.mixins.GroupDotIndexingMixin & ...
        instrument.icdevice.internal.mixins.GroupMethodAccessorMixin & ...
        instrument.icdevice.internal.mixins.GroupGetterSetterMixin & ...
        instrument.icdevice.internal.mixins.GroupPropInfoMixin & ...
        instrument.icdevice.internal.mixins.GroupCustomDisplayMixin & ...
        instrument.icdevice.internal.mixins.GroupLegacyMethodsMixin & ...
        instrument.icdevice.internal.mixins.base.ProductionMixin & ...
        instrument.icdevice.internal.mixins.base.MDDSpecificPropertiesMixin & ...
        instrument.icdevice.internal.mixins.base.ClassSpecificPropertiesMixin & ...
        instrument.icdevice.internal.mixins.base.PropertyFinderMixin & ...
        instrument.icdevice.internal.mixins.base.ErrorProxyMixin & ...
        instrument.icdevice.internal.mixins.base.LegacyCompatibilityMixin
        
    %GROUP is the alternate class to icdevice'S ICGROUP. Each GROUP class
    %represents each group present on the MDD. The DRIVER object has a list
    %of GROUP objects, similar to how an MDD has a collection of groups.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Hidden)
        Description
        Command
        Size
        Mappings
        PropertyInfo

        MethodMap
        PropertyMap

        IsRepeated (1, 1) logical = false
        RepCapName (1, 1) string
    end

    properties (Hidden, Constant)
        LocalMethodNames = ["disp", "invoke", "get", "set", "isa", "class"]
    end

    properties (Dependent, Hidden)
        MDDMethodNames
    end

    properties (Hidden, Constant)
        PreDefinedClassPropertyList = ["Name", "HwIndex", "HwName", "Type", "Parent"]
    end

    methods
        function obj = Group(group, parent)
            arguments
                group
                parent (1, 1) instrument.icdevice.internal.Driver
            end

            % The UseErrorProxy flag ensures unit tests for the driver
            % class bypass the errorProxy map, preserving the integrity of
            % their unique IDs and preventing test failures.
            obj.UseErrorProxy = parent.UseErrorProxy;
            obj.Parent = parent;
            setLegacyAndSCPIflags(obj, obj.Parent.IsLegacy, obj.Parent.IsSCPI);
            obj.ProductionMode = parent.ProductionMode;
            fields = string(fieldnames(group))';
            for f = fields
                if f == "MethodInfo"
                    continue
                end
                obj.(f) = group.(f);
            end
        end

        function varargout = invoke(obj, methodName, varargin)
            % Invoke a function call on the group.

            import instrument.icdevice.internal.utility.WarningUtility
            warnState = WarningUtility.cleanupStartMethod();
            c = onCleanup(@()WarningUtility.cleanupEndMethod(warnState));

            if nargin == 1
                throw(obj.getMException(MException(message("instrument_icdevice:driver:invokeGroupInvalidSyntax", "invoke"))));
            end

            temp = instrument.icdevice.internal.utility.CodeEvaluator.invoke(obj, methodName, varargin{:});
            varargout = temp{:};
        end

        function setup(obj)
            % Add the MDD Specific group sub-properties, if they exist.

            if ~isstruct(obj.PropertyInfo)
                %If Group does not contain any properties, make sure to
                %fill custom display information before returning.
                setCustomDisplay(obj);
                return
            end

            for prop = obj.PropertyInfo.Property
                propName = prop.Name;
                if isprop(obj, propName)
                    continue
                end
                addMDDSpecificProperty(obj, propName, []);
            end

            %Set Custom Display properties for new group object.
            setCustomDisplay(obj);
        end
    end

    %% Getters/Setters
    methods
        function val = get.MDDMethodNames(obj)
            val = string(obj.MethodMap.keys);
        end
    end
end
