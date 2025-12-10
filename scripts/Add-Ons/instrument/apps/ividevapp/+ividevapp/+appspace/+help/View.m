classdef View < handle
    %VIEW is the Appspace Help Section View class. It creates the help
    % panel that displays the help text for the selected function/property.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% UI elements
    properties
        % Vendor Help Panel
        HelpPanel
        HelpGrid
        UITextArea

        % Example Help Panel
        ExampleUIHTMLHandle
        ExampleCodePanel
        ExampleCodeGrid
    end

    %% UI element properties
    properties (Constant)
        ExampleCodeLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(1, 1)
        HelpLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(2, 1)
        DefaultGridProperties = struct("ColumnWidth", {"1x"}, ...
            "RowHeight", {"1x"}, ...
            "Padding", [0 0 0 0])

        HelpPanelTitle = message("ividevapp:ividevapp:HelpPanelTitle").string
        ExampleCodePanelTitle = message("ividevapp:ividevapp:ExampleCodePanelTitle").string
    end

    %% Lifetime
    methods
        function obj = View(parentGrid)
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            obj.HelpPanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.HelpLayout, struct("Title", obj.HelpPanelTitle));

            obj.HelpGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.HelpPanel, obj.DefaultGridProperties);

            obj.createVendorHelpPanelView();

            obj.ExampleCodePanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.ExampleCodeLayout, struct("Title", obj.ExampleCodePanelTitle));

            obj.ExampleCodeGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.ExampleCodePanel, obj.DefaultGridProperties);

            obj.createExamplePanelView();
        end
    end

    %% Helper Functions
    methods (Access = protected)
        function createVendorHelpPanelView(obj)
            % Create the initial uitextarea for the help panel.
            % Make the text area non-editable.
            obj.UITextArea = uitextarea(obj.HelpGrid, Value="", Editable="off");
        end

        function createExamplePanelView(obj)
            % Create the uihtml Example Panel to display ividev example
            % code.
            obj.ExampleUIHTMLHandle = uihtml(obj.ExampleCodeGrid);
        end
    end
end
