classdef TreeCache < handle
    %TREECACHE class holds on to the cached function and property tree for
    %the ividev app.

    %   Copyright 2023 The MathWorks, Inc.

    properties (SetAccess = immutable, GetAccess = private)
        CachedTree
    end

    methods
        function obj = TreeCache(tree)
            obj.CachedTree = tree;
            obj.CachedTree.Visible = "off";
        end

        function delete(obj)
            delete(obj.CachedTree);
        end

        function tree = fetchTreeFromCache(obj)
            tree = obj.CachedTree;
        end
    end
end
