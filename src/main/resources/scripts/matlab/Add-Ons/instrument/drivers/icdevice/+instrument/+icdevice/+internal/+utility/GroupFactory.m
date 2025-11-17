classdef GroupFactory
    %GROUPFACTORY class parses the driver MDD struct (from readstruct) and
    %creates a Group type for each MDD group.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Constant)
        MaxGroupNameLength = 63
    end

    methods (Static)
        function group = createGroup(groupStruct, driver)
            import instrument.icdevice.internal.utility.GroupFactory
            try
                propertyMap = GroupFactory.getPropertyMap(groupStruct, driver);
                methodMap = GroupFactory.getMethodsMap(groupStruct);
                repCap = GroupFactory.getRepCapValues(groupStruct);

                group = GroupFactory.createAndPopulateGroup( ...
                    groupStruct, driver, methodMap, propertyMap, repCap);
            catch ex
                throw(ex);
            end
        end
    end

    methods (Static, Access = private)
        function group = createAndPopulateGroup(groupStruct, driver, methodMap, propertyMap, repCap)
            group = instrument.icdevice.internal.Group.empty;
            for idx = 1 : groupStruct.Size
                [hwIndex, hwName] = instrument.icdevice.internal.utility.GroupFactory.getCommandAttributes(groupStruct, idx);

                % Create a new group and populate it
                g = instrument.icdevice.internal.Group(groupStruct, driver); %#ok<*AGROW>
                g.MethodMap = methodMap;
                g.PropertyMap = propertyMap;
                g.HwIndex = hwIndex;
                g.HwName = hwName;
                g.Type = instrument.icdevice.internal.utility.DriverUtility.getInstrumentType(driver.Type)+ "-" + g.Name;
                g.IsRepeated = isa(repCap, "dictionary");

                if g.IsRepeated
                    g.RepCapName = repCap(idx);
                end

                group(end+1) = g;
            end
        end

        function val = getMethodsMap(group)
            % Create and return a map of group method names as map keys and
            % their corresponding information as the map value.

            val = containers.Map;

            if ~isfield(group.MethodInfo, "Method")
                return
            end

            for g1 = group.MethodInfo.Method
                val(g1.Name) = g1;
            end
        end

        function val = getPropertyMap(group, driver)
            % Create and return a map of group property names as map keys
            % and their corresponding information as the map value. Every
            % group also has a parent property that points to the parent
            % driver object.

            val = containers.Map;

            if ~isfield(group.PropertyInfo, "Property")
                return
            end

            try
                for p1 = group.PropertyInfo.Property
                    p1.Parent = driver;
                    p1.Constraint = instrument.icdevice.internal.utility. ...
                        ConstraintAccessor(p1.Name, p1.PermissibleType);
                    val(p1.Name) = p1;
                end
            catch ex
                throw(ex);
            end
        end

        function repCap = getRepCapValues(groupStruct)
            % Create and return the repeated capability names as a
            % dictionary. If the group does not have a repeated capability,
            % return [].

            repCap = [];
            if groupStruct.Size <= 1
                return
            end

            mappings = groupStruct.Mappings.ChannelMap;
            repCap = dictionary;
            for groupMap = mappings
                key = groupMap.IndexAttribute;
                value = groupMap.CommandAttribute;
                repCap(key) = value;
            end
        end

        function [index, name] = getCommandAttributes(g, idx)
            % Get the hardware name and hardware index for the group.

            index = [];
            name = [];
            if isfield(g, "Mappings") && isfield(g.Mappings, "ChannelMap") ...
                    && isfield(g.Mappings.ChannelMap, "IndexAttribute") ...
                    && isfield(g.Mappings.ChannelMap, "CommandAttribute")

                allChannelMaps = g.Mappings.ChannelMap;

                if length(allChannelMaps) >= idx
                    currentChannelMap = allChannelMaps(idx);
                else
                    currentChannelMap = allChannelMaps;
                end
                index = currentChannelMap.IndexAttribute;
                name = currentChannelMap.CommandAttribute;
            end
        end
    end

    %% PRIVATE CONSTRUCTOR
    methods (Access = private)
        function obj = GroupFactory()
        end
    end
end
