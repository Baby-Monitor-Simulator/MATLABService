classdef UserOptions < instrument.ivic.IviGroupBase
    %USEROPTIONS Attributes you can set to affect the operation
    %of this instrument driver.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %RANGE_CHECK Specifies whether to validate attribute values
        %and function parameters.  If enabled, the instrument driver
        %validates the parameter values that you pass to driver
        %functions.  Range checking parameters is very useful for
        %debugging.  After you validate your program, you can set
        %this attribute to VI_FALSE to disable range checking and
        %maximize performance.     The default value is VI_TRUE.
        %Use the IviDmm_InitWithOptions function to override this
        %value.
        Range_Check
        
        %QUERY_INSTRUMENT_STATUS Specifies whether the instrument
        %driver queries the instrument status after each operation.
        %Querying the instrument status is very useful for
        %debugging.  After you validate your program, you can set
        %this attribute to VI_FALSE to disable status checking and
        %maximize performance     The instrument driver can choose
        %to ignore status checking for particular attributes
        %regardless of the setting of this attribute.     The
        %default value is VI_FALSE.   Use the IviDmm_InitWithOptions
        %function to override this value.
        Query_Instrument_Status
        
        %CACHE Specifies whether to cache the value of attributes.
        %When caching is enabled, the instrument driver keeps track
        %of the current instrument settings and avoids sending
        %redundant commands to the instrument.  Thus, you can
        %significantly increase execution speed.     The instrument
        %driver can choose always to cache or never to cache
        %particular attributes regardless of the setting of this
        %attribute.     The default value is VI_TRUE.   Use the
        %IviDmm_InitWithOptions function to override this value.
        Cache
        
        %SIMULATE Specifies whether or not to simulate instrument
        %driver IO operations.  If simulation is enabled, instrument
        %driver functions perform range checking and set and get
        %attributes, but they do not perform instrument IO.  For
        %output parameters that represent instrument data, the
        %instrument driver functions return calculated values.
        %The default value is VI_FALSE.   Use the
        %IviDmm_InitWithOptions function to override this value.
        Simulate
        
        %USE_SPECIFIC_SIMULATION Specifies whether to simulate
        %instrument driver IO operations in the specific or class
        %driver.  This attribute affects instrument driver operation
        %only when the IVIDMM_ATTR_SIMULATE attribute is set to
        %VI_TRUE.     The default value is VI_FALSE.
        Use_Specific_Simulation
        
        %RECORD_VALUE_COERCIONS Specifies whether the instrument
        %driver keeps a list of the value coercions it makes for
        %ViInt32 and ViReal64 attributes.  If IVIDMM_ATTR_SPY is set
        %to VI_TRUE, you use the NI-Spy utility to view coercion
        %information.  If IVIDMM_ATTR_SPY is set to VI_FALSE you
        %call IviDmm_GetNextCoercionRecord to extract and delete the
        %oldest coercion record from the list.     The default value
        %is VI_FALSE.   Use the IVI Configuration utility or the
        %IviDmm_InitWithOptions function to override this value.
        Record_Value_Coercions
        
        %INTERCHANGE_CHECK Specifies whether to perform
        %interchangeability checking and retrieve interchangeability
        %warnings when you call the IviDmm_Initiate, IviDmm_Read,
        %and IviDmm_ReadMultiPoint functions.  The default value is
        %VI_FALSE.  Interchangeability warnings indicate that using
        %your application with a different instrument might cause
        %different behavior.  If IVIDMM_ATTR_SPY is set to VI_FALSE,
        %you call IviDmm_GetNextInterchangeWarning to extract
        %interchange warnings.  Call the
        %IviDmm_ClearInterchangeWarnings function to clear the list
        %of interchangeability warnings without reading them. If
        %IVIDMM_ATTR_SPY is set to VI_TRUE, you can use the NI Spy
        %utility to view interchange warnings.
        %Interchangeability checking examines the attributes in a
        %capability group only if you specify a value for at least
        %one attribute within that group.  Interchangeability
        %warnings can occur under the following conditions:  (1) An
        %attribute affects the behavior of the instrument and you
        %have not set that attribute.  (2) The IviDmm class defines
        %values for an attribute and you have set that attribute to
        %a value not defined by the IviDmm class.  (3) The IviDmm
        %class defines an attribute as read-only and you have set
        %that attribute.       The IviDmm class provides the
        %following additional rules and exceptions to these
        %interchangeability checking rules.  They are listed under
        %the capability group to which they refer:  (1) IviDmmBase
        %Capabilities:   - If the IVIDMM_ATTR_FUNCTION attribute is
        %set to IVIDMM_VAL_TEMPERATURE, the
        %IVIDMM_ATTR_RESOLUTION_ABSOLUTE attribute is not required
        %to be in a user specified state.  (2) IviDmmACMeasurement
        %Capabilities:   - If the IVIDMM_ATTR_FUNCTION attribute is
        %not set to IVIDMM_VAL_AC_VOLTS, IVIDMM_VAL_AC_CURRENT,
        %IVIDMM_VAL_AC_PLUS_DC_VOLTS, or
        %IVIDMM_VAL_AC_PLUS_DC_CURRENT, then the
        %IVIDMM_ATTR_AC_MIN_FREQ and IVIDMM_ATTR_AC_MAX_FREQ
        %attributes are not required to be in a user specified
        %state.  (3) IviDmmTemperatureMeasurement Capabilities:   -
        %If the IVIDMM_ATTR_FUNCTION attribute is not set to
        %IVIDMM_VAL_TEMPERATURE, the
        %IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is not required
        %to be in a user specified state.  (4) IviDmmThermocouple
        %Capabilities:   - If the IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE
        %attribute is not set to IVIDMM_VAL_THERMOCOUPLE, then the
        %IVIDMM_ATTR_TEMP_TC_TYPE,
        %IVIDMM_ATTR_TEMP_TC_REF_JUNC_TYPE, and
        %IVIDMM_ATTR_TEMP_TC_FIXED_REF_JUNC attributes are not
        %required to be in a user specified state.  (5)
        %IviDmmResistanceTemperatureDevice Capabilities:   - If the
        %IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is not set to
        %IVIDMM_VAL_2_WIRE_RTD or IVIDMM_VAL_4_WIRE_RTD, then the
        %IVIDMM_ATTR_TEMP_RTD_ALPHA and IVIDMM_ATTR_TEMP_RTD_RES
        %attributes are not required to be in a user specified
        %state.  (6) IviDmmThermistor Capabilities:   - If the
        %IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is not set to
        %IVIDMM_VAL_THERMISTOR, the IVIDMM_ATTR_TEMP_THERMISTOR_RES
        %attribute is not required to be in a user specified state.
        %(7) IviDmmMultiPoint Capabilities:   - If the
        %IVIDMM_ATTR_SAMPLE_COUNT attribute is set to 1, then the
        %IVIDMM_ATTR_SAMPLE_TRIGGER attribute is not required to be
        %in a user specified state.   - If the
        %IVIDMM_ATTR_SAMPLE_COUNT attribute is set 1 and the
        %IVIDMM_ATTR_SAMPLE_TRIGGER attribute is set to a value
        %other than IVIDMM_VAL_INTERVAL, then the
        %IVIDMM_ATTR_SAMPLE_INTERVAL attribute is not required to be
        %in a user specified state.
        Interchange_Check
        
        %SPY Specifies whether to log class function calls to the
        %NI Spy utility.  If spying is enabled, you can use NI Spy
        %to view the input and output parameters, return values,
        %coercion records, and interchangeability warnings of class
        %function calls.     The default value is TRUE.
        Spy
    end
    
    %% Property access methods
    methods
        %% Range_Check property access methods
        function value = get.Range_Check(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050002);
        end
        function set.Range_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050002, newValue);
        end
        
        %% Query_Instrument_Status property access methods
        function value = get.Query_Instrument_Status(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050003);
        end
        function set.Query_Instrument_Status(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050003, newValue);
        end
        
        %% Cache property access methods
        function value = get.Cache(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050004);
        end
        function set.Cache(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050004, newValue);
        end
        
        %% Simulate property access methods
        function value = get.Simulate(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050005);
        end
        function set.Simulate(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050005, newValue);
        end
        
        %% Use_Specific_Simulation property access methods
        function value = get.Use_Specific_Simulation(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050023);
        end
        function set.Use_Specific_Simulation(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050023, newValue);
        end
        
        %% Record_Value_Coercions property access methods
        function value = get.Record_Value_Coercions(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050006);
        end
        function set.Record_Value_Coercions(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050006, newValue);
        end
        
        %% Interchange_Check property access methods
        function value = get.Interchange_Check(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050021);
        end
        function set.Interchange_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050021, newValue);
        end
        
        %% Spy property access methods
        function value = get.Spy(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050022);
        end
        function set.Spy(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050022, newValue);
        end
    end
end
