classdef GroupCustomDisplayMixin < instrument.icdevice.internal.mixins.base.CustomDisplayMixin
    %GROUPCUSTOMDISPLAYMIXIN Group-specific implementation assisting in
    %building a custom display.

    %   Copyright 2023 The MathWorks, Inc.

    properties (Constant)
        %List of Class specific properties to be part of the initial group
        %display.
        InitialGroupPropDisplay (1, :) string = ["Name", "HwIndex", "HwName"]
    end

    methods
        function obj = GroupCustomDisplayMixin()
            mustBeA(obj, "instrument.icdevice.internal.Group");
        end
    end

    methods(Hidden)
        function addInitialDisplayParams(obj)
            %This function chooses which class properties of the Group
            %object are shown in the initial display.

            arguments
                obj (1, 1) instrument.icdevice.internal.Group
            end

            %Add property names to Group List so that only selected
            %properties are displayed.
            obj.PropertyGroupList = {obj.InitialGroupPropDisplay};
            obj.PropertyGroupNames = "";
        end

        function fillPropertyNamesInfo(obj, mddRelatedPropNames)
            %This function populates PropertyNames with lists
            %of properties belonging to either the MDD specific or Class
            %specific custom links.

            arguments
                obj (1, 1) instrument.icdevice.internal.Group
                mddRelatedPropNames
            end

            %Add lists, list names, and link text names to create custom
            %links on the custom display
            obj.PropertyNames = {mddRelatedPropNames, ...
                obj.ClassSpecificPropertiesList};
            obj.LinkText = [string(message("instrument_icdevice:driver:groupSpecificProps")), string(message("instrument_icdevice:driver:classProps"))];
            obj.PropertyGroups = [string(message("instrument_icdevice:driver:groupSpecificProps")) + ":", string(message("instrument_icdevice:driver:classProps")) + ":"];
        end
    end
end
