classdef DriverCustomDisplayMixin < instrument.icdevice.internal.mixins.base.CustomDisplayMixin
    %DRIVERCUSTOMDISPLAYMIXIN Driver-specific implementation assisting in
    %building a custom display.

    %   Copyright 2023-2024 The MathWorks, Inc.

    properties (Constant)
        %List of Class specific properties to be part of the initial driver
        %display.
        InitialDriverPropDisplay (1, :) string = ["DriverName", "DriverType", "InstrumentModel", "Manufacturer", "Status"]
    end

    methods
        function obj = DriverCustomDisplayMixin()
            mustBeA(obj, "instrument.icdevice.internal.Driver");
        end
    end

    methods(Hidden)
        function addInitialDisplayParams(obj)
            %This function chooses which class properties of the Driver
            %object are shown in the initial display.

            arguments
                obj (1, 1) instrument.icdevice.internal.Driver
            end

            %Add property names to Group List so that only selected
            %properties are displayed.
            obj.PropertyGroupList = {obj.InitialDriverPropDisplay};
            obj.PropertyGroupNames = "";
        end

        function fillPropertyNamesInfo(obj, mddRelatedPropNames)
            %This function populates PropertyNames with lists
            %of properties belonging to either the MDD specific or Class
            %specific custom links.

            arguments
                obj (1, 1) instrument.icdevice.internal.Driver
                mddRelatedPropNames
            end

            %Add lists, list names, and link text names to create custom
            %links on the custom display
            obj.PropertyNames = {mddRelatedPropNames, ...
                setdiff(obj.ClassSpecificPropertiesList, obj.ParentPropertyList)};
            obj.LinkText = [string(message("instrument_icdevice:driver:driverSpecificProps")), string(message("instrument_icdevice:driver:classProps"))];
            obj.PropertyGroups = [string(message("instrument_icdevice:driver:driverSpecificProps")) + ":", string(message("instrument_icdevice:driver:classProps")) + ":"];
        end
    end
end
