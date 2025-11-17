classdef ARBGenerator < instrument.ivic.IviGroupBase
    %ARBGENERATOR This class contains functions and sub-classes
    %to configure the arbitrary waveform functionality of the
    %RFSigGen.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureArb(obj,ClockFrequency,FilterFrequency)
            %CONFIGUREARB This function configures the ARB generator by
            %specifying the sample frequency and filter frequency.
            
            narginchk(3,3)
            ClockFrequency = obj.checkScalarDoubleArg(ClockFrequency);
            FilterFrequency = obj.checkScalarDoubleArg(FilterFrequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureArb', session, ClockFrequency, FilterFrequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WriteArbWaveform(obj,Name,NumberofSamples,DataI,DataQ,MoreDataPending)
            %WRITEARBWAVEFORM This function stores the transmitted
            %waveform in the drivers's or instrument's memory.
            
            narginchk(6,6)
            Name = obj.checkScalarStringArg(Name);
            NumberofSamples = obj.checkScalarInt32Arg(NumberofSamples);
            DataI = obj.checkVectorDoubleArg(DataI);
            DataQ = obj.checkVectorDoubleArg(DataQ);
            MoreDataPending = obj.checkScalarBoolArg(MoreDataPending);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_WriteArbWaveform', session, Name, NumberofSamples, DataI, DataQ, MoreDataPending);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SelectArbWaveform(obj,Name)
            %SELECTARBWAVEFORM This function sets a named waveform to
            %be the active waveform.  Create arb waveform names using
            %the IviRFSigGen_WriteArbWaveform function.
            
            narginchk(2,2)
            Name = obj.checkScalarStringArg(Name);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = [double(Name) 0];
                
                status = calllib( libname,'IviRFSigGen_SelectArbWaveform', session, Name);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ClearAllArbWaveforms(obj)
            %CLEARALLARBWAVEFORMS This function deletes all the
            %currently defined arb waveforms.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ClearAllArbWaveforms', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [MaxNumberofWaveforms,WaveformQuantum,MinWaveformSize,MaxWaveformSize] = QueryArbWaveformCapabilities(obj)
            %QUERYARBWAVEFORMCAPABILITIES This function returns the arb
            %generator settings that are related to creating arbitrary
            %waveforms. These attributes are the maximum number of
            %waveforms, waveform quantum, minimum waveform size, and
            %maximum waveform size.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MaxNumberofWaveforms = libpointer('int32Ptr', 0);
                WaveformQuantum = libpointer('int32Ptr', 0);
                MinWaveformSize = libpointer('int32Ptr', 0);
                MaxWaveformSize = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviRFSigGen_QueryArbWaveformCapabilities', session, MaxNumberofWaveforms, WaveformQuantum, MinWaveformSize, MaxWaveformSize);
                
                MaxNumberofWaveforms = MaxNumberofWaveforms.Value;
                WaveformQuantum = WaveformQuantum.Value;
                MinWaveformSize = MinWaveformSize.Value;
                MaxWaveformSize = MaxWaveformSize.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureArbTriggerSource(obj,Source)
            %CONFIGUREARBTRIGGERSOURCE This function configures the
            %trigger source for the waveform generation.  The output
            %waveform is generated continuously if the source is
            %immediate.  Otherwise, the output is triggered.
            
            narginchk(2,2)
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureArbTriggerSource', session, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureArbExternalTriggerSlope(obj,Slope)
            %CONFIGUREARBEXTERNALTRIGGERSLOPE This function configures
            %the trigger event to occur on the rising or falling edge of
            %the input signal.
            
            narginchk(2,2)
            Slope = obj.checkScalarInt32Arg(Slope);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_ConfigureArbExternalTriggerSlope', session, Slope);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
