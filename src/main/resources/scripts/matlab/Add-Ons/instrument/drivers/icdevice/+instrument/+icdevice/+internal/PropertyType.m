classdef PropertyType
    %PROPERTYTYPE is the type of property returned by PropertyFinderMixin.
    %This helps consumsers of PropertyFinderMixin.findProperty() utility
    %method to perform operations based on the type of property returned.

    %   Copyright 2022 The MathWorks, Inc.

    enumeration
        ClassSpecific
        MDDSpecific
        LocalProperty
        ExcludedProperty
        Error
    end
end