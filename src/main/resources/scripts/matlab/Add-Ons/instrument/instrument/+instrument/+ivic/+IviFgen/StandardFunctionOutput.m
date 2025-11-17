classdef StandardFunctionOutput < instrument.ivic.IviGroupBase
    %STANDARDFUNCTIONOUTPUT Attributes for generating standard
    %function waveform output.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %WAVEFORM_STD This channel-based attribute specifies which
        %standard waveform the function generator produces.     You
        %use this attribute only when the IVIFGEN_ATTR_OUTPUT_MODE
        %attribute is set to IVIFGEN_VAL_OUTPUT_FUNC.  Note: (1)
        %This attribute is part of the IviFgenStdFunc STD extension
        %group.
        Waveform_STD
        
        %AMPLITUDE_STD This channel-based attribute specifies the
        %amplitude of the standard waveform the function generator
        %produces.  This value is the amplitude at the output
        %terminal.  The units are volts peak-to-peak (Vpp).  For
        %example, to produce a waveform ranging from -5.0 to +5.0
        %volts, you set this value to 10.0 volts.     You use this
        %attribute only when the IVIFGEN_ATTR_OUTPUT_MODE attribute
        %is set to IVIFGEN_VAL_OUTPUT_FUNC.  This attribute does not
        %affect function generator behavior when you set the
        %IVIFGEN_ATTR_FUNC_WAVEFORM attribute to IVIFGEN_VAL_WFM_DC.
        % Note: (1) This attribute is part of the IviFgenStdFunc STD
        %extension group.
        Amplitude_STD
        
        %DC_OFFSET_STD This channel-based attribute specifies the
        %DC offset of the standard waveform the function generator
        %produces.  This value is the offset at the output terminal.
        % The units are volts (V).  The value is the offset from
        %ground to the center of the waveform you specify with the
        %IVIFGEN_ATTR_FUNC_WAVEFORM attribute.  For example, a
        %standard waveform ranging from +5.0 volts to 0.0 volts has
        %a DC offset of 2.5 volts.     You use this attribute only
        %when the IVIFGEN_ATTR_OUTPUT_MODE attribute is set to
        %IVIFGEN_VAL_OUTPUT_FUNC.  Note: (1) This attribute is part
        %of the IviFgenStdFunc STD extension group.
        DC_Offset_STD
        
        %FREQUENCY_STD This channel-based attribute specifies the
        %frequency of the standard waveform the function generator
        %produces.  The units are hertz (Hz).  You use this
        %attribute only when the IVIFGEN_ATTR_OUTPUT_MODE attribute
        %is set to IVIFGEN_VAL_OUTPUT_FUNC.     This attribute does
        %not affect function generator behavior when you set the
        %IVIFGEN_ATTR_FUNC_WAVEFORM attribute to IVIFGEN_VAL_WFM_DC.
        % Note: (1) This attribute is part of the IviFgenStdFunc STD
        %extension group.
        Frequency_STD
        
        %START_PHASE_STD This channel-based attribute specifies the
        %horizontal offset of the standard waveform the function
        %generator produces.  You specify this attribute in degrees
        %of one waveform cycle.  For example, a 180 degree phase
        %offset means output generation begins half way through the
        %waveform.  A start phase of 360 degrees offsets the output
        %by an entire waveform cycle.  It is therefore identical to
        %a start phase of 0 degrees.     You use this attribute only
        %when the IVIFGEN_ATTR_OUTPUT_MODE attribute is set to
        %IVIFGEN_VAL_OUTPUT_FUNC.  This attribute does not affect
        %function generator behavior when you set the
        %IVIFGEN_ATTR_FUNC_WAVEFORM attribute to IVIFGEN_VAL_WFM_DC.
        % Note: (1) This attribute is part of the IviFgenStdFunc STD
        %extension group.
        Start_Phase_STD
        
        %DUTY_CYCLE_HIGH_STD This channel-based attribute specifies
        %the length of time the output voltage level remains high in
        %a square waveform.  You specify this attribute as a
        %percentage of one waveform cycle.     You use this
        %attribute only when the IVIFGEN_ATTR_OUTPUT_MODE attribute
        %is set to IVIFGEN_VAL_OUTPUT_FUNC and the
        %IVIFGEN_ATTR_FUNC_WAVEFORM attribute to
        %IVIFGEN_VAL_WFM_SQUARE.  Note: (1) This attribute is part
        %of the IviFgenStdFunc STD extension group.
        Duty_Cycle_High_STD
    end
    
    %% Property access methods
    methods
        %% Waveform_STD property access methods
        function value = get.Waveform_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250101);
        end
        function set.Waveform_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.StandardFunctionOutput.*;
            attrFuncWaveformRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250101, newValue);
        end
        
        %% Amplitude_STD property access methods
        function value = get.Amplitude_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250102);
        end
        function set.Amplitude_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250102, newValue);
        end
        
        %% DC_Offset_STD property access methods
        function value = get.DC_Offset_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250103);
        end
        function set.DC_Offset_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250103, newValue);
        end
        
        %% Frequency_STD property access methods
        function value = get.Frequency_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250104);
        end
        function set.Frequency_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250104, newValue);
        end
        
        %% Start_Phase_STD property access methods
        function value = get.Start_Phase_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250105);
        end
        function set.Start_Phase_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250105, newValue);
        end
        
        %% Duty_Cycle_High_STD property access methods
        function value = get.Duty_Cycle_High_STD(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250106);
        end
        function set.Duty_Cycle_High_STD(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250106, newValue);
        end
    end
end
