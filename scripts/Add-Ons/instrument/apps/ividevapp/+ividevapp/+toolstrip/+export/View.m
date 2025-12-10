classdef View < handle
    %VIEW is the Toolstrip Export Section View Class. It creates all the
    % toolstrip export section UI Elements.

    % Copyright 2023 The MathWorks, Inc.

    %% UI Elements
    properties
        ToolstripTabHandle
        ExportSection
        WorkspaceVariableEditField
        ExportButton
        ActivityLogList
        CodeLogList
        ActivityLogSelectedCellList
    end

    %% Events that the Controller listens for
    events
        % Events with the same names are also used in the export View for
        % shared app infrastructure.
        ExportCommLogPressed
        ExportCodeLogPressed
        ExportSelectedRowPressed
        WorkspaceVariableChanged
    end

    %% UI element properties
    properties
        SharedAppConstants = matlabshared.transportapp.internal.toolstrip.export.Constants
        Constants = ividevapp.toolstrip.export.Constants
    end

    %% Lifetime
    methods
        function obj = View(toolstripTabHandle, ~)
            obj.ToolstripTabHandle = toolstripTabHandle;
            createView(obj);
            setupEvents(obj);
        end
    end

    %% API
    methods (Access = private)
        function createView(obj)
            % Create the export section view UI elements. The order of
            % creation of columns matters as the createAndAddColumn adds
            % the new column to the right of the current column with the
            % contained UI elements.

            import matlabshared.transportapp.internal.utilities.factories.ToolstripElementsFactory

            obj.ExportSection = obj.ToolstripTabHandle.addSection(obj.SharedAppConstants.ExportSectionName);

            %% EXPORT SECTION Column 1
            label = ToolstripElementsFactory.createLabel(obj.Constants.WorkspaceVariableLabelProps);

            obj.WorkspaceVariableEditField = ToolstripElementsFactory.createEditField ...
                (obj.SharedAppConstants.WorkspaceVariableEditFieldProps);

            % Create the toolstrip column with the export variable edit
            % field and label.
            ToolstripElementsFactory.createAndAddColumn...
                (obj.ExportSection, obj.Constants.Position, [label, obj.WorkspaceVariableEditField]);

            %% EXPORT SECTION Column 2
            obj.ExportButton = ToolstripElementsFactory.createDropDownButton(obj.Constants.ExportButtonProps);

            % Create the 3 list items
            obj.ActivityLogList = ToolstripElementsFactory.createListItem(obj.Constants.ActivityLogListProps);
            obj.CodeLogList = ToolstripElementsFactory.createListItem(obj.Constants.ExportCodeListProps);
            obj.ActivityLogSelectedCellList = ToolstripElementsFactory.createListItem(obj.Constants.ActivityLogSelectedCellListProps);

            % Create the Popup List and assign the popup list to the ExportButton
            listItems = [obj.ActivityLogSelectedCellList, obj.ActivityLogList, obj.CodeLogList];
            popupList = ToolstripElementsFactory.createPopupList(listItems, struct.empty);
            obj.ExportButton.Popup = popupList;

            % Create the toolstrip column with the ExportButton
            ToolstripElementsFactory.createAndAddColumn...
                (obj.ExportSection, obj.Constants.Position, obj.ExportButton);
        end

        function setupEvents(obj)
            % Setup the UI elements event callback handlers.
            obj.ActivityLogList.ItemPushedFcn = @obj.exportActivityLogPressedFcn;
            obj.CodeLogList.ItemPushedFcn = @obj.exportSessionLogPressedFcn;
            obj.ActivityLogSelectedCellList.ItemPushedFcn = @obj.exportSelectedCellActivityLogPressedFcn;
            obj.WorkspaceVariableEditField.ValueChangedFcn = @obj.handleWorkspaceVariableChanged;
        end
    end

    %% Event Callback Functions
    methods
        function exportActivityLogPressedFcn(obj, ~, ~)
            obj.notify("ExportCommLogPressed");
        end

        function exportSessionLogPressedFcn(obj, ~, ~)
            obj.notify("ExportCodeLogPressed");
        end

        function exportSelectedCellActivityLogPressedFcn(obj, ~, ~)
            obj.notify("ExportSelectedRowPressed");
        end

        function handleWorkspaceVariableChanged(obj, ~, evt)
            % Handler for when the Workspace Variable Edit field is
            % changed.
            evtData = matlabshared.transportapp.internal.utilities.EventData(evt.EventData);
            obj.notify("WorkspaceVariableChanged", evtData);
        end
    end
end
