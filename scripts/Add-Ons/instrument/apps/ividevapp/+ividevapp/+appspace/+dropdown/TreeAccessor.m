classdef TreeAccessor < handle
    %TREEACCESSOR class contains the uitree for the ividev app. It contains
    %the following functionalities -
    % 1. Creating a uitree.
    % 2. Adding uitree nodes and adding them to a tree.
    % 3. Creating the root Functions and Properties nodes of the tree.
    % 4. Updating the tree based on user search.

    %   Copyright 2023 The MathWorks, Inc.

    events
        % Notify the View that a new uitree was created. The View needs to
        % set the appropriate SelectionChangedFcn as a response to this
        % event.
        TreeRecreated
    end

    properties
        Tree
        FunctionRoot
        PropertyRoot
    end

    %% Composed Classes
    properties (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        % The handle to the cached tree handler.
        TreeCache

        % The handle to the class responsible for adding and removing
        % styling (bold texts, text highlights) to the ui tree.
        TreeStyler
    end

    %% Other Tree properties
    properties (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        % Map of Function Names to their position in the main tree. E.g.
        % map with key - "Channel" and value [10 1 2] implies that there is
        % an entry called "Channel" in the main tree at the following
        % location: Tree -> Functions -> 10th Child -> 1st Child -> 2nd
        % Child
        FunctionToTreeLevel

        % Map of Property Names to their position in the main tree. E.g.
        % map with key - "Channel" and value [10 1 2] implies that there is
        % an entry called "Channel" in the main tree at the following
        % location: Tree -> Properties -> 10th Child -> 1st Child -> 2nd
        % Child
        PropertyToTreeLevel

        % The level or hierarchy of the property or function that is being
        % examined. E.g. [10 1 2] implies 10th Child -> 1st Child -> 2nd
        % Child.
        LevelTag (1, :) double = 0

        % The current level of hierarchy, but only for properties.
        CurrentPropLevel (1, 1) double = 0

        % Flag that internally keeps track of whether the tree was cached.
        % The tree should be cached only once - this flag is used to error
        % if the tree was cached again.
        IsCached (1, 1) logical = false

        % Dictionary that contains the PROPERTY or FUNCTION enumeration as
        % the key and the associated creation method as the value.
        PropertyFunctionCreationDictionary = ...
            configureDictionary("ividevapp.FunctionPropertyEnum", "function_handle")
    end

    properties (Constant, Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        FunctionNodeText (1, 1) string = message("ividevapp:ividevapp:FunctionsNodeName").string
        PropertyNodeText (1, 1) string = message("ividevapp:ividevapp:PropertiesNodeName").string
    end

    properties (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        % Properties used in unit testing to identify if a method was executed

        CreateTreeWithEmptyFunctionPropertyNodeExecuted (1, 1) logical = false
        CreateNewTreeFromMatchesExecuted (1, 1) logical = false
    end

    %% Lifetime
    methods
        function obj = TreeAccessor(treeInstance)
            obj.Tree = treeInstance;
            setTreeLayout(obj);

            obj.TreeStyler = ividevapp.appspace.dropdown.TreeNodeStyler;
            obj.TreeStyler.HighlightingEnabled = true;
            obj.FunctionToTreeLevel = containers.Map;
            obj.PropertyToTreeLevel = containers.Map;

            obj.PropertyFunctionCreationDictionary(ividevapp.FunctionPropertyEnum.PROPERTY) = ...
                @()obj.createPropertyRoot;
            obj.PropertyFunctionCreationDictionary(ividevapp.FunctionPropertyEnum.FUNCTION) = ...
                @()obj.createFunctionRoot;
        end

        function delete(~)
            % Since the tree is a persistent instance, explicitly set a
            % flag to delete it.
            clearPersistentTree = true;
            ividevapp.appspace.dropdown.TreeAccessor.getCurrentTreeHandle(clearPersistentTree);
        end
    end

    %% Controller accessing Tree
    methods
        function cacheTree(obj, varargin)
            % Cache the main tree once. This tree is going to be the lookup
            % tree for populating the new tree when user searches for
            % entries like "Channel" or "Trigger" in the search edit field.

            narginchk(1, 2);

            if obj.IsCached
                throwAsCaller(MException(message("ividevapp:ividevapp:CannotCacheTreeTwice")));
            end

            obj.TreeStyler.boldFunctionsPropertiesNodes(obj.Tree);
            obj.TreeStyler.highlightTreeNodes(obj.Tree);
            obj.TreeCache = ividevapp.appspace.dropdown.TreeCache(obj.Tree);

            % Recreate a new tree from the cache - this is less expensive
            % than copying the properties and functions nodes of the cached
            % tree.
            recreateCompleteTreeFromCache(obj, varargin{:});
            obj.IsCached = true;
        end

        function node = addNode(~, parent, name, nodeData, tag)
            % Add a node with the given name and node data to the specified
            % parent tree.

            node = uitreenode(parent, 'Text', name, 'NodeData', nodeData, "Tag", tag);
        end

        function resetLevelTag(obj)
            % Reset the Level Tag after creating the property tree or
            % function tree.

            obj.LevelTag = 0;
        end

        function addFunctionNameToLevel(obj, name, levels)
            % Add the current function group or function name with
            % its associated level to the FunctionToTreeLevel map.

            arguments
                obj
                name (1, 1) string
                levels (1, :) double
            end

            % If the level is a root level node on the Properties or
            % Functions node, the value of levels is a scalar.
            if isscalar(levels)
                % Root Element
                %
                % We need to reset obj.LevelTag to the root. E.g. if the
                % last entry reflected by LevelTag was [5 1 3], and a root
                % level node comes in, we have to update LevelTag to [6].
                % In the above case of obj.LevelTag = [5 1 3],
                % obj.LevelTag(1) = 5. obj.LevelTag(1) + 1 becomes 6.
                obj.LevelTag = obj.LevelTag(1) + 1;
            else
                currentFunctionLevel = length(levels);
                obj.updateLevelTag(currentFunctionLevel, length(obj.LevelTag));
            end

            ividevapp.appspace.dropdown.TreeBuildingUtility.addNameAndLevelToMap(obj.FunctionToTreeLevel, name, obj.LevelTag);
        end

        function addPropertyNameToLevel(obj, name, level)
            % Add the current property group or property name with
            % its associated level to the PropertyToTreeLevel map.

            if level == 1
                % Root Element
                %
                % We need to reset obj.LevelTag to the root. E.g. if the
                % last entry reflected by LevelTag was [5 1 3], and a root
                % level node comes in, we have to update LevelTag to [6].
                % In the above case of obj.LevelTag = [5 1 3],
                % obj.LevelTag(1) = 5. obj.LevelTag(1) + 1 becomes 6.
                obj.LevelTag = obj.LevelTag(1) + 1;
            else
                obj.updateLevelTag(level, obj.CurrentPropLevel);
            end

            obj.CurrentPropLevel = level;
            ividevapp.appspace.dropdown.TreeBuildingUtility.addNameAndLevelToMap(obj.PropertyToTreeLevel, name, obj.LevelTag);
        end

        function populateFirstLevelTreeChildren(obj, type)
            % Create the function or property root. This method ensures
            % that the order of function and property roots is maintained
            % in the tree.

            arguments
                obj
                type (1, 1) ividevapp.FunctionPropertyEnum
            end

            rootChildIndex = double(type);
            currentTreeLength = length(obj.Tree.Children);
            diff = rootChildIndex - currentTreeLength;

            % Check if tree node is created in a order. If diff is not equal
            % to 1, then the tree node is not being created in order. In
            % this case throw an error.
            % Example: If FUNCTION node index is 2 and the currentTreeLength
            % is 0, then the PROPERTY which was supposed to be added as
            % index 1 was never added. This is not a valid worklfow and the
            % diff in this case will be 2.
            if diff ~= 1
                throwAsCaller(MException(message("ividevapp:ividevapp:OutOfOrderTreeNodeCreation", string(type))));
            end

            % Invoke the appropriate property or function root node
            % creation function
            fcn = obj.PropertyFunctionCreationDictionary(type);
            fcn();
        end
    end

    % Callback methods
    methods
        function searchFieldChangedFcn(obj, searchFieldValue)
            % Create a new tree based on the search field value. E.g. when
            % search field value is "Channel", only display the property
            % and function groups or names that have the "Channel" string
            % (case-insensitive).

            if ~obj.IsCached
                throwAsCaller(MException(message("ividevapp:ividevapp:TreeNotCached")));
            end

            c = onCleanup(@() resetTreeEnable(obj));
            obj.Tree.Enable = "off";

            % Needed for graphics element to be updated.
            drawnow;

            obj.TreeStyler.setTextToHighlight(searchFieldValue);

            % Case 1 - Search field is empty. Restore the tree to its
            % original form.
            if isempty(searchFieldValue) || searchFieldValue == ""
                recreateCompleteTreeFromCache(obj);
                return
            end

            % Check to see if search field value results in matched names.
            % Show only those groups or names (both for properties and
            % functions).
            matches = getNamesThatMatchPattern(obj, searchFieldValue);

            % Case 2 - No matching property or function group and names
            % were found. Show an empty tree with an empty "Functions" and
            % "Properties" node.
            if isempty(matches.FunctionNamesMatch) && isempty(matches.PropertyNamesMatch)
                createTreeWithEmptyFunctionPropertyNode(obj)
            else
                % Case 3 - Matches found. Populate a new tree with the
                % matches.
                createNewTreeFromMatches(obj, matches);
            end

            %% NESTED FUNCTION
            function createNewTreeFromMatches(obj, matches)
                % Create a new tree with matching groups and names (both
                % for properties and functions).

                obj.CreateNewTreeFromMatchesExecuted = true;

                % Consists of 4 main steps -

                % Step 1 - Create an empty tree with an empty "Functions"
                % and "Properties" node. (Same as Case 2).
                createTreeWithEmptyFunctionPropertyNode(obj);

                % Step 2 - Create 2 maps, 1 for properties and 1 for
                % functions. The map (Let's call it IndexMap) contains the
                % node's Children index in the main tree that need to be
                % shown in the new tree as keys. The value for this entry
                % is an IndexMap for the next level (Child node) with the
                % indices for the node that need to be shown. And so on.
                [functionTreeBuildingNodeMap, allFunctionsMatchedMap] = ividevapp.appspace.dropdown.TreeBuildingUtility. ...
                    createMapOfMapsForIndices(obj.FunctionToTreeLevel, matches.FunctionNamesMatch);
                [propertyTreeBuildingNodeMap, allPropertiesMatchedMap] = ividevapp.appspace.dropdown.TreeBuildingUtility. ...
                    createMapOfMapsForIndices(obj.PropertyToTreeLevel, matches.PropertyNamesMatch);

                % Step 3 - Fetch the original cached tree.
                cachedTree = obj.TreeCache.fetchTreeFromCache();

                % Step 4 - Once the above maps are created in Step 2, use
                % this map to lookup the tree entries in the maintree
                % instance from Step 3. Populate the property and function
                % nodes for the matching entries.
                populateTreeRecursive(obj, ...
                    cachedTree.Children(ividevapp.FunctionPropertyEnum.PROPERTY), ...
                    obj.Tree.Children(ividevapp.FunctionPropertyEnum.PROPERTY), ...
                    propertyTreeBuildingNodeMap, allPropertiesMatchedMap)

                populateTreeRecursive(obj, ...
                    cachedTree.Children(ividevapp.FunctionPropertyEnum.FUNCTION), ...
                    obj.Tree.Children(ividevapp.FunctionPropertyEnum.FUNCTION), ...
                    functionTreeBuildingNodeMap, allFunctionsMatchedMap)
            end
        end
    end

    %% Private Helper Functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function createFunctionRoot(obj)
            % Create the initial root for the tree displaying all
            % functions.

            obj.FunctionRoot = uitreenode(obj.Tree);
            obj.FunctionRoot.Text = ividevapp.appspace.dropdown.TreeAccessor.FunctionNodeText;
            obj.FunctionRoot.Tag = "Functions";
        end

        function createPropertyRoot(obj)
            % Create the initial root for the tree displaying all
            % properties.

            obj.PropertyRoot = uitreenode(obj.Tree);
            obj.PropertyRoot.Text = ividevapp.appspace.dropdown.TreeAccessor.PropertyNodeText;
            obj.PropertyRoot.Tag = "Properties";
        end

        function resetTreeEnable(obj)
            obj.Tree.Enable = "on";
        end

        function createTreeWithEmptyFunctionPropertyNode(obj)
            % Clear existing tree and create a new tree with just the
            % "Functions" and "Properties" nodes.

            obj.CreateTreeWithEmptyFunctionPropertyNodeExecuted = true;

            obj.removeTreeChildren();

            obj.populateFirstLevelTreeChildren("PROPERTY");
            obj.populateFirstLevelTreeChildren("FUNCTION");

            obj.TreeStyler.boldFunctionsPropertiesNodes(obj.Tree);
            obj.TreeStyler.highlightTreeNodes(obj.Tree);
        end

        function removeTreeChildren(obj)
            % Remove the "Functions" and "Properties" nodes from the tree.

            obj.TreeStyler.removeAllStyles(obj.Tree);
            for i = length(obj.Tree.Children) : -1 : 1
                obj.Tree.Children(i).delete;
            end
        end

        function updateLevelTag(obj, currentLevel, previousLevel)
            % When creating the map between all tree nodes and their
            % respective level, this function creates the Level for each
            % entry. E.g. "ChannelEnabled"  as a node is present at -> Tree
            % -> "Functions" Node -> 15th Child -> 2nd Child -> 1st Child.
            % This function sets the LevelTag for this entry to [15 2 1].

            if previousLevel == currentLevel
                % The entry is at the same level as the previous. The
                % LevelTag for this entry should be increased by 1 to
                % signify that next node entry is added at same level.
                %
                % E.g. obj.LevelTag = [5 1 2] to obj.LevelTag = [5 1 3].
                obj.LevelTag(end) = obj.LevelTag(end) + 1;

            elseif previousLevel < currentLevel
                % A deeper level entry is being added. This will be the
                % first child at this level, hence assigning 1 as new
                % LevelTag entry.
                %
                % E.g. obj.LevelTag = [5 1 2] to obj.LevelTag = [5 1 2 1].
                obj.LevelTag(end+1) = 1;

            else
                % Going back to the parent level. Remove other lower
                % entries. Increment the parent level entry (LevelTag) by 1
                % to indicate that level was added for a new parent group
                % node.
                %
                % E.g. obj.LevelTag = [5 1 2] to obj.LevelTag = [5 2]
                beginIdx = currentLevel + 1;
                obj.LevelTag(beginIdx:end) = [];
                obj.LevelTag(end) = obj.LevelTag(end) + 1;
            end
        end

        function matches = getNamesThatMatchPattern(obj, patternToMatch)
            % Return the list of function and property names that contains
            % the "patternToMatch" substring.

            arguments
                obj
                patternToMatch (1, 1) string
            end

            matches.FunctionNamesMatch = getMatchingNames(obj, string(keys(obj.FunctionToTreeLevel)), patternToMatch);
            matches.PropertyNamesMatch = getMatchingNames(obj, string(keys(obj.PropertyToTreeLevel)), patternToMatch);

            %% NESTED FUNCTION
            function match = getMatchingNames(~, allKeys, patternToMatch)
                match = string.empty;
                matchingIDs = contains(allKeys, patternToMatch, IgnoreCase=true);

                if isempty(matchingIDs)
                    return
                end
                match = allKeys(matchingIDs);
            end
        end

        function populateTreeRecursive(obj, referenceNode, parentNodeInNewTree, mapToCreateTree, allMatchedNodeIndicesMap)
            % Create the new function or property tree, based on matched
            % entries. This is called recursively as the name suggests.
            %
            % referenceNode - The node from the cached (or full) tree.
            %
            % parentNodeInNewTree - Corresponding node in the new tree.
            %
            % mapToCreateTree - The map of map of map (and so on) that
            % contains the tree of node indices that correspond to the main tree
            % to create the new tree structure.
            %
            % allMatchedNodeIndicesMap - The map of map of map (and so on)
            % that contains the tree of node indices that correspond to the
            % main tree. This will be used to expand the new leaf nodes on
            % the new tree (if applicable).

            allKeys = keys(mapToCreateTree);
            for i = 1 : length(allKeys)
                currentKey = allKeys{i};
                node = referenceNode.Children(currentKey);
                mapVal = mapToCreateTree(currentKey);

                % If the current map value is empty, implying this is a
                % node "ALONG WITH ITS CHILDREN" that we want to copy from
                % the full tree into the new tree.
                if isnumeric(mapVal) || isempty(mapVal)

                    % Create a new handle for the copy of "node" and assign
                    % that as a child of "parentNodeInNewTree".
                    node_handle = copyobj(node, parentNodeInNewTree);

                    % Highlight the node.
                    obj.TreeStyler.highlightMatchingNodes(obj.Tree, node_handle);

                    % Expand the nodes
                    expand(parentNodeInNewTree);
                    expandNodesRecursive(obj, node_handle, allMatchedNodeIndicesMap(currentKey));
                else
                    % Try to create a new node and add it to the new tree.
                    % Recursively call the populateTreeRecursive function
                    % on this new node.
                    nodeData = node.NodeData;
                    text = node.Text;
                    tag = node.Tag;

                    % Add a new node containing the cached (or full) tree
                    % data.
                    newParent = obj.addNode(parentNodeInNewTree, text, nodeData, tag);
                    populateTreeRecursive(obj, node, newParent, mapToCreateTree(currentKey), allMatchedNodeIndicesMap(currentKey));
                end
            end

            %% NESTED FUNCTION - Level 1
            function expandNodesRecursive(obj, parentNode, allMatchedNodeIndicesMap)
                % Expand the nodes in the new tree that would need to be
                % expanded.

                if isempty(allMatchedNodeIndicesMap)
                    return
                end

                allMatchedNodeKeys = keys(allMatchedNodeIndicesMap);
                for keyIdx = 1 : length(allMatchedNodeKeys)
                    currKey = allMatchedNodeKeys{keyIdx};

                    % Highlight the node.
                    obj.TreeStyler.highlightMatchingNodes(obj.Tree, parentNode.Children(currKey));

                    expand(parentNode);

                    if ~isempty(allMatchedNodeIndicesMap(currKey))
                        newParentNode = parentNode.Children(currKey);
                        expandNodesRecursive(obj, newParentNode, allMatchedNodeIndicesMap(currKey));
                    end
                end
            end
        end

        function recreateCompleteTreeFromCache(obj, varargin)
            % Create a new tree that will replace the existing obj.Tree and
            % replace that with a new uitree.
            % NOTE - this does not affect the cached tree instance.

            parent = obj.Tree.Parent;
            obj.Tree.Parent = [];

            if isempty(varargin)
                obj.Tree = uitree(parent);
                obj.Tree.Parent = parent;
                setTreeLayout(obj);
            else
                obj.Tree = varargin{1};
            end
            populateTreeFromCache(obj);
            obj.TreeStyler.boldFunctionsPropertiesNodes(obj.Tree);
            obj.TreeStyler.highlightTreeNodes(obj.Tree);

            % Notify the View that a new uitree was created. The View needs to
            % set the appropriate SelectionChangedFcn as a response to this
            % event.
            obj.notify("TreeRecreated");

            %% NESTED FUNCTION - Level 1
            function populateTreeFromCache(obj)
                % Add a function and property root node. Copy
                % everything under the cached tree's function and
                % property nodes into the Tree and TreeCopy instances.

                tree = obj.TreeCache.fetchTreeFromCache();

                % NOTE: Ensure that the property and function nodes are
                % added in the order specified by
                % "ividevapp.FunctionPropertyEnum".
                obj.PropertyRoot = copyobj(tree.Children(ividevapp.FunctionPropertyEnum.PROPERTY), obj.Tree);
                obj.FunctionRoot = copyobj(tree.Children(ividevapp.FunctionPropertyEnum.FUNCTION), obj.Tree);

                expand(obj.FunctionRoot);
                expand(obj.PropertyRoot);
            end
        end

        function setTreeLayout(obj)
            obj.Tree.Layout.Row = 2;
            obj.Tree.Layout.Column = [1 2];
        end
    end

    %% Getters and Setters
    methods
        function set.Tree(obj, newTree)
            obj.Tree = newTree;
            obj.Tree.Tag = "FunctionPropertyTree";

            % Save the tree instance to be retrieved later (used for
            % testing).
            ividevapp.appspace.dropdown.TreeAccessor.getCurrentTreeHandle(false, newTree);
        end
    end

    %% Static Helpers
    methods (Static, Hidden)
        function returnTree = getCurrentTreeHandle(clearTree, tree)
            % Get access to the underlying tree (used for testing).
            % Inputs:
            %
            % clearTree: Flag that clears the persistent variable holding
            % on to the tree instance. true - clears the persistent
            % variable, false - NO-OP.
            %
            % tree: Internally used in the source code to set the
            % persistent variable to the tree instance upon creation. This
            % tree is later retrieved in the test.
            %
            % Outputs:
            %
            % returnTree: The handle to the tree stored in the persistent
            % variable. If clearTree is set to true, returnTree is [].
            % Else it return the persistent tree handle.

            arguments
                clearTree (1, 1) logical = false
                tree = []
            end

            persistent currentTree

            returnTree = [];
            if clearTree
                currentTree = [];
                return
            end

            if ~isempty(tree)
                currentTree = tree;
            end
            returnTree = currentTree;
        end
    end
end
