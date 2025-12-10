classdef SpecificMeasurements < instrument.ivic.IviGroupBase
    %SPECIFICMEASUREMENTS This class contains functions and
    %sub-classes that configure additional parameters for some
    %measurement types. These are the AC Voltage, AC Current,
    %frequency, and temperature measurements.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = SpecificMeasurements()
            %% Initialize properties
            obj.Temperature = instrument.ivic.IviDmm.Configuration.SpecificMeasurements.Temperature();
        end
        
        function delete(obj)
            obj.Temperature = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Temperature.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %TEMPERATURE This class contains functions that configure
        %additional parameters for temperature measurements. These
        %parameters include the transducer type and settings
        %specific to each transducer type. Read Only.
        Temperature
    end
    
    %% Property access methods
    methods
        %% Temperature property access methods
        function value = get.Temperature(obj)
            if isempty(obj.Temperature)
                obj.Temperature = instrument.ivic.IviDmm.Configuration.SpecificMeasurements.Temperature();
            end
            value = obj.Temperature;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureACBandwidth(obj,ACMinimumFrequencyHz,ACMaximumFrequencyHz)
            %CONFIGUREACBANDWIDTH This function configures the AC
            %minimum and maximum frequency for DMMs that take AC voltage
            %or AC current measurements.  This function affects the
            %behavior of the instrument only if the IVIDMM_ATTR_FUNCTION
            %attribute is set to an AC voltage or AC current
            %measurement.  Note:  (1) This function is part of the
            %IviDmmACMeasurement [AC] extension group.
            
            narginchk(3,3)
            ACMinimumFrequencyHz = obj.checkScalarDoubleArg(ACMinimumFrequencyHz);
            ACMaximumFrequencyHz = obj.checkScalarDoubleArg(ACMaximumFrequencyHz);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureACBandwidth', session, ACMinimumFrequencyHz, ACMaximumFrequencyHz);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencyVoltageRange(obj,FrequencyVoltageRangeVrms)
            %CONFIGUREFREQUENCYVOLTAGERANGE This function configures
            %the frequency voltage range of the DMM for frequency and
            %period measurements.  This function affects the behavior of
            %the instrument only if the IVIDMM_ATTR_FUNCTION attribute
            %is set to IVIDMM_VAL_FREQ or IVIDMM_VAL_PERIOD.   Note:
            %(1) This function is part of the IviDmmFrequencyMeasurement
            %[FRQ] extension group.
            
            narginchk(2,2)
            FrequencyVoltageRangeVrms = obj.checkScalarDoubleArg(FrequencyVoltageRangeVrms);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_ConfigureFrequencyVoltageRange', session, FrequencyVoltageRangeVrms);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
