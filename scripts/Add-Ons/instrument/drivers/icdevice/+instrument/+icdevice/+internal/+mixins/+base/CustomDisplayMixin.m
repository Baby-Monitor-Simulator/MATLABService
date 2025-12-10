classdef (Abstract) CustomDisplayMixin < matlabshared.testmeas.CustomDisplay & ...
        instrument.icdevice.internal.mixins.base.MDDSpecificPropertiesMixin
    %CUSTOMDISPLAY allows for custom displaying of Driver and Group
    %objects.

    %   Copyright 2023 The MathWorks, Inc.

    properties
        %Contains a list of lists which hold the property names for each
        %custom link being created.
        %EXAMPLE: If you want to create three custom links, you would have
        %a cell array containing three arrays, each containing property names
        %corresponding to the respective link.
        PropertyNames (1, :) cell

        %Contains a list of headings which are displayed after clicking on its
        %respective custom link.
        PropertyGroups (1, :) string

        %Contains a list of strings which are displayed as the text of the
        %links when displaying a Driver or Group object.
        LinkText (1, :) string
    end

    methods
        function obj = CustomDisplayMixin()
            mustBeA(obj, ["instrument.icdevice.internal.Driver", "instrument.icdevice.internal.Group"]);
        end
    end

    methods (Abstract, Hidden)
        % %Populate Display Header for either Driver or Group object.
        % fillDisplayHeader(obj)

        %Set which initial class properties are displayed.
        addInitialDisplayParams(obj)

        %Populate PropertyNames with MDD and Class specific props.
        fillPropertyNamesInfo(obj, adjustedMDDRelatedPropertiesList)
    end

    methods (Hidden)
        function setCustomDisplay(obj)
            %This function sets all necessary property values for custom
            %displaying of either a Driver or a Group object.

            import instrument.icdevice.internal.utility.GroupFactory

            %Build header display.
            obj.HeaderText = string(message("instrument_icdevice:driver:customHeader"));

            % Set up Custom Display settings for proper displaying
            obj.UseGetForPropertyValue = true;
            obj.GetErrorMessageAsValue = true;
            obj.ShowAllPropertiesInFooter = false;

            %Add Driver or Group Specific properties names to the initial
            %display. Selects which of the properties are intially displayed.
            %Separate implementations for Driver or Group found in their
            %respective mixins.
            addInitialDisplayParams(obj);

            %Builds the Driver specific or Group specific property lists. Does
            %not display properties beyond the max length for names, 63
            %characters. If there are no properties, create empty string.
            if ~isempty(obj.MDDRelatedPropertiesList)
                adjustedMDDRelatedPropertiesList = obj.MDDRelatedPropertiesList;
                adjustedMDDRelatedPropertiesList(strlength(adjustedMDDRelatedPropertiesList) > GroupFactory.MaxGroupNameLength) = [];
            else
                adjustedMDDRelatedPropertiesList = string.empty;
            end

            %Fill the link text display information and create custom
            %property objects with this information. Separate
            %implementation for Driver and Group objects found in their
            %respective mixins.
            fillPropertyNamesInfo(obj, adjustedMDDRelatedPropertiesList);
            for i = 1 : length(obj.PropertyGroups)
                obj.CustomProperties(end+1) = matlabshared.testmeas.CustomProperties( ...
                    obj.PropertyGroups(i), obj.PropertyNames(i), obj.LinkText(i));
            end
        end
    end
end