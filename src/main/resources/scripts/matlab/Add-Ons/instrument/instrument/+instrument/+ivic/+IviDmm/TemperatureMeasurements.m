classdef TemperatureMeasurements < instrument.ivic.IviGroupBase
    %TEMPERATUREMEASUREMENTS Attribues that configure
    %additional parameters for temperature
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = TemperatureMeasurements()
            %% Initialize properties
            obj.Thermocouple = instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple();
            obj.ResistanceTemperatureDevice = instrument.ivic.IviDmm.TemperatureMeasurements.ResistanceTemperatureDevice();
            obj.Thermistor = instrument.ivic.IviDmm.TemperatureMeasurements.Thermistor();
        end
        
        function delete(obj)
            obj.Thermistor = [];
            obj.ResistanceTemperatureDevice = [];
            obj.Thermocouple = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Thermistor.setLibraryAndSession(libName, session);
            obj.ResistanceTemperatureDevice.setLibraryAndSession(libName, session);
            obj.Thermocouple.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %TRANSDUCER_TYPE_TMP Specifies the device used to measure
        %the temperature.  The value of this attribute affects
        %instrument behavior only when the IVIDMM_ATTR_FUNCTION
        %attribute is set to IVIDMM_VAL_TEMPERATURE.  Note: (1) This
        %attribute is part of the IviDmmTemperatureMeasurement TMP
        %extension group.
        Transducer_Type_TMP
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %THERMOCOUPLE Attributes for configuring the thermocoulple
        %transducer type.\n Read Only.
        Thermocouple
        
        %RESISTANCETEMPERATUREDEVICE Attributes that configure the
        %RTD transducer type.\n Read Only.
        ResistanceTemperatureDevice
        
        %THERMISTOR Attributes that configure the thermistor
        %transducer type.\n Read Only.
        Thermistor
    end
    
    %% Property access methods
    methods
        %% Transducer_Type_TMP property access methods
        function value = get.Transducer_Type_TMP(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250201);
        end
        function set.Transducer_Type_TMP(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.TemperatureMeasurements.*;
            attrTempTransducerTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250201, newValue);
        end
        %% Thermocouple property access methods
        function value = get.Thermocouple(obj)
            if isempty(obj.Thermocouple)
                obj.Thermocouple = instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple();
            end
            value = obj.Thermocouple;
        end
        
        %% ResistanceTemperatureDevice property access methods
        function value = get.ResistanceTemperatureDevice(obj)
            if isempty(obj.ResistanceTemperatureDevice)
                obj.ResistanceTemperatureDevice = instrument.ivic.IviDmm.TemperatureMeasurements.ResistanceTemperatureDevice();
            end
            value = obj.ResistanceTemperatureDevice;
        end
        
        %% Thermistor property access methods
        function value = get.Thermistor(obj)
            if isempty(obj.Thermistor)
                obj.Thermistor = instrument.ivic.IviDmm.TemperatureMeasurements.Thermistor();
            end
            value = obj.Thermistor;
        end
    end
end
