classdef FrequencyModulation < instrument.ivic.IviGroupBase
    %FREQUENCYMODULATION This class contains functions that
    %configure the modulating signal and apply frequency
    %modulation to a carrier signal.  Frequency modulation
    %produces an output signal by varying the frequency of a
    %carrier signal according to the frequency of a modulating
    %signal.  You specify the carrier signal with the functions
    %in either the Standard Function Output class or the
    %Arbitrary Waveform Output class.  The modulating signal can
    %be an internally generated or an externally generated
    %signal.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureFMEnabled(obj,ChannelName,FMEnabled)
            %CONFIGUREFMENABLED This function specifies whether the
            %function generator applies frequency modulation to the
            %signal that the function generator produces with the
            %IviFgenStdFunc, IviFgenArbWfm, or IviFgenArbSeq capability
            %groups.  Notes:  (1) This function is part of the
            %IviFgenModulateFM [FM] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            FMEnabled = obj.checkScalarBoolArg(FMEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureFMEnabled', session, ChannelName, FMEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFMSource(obj,ChannelName,Source)
            %CONFIGUREFMSOURCE This function configures the source of
            %the signal the function generator uses to apply frequency
            %modulation to the channel.  Notes:  (1) This function is
            %part of the IviFgenModulateFM [FM] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureFMSource', session, ChannelName, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFMInternal(obj,PeakDeviation,ModulationWaveform,ModulationFrequency)
            %CONFIGUREFMINTERNAL This function configures the
            %attributes that control the function generator's internal
            %frequency modulation source.  These attributes are the peak
            %deviation, waveform, and frequency.  Notes:  (1) This
            %function is part of the IviFgenModulateFM [FM] extension
            %group.
            
            narginchk(4,4)
            PeakDeviation = obj.checkScalarDoubleArg(PeakDeviation);
            ModulationWaveform = obj.checkScalarInt32Arg(ModulationWaveform);
            ModulationFrequency = obj.checkScalarDoubleArg(ModulationFrequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureFMInternal', session, PeakDeviation, ModulationWaveform, ModulationFrequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
