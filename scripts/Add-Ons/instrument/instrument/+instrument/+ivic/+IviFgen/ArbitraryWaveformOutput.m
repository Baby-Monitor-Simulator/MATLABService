classdef ArbitraryWaveformOutput < instrument.ivic.IviGroupBase
    %ARBITRARYWAVEFORMOUTPUT Attributes for generating
    %arbitrary waveform output.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ARBITRARY_WAVEFORM_HANDLE_ARB This channel-based attribute
        %identifies which arbitrary waveform the function generator
        %produces.  You can create multiple arbitrary waveforms
        %using the IviFgen_CreateArbWaveform function.  The
        %IviFgen_CreateArbWaveform function returns a handle that
        %you use to identify the particular waveform.  To configure
        %the function generator to produce a particular waveform,
        %you set this attribute to the waveform's handle.     You
        %use this attribute only when the IVIFGEN_ATTR_OUTPUT_MODE
        %attribute is set to IVIFGEN_VAL_OUTPUT_ARB.  Note: (1) This
        %attribute is part of the IviFgenArbWfm ARB extension group.
        Arbitrary_Waveform_Handle_ARB
        
        %ARBITRARY_WAVEFORM_GAIN_ARB This channel-based attribute
        %specifies the factor by which the function generator scales
        %the arbitrary waveform data.  When you create arbitrary
        %waveforms, you must first normalize the data points to the
        %range -1.0 to +1.0.  You use this attribute to scale the
        %arbitrary waveform to other ranges.  For example, when you
        %set this attribute to 2.0, the output signal ranges from
        %-2.0 to +2.0 volts.     You use this attribute when the
        %IVIFGEN_ATTR_OUTPUT_MODE attribute is set to
        %IVIFGEN_VAL_OUTPUT_ARB or IVIFGEN_VAL_OUTPUT_SEQ.  Note:
        %(1) This attribute is part of the IviFgenArbWfm ARB
        %extension group.
        Arbitrary_Waveform_Gain_ARB
        
        %ARBITRARY_WAVEFORM_OFFSET_ARB This channel-based attribute
        %specifies the value the function generator adds to the
        %arbitrary waveform data.  When you create arbitrary
        %waveforms, you must first normalize the data points to the
        %range -1.0 to +1.0.  You use this attribute to shift the
        %arbitrary waveform's range.The units are volts (V).  For
        %example, when you set this attribute to 1.0, the output
        %signal ranges from 2.0 volts to 0.0 volts.     You use this
        %attribute when the IVIFGEN_ATTR_OUTPUT_MODE attribute is
        %set to IVIFGEN_VAL_OUTPUT_ARB or IVIFGEN_VAL_OUTPUT_SEQ.
        %Note: (1) This attribute is part of the IviFgenArbWfm ARB
        %extension group.
        Arbitrary_Waveform_Offset_ARB
        
        %SAMPLE_RATE_ARB Specifies the rate at which the function
        %generator outputs the points in arbitrary waveforms.  The
        %units are samples per second.     You use this attribute
        %when the IVIFGEN_ATTR_OUTPUT_MODE attribute is set to
        %IVIFGEN_VAL_OUTPUT_ARB or IVIFGEN_VAL_OUTPUT_SEQ.  Note:
        %(1) This attribute is part of the IviFgenArbWfm ARB
        %extension group.
        Sample_Rate_ARB
        
        %ARB_FREQUENCY_AF Specifies the rate at which the function
        %generator outputs an entire arbitrary waveform.  The units
        %are arbitrary waveforms per second.     You use this
        %attribute when the IVIFGEN_ATTR_OUTPUT_MODE attribute is
        %set to IVIFGEN_VAL_OUTPUT_ARB.  Note: (1) This attribute is
        %part of the IviFgenArbFrequency AF extension group.
        Arb_Frequency_AF
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MAX_NUMBER_OF_WAVEFORMS_ARB Returns the maximum number of
        %arbitrary waveforms that the function generator allows.
        %Typically, this value is constant for the function
        %generator.  Note: (1) This attribute is part of the
        %IviFgenArbWfm ARB extension group. Read Only.
        Max_Number_of_Waveforms_ARB
        
        %WAVEFORM_QUANTUM_ARB The size of each arbitrary waveform
        %must be a multiple of a quantum value.  This attribute
        %returns the quantum value the function generator allows.
        %For example, when this attribute returns a value of 8, all
        %waveform sizes must be a multiple of 8.  Typically, this
        %value is constant for the function generator.  Note: (1)
        %This attribute is part of the IviFgenArbWfm ARB extension
        %group. Read Only.
        Waveform_Quantum_ARB
        
        %MIN_WAVEFORM_SIZE_ARB Returns the minimum number of points
        %the function generator allows in an arbitrary waveform.
        %Typically, this value is constant for the function
        %generator.  Note: (1) This attribute is part of the
        %IviFgenArbWfm ARB extension group. Read Only.
        Min_Waveform_Size_ARB
        
        %MAX_WAVEFORM_SIZE_ARB Returns the maximum number of points
        %the function generator allows in an arbitrary waveform.
        %Typically, this value is constant for the function
        %generator.  Note: (1) This attribute is part of the
        %IviFgenArbWfm ARB extension group. Read Only.
        Max_Waveform_Size_ARB
    end
    
    %% Property access methods
    methods
        %% Arbitrary_Waveform_Handle_ARB property access methods
        function value = get.Arbitrary_Waveform_Handle_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250201);
        end
        function set.Arbitrary_Waveform_Handle_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250201, newValue);
        end
        
        %% Arbitrary_Waveform_Gain_ARB property access methods
        function value = get.Arbitrary_Waveform_Gain_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250202);
        end
        function set.Arbitrary_Waveform_Gain_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250202, newValue);
        end
        
        %% Arbitrary_Waveform_Offset_ARB property access methods
        function value = get.Arbitrary_Waveform_Offset_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250203);
        end
        function set.Arbitrary_Waveform_Offset_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250203, newValue);
        end
        
        %% Sample_Rate_ARB property access methods
        function value = get.Sample_Rate_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250204);
        end
        function set.Sample_Rate_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250204, newValue);
        end
        
        %% Arb_Frequency_AF property access methods
        function value = get.Arb_Frequency_AF(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250209);
        end
        function set.Arb_Frequency_AF(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250209, newValue);
        end
        %% Max_Number_of_Waveforms_ARB property access methods
        function value = get.Max_Number_of_Waveforms_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250205);
        end
        
        %% Waveform_Quantum_ARB property access methods
        function value = get.Waveform_Quantum_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250206);
        end
        
        %% Min_Waveform_Size_ARB property access methods
        function value = get.Min_Waveform_Size_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250207);
        end
        
        %% Max_Waveform_Size_ARB property access methods
        function value = get.Max_Waveform_Size_ARB(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250208);
        end
    end
end
