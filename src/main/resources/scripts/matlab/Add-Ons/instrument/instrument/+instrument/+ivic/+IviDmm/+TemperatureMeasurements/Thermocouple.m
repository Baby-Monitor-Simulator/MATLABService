classdef Thermocouple < instrument.ivic.IviGroupBase
    %THERMOCOUPLE Attributes for configuring the thermocoulple
    %transducer type.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %THERMOCOUPLE_TYPE_TC Specifies the type of thermocouple
        %used to measure the temperature.  The value of this
        %attribute affects instrument behavior only when the
        %IVIDMM_VAL_TEMP_TRANSDUCER_TYPE is set to
        %IVIDMM_VAL_THERMOCOUPLE.  Note: (1) This attribute is part
        %of the IviDmmThermocouple TC extension group.
        Thermocouple_Type_TC
        
        %REFERENCE_JUNCTION_TYPE_TC Specifies the type of reference
        %junction to be used in the reference junction compensation
        %of a thermocouple measurement.  The value of this attribute
        %affects instrument behavior only when the
        %IVIDMM_VAL_TEMP_TRANSDUCER_TYPE attribute is set to
        %IVIDMM_VAL_THERMOCOUPLE.  Note: (1) This attribute is part
        %of the IviDmmThermocouple TC extension group.
        Reference_Junction_Type_TC
        
        %FIXED_REFERENCE_JUNCTION_TC Specifies the external
        %reference junction temperature when a fixed reference
        %junction type thermocouple is used to take the temperature
        %measurement.  The temperature is specified in degrees
        %Celsius.  The value of this attribute affects instrument
        %behavior only when the IVIDMM_ATTR_TEMP_TC_REF_JUNC_TYPE
        %attribute is set to IVIDMM_VAL_TEMP_REF_JUNC_FIXED.  Note:
        %(1) This attribute is part of the IviDmmThermocouple TC
        %extension group.
        Fixed_Reference_Junction_TC
    end
    
    %% Property access methods
    methods
        %% Thermocouple_Type_TC property access methods
        function value = get.Thermocouple_Type_TC(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250231);
        end
        function set.Thermocouple_Type_TC(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple.*;
            attrTempTcTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250231, newValue);
        end
        
        %% Reference_Junction_Type_TC property access methods
        function value = get.Reference_Junction_Type_TC(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250232);
        end
        function set.Reference_Junction_Type_TC(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple.*;
            attrTempTcRefJuncTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250232, newValue);
        end
        
        %% Fixed_Reference_Junction_TC property access methods
        function value = get.Fixed_Reference_Junction_TC(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250233);
        end
        function set.Fixed_Reference_Junction_TC(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250233, newValue);
        end
    end
end
