classdef Configuration < instrument.ivic.IviGroupBase
    %CONFIGURATION This class contains functions that configure
    %the instrument.  The class includes high-level functions
    %that configure multiple instrument settings as well as
    %low-level functions that set, get, and check individual
    %attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Configuration()
            %% Initialize properties
            obj.Output = instrument.ivic.IviDCPwr.Configuration.Output();
            obj.Triggering = instrument.ivic.IviDCPwr.Configuration.Triggering();
            obj.SetGetCheckAttribute = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.Triggering = [];
            obj.Output = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.Triggering.setLibraryAndSession(libName, session);
            obj.Output.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %OUTPUT This class contains functions for configuring the
        %output. Read Only.
        Output
        
        %TRIGGERING This class contains functions for configuring
        %the trigger system. Read Only.
        Triggering
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% Output property access methods
        function value = get.Output(obj)
            if isempty(obj.Output)
                obj.Output = instrument.ivic.IviDCPwr.Configuration.Output();
            end
            value = obj.Output;
        end
        
        %% Triggering property access methods
        function value = get.Triggering(obj)
            if isempty(obj.Triggering)
                obj.Triggering = instrument.ivic.IviDCPwr.Configuration.Triggering();
            end
            value = obj.Triggering;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
end
