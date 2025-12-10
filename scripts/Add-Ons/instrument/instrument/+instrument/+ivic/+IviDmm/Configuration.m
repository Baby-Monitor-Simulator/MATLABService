classdef Configuration < instrument.ivic.IviGroupBase
    %CONFIGURATION This class contains functions and
    %sub-classes that configure the DMM.  The class includes
    %high-level functions that configure the basic measurement
    %operation and subclasses that configure the trigger and the
    %multi-point measurement capability.  It also contains
    %sub-classes that configure additional parameters for some
    %measurement types and that return information about the
    %current state of the instrument. The class also contains
    %the low-level functions that set, get, and check individual
    %attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Configuration()
            %% Initialize properties
            obj.SpecificMeasurements = instrument.ivic.IviDmm.Configuration.SpecificMeasurements();
            obj.Trigger = instrument.ivic.IviDmm.Configuration.Trigger();
            obj.MultiPoint = instrument.ivic.IviDmm.Configuration.MultiPoint();
            obj.MeasurementOperationOptions = instrument.ivic.IviDmm.Configuration.MeasurementOperationOptions();
            obj.ConfigurationInformation = instrument.ivic.IviDmm.Configuration.ConfigurationInformation();
            obj.SetGetCheckAttribute = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.ConfigurationInformation = [];
            obj.MeasurementOperationOptions = [];
            obj.MultiPoint = [];
            obj.Trigger = [];
            obj.SpecificMeasurements = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.ConfigurationInformation.setLibraryAndSession(libName, session);
            obj.MeasurementOperationOptions.setLibraryAndSession(libName, session);
            obj.MultiPoint.setLibraryAndSession(libName, session);
            obj.Trigger.setLibraryAndSession(libName, session);
            obj.SpecificMeasurements.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %SPECIFICMEASUREMENTS This class contains functions and
        %sub-classes that configure additional parameters for some
        %measurement types. These are the AC Voltage, AC Current,
        %frequency, and temperature measurements. Read Only.
        SpecificMeasurements
        
        %TRIGGER This class contains functions that configure the
        %triggering capabilities of the DMM. These include the
        %trigger source, trigger delay, and trigger slope. Read Only.
        Trigger
        
        %MULTIPOINT This class contains functions that configure
        %the multi-point capabilities of the DMM. Read Only.
        MultiPoint
        
        %MEASUREMENTOPERATIONOPTIONS This class contains functions
        %that configure the instrument for different measurement
        %operations. These operations are the auto zero mode and
        %powerline frequency.  Read Only.
        MeasurementOperationOptions
        
        %CONFIGURATIONINFORMATION This class contains functions
        %that return information about the current state of the
        %instrument. This information includes the actual range,
        %aperture time, and the aperture time units.  Read Only.
        ConfigurationInformation
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% SpecificMeasurements property access methods
        function value = get.SpecificMeasurements(obj)
            if isempty(obj.SpecificMeasurements)
                obj.SpecificMeasurements = instrument.ivic.IviDmm.Configuration.SpecificMeasurements();
            end
            value = obj.SpecificMeasurements;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviDmm.Configuration.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% MultiPoint property access methods
        function value = get.MultiPoint(obj)
            if isempty(obj.MultiPoint)
                obj.MultiPoint = instrument.ivic.IviDmm.Configuration.MultiPoint();
            end
            value = obj.MultiPoint;
        end
        
        %% MeasurementOperationOptions property access methods
        function value = get.MeasurementOperationOptions(obj)
            if isempty(obj.MeasurementOperationOptions)
                obj.MeasurementOperationOptions = instrument.ivic.IviDmm.Configuration.MeasurementOperationOptions();
            end
            value = obj.MeasurementOperationOptions;
        end
        
        %% ConfigurationInformation property access methods
        function value = get.ConfigurationInformation(obj)
            if isempty(obj.ConfigurationInformation)
                obj.ConfigurationInformation = instrument.ivic.IviDmm.Configuration.ConfigurationInformation();
            end
            value = obj.ConfigurationInformation;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureMeasurement(obj,MeasurementFunction,Range,Resolutionabsolute)
            %CONFIGUREMEASUREMENT This function configures the common
            %attributes of the DMM.  These attributes include the
            %measurement function, maximum range, and the absolute
            %resolution.
            
            narginchk(4,4)
            MeasurementFunction = obj.checkScalarInt32Arg(MeasurementFunction);
            Range = obj.checkScalarDoubleArg(Range);
            Resolutionabsolute = obj.checkScalarDoubleArg(Resolutionabsolute);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureMeasurement', session, MeasurementFunction, Range, Resolutionabsolute);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
