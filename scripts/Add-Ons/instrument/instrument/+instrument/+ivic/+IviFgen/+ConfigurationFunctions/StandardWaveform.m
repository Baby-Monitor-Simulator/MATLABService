classdef StandardWaveform < instrument.ivic.IviGroupBase
    %STANDARDWAVEFORM This class contains functions that
    %configure the function generator to produce standard
    %waveform output.  These periodic signals are characterized
    %by their waveform, amplitude, DC offset, frequency, and
    %start phase.  Some waveforms may require additional
    %parameters to characterize their output.  For example, a
    %square wave requires a duty cycle parameter in addition to
    %those parameters listed above.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureStandardWaveform(obj,ChannelName,Waveform,Amplitude,DCOffset,Frequency,StartPhase)
            %CONFIGURESTANDARDWAVEFORM This function configures the
            %attributes of the function generator that affect standard
            %waveform generation. These attributes are the waveform,
            %amplitude, DC offset, frequency, and start phase.  Notes:
            %(1) This function is part of the IviFgenStdFunc [STD]
            %extension group.
            
            narginchk(7,7)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Waveform = obj.checkScalarInt32Arg(Waveform);
            Amplitude = obj.checkScalarDoubleArg(Amplitude);
            DCOffset = obj.checkScalarDoubleArg(DCOffset);
            Frequency = obj.checkScalarDoubleArg(Frequency);
            StartPhase = obj.checkScalarDoubleArg(StartPhase);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureStandardWaveform', session, ChannelName, Waveform, Amplitude, DCOffset, Frequency, StartPhase);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
