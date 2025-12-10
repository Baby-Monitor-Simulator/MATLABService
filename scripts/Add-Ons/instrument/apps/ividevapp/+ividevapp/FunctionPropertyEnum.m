classdef FunctionPropertyEnum < uint8
    %FUNCTIONPROPERTYENUM Enumeration class that defines the ordering of
    %the function and property tree nodes, i.e. which node is created as
    %the first node and which as the second.

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        PROPERTY (1)
        FUNCTION (2)
    end
end