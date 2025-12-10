classdef Controller < matlabshared.mediator.internal.Publisher & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource
    %CONTROLLER is the Appspace drop-down Controller class. It contains
    % business logic for operations that need to be performed when
    % interacting with the drop-down View elements.

    % Copyright 2023 The MathWorks, Inc.

    properties (SetObservable)
        DisplayFunctionPanel
        PropertyNode
        SelectedNode
    end

    properties (Access = protected)
        ViewConfiguration
    end

    properties (Dependent)
        % Drop-down View tree handles
        View
        Tree
        FunctionRoot
        PropertyRoot
    end

    properties
        FunctionTree
        PropertyTree
        GetNameFcnToPropNodesMap
        PropertyTagCount

        ViewListeners = event.listener.empty

        % Adapter instance that will provide information about driver
        % functions and properties
        MetaDataAdapter
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration, ~)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
                ~
            end
            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);
            obj.ViewConfiguration = viewConfiguration;
            obj.GetNameFcnToPropNodesMap = containers.Map;

            % Only for production mode
            if isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                obj.setupListeners();
            end
        end
    end

    %% View creation Functions
    methods
        function createFuncPropTree(obj)
            % Create the function/property tree(s).

            obj.Tree.SelectedNodes = [];

            % Create Search Bar
            obj.View.createSearchBar();

            % Property drop-down creation
            obj.View.populateFirstLevelTreeChildren(ividevapp.FunctionPropertyEnum.PROPERTY);
            propData = getPropertyMetaData(obj.MetaDataAdapter);

            obj.PropertyTagCount = 0;
            obj.createPropertyTreeRecursive(propData, obj.PropertyRoot, "", false, obj.GetNameFcnToPropNodesMap, 1);

            % Reset the Level Tag value on the tree.
            obj.View.resetLevelTag();

            % Function drop-down creation
            obj.View.populateFirstLevelTreeChildren(ividevapp.FunctionPropertyEnum.FUNCTION);
            obj.createFunctionTree();

            obj.FunctionTree = obj.Tree.Children(ividevapp.FunctionPropertyEnum.FUNCTION);
            obj.PropertyTree = obj.Tree.Children(ividevapp.FunctionPropertyEnum.PROPERTY);

            obj.View.cacheTree();
            obj.View.createSearchBar();
        end
    end

    %% Listener Functions
    methods
        function searchFieldValuedChanged(obj, ~, evt)
            % Handler when the search edit field value changes.

            currentValue = string(evt.Value);
            previousValue = string(evt.PreviousValue);

            % Remove all double-quotes, single-quotes, and trailing and
            % leading white spaces.
            currentValue = removeQuotesLeadingTrailingSpaces(currentValue);

            % Single character was passed - error.
            if strlength(currentValue) == 1
                obj.showErrorDialog(MException(message("ividevapp:ividevapp:SingleCharacterForSearch")));
                return
            end
            previousValue = removeQuotesLeadingTrailingSpaces(previousValue);

            % Need to update the tree if and only if a new search text was
            % given. The search text comparison is case-insensitive.
            if ~strcmpi(currentValue, previousValue)
                obj.View.searchFieldChangedFcn(currentValue);
            end

            %% NESTED FUNCTION
            function str = removeQuotesLeadingTrailingSpaces(str)
                str = string(str);
                str = strip(replace(str, ["""", "'"], ""));
            end
        end

        function nodeChange(obj, src, ~)
            % Handler for when a function/property is selected in the
            % dropdown.

            obj.SelectedNode = src.Tree.SelectedNodes;

            if obj.SelectedNode.Text == "Functions" || obj.SelectedNode.Text == "Properties"
                % DisplayFunctionPanel and PropertyNode should be empty if
                % the selected node is the "Functions" or "Properties"
                % header node.

                obj.DisplayFunctionPanel = [];
                obj.PropertyNode = [];
                return
            end

            % Get the tree node type - "Function" or "Property"
            nodeType = obj.SelectedNode.NodeData.Type;

            if nodeType == "Function"

                % Get index from selected function tree node.
                index = obj.SelectedNode.NodeData.Index;

                if functionHasNoChild(obj.MetaDataAdapter, index)
                    % DisplayFunctionPanel should be set only for leaf
                    % functions and not function groups.
                    obj.DisplayFunctionPanel = obj.SelectedNode.NodeData;
                else
                    % DisplayFunctionPanel should not be set when
                    % function group is selected.
                    obj.DisplayFunctionPanel = [];
                end
            elseif nodeType == "Property"

                % If selected property node does not have any children
                % (i.e. it is a property leaf node and not a property
                % group) then set the PropertyNode.
                if isempty(obj.SelectedNode.Children)
                    obj.PropertyNode = obj.SelectedNode;
                else
                    obj.PropertyNode = [];
                end
            end
        end
    end

    %% Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function createFunctionTree(obj)
            % Create a tree to display driver functions hierarchically.

            % Store the parent nodes and the levels of the parent nodes in
            % arrays.
            parents = obj.FunctionRoot;
            levels = 0;

            % Start at a function data index so that the driver name,
            % "Initialize", and "Initialize With Options" function groups
            % are not displayed in the app.
            index = getFuncMetaDataStartIndex(obj.MetaDataAdapter);

            while index <= getNumFunctions(obj.MetaDataAdapter)

                % If the current function node has no children then get the
                % function name otherwise get the function group name.
                if functionHasNoChild(obj.MetaDataAdapter, index)
                    fnName = getFunctionName(obj.MetaDataAdapter, index);
                else
                    fnName = getFunctionGroupName(obj.MetaDataAdapter, index);
                end

                if isPreviousFuncNodeParent(obj.MetaDataAdapter, levels(end), index)
                    % Add child node to the last stored parent if the
                    % current function node is a child of the previous node.

                    % Store node type (function) and function index in
                    % NodeData.
                    tag = "Function_" + fnName + "_" + index;

                    % Create a node data form and fill in the function
                    % details as needed.
                    nodeData = ividevapp.utilities.forms.FunctionNodeData;
                    nodeData.Index = index;
                    nodeData.Name = fnName;
                    child = obj.View.addNode(parents(end), fnName, nodeData, tag);

                    obj.View.addFunctionNameToLevel(fnName, levels);

                    if isNextFuncNodeChild(obj.MetaDataAdapter, levels(end), index)
                        % Update parents and levels if the next function
                        % node is a child of the current function node.

                        parents(end+1) = child; %#ok<*AGROW>
                        levels(end+1) = getFunctionLevel(obj.MetaDataAdapter, index);
                    end
                else
                    % Remove the last stored parent and level once the
                    % current function node is no longer a child.
                    parents(end) = [];
                    levels(end) = [];

                    % Since current node is a not a child of previous node
                    % decrement the counter so that current node is not
                    % skipped.
                    index = index - 1;
                end

                index = index + 1;
            end
        end

        function createPropertyTreeRecursive(obj, data, parentNodes, parentNames, isAttr, map, currentLevel)
            % Creates tree to display driver properties hierarchically.

            for prop = data
                % Create a node data form and fill in the property
                % details as needed.
                nodeData = ividevapp.utilities.forms.PropertyNodeData;
                nodeData.Type = "Property";

                if isAttr
                    % If the current property is an AttributeIdentifier (property),
                    % add node.

                    attributeName = getAttributeIdentifierName(obj.MetaDataAdapter, prop);
                    help = getAttributeIdentifierHelp(obj.MetaDataAdapter, prop);
                    accessMode = getAttributeIdentifierAccessMode(obj.MetaDataAdapter, prop);
                    visaType = getAttributeIdentifierVISAType(obj.MetaDataAdapter, prop);
                    obj.PropertyTagCount = obj.PropertyTagCount + 1;
                    tag = "Property_" + attributeName + "_" + obj.PropertyTagCount;

                    % Fill in the remaining NodeData fields.
                    nodeData.Name = attributeName;
                    nodeData.Help = help;
                    nodeData.ParentNodeName = parentNames(end);
                    nodeData.AccessType = accessMode;
                    nodeData.VisaType = visaType;

                    % Add the node, nodedata and tag.
                    obj.View.addNode(parentNodes(end), attributeName, nodeData, tag);

                    obj.View.addPropertyNameToLevel(attributeName, currentLevel);
                else
                    % If the current property is a ClassIdentifier (property group), add
                    % node and update parentNodes, parentNames, and GetNameFcns to property nodes map.

                    groupName = getClassIdentifierName(obj.MetaDataAdapter, prop);
                    help = getClassIdentifierHelp(obj.MetaDataAdapter, prop);
                    hasRepCap = ~isempty(getClassIdentifierRCNames(obj.MetaDataAdapter, prop));

                    obj.PropertyTagCount = obj.PropertyTagCount + 1;
                    tag = "Property_" + groupName + "_" + obj.PropertyTagCount;

                    % Fill in the remaining NodeData fields.
                    nodeData.Name = groupName;
                    nodeData.Help = help;
                    nodeData.ParentNodeName = parentNames;
                    nodeData.HasRepCap = hasRepCap;

                    % Add the node, nodedata and tag.
                    parent = obj.View.addNode(parentNodes(end), groupName, nodeData, tag);

                    obj.View.addPropertyNameToLevel(groupName, currentLevel);
                    parentNodes(end+1) = parent;
                    parentNames(end+1) = groupName;

                    buildGetNameFcnToPropNodesMap(obj, prop, map);

                    if hasClassIdentifiers(obj.MetaDataAdapter, prop)
                        % If the current property group has other sub property groups,
                        % make recursive call with those property groups
                        % as data.
                        classIdentifiers = getClassIdentifiers(obj.MetaDataAdapter, prop);
                        obj.createPropertyTreeRecursive(classIdentifiers, parentNodes, parentNames, false, map, currentLevel+1);
                    end

                    if hasAttributeIdentifiers(obj.MetaDataAdapter, prop)
                        % If the current property group has properties,
                        % make recursive call with those properties as
                        % data, and isAttr set to true.

                        attributeIdentifiers = getAttributeIdentifiers(obj.MetaDataAdapter, prop);
                        obj.createPropertyTreeRecursive(attributeIdentifiers, parentNodes, parentNames, true, map, currentLevel+1);
                    end

                    % Set parentNodes and parentNames to empty once
                    % properties/property groups have been added for
                    % current property group.
                    parentNodes(end) = [];
                    parentNames(end) = [];
                end
            end
        end

        function buildGetNameFcnToPropNodesMap(obj, prop, map)
            % Generate a map mapping the repeated capability GetNameFcns to
            % property nodes.

            % Get the repeated capability information (if exists) for the
            % selected class identifier (property group).
            rcNames = getClassIdentifierRCNames(obj.MetaDataAdapter, prop);

            if ~isempty(rcNames)
                getNameFcn = findGetNameFcn(obj, rcNames);
                if ~ismissing(getNameFcn)
                    obj.mapGetNameFcnToPropNodes(prop, map, getNameFcn);
                end
            end

            % Nested function
            function getNameFcn = findGetNameFcn(~, rcNames)
                getNameFcn = strip(extractAfter(rcNames, ":"));
                if contains(getNameFcn, ",")
                    getNameFcn = strip(extractBefore(getNameFcn, ","));
                end
            end
        end

        function mapGetNameFcnToPropNodes(obj, prop, map, getNameFcn)
            % Recursive function that adds relevant AttributeIdentifier (property)
            % nodes whose parents have getNameFcn in their RCNames to map.

            if hasAttributeIdentifiers(obj.MetaDataAdapter, prop)
                attrIdentifiers = getAttributeIdentifiers(obj.MetaDataAdapter, prop);

                for i = 1:size(attrIdentifiers, 2)
                    attrIdentifiers(i).Parent = prop.ClassName;
                end

                if isKey(map, char(getNameFcn))
                    map(char(getNameFcn)) = [map(char(getNameFcn)), attrIdentifiers];
                else
                    map(char(getNameFcn)) = attrIdentifiers;
                end
            end

            % Look for more attribute identifiers (properties) hidden in a
            % class identifier sub node (property group).
            if hasClassIdentifiers(obj.MetaDataAdapter, prop)
                for classIdentifier = getClassIdentifiers(obj.MetaDataAdapter, prop)
                    obj.mapGetNameFcnToPropNodes(classIdentifier, map, getNameFcn);
                end
            end
        end
    end

    %% Setup Listener Functions
    methods (Access = private)
        function setupListeners(obj)
            obj.ViewListeners(end+1) = listener(obj.View, "SelectedNode", ...
                @(src, evt)obj.nodeChange(src, evt));

            obj.ViewListeners(end+1) = listener(obj.View, "SearchFieldValueChanged", ...
                @(src, evt)obj.searchFieldValuedChanged(src, evt));
        end
    end

    %% Getters and Setters
    methods
        function value = get.View(obj)
            value = obj.ViewConfiguration.View;
        end

        function value = get.Tree(obj)
            value = obj.View.Tree;
        end

        function value = get.FunctionRoot(obj)
            value = obj.View.FunctionRoot;
        end

        function value = get.PropertyRoot(obj)
            value = obj.View.PropertyRoot;
        end
    end
end
