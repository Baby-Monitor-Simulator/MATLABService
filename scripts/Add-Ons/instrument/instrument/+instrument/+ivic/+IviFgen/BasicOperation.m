classdef BasicOperation < instrument.ivic.IviGroupBase
    %BASICOPERATION Attributes that control the basic features
    %of the function generator.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %OUTPUT_MODE Determines the kind of waveform the function
        %generator produces.  The value you specify determines which
        %functions and attributes you use to configure the waveform
        %the function generator produces.     When you set this
        %attribute to IVIFGEN_VAL_OUTPUT_FUNC, you use the following
        %attributes and functions to configure standard waveforms:
        %IVIFGEN_ATTR_FUNC_WAVEFORM IVIFGEN_ATTR_FUNC_AMPLITUDE
        %IVIFGEN_ATTR_FUNC_DC_OFFSET IVIFGEN_ATTR_FUNC_FREQUENCY
        %IVIFGEN_ATTR_FUNC_START_PHASE
        %IVIFGEN_ATTR_FUNC_DUTY_CYCLE_HIGH
        %IviFgen_ConfigureStandardWaveform      When you set this
        %attribute to IVIFGEN_VAL_OUTPUT_ARB, you use the following
        %attributes and functions to configure arbitrary waveforms:
        %IVIFGEN_ATTR_ARB_WAVEFORM_HANDLE IVIFGEN_ATTR_ARB_GAIN
        %IVIFGEN_ATTR_ARB_OFFSET IVIFGEN_ATTR_ARB_SAMPLE_RATE
        %IviFgen_CreateArbWaveform IviFgen_ClearArbWaveform
        %IviFgen_ConfigureArbWaveform IviFgen_ConfigureSampleRate
        % If your instrument allows you to specify the rate at which
        %an entire arbitrary waveform is generated, you can also use
        %the following attributes and functions to configure
        %arbitrary waveforms:  IVIFGEN_ATTR_ARB_FREQUENCY
        %IviFgen_ConfigureArbFrequency      When you set this
        %attribute to IVIFGEN_VAL_OUTPUT_SEQ, you use the following
        %attributes and functions to configure sequences:
        %IVIFGEN_ATTR_ARB_SEQUENCE_HANDLE IVIFGEN_ATTR_ARB_GAIN
        %IVIFGEN_ATTR_ARB_OFFSET IVIFGEN_ATTR_ARB_SAMPLE_RATE
        %IviFgen_CreateArbSequence IviFgen_ClearArbSequence
        %IviFgen_ClearArbMemory IviFgen_ConfigureArbSequence
        Output_Mode
        
        %OPERATION_MODE This attribute specifies how the function
        %generator produces waveforms. For example, you can
        %configure the instrument to generate output continuously,
        %or to generate a discrete number of waveform cycles based
        %on a trigger event.
        Operation_Mode
        
        %REFERENCE_CLOCK_SOURCE Specifies the reference clock
        %source.  The function generator derives frequencies and
        %sample rates that it uses to generate waveforms from the
        %source you specify.
        Reference_Clock_Source
        
        %OUTPUT_ENABLED This channel-based attribute specifies
        %whether the signal the function generator produces appears
        %at the output connector.
        Output_Enabled
        
        %OUTPUT_IMPEDANCE This channel-based attribute specifies
        %the function generator's output impedance at the output
        %connector.
        Output_Impedance
    end
    
    %% Property access methods
    methods
        %% Output_Mode property access methods
        function value = get.Output_Mode(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250001);
        end
        function set.Output_Mode(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.BasicOperation.*;
            attrOutputModeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250001, newValue);
        end
        
        %% Operation_Mode property access methods
        function value = get.Operation_Mode(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250005);
        end
        function set.Operation_Mode(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.BasicOperation.*;
            attrOperationModeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Reference_Clock_Source property access methods
        function value = get.Reference_Clock_Source(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250002);
        end
        function set.Reference_Clock_Source(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.BasicOperation.*;
            attrRefClockSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% Output_Enabled property access methods
        function value = get.Output_Enabled(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250003);
        end
        function set.Output_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250003, newValue);
        end
        
        %% Output_Impedance property access methods
        function value = get.Output_Impedance(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250004);
        end
        function set.Output_Impedance(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250004, newValue);
        end
    end
end
