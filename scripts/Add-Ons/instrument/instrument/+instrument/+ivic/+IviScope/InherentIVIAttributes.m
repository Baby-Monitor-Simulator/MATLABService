classdef InherentIVIAttributes < instrument.ivic.IviGroupBase
    %INHERENTIVIATTRIBUTES Attributes common to all IVI
    %instrument drivers.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = InherentIVIAttributes()
            %% Initialize properties
            obj.UserOptions = instrument.ivic.IviScope.InherentIVIAttributes.UserOptions();
            obj.ClassDriverIdentification = instrument.ivic.IviScope.InherentIVIAttributes.ClassDriverIdentification();
            obj.SpecificDriverIdentification = instrument.ivic.IviScope.InherentIVIAttributes.SpecificDriverIdentification();
            obj.SpecificDriverCapabilities = instrument.ivic.IviScope.InherentIVIAttributes.SpecificDriverCapabilities();
            obj.InstrumentIdentification = instrument.ivic.IviScope.InherentIVIAttributes.InstrumentIdentification();
            obj.AdvancedSessionInformation = instrument.ivic.IviScope.InherentIVIAttributes.AdvancedSessionInformation();
        end
        
        function delete(obj)
            obj.AdvancedSessionInformation = [];
            obj.InstrumentIdentification = [];
            obj.SpecificDriverCapabilities = [];
            obj.SpecificDriverIdentification = [];
            obj.ClassDriverIdentification = [];
            obj.UserOptions = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.AdvancedSessionInformation.setLibraryAndSession(libName, session);
            obj.InstrumentIdentification.setLibraryAndSession(libName, session);
            obj.SpecificDriverCapabilities.setLibraryAndSession(libName, session);
            obj.SpecificDriverIdentification.setLibraryAndSession(libName, session);
            obj.ClassDriverIdentification.setLibraryAndSession(libName, session);
            obj.UserOptions.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %USEROPTIONS Attributes you can set to affect the operation
        %of this instrument driver.\n Read Only.
        UserOptions
        
        %CLASSDRIVERIDENTIFICATION Attributes that provide identity
        %and version information about the class driver.\n Read Only.
        ClassDriverIdentification
        
        %SPECIFICDRIVERIDENTIFICATION Attributes that provide
        %identity and version information about the specific
        %driver.\n Read Only.
        SpecificDriverIdentification
        
        %SPECIFICDRIVERCAPABILITIES Attributes that provide
        %information about the capabilities of the specific
        %driver.\n Read Only.
        SpecificDriverCapabilities
        
        %INSTRUMENTIDENTIFICATION Attributes that provide identity
        %information about the instrument that you are using. Read
        %Only.
        InstrumentIdentification
        
        %ADVANCEDSESSIONINFORMATION Attributes that contain
        %additional information concerning the instrument driver
        %session.   Read Only.
        AdvancedSessionInformation
    end
    
    %% Property access methods
    methods
        %% UserOptions property access methods
        function value = get.UserOptions(obj)
            if isempty(obj.UserOptions)
                obj.UserOptions = instrument.ivic.IviScope.InherentIVIAttributes.UserOptions();
            end
            value = obj.UserOptions;
        end
        
        %% ClassDriverIdentification property access methods
        function value = get.ClassDriverIdentification(obj)
            if isempty(obj.ClassDriverIdentification)
                obj.ClassDriverIdentification = instrument.ivic.IviScope.InherentIVIAttributes.ClassDriverIdentification();
            end
            value = obj.ClassDriverIdentification;
        end
        
        %% SpecificDriverIdentification property access methods
        function value = get.SpecificDriverIdentification(obj)
            if isempty(obj.SpecificDriverIdentification)
                obj.SpecificDriverIdentification = instrument.ivic.IviScope.InherentIVIAttributes.SpecificDriverIdentification();
            end
            value = obj.SpecificDriverIdentification;
        end
        
        %% SpecificDriverCapabilities property access methods
        function value = get.SpecificDriverCapabilities(obj)
            if isempty(obj.SpecificDriverCapabilities)
                obj.SpecificDriverCapabilities = instrument.ivic.IviScope.InherentIVIAttributes.SpecificDriverCapabilities();
            end
            value = obj.SpecificDriverCapabilities;
        end
        
        %% InstrumentIdentification property access methods
        function value = get.InstrumentIdentification(obj)
            if isempty(obj.InstrumentIdentification)
                obj.InstrumentIdentification = instrument.ivic.IviScope.InherentIVIAttributes.InstrumentIdentification();
            end
            value = obj.InstrumentIdentification;
        end
        
        %% AdvancedSessionInformation property access methods
        function value = get.AdvancedSessionInformation(obj)
            if isempty(obj.AdvancedSessionInformation)
                obj.AdvancedSessionInformation = instrument.ivic.IviScope.InherentIVIAttributes.AdvancedSessionInformation();
            end
            value = obj.AdvancedSessionInformation;
        end
    end
end
