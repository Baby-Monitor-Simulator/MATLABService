classdef View < handle
    %VIEW is the Appspace Actions tab View class. It creates UI elements
    % for the actions tab panel for the selected function or property.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% Events
    events
        ExecuteFunction
        SetPropValue
        GetPropValue
    end

    %% UI elements
    properties
        FunctionPropertyPanel
        ControlPanelGrid
        ExecuteButton
        GetterUIElem
        GetButton
        SetButton
    end

    properties
        Constants = ividevapp.appspace.actionsTab.Constants
    end

    %% Lifetime
    methods
        function obj = View(parentGrid)
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            obj.FunctionPropertyPanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.Constants.FunctionPropertyLayout, obj.Constants.FunctionProperty);
        end
    end

    %% UI element creation Functions
    methods
        function createControlPanelGrid(obj, displayType)
            % Setup grid for specified display type.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            if displayType == "Function"
                controlPanelGridProperties.ColumnWidth = {'fit', '20x', '10x'};
            elseif displayType == "FunctionWithNoInputs"
                controlPanelGridProperties.ColumnWidth = {'10x', '20x', '10x'};
            elseif displayType == "Property"
                controlPanelGridProperties.ColumnWidth = {'fit', '14x', '20x', '14x'};
            end

            controlPanelGridProperties.RowHeight = {24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, '1x'};
            controlPanelGridProperties.Padding = [4 4 4 4];
            controlPanelGridProperties.ColumnSpacing = 2;
            controlPanelGridProperties.RowSpacing = 2;
            controlPanelGridProperties.Scrollable = "on";

            obj.ControlPanelGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.FunctionPropertyPanel, controlPanelGridProperties);
        end

        function createControlPanelGridEmpty(obj)
            % Setup empty grid when selecting a function group or property group.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory


            controlPanelGridProperties.ColumnWidth = {'1x', 'fit', '1x'};
            controlPanelGridProperties.RowHeight = {'1x', 'fit', '1x'};
            controlPanelGridProperties.Padding = [4 4 4 4];
            controlPanelGridProperties.ColumnSpacing = 2;
            controlPanelGridProperties.RowSpacing = 2;
            controlPanelGridProperties.Scrollable = "on";

            obj.ControlPanelGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.FunctionPropertyPanel, controlPanelGridProperties);

            % Create labels to display
            row = 2;
            column = 2;
            text = obj.Constants.ActionsTabEmptyText;
            createLabel(obj, row, text, column, "bold");
        end

        function label = createLabel(obj, row, text, column, fontWeight)
            % Creates a label field with given properties.

            arguments
                obj
                row
                text
                column (1,:) double = 1
                fontWeight (1,1) string = ""
            end

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            labelLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(row, column);
            labelProperties.Text = text;

            if fontWeight ~= ""
                labelProperties.FontWeight = fontWeight;
            end

            label = AppSpaceElementsFactory.createLabel ...
                (obj.ControlPanelGrid, labelLayout, labelProperties);
        end

        function dropDown = createDropDown(obj, row, items, value, tag)
            % Creates dropdown with given properties.

            dropDown = uidropdown(obj.ControlPanelGrid);
            dropDown.Layout.Row = row;
            dropDown.Layout.Column = [2 3];
            dropDown.Items = items;
            dropDown.Value = char(value);
            dropDown.Tag = tag;
        end

        function editableDropdown = createEditableDropDown(obj, row, items, value, tag)
            % Creates editable dropdown (also known as combo box) with given properties.

            editableDropdown = uidropdown(obj.ControlPanelGrid, "Editable", "on");
            editableDropdown.Layout.Row = row;
            editableDropdown.Layout.Column = [2 3];
            editableDropdown.Items = items;
            editableDropdown.Value = char(value);
            editableDropdown.Tag = tag;
        end

        function createExecuteButton(obj, row)
            % Setup the UI for the "Execute" button in the function panel.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            buttonLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(row, 3);
            buttonProperties.Text = obj.Constants.ExecuteButtonText;
            buttonProperties.Tag = "ExecuteButton";

            obj.ExecuteButton = AppSpaceElementsFactory.createButton ...
                (obj.ControlPanelGrid, buttonLayout, buttonProperties);
        end

        function dropDown = createRepCap(obj, row, repcaps)
            % Setup label and dropdown for repeated capability field.

            % Create label
            column = 1;
            text = obj.Constants.RepCapID;
            createLabel(obj, row, text, column);

            % Create corresponding dropdown
            dropDown = createDropDown(obj, row, repcaps, repcaps(1), text);
        end

        function createGetter(obj, row)
            % Setup get label and edit box for the property panel.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            % Create label
            column = 1;
            text = obj.Constants.GetterLabel;
            createLabel(obj, row, text, column);

            % Create corresponding edit field
            editBoxLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(row, [2 3]);
            editBoxProperties.Value = "";
            editBoxProperties.Editable = "off";
            editBoxProperties.Enable = "off";
            editBoxProperties.FontWeight = "bold";
            editBoxProperties.Tag = "GetPropertyField";

            obj.GetterUIElem = AppSpaceElementsFactory.createEditField ...
                (obj.ControlPanelGrid, editBoxLayout, editBoxProperties);

            % Create corresponding Get button
            tag = "GetButton";
            obj.GetButton = obj.createPropertyButton(row, obj.Constants.GetButtonText, tag);

            % Invoke the getter operation.
            obj.notify("GetPropValue");
        end

        function uiElem = createSetter(obj, row, type, enumVals)
            % Create setter UI elements for property

            arguments
                obj
                row (1, 1) double
                type (1, 1) string {mustBeMember(type, ["logical", "editable", "enum"])} = "editable"
                enumVals (1, :) string = []
            end

            % Create label
            text = obj.Constants.SetterLabel;
            column = 1;
            createLabel(obj, row, text, column);

            % Create UI element for setter
            tag = "SetPropertyField";
            switch type
                case "logical"
                    uiElem = createSetterBoolDropDown(obj, row, tag);
                case "editable"
                    uiElem = createSetterEditableDropDown(obj, row, tag);
                case "enum"
                    uiElem = createSetterEnumDropDown(obj, row, enumVals, tag);
            end

            % Create corresponding Set button
            tag = "SetButton";
            obj.SetButton = obj.createPropertyButton(row, obj.Constants.SetButtonText, tag);

            %% NESTED FUNCTIONS
            function dropDown = createSetterEnumDropDown(obj, row, enums, tag)
                % Create drop down field of enum values for property setter.
                value = enums(1);
                dropDown = obj.createDropDown(row, enums, value, tag);
                dropDown.ItemsData = enums;
            end

            function dropDown = createSetterBoolDropDown(obj, row, tag)
                % Create boolean dropdown field for property setter.
                value = "false";
                items = ["false", "true"];
                dropDown = obj.createDropDown(row, items, value, tag);
                dropDown.ItemsData = [false true];
            end

            function editableDropDown = createSetterEditableDropDown(obj, row, tag)
                % Create editable dropdown field for property setter.
                value = "";
                items = "";
                editableDropDown = obj.createEditableDropDown(row, items, value, tag);
            end
        end

        function propertyButton = createPropertyButton(obj, row, text, tag)
            % Creates run button for the property panel get and set.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            buttonLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(row, 4);
            buttonProperties.Text = text;
            buttonProperties.Tag = tag;

            propertyButton = AppSpaceElementsFactory.createButton ...
                (obj.ControlPanelGrid, buttonLayout, buttonProperties);
        end

        function setupEvents(obj, type)
            % Setup the UI elements event callback handlers based on
            % operation type.

            if type == "Function"
                obj.ExecuteButton.ButtonPushedFcn = @obj.executeFcnPanel;
                return
            end

            if contains(type, "g")
                obj.GetButton.ButtonPushedFcn = @obj.executePropPanelGet;
            end

            if contains(type, "s")
                obj.SetButton.ButtonPushedFcn = @obj.executePropPanelSet;
            end
        end
    end

    %% Event Callback Functions
    methods
        function executeFcnPanel(obj, ~, ~)
            obj.notify("ExecuteFunction");
        end

        function executePropPanelSet(obj, ~, ~)
            obj.notify("SetPropValue");
        end

        function executePropPanelGet(obj, ~, ~)
            obj.notify("GetPropValue");
        end
    end
end
