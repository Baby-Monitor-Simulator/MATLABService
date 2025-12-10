classdef ArbitraryWaveform < instrument.ivic.IviGroupBase
    %ARBITRARYWAVEFORM This class contains functions that
    %configure the function generator to produce arbitrary
    %waveform output, create arbitrary waveforms, and clear
    %arbitrary waveforms.    An arbitrary waveform consists of a
    %user-specified array of normalized data that function
    %generator can produce.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = ArbitraryWaveform()
            %% Initialize properties
            obj.ArbitraryWaveformFrequency = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitraryWaveform.ArbitraryWaveformFrequency();
        end
        
        function delete(obj)
            obj.ArbitraryWaveformFrequency = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.ArbitraryWaveformFrequency.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %ARBITRARYWAVEFORMFREQUENCY This class contains functions
        %that configure the function generator to produce arbitrary
        %waveform output and specify the rate at which an entire
        %arbitrary waveform is generated.  Read Only.
        ArbitraryWaveformFrequency
    end
    
    %% Property access methods
    methods
        %% ArbitraryWaveformFrequency property access methods
        function value = get.ArbitraryWaveformFrequency(obj)
            if isempty(obj.ArbitraryWaveformFrequency)
                obj.ArbitraryWaveformFrequency = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitraryWaveform.ArbitraryWaveformFrequency();
            end
            value = obj.ArbitraryWaveformFrequency;
        end
    end
    
    %% Public Methods
    methods
        function [MaximumNumberofWaveforms,WaveformQuantum,MinimumWaveformSize,MaximumWaveformSize] = QueryArbWfmCapabilities(obj)
            %QUERYARBWFMCAPABILITIES This function returns the
            %attributes of the function generator that are related to
            %creating arbitrary waveforms. These attributes are the
            %maximum number of waveforms, waveform quantum, minimum
            %waveform size, and maximum waveform size.  Notes:  (1) This
            %function is part of the IviFgenArbWfm [ARB] extension
            %group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MaximumNumberofWaveforms = libpointer('int32Ptr', 0);
                WaveformQuantum = libpointer('int32Ptr', 0);
                MinimumWaveformSize = libpointer('int32Ptr', 0);
                MaximumWaveformSize = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviFgen_QueryArbWfmCapabilities', session, MaximumNumberofWaveforms, WaveformQuantum, MinimumWaveformSize, MaximumWaveformSize);
                
                MaximumNumberofWaveforms = MaximumNumberofWaveforms.Value;
                WaveformQuantum = WaveformQuantum.Value;
                MinimumWaveformSize = MinimumWaveformSize.Value;
                MaximumWaveformSize = MaximumWaveformSize.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WaveformHandle = CreateArbWaveform(obj,WaveformSize,WaveformDataArray)
            %CREATEARBWAVEFORM This function creates an arbitrary
            %waveform and returns a handle that identifies that
            %waveform. You pass this handle to the
            %IviFgen_ConfigureArbWaveform function to produce that
            %waveform.  You also use the handles this function returns
            %to specify a sequence of arbitrary waveforms with the
            %IviFgen_CreateArbSequence function.  Notes:  (1) This
            %function is part of the IviFgenArbWfm [ARB] extension
            %group.
            
            narginchk(3,3)
            WaveformSize = obj.checkScalarInt32Arg(WaveformSize);
            WaveformDataArray = obj.checkVectorDoubleArg(WaveformDataArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                WaveformHandle = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviFgen_CreateArbWaveform', session, WaveformSize, WaveformDataArray, WaveformHandle);
                
                WaveformHandle = WaveformHandle.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureSampleRate(obj,SampleRateSamps)
            %CONFIGURESAMPLERATE This function configures the sample
            %rate attribute, which determines the rate at which the
            %function generator produces arbitrary waveforms. When you
            %configure the function generator to produce an arbitrary
            %sequence, this is the sample rate for all arbitrary
            %waveforms in the sequence.    Notes:  (1) This function is
            %part of the IviFgenArbWfm [ARB] extension group.
            
            narginchk(2,2)
            SampleRateSamps = obj.checkScalarDoubleArg(SampleRateSamps);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureSampleRate', session, SampleRateSamps);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureArbWaveform(obj,ChannelName,WaveformHandle,Gain,Offset)
            %CONFIGUREARBWAVEFORM This function configures the
            %attributes of the function generator that affect arbitrary
            %waveform generation. These attributes are the arbitrary
            %waveform handle, gain, and offset.  Notes:  (1) This
            %function is part of the IviFgenArbWfm [ARB] extension
            %group.
            
            narginchk(5,5)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            WaveformHandle = obj.checkScalarInt32Arg(WaveformHandle);
            Gain = obj.checkScalarDoubleArg(Gain);
            Offset = obj.checkScalarDoubleArg(Offset);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureArbWaveform', session, ChannelName, WaveformHandle, Gain, Offset);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearArbWaveform(obj,WaveformHandle)
            %CLEARARBWAVEFORM This function removes a previously
            %created arbitrary waveform from the function generator's
            %memory and invalidates the waveform's handle.  Notes:  (1)
            %This function is part of the IviFgenArbWfm [ARB] extension
            %group.
            
            narginchk(2,2)
            WaveformHandle = obj.checkScalarInt32Arg(WaveformHandle);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ClearArbWaveform', session, WaveformHandle);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
