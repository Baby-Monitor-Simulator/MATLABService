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
        %Use the IviScope_InitWithOptions function to override this
        %value.
        Range_Check
        
        %QUERY_INSTRUMENT_STATUS Specifies whether the instrument
        %driver queries the instrument status after each operation.
        %Querying the instrument status is very useful for
        %debugging.  After you validate your program, you can set
        %this  attribute to VI_FALSE to disable status checking and
        %maximize performance.     The instrument driver can choose
        %to ignore status checking for particular attributes
        %regardless of the setting of this attribute.     The
        %default value is FALSE.   Use the IviScope_InitWithOptions
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
        %IviScope_InitWithOptions function to override this value.
        Cache
        
        %RECORD_VALUE_COERCIONS Specifies whether the instrument
        %driver keeps a list of the value coercions it makes for
        %ViInt32 and ViReal64 attributes.  If IVISCOPE_ATTR_SPY is
        %set to VI_TRUE, you use the NI-Spy utility to view coercion
        %information.  If IVISCOPE_ATTR_SPY is set to VI_FALSE you
        %call IviScope_GetNextCoercionRecord to extract and delete
        %the oldest coercion record from the list.     The default
        %value is VI_FALSE.   Use the IVI Configuration utility or
        %the IviScope_InitWithOptions function to override this
        %value.
        Record_Value_Coercions
        
        %SIMULATE Specifies whether or not to simulate instrument
        %driver IO operations.  If simulation is enabled, instrument
        %driver functions perform range checking and set and get
        %attributes, but they do not perform instrument IO.  For
        %output parameters that represent instrument data, the
        %instrument driver functions return calculated values.
        %The default value is VI_FALSE.   Use the
        %IviScope_InitWithOptions function to override this value.
        Simulate
        
        %USE_SPECIFIC_SIMULATION Specifies whether to simulate
        %instrument driver IO operations in the specific or class
        %driver.  This attribute affects instrument driver operation
        %only when the IVISCOPE_ATTR_SIMULATE attribute is set to
        %VI_TRUE.     The default value is VI_FALSE.
        Use_Specific_Simulation
        
        %INTERCHANGE_CHECK Specifies whether to record
        %interchangeability warnings when you call one of the
        %following functions:      IviScope_InitiateAcquisition
        %IviScope_ReadWaveform     IviScope_ReadMinMaxWaveform
        %IviScope_ReadWaveformMeasurement
        %IviScope_FetchWaveformMeasurement      The default value is
        %VI_FALSE.  Interchangeability warnings indicate that using
        %your application with a different instrument might cause
        %different behavior.  If IVISCOPE_ATTR_SPY is set to
        %VI_FALSE, you call IviScope_GetNextInterchangeWarning to
        %extract interchange warnings.  Call the
        %IviScope_ClearInterchangeWarnings function to clear the
        %list of interchangeability warnings without reading them.
        %If the IVISCOPE_ATTR_SPY attribute is set to VI_TRUE, you
        %use the NI-Spy utility to view interchangeability warnings.
        %Interchangeability checking examines the attributes in a
        %capability group only if you specify a value for at least
        %one attribute within that group.  Interchangeability
        %warnings can occur under the following conditions:  (1) An
        %attribute affects the behavior of the instrument and you
        %have not set that attribute.  (2) The IviScope class
        %defines values for an attribute and you have set that
        %attribute to a value not defined by the IviScope class.
        %(3) The IviScope class defines an attribute as read-only
        %and you have set that attribute.  The IviScope class
        %provides the following exceptions to these
        %interchangeability checking rules.  The exceptions are
        %listed under the capability group to which they refer:  (1)
        %IviScopeBase Capabilities:   - The following attributes are
        %required to be in a user-specified state on a channel only
        %if the IVISCOPE_ATTR_CHANNEL_ENABLED attribute is set to
        %VI_TRUE for that channel:      IVISCOPE_ATTR_VERTICAL_RANGE
        %    IVISCOPE_ATTR_VERTICAL_OFFSET
        %IVISCOPE_ATTR_VERTICAL_COUPLING
        %IVISCOPE_ATTR_PROBE_ATTENUATION
        %IVISCOPE_ATTR_MAX_INPUT_FREQUENCY
        %IVISCOPE_ATTR_INPUT_IMPEDANCE   - The
        %IVISCOPE_ATTR_TRIGGER_LEVEL attribute is required to be in
        %a user-specified state only if the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_EDGE_TRIGGER, IVISCOPE_VAL_GLITCH_TRIGGER or
        %IVISCOPE_VAL_WIDTH_TRIGGER.   - The
        %IVISCOPE_ATTR_TRIGGER_COUPLING and
        %IVISCOPE_ATTR_TRIGGER_SLOPE attributes are required to be
        %in a user-specified state only if the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_EDGE.  (2) IviScopeTVTrigger Capabilities:   -
        %Interchangeability checking is performed on this extension
        %group only when the IVISCOPE_ATTR_TRIGGER_TYPE attribute is
        %set to IVISCOPE_VAL_TV_TRIGGER.   - The
        %IVISCOPE_ATTR_TV_TRIGGER_LINE_NUMBER attribute must be in a
        %user-specified state only if the
        %IVISCOPE_ATTR_TV_TRIGGER_EVENT attribute is set to
        %IVISCOPE_VAL_LINE_NUMBER.  (3) IviScopeRuntTrigger
        %Capabilities:   - Interchangeability checking is performed
        %on this extension group only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_RUNT_TRIGGER.  (4) IviScopeGlitchTrigger
        %Capabilities:  - Interchangeability checking is performed
        %on this extension group only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_GLITCH_TRIGGER.  (5) IviScopeWidthTrigger
        %Capabilities:   - Interchangeability checking is performed
        %on this extension group only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_WIDTH_TRIGGER.  (6) IviScopeAcLineTrigger
        %Capabilities:   - Interchangeability checking is performed
        %on this extension group only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_AC_LINE_TRIGGER.  (7) IviScopeWaveformMeas
        %Capabilities:   - Interchangeability checking is performed
        %on this extension group only when the
        %IviScope_ReadWaveformMeasurement function is called.   -
        %The IVISCOPE_ATTR_MEAS_LOW_REF, IVISCOPE_ATTR_MEAS_MID_REF,
        %and IVISCOPE_ATTR_MEAS_HIGH_REF attributes are required to
        %be in a user-specified state only if you request a waveform
        %measurement that requires reference levels.  (8)
        %IviScopeMinMaxWaveform Capabilities:   - Interchangeability
        %checking is performed on this extension group only when the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute is set to
        %IVISCOPE_VAL_ENVELOPE or IVISCOPE_VAL_PEAK_DETECT.   - The
        %IVISCOPE_ATTR_NUM_ENVELOPES attribute is required to be in
        %a user-specified state only when the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute is set to
        %IVISCOPE_VAL_ENVELOPE.  (9) IviScopeAverageAcquisition
        %Capabilities:   - Interchangeability checking is performed
        %on this extension group only when the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute is set to
        %IVISCOPE_VAL_AVERAGE.
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
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050002);
        end
        function set.Range_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050002, newValue);
        end
        
        %% Query_Instrument_Status property access methods
        function value = get.Query_Instrument_Status(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050003);
        end
        function set.Query_Instrument_Status(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050003, newValue);
        end
        
        %% Cache property access methods
        function value = get.Cache(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050004);
        end
        function set.Cache(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050004, newValue);
        end
        
        %% Record_Value_Coercions property access methods
        function value = get.Record_Value_Coercions(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050006);
        end
        function set.Record_Value_Coercions(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050006, newValue);
        end
        
        %% Simulate property access methods
        function value = get.Simulate(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050005);
        end
        function set.Simulate(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050005, newValue);
        end
        
        %% Use_Specific_Simulation property access methods
        function value = get.Use_Specific_Simulation(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050023);
        end
        function set.Use_Specific_Simulation(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050023, newValue);
        end
        
        %% Interchange_Check property access methods
        function value = get.Interchange_Check(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050021);
        end
        function set.Interchange_Check(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050021, newValue);
        end
        
        %% Spy property access methods
        function value = get.Spy(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1050022);
        end
        function set.Spy(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.InherentIVIAttributes.UserOptions.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1050022, newValue);
        end
    end
end
