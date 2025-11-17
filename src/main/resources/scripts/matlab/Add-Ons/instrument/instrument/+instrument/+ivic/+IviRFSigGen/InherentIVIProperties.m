classdef InherentIVIProperties < instrument.ivic.IviGroupBase
    %INHERENTIVIPROPERTIES Attributes common to all IVI
    %instrument drivers.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = InherentIVIProperties()
            %% Initialize properties
            obj.UserOptions = instrument.ivic.IviRFSigGen.InherentIVIProperties.UserOptions();
            obj.DriverIdentification = instrument.ivic.IviRFSigGen.InherentIVIProperties.DriverIdentification();
            obj.DriverCapabilities = instrument.ivic.IviRFSigGen.InherentIVIProperties.DriverCapabilities();
            obj.InstrumentIdentification = instrument.ivic.IviRFSigGen.InherentIVIProperties.InstrumentIdentification();
            obj.AdvancedSessionInformation = instrument.ivic.IviRFSigGen.InherentIVIProperties.AdvancedSessionInformation();
        end
        
        function delete(obj)
            obj.AdvancedSessionInformation = [];
            obj.InstrumentIdentification = [];
            obj.DriverCapabilities = [];
            obj.DriverIdentification = [];
            obj.UserOptions = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.AdvancedSessionInformation.setLibraryAndSession(libName, session);
            obj.InstrumentIdentification.setLibraryAndSession(libName, session);
            obj.DriverCapabilities.setLibraryAndSession(libName, session);
            obj.DriverIdentification.setLibraryAndSession(libName, session);
            obj.UserOptions.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %USEROPTIONS Attributes you can set to affect the operation
        %of this instrument driver.\n Read Only.
        UserOptions
        
        %DRIVERIDENTIFICATION Attributes that provide identity and
        %version information about this  Read Only.
        DriverIdentification
        
        %DRIVERCAPABILITIES Attributes that provide information
        %about the capabilities of this  Read Only.
        DriverCapabilities
        
        %INSTRUMENTIDENTIFICATION Attributes that provide identity
        %information about the instrument that  Read Only.
        InstrumentIdentification
        
        %ADVANCEDSESSIONINFORMATION Attributes that contain
        %additional information concerning the instrument  Read Only.
        AdvancedSessionInformation
    end
    
    %% Property access methods
    methods
        %% UserOptions property access methods
        function value = get.UserOptions(obj)
            if isempty(obj.UserOptions)
                obj.UserOptions = instrument.ivic.IviRFSigGen.InherentIVIProperties.UserOptions();
            end
            value = obj.UserOptions;
        end
        
        %% DriverIdentification property access methods
        function value = get.DriverIdentification(obj)
            if isempty(obj.DriverIdentification)
                obj.DriverIdentification = instrument.ivic.IviRFSigGen.InherentIVIProperties.DriverIdentification();
            end
            value = obj.DriverIdentification;
        end
        
        %% DriverCapabilities property access methods
        function value = get.DriverCapabilities(obj)
            if isempty(obj.DriverCapabilities)
                obj.DriverCapabilities = instrument.ivic.IviRFSigGen.InherentIVIProperties.DriverCapabilities();
            end
            value = obj.DriverCapabilities;
        end
        
        %% InstrumentIdentification property access methods
        function value = get.InstrumentIdentification(obj)
            if isempty(obj.InstrumentIdentification)
                obj.InstrumentIdentification = instrument.ivic.IviRFSigGen.InherentIVIProperties.InstrumentIdentification();
            end
            value = obj.InstrumentIdentification;
        end
        
        %% AdvancedSessionInformation property access methods
        function value = get.AdvancedSessionInformation(obj)
            if isempty(obj.AdvancedSessionInformation)
                obj.AdvancedSessionInformation = instrument.ivic.IviRFSigGen.InherentIVIProperties.AdvancedSessionInformation();
            end
            value = obj.AdvancedSessionInformation;
        end
    end
end
