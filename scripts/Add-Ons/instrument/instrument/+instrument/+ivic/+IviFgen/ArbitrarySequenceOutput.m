classdef ArbitrarySequenceOutput < instrument.ivic.IviGroupBase
    %ARBITRARYSEQUENCEOUTPUT Attributes for generating
    %arbitrary sequence output.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ARBITRARY_SEQUENCE_HANDLE_SEQ This channel-based attribute
        %identifies which sequence the function generator produces.
        %You can create multiple sequences using the
        %IviFgen_CreateArbSequence function.  The
        %IviFgen_CreateArbSequence function returns a handle that
        %you use to identify the particular sequence.  To configure
        %the function generator to produce a particular sequence,
        %you set this attribute to the sequence's handle.     You
        %use this attribute only when the IVIFGEN_ATTR_OUTPUT_MODE
        %attribute is set to IVIFGEN_VAL_OUTPUT_SEQ.  Note: (1) This
        %attribute is part of the IviFgenArbSeq SEQ extension group.
        Arbitrary_Sequence_Handle_SEQ
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MAX_NUMBER_OF_SEQUENCES_SEQ Returns the maximum number of
        %arbitrary sequences the function generator allows.
        %Typically, this value is constant for the function
        %generator.  Note: (1) This attribute is part of the
        %IviFgenArbSeq SEQ extension group. Read Only.
        Max_Number_of_Sequences_SEQ
        
        %MIN_SEQUENCE_LENGTH_SEQ Returns the minimum number of
        %arbitrary waveforms the function generator allows in a
        %sequence.  Typically, this value is constant for the
        %function generator.  Note: (1) This attribute is part of
        %the IviFgenArbSeq SEQ extension group. Read Only.
        Min_Sequence_Length_SEQ
        
        %MAX_SEQUENCE_LENGTH_SEQ Returns the maximum number of
        %arbitrary waveforms the function generator allows in a
        %sequence.  Typically, this value is constant for the
        %function generator.  Note: (1) This attribute is part of
        %the IviFgenArbSeq SEQ extension group. Read Only.
        Max_Sequence_Length_SEQ
        
        %MAX_LOOP_COUNT_SEQ Returns the maximum number of times the
        %function generator can repeat a waveform in a sequence.
        %Typically, this value is constant for the function
        %generator.  Note: (1) This attribute is part of the
        %IviFgenArbSeq SEQ extension group. Read Only.
        Max_Loop_Count_SEQ
    end
    
    %% Property access methods
    methods
        %% Arbitrary_Sequence_Handle_SEQ property access methods
        function value = get.Arbitrary_Sequence_Handle_SEQ(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250211);
        end
        function set.Arbitrary_Sequence_Handle_SEQ(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250211, newValue);
        end
        %% Max_Number_of_Sequences_SEQ property access methods
        function value = get.Max_Number_of_Sequences_SEQ(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250212);
        end
        
        %% Min_Sequence_Length_SEQ property access methods
        function value = get.Min_Sequence_Length_SEQ(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250213);
        end
        
        %% Max_Sequence_Length_SEQ property access methods
        function value = get.Max_Sequence_Length_SEQ(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250214);
        end
        
        %% Max_Loop_Count_SEQ property access methods
        function value = get.Max_Loop_Count_SEQ(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250215);
        end
    end
end
