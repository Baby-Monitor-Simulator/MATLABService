classdef PropertyNodeData < ividevapp.utilities.forms.NodeData
    %PROPERTYNODEDATA form class contains node data information about the
    %property nodes.

    %   Copyright 2023 The MathWorks, Inc.

    properties
        % Flag that indicates whether the property has an associated
        % repeated capability identifier or not.
        HasRepCap (1, 1) logical = false

        % The name(s) of the parent for the given node.
        ParentNodeName (1, :) string

        % The associated Visa Type for the property, e.g. ViString,
        % ViBoolean, etc.
        VisaType (1, 1) string

        % States whether the property has a get-only, set-only access or
        % both get and set access.
        AccessType (1, 1) string {mustBeMember(AccessType, ["g", "s", "gs"])} = "g"

        % The associated help text for a node.
        Help (1, 1) string = ""
    end
end

