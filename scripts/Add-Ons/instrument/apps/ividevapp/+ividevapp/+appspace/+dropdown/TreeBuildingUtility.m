classdef TreeBuildingUtility
    %TREEBUILDINGUTILITY class contains utility functions for the Tree
    %Accessor class.

    %   Copyright 2023 The MathWorks, Inc.

    methods (Static)
        function [treeBuildingNodeMap, allMatchedIndexesMap] = createMapOfMapsForIndices(map, matchEntries)
            % Takes 2 input arguments -
            %
            % map - A containers.Map instance containing the list of all
            % names of properties and functions (at all levels) as the keys
            % and their respective levels as the value. E.g.
            %
            % >> map("Channel")
            %
            % ans =
            %
            %      {[5 1 3] [18] [19 2]}
            %
            % This implies that the "Channel" name was found at node 5 ->
            % child 1 -> child 3
            %
            % matchEntries - The list of group, property, or function names
            % that matched the search entry by the user.
            %
            % -------------------------------------------------------------
            %
            % Return 2 maps from this function.
            %
            % treeBuildingNodeMap - contains a map of map of map (and so
            % on) of the tree hierarchy of the cached (or full) tree that
            % match the match entries. This map will be used to construct
            % the new tree of matched entries.
            %
            % allMatchedIndexesMap - contains a map of map of map (and
            % so on) of all the indices of the cached (or full) tree
            % hierarchy. This will be used to expand the matching
            % nodes in the new tree.

            arguments
                map containers.Map
                matchEntries (1, :) string
            end

            treeBuildingNodeMap = containers.Map("KeyType", "double", "ValueType", "any");
            allMatchedIndexesMap = containers.Map("KeyType", "double", "ValueType", "any");
            for entryName = matchEntries
                treeLevels = map(entryName);
                for levelCell = treeLevels
                    levels = levelCell{:};
                    createMapRecursive(treeBuildingNodeMap, allMatchedIndexesMap, levels, 1);
                end
            end

            %% NESTED FUNCTION - Level 1
            function createMapRecursive(treeBuildingNodeMap, allMatchedIndexesMap, allLevelsArray, currLevelIdx)
                % Recursively create the treeBuildingNodeMap and the
                % allMatchedIndexesMap.

                if currLevelIdx > length(allLevelsArray)
                    return
                end

                currLevelValue = allLevelsArray(currLevelIdx);

                if ~isKey(treeBuildingNodeMap, currLevelValue)
                    treeBuildingNodeMap(currLevelValue) = containers.Map("KeyType", "double", "ValueType", "any");
                    allMatchedIndexesMap(currLevelValue) = containers.Map("KeyType", "double", "ValueType", "any");
                else
                    % If we are looking at the last index - no next
                    % element exists - remove everything else.
                    if currLevelIdx == length(allLevelsArray)
                        treeBuildingNodeMap(currLevelValue) = containers.Map("KeyType", "double", "ValueType", "any");
                    else
                        % E.g. if [15 2] exists in the treeBuildingNodeMap
                        % and we get a new entry [15 2 1], we should not
                        % add "1" to the map(15)->map(2) to the
                        % treeBuildingNodeMap. This is because [15 2] was
                        % already a match, and the new tree is going to
                        % contain everything under [15 2]. However, "1"
                        % needs to be added to map(15)->map(2)->map(1) for
                        % allMatchedIndexesMap as this will be used for
                        % expanding the "2" node in the final tree.
                        if isempty(treeBuildingNodeMap(currLevelValue))
                            populateNodesToExpandMapRecursive(allMatchedIndexesMap(currLevelValue), allLevelsArray(currLevelIdx+1:end));
                            return
                        end
                    end
                end
                createMapRecursive(treeBuildingNodeMap(currLevelValue), allMatchedIndexesMap(currLevelValue), allLevelsArray, currLevelIdx + 1);

                %% NESTED FUNCTION - Level 1.1
                function populateNodesToExpandMapRecursive(allMatchedIndexesMap, remainingLevels)
                    % Further populate the "allMatchedIndexesMap" map with
                    % new map entries that need to be expanded in the new
                    % tree.

                    if isempty(remainingLevels)
                        return
                    end

                    idx = remainingLevels(1);
                    if ~isKey(allMatchedIndexesMap, idx)
                        allMatchedIndexesMap(idx) = containers.Map("KeyType", "double", "ValueType", "any");
                    end

                    remainingLevels(1) = [];
                    populateNodesToExpandMapRecursive(allMatchedIndexesMap(idx), remainingLevels);
                end
            end
        end

        function addNameAndLevelToMap(map, name, tag)
            % Add a name, e.g. "Channel" as key with the associated level,
            % e.g. [10 1 2] to the given map.
            %
            % [10 1 2] implies 10th Child -> 1st Child -> 2nd Child.
            arguments
                map
                name (1, 1) string
                tag
            end

            if isKey(map, name)
                val = map(name);
                val{end+1} = tag;
                map(name) = val;
            else
                map(name) = {tag}; %#ok<*NASGU>
            end
        end
    end
end