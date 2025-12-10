classdef Manager < handle
    % MANAGER creates and controls lifetime of the different section
    % managers (dropdown, actionsTab, help, and logs) of the appspace area.
    % It also creates the parent panels of the above sections.

    % Copyright 2023-2024 The MathWorks, Inc.

    %% Managers
    properties
        DropdownManager
        ActionsTabManager
        HelpManager
        LogsManager
    end

    %% UI element Properties
    properties (Constant)
        BaseGrid = struct( ...
            'RowHeight', ["1.3x", "2x"], ...
            'ColumnWidth', ["2x", "2x", "4x"], ...
            'Padding', [0 0 0 0], ...
            'RowSpacing', 0, ...
            'ColumnSpacing', 0);
    end

    %% Lifetime
    methods
        function obj = Manager(mediator, rootWindow, sidePanelGrid, metaDataAdapter)
            % Create the base grid on which all appspace elements except
            % the Help Panel are going to be created. Help Panel will be
            % using the Hardware manager side panel.
            baseGrid = obj.createBaseGridLayout(rootWindow);

            obj.DropdownManager = ividevapp.appspace.dropdown.Manager(baseGrid, mediator, metaDataAdapter);
            obj.ActionsTabManager = ividevapp.appspace.actionsTab.Manager(baseGrid, mediator, metaDataAdapter);
            obj.HelpManager = ividevapp.appspace.help.Manager(sidePanelGrid, mediator, metaDataAdapter);
            obj.LogsManager = ividevapp.appspace.logs.Manager(baseGrid, mediator);
        end
    end

    %% API
    methods
        function injectRepCapMap(obj, repCapIDToGetNameFcnMap)
            % Takes in map of Repeated capability values to GetNameFcns to
            % pass it along to the ActionsTabManager.
            getNameFcnToNodesMap = obj.DropdownManager.getNameFcnToNodesMap();
            obj.ActionsTabManager.injectRepCapMap(repCapIDToGetNameFcnMap, getNameFcnToNodesMap);
        end

        function setSideFigPanel(obj, sideFigPanel)
            setSideFigPanel(obj.HelpManager, sideFigPanel);
        end
    end

    %% Helper functions
    methods (Access = private)
        function gridLayout = createBaseGridLayout(obj, rootWindow)
            % Create the base grid on which all appspace elements are
            % going to be created.
            gridLayout = matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory.createGridLayout ...
                (rootWindow, obj.BaseGrid);
        end
    end
end
