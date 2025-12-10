classdef Configuration < instrument.ivic.IviGroupBase
    %CONFIGURATION This class contains functions and
    %sub-classes that configure the oscilloscope.  The class
    %includes high-level functions that configure the
    %acquisition, channel, and trigger subsystems.  The class
    %also contains the low-level functions that set, get, and
    %check individual attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Configuration()
            %% Initialize properties
            obj.Acquisition = instrument.ivic.IviScope.Configuration.Acquisition();
            obj.Channel = instrument.ivic.IviScope.Configuration.Channel();
            obj.Trigger = instrument.ivic.IviScope.Configuration.Trigger();
            obj.Measurement = instrument.ivic.IviScope.Configuration.Measurement();
            obj.ConfigurationInformation = instrument.ivic.IviScope.Configuration.ConfigurationInformation();
            obj.SetGetCheckAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.ConfigurationInformation = [];
            obj.Measurement = [];
            obj.Trigger = [];
            obj.Channel = [];
            obj.Acquisition = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.ConfigurationInformation.setLibraryAndSession(libName, session);
            obj.Measurement.setLibraryAndSession(libName, session);
            obj.Trigger.setLibraryAndSession(libName, session);
            obj.Channel.setLibraryAndSession(libName, session);
            obj.Acquisition.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %ACQUISITION This class contains functions that configure
        %the acquisition subsystem. Read Only.
        Acquisition
        
        %CHANNEL This class contains functions that configure the
        %individual channels of the oscilloscope. Read Only.
        Channel
        
        %TRIGGER This class contains functions that configure the
        %trigger subsystem.  To configure the trigger subsystem,
        %first call the IviScope_ConfigureTrigger function.  Then
        %call the trigger configuration function that corresponds to
        %the trigger type you specify. Read Only.
        Trigger
        
        %MEASUREMENT This class contains functions that configure
        %the measurement subsystem. Read Only.
        Measurement
        
        %CONFIGURATIONINFORMATION This class contains functions
        %that return information about the current configuration.
        %Read Only.
        ConfigurationInformation
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% Acquisition property access methods
        function value = get.Acquisition(obj)
            if isempty(obj.Acquisition)
                obj.Acquisition = instrument.ivic.IviScope.Configuration.Acquisition();
            end
            value = obj.Acquisition;
        end
        
        %% Channel property access methods
        function value = get.Channel(obj)
            if isempty(obj.Channel)
                obj.Channel = instrument.ivic.IviScope.Configuration.Channel();
            end
            value = obj.Channel;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviScope.Configuration.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% Measurement property access methods
        function value = get.Measurement(obj)
            if isempty(obj.Measurement)
                obj.Measurement = instrument.ivic.IviScope.Configuration.Measurement();
            end
            value = obj.Measurement;
        end
        
        %% ConfigurationInformation property access methods
        function value = get.ConfigurationInformation(obj)
            if isempty(obj.ConfigurationInformation)
                obj.ConfigurationInformation = instrument.ivic.IviScope.Configuration.ConfigurationInformation();
            end
            value = obj.ConfigurationInformation;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function AutoSetup(obj)
            %AUTOSETUP This function automatically configures the
            %instrument.  Notes:  (1) When you call this function, the
            %oscilloscope senses the input signal and automatically
            %configures many of the instrument settings.  The settings
            %no longer match the cache values for the corresponding
            %attributes.  Therefore, this function invalidates all
            %attribute cache values.  (2) This function is part of the
            %IviScopeAutoSetup [AS] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_AutoSetup', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
