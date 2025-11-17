classdef SetGetCheckAttribute < instrument.ivic.IviGroupBase
    %SETGETCHECKATTRIBUTE This class contains sub-classes for
    %the set, get, and check attribute functions.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = SetGetCheckAttribute()
            %% Initialize properties
            obj.SetAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            obj.GetAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            obj.CheckAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.CheckAttribute();
        end
        
        function delete(obj)
            obj.CheckAttribute = [];
            obj.GetAttribute = [];
            obj.SetAttribute = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.CheckAttribute.setLibraryAndSession(libName, session);
            obj.GetAttribute.setLibraryAndSession(libName, session);
            obj.SetAttribute.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %SETATTRIBUTE This class contains functions that set an
        %attribute to a new value.  There are typesafe functions for
        %each attribute data type. Read Only.
        SetAttribute
        
        %GETATTRIBUTE This class contains functions that obtain the
        %current value of an attribute.  There are typesafe
        %functions for each attribute data type. Read Only.
        GetAttribute
        
        %CHECKATTRIBUTE This class contains functions that obtain
        %the current value of an attribute.  There are typesafe
        %functions for each attribute data type. Read Only.
        CheckAttribute
    end
    
    %% Property access methods
    methods
        %% SetAttribute property access methods
        function value = get.SetAttribute(obj)
            if isempty(obj.SetAttribute)
                obj.SetAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            end
            value = obj.SetAttribute;
        end
        
        %% GetAttribute property access methods
        function value = get.GetAttribute(obj)
            if isempty(obj.GetAttribute)
                obj.GetAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            end
            value = obj.GetAttribute;
        end
        
        %% CheckAttribute property access methods
        function value = get.CheckAttribute(obj)
            if isempty(obj.CheckAttribute)
                obj.CheckAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.CheckAttribute();
            end
            value = obj.CheckAttribute;
        end
    end
end
