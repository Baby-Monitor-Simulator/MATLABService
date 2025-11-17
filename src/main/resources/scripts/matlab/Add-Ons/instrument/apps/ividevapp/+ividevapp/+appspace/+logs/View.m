classdef View < handle
    %VIEW is the Appspace Logs Section View class. It creates the activity
    % log and code log tabs.

    % Copyright 2023 The MathWorks, Inc.

    %% UI elements
    properties
        ActivityLogPanel
        ActivityLogGrid
        CodeLogPanel
        CodeLogGrid
        CodeLogUIHTMLHandle
        Table
    end

    %% UI element properties
    properties
        Constants = ividevapp.appspace.logs.Constants
    end

    %% Lifetime
    methods
        function obj = View(parentGrid, ~)
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            % Activity Log Panel
            obj.ActivityLogPanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.Constants.ActivityLogLayout, obj.Constants.ActivityLogPanelProps);
            obj.ActivityLogGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.ActivityLogPanel, obj.Constants.LogsGridProperties);

            % Activity Log table
            obj.createTable(obj.ActivityLogGrid);

            % MATLAB Code Log Panel
            obj.CodeLogPanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.Constants.CodeLogLayout, obj.Constants.CodeLogPanelProps);
            obj.CodeLogGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.CodeLogPanel, obj.Constants.LogsGridProperties);
            obj.CodeLogUIHTMLHandle = uihtml(obj.CodeLogGrid);
        end
    end

    %% Helper Functions
    methods
        function createTable(obj, grid)
            % This function creates the Activity Log table using properties
            % defined in the Constants.
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory
            import matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout

            obj.Table = AppSpaceElementsFactory.createTable(grid, ...
                AppSpaceGridLayout(1, 1), obj.Constants.TableProperties);
            obj.Table.Data = [];
        end

        function styleTable(obj)
            % This function makes the table scrollable.
            scroll(obj.Table, "bottom");
        end
    end
end
