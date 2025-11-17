classdef View < handle
    %VIEW is the Appspace Dropdown Section View class. It creates the
    % uitree nodes for functions/properties and contains events for user
    % selection in the function/property uitree.

    % Copyright 2023 The MathWorks, Inc.

    events
        SelectedNode
        SearchFieldValueChanged
    end

    %% UI elements
    properties
        DropdownPanel
        TreeGrid
        SearchEditField

        TreeAccessor
        TreeListener
    end

    properties (Dependent)
        Tree
        FunctionRoot
        PropertyRoot
    end

    %% UI element properties
    properties (Constant)
        DropdownLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(1:2,1)
        Dropdown = struct("Title", message("ividevapp:ividevapp:FuncPropSectionTitle").string, ...
            "TitlePosition", "lefttop", ...
            "FontSize", 12, ...
            "FontWeight", "bold");
        TreeGridProperties = struct("ColumnWidth", ["fit", "1x"], ...
            "RowHeight", ["fit", "1x"], ...
            "Padding", [1 0 1 6]);
    end

    %% Lifetime
    methods
        function obj = View(parentGrid)
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            obj.DropdownPanel = AppSpaceElementsFactory.createPanel ...
                (parentGrid, obj.DropdownLayout, obj.Dropdown);

            obj.TreeGrid = AppSpaceElementsFactory.createGridLayout ...
                (obj.DropdownPanel, obj.TreeGridProperties);

            obj.TreeAccessor = ividevapp.appspace.dropdown.TreeAccessor(uitree(obj.TreeGrid));
            obj.setupListener();
            obj.setupEvents();
        end
    end

    %% View creation Functions
    methods
        function createSearchBar(obj)
            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            labelLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(1, 1);
            labelProperties.Text = message("ividevapp:ividevapp:FilterField").string;
            AppSpaceElementsFactory.createLabel ...
                (obj.TreeGrid, labelLayout, labelProperties);

            editBoxLayout = matlabshared.transportapp.internal.utilities.forms.AppSpaceGridLayout(1, 2);
            editBoxProperties.Value = "";
            editBoxProperties.Tag = "SearchEditFieldTag";
            obj.SearchEditField = AppSpaceElementsFactory.createEditField ...
                (obj.TreeGrid, editBoxLayout, editBoxProperties);

            obj.SearchEditField.ValueChangedFcn = @obj.searchFieldValueChangedFcn;
        end

        function setupEvents(obj, varargin)
            % Setup the UI elements event callback handlers.

            obj.Tree.SelectionChangedFcn = @obj.nodeChange;
        end

        function setupListener(obj)
            % Setup the UI elements event callback handlers.

            obj.TreeListener = listener(obj.TreeAccessor, "TreeRecreated", ...
                @(src, evt)obj.setupEvents(src, evt));
        end
    end

    %% Event Callback Functions
    methods
        function nodeChange(obj, ~, ~)
            obj.notify("SelectedNode");
        end

        function searchFieldValueChangedFcn(obj, ~, evt)
            obj.notify("SearchFieldValueChanged", evt);
        end
    end

    %% Dependent Properties
    methods
        function val = get.Tree(obj)
            val = obj.TreeAccessor.Tree;
        end

        function set.Tree(obj, val)
            obj.TreeAccessor.Tree = val;
        end

        function val = get.FunctionRoot(obj)
            val = obj.TreeAccessor.FunctionRoot;
        end

        function set.FunctionRoot(obj, val)
            obj.TreeAccessor.FunctionRoot = val;
        end

        function val = get.PropertyRoot(obj)
            val = obj.TreeAccessor.PropertyRoot;
        end

        function set.PropertyRoot(obj, val)
            obj.TreeAccessor.PropertyRoot = val;
        end
    end

    %% Delegation methods to TreeAccessor
    methods
        function populateFirstLevelTreeChildren(obj, type)
            % Create the first level property nodes - function or property
            % nodes.
            obj.TreeAccessor.populateFirstLevelTreeChildren(type);
        end

        function node = addNode(obj, varargin)
            % Add a node with the given name and node data to the specified
            % parent tree.

            node = obj.TreeAccessor.addNode(varargin{:});
        end

        function resetLevelTag(obj)
            % Reset the Level Tag after creating the property tree or
            % function tree.

            obj.TreeAccessor.resetLevelTag();
        end

        function addFunctionNameToLevel(obj, varargin)
            % Add the current function group or function name with
            % its associated level to the FunctionNameToTagMap map.
            obj.TreeAccessor.addFunctionNameToLevel(varargin{:});
        end

        function addPropertyNameToLevel(obj, varargin)
            % Add the current property group or property name with
            % its associated level to the PropertyNameToTagMap map.

            obj.TreeAccessor.addPropertyNameToLevel(varargin{:});
        end

        function cacheTree(obj, varargin)
            % Cache the current UI Tree.

            obj.TreeAccessor.cacheTree(varargin{:});
        end

        function searchFieldChangedFcn(obj, searchFieldValue)
            % The search field value changed, meaning the tree needs to be
            % updated. Delegate this to the TreeAccessor to handle the new
            % tree creation.

            obj.TreeAccessor.searchFieldChangedFcn(searchFieldValue);
        end
    end
end
