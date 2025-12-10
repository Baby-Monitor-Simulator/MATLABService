classdef CodeOperationType
    %CODEOPERATIONTYPE contains the kind of code operations like property
    %set, property get, or other function operations - invoke, connect,
    %disconnect, init.

    %   Copyright 2022 The MathWorks, Inc.

    enumeration
        FunctionOperation
        PropertyGet
        PropertySet
    end
end