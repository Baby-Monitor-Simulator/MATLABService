classdef (Abstract) NodeData
    %NODEDATA form class contains node data information about the property
    %and function nodes like name, type and other properties.

    % Copyright 2023 The MathWorks, Inc.

    properties
        % The name of the node.
        Name (1, 1) string

        % The type of node - Property or Function.
        Type (1, 1) {mustBeMember(Type, ["Function", "Property"])} = "Function"
    end
end