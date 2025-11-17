classdef ArbitrarySequence < instrument.ivic.IviGroupBase
    %ARBITRARYSEQUENCE This class contains functions that
    %configure the function generator to produce arbitrary
    %sequence output, create arbitrary sequences, and clear
    %arbitrary sequences.    An arbitrary sequence consists of
    %multiple arbitrary waveforms.  For each waveform, you
    %specify the number of times the function generator produces
    %the waveform before proceeding to the next waveform.  The
    %number of times to repeat a specific waveform is called the
    %loop count.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function [MaximumNumberofSequences,MinimumSequenceLength,MaximumSequenceLength,MaximumLoopCount] = QueryArbSeqCapabilities(obj)
            %QUERYARBSEQCAPABILITIES This function returns the
            %attributes of the function generator that are related to
            %creating arbitrary sequences. These attributes are the
            %maximum number of sequences, minimum sequence length,
            %maximum sequence length, and maximum loop count.  Note:
            %This function is part of the IviFgenArbSeq [SEQ] extension
            %group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MaximumNumberofSequences = libpointer('int32Ptr', 0);
                MinimumSequenceLength = libpointer('int32Ptr', 0);
                MaximumSequenceLength = libpointer('int32Ptr', 0);
                MaximumLoopCount = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviFgen_QueryArbSeqCapabilities', session, MaximumNumberofSequences, MinimumSequenceLength, MaximumSequenceLength, MaximumLoopCount);
                
                MaximumNumberofSequences = MaximumNumberofSequences.Value;
                MinimumSequenceLength = MinimumSequenceLength.Value;
                MaximumSequenceLength = MaximumSequenceLength.Value;
                MaximumLoopCount = MaximumLoopCount.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SequenceHandle = CreateArbSequence(obj,SequenceLength,WaveformHandlesArray,LoopCountsArray)
            %CREATEARBSEQUENCE An arbitrary sequence consists of
            %multiple waveforms. For each waveform, you specify the
            %number of times the function generator produces the
            %waveform before proceeding to the next waveform.  The
            %number of times to repeat a specific waveform is called the
            %loop count.   This function creates an arbitrary sequence
            %from an array of waveform handles and an array of
            %corresponding loop counts. The function returns a handle
            %that identifies the sequence. You pass this handle to the
            %IviFgen_ConfigureArbSequence function to specify what
            %arbitrary sequence you want the function generator to
            %produce.  Notes:  (1) This function is part of the
            %IviFgenArbSeq [SEQ] extension group.
            
            narginchk(4,4)
            SequenceLength = obj.checkScalarInt32Arg(SequenceLength);
            WaveformHandlesArray = obj.checkVectorInt32Arg(WaveformHandlesArray);
            LoopCountsArray = obj.checkVectorInt32Arg(LoopCountsArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                SequenceHandle = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviFgen_CreateArbSequence', session, SequenceLength, WaveformHandlesArray, LoopCountsArray, SequenceHandle);
                
                SequenceHandle = SequenceHandle.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureArbSequence(obj,ChannelName,SequenceHandle,Gain,Offset)
            %CONFIGUREARBSEQUENCE This function configures the
            %attributes of the function generator that affect arbitrary
            %sequence generation. These attributes are the arbitrary
            %sequence handle, gain, and offset.  Notes:  (1) This
            %function is part of the IviFgenArbSeq [SEQ] extension
            %group.
            
            narginchk(5,5)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            SequenceHandle = obj.checkScalarInt32Arg(SequenceHandle);
            Gain = obj.checkScalarDoubleArg(Gain);
            Offset = obj.checkScalarDoubleArg(Offset);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureArbSequence', session, ChannelName, SequenceHandle, Gain, Offset);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearArbSequence(obj,SequenceHandle)
            %CLEARARBSEQUENCE This function removes a previously
            %created arbitrary sequence from the function generator's
            %memory and invalidates the sequence's handle.  Notes:  (1)
            %This function is part of the IviFgenArbSeq [SEQ] extension
            %group.
            
            narginchk(2,2)
            SequenceHandle = obj.checkScalarInt32Arg(SequenceHandle);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ClearArbSequence', session, SequenceHandle);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearArbMemory(obj)
            %CLEARARBMEMORY This function removes all previously
            %created arbitrary waveforms and sequences from the function
            %generator's memory. It also invalidates all waveform and
            %sequence handles.  Notes:  (1) This function is part of the
            %IviFgenArbSeq [SEQ] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ClearArbMemory', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
