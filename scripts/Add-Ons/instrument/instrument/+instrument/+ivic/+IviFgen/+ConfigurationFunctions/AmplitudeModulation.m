classdef AmplitudeModulation < instrument.ivic.IviGroupBase
    %AMPLITUDEMODULATION This class contains functions that
    %configure the modulating signal and apply amplitude
    %modulation to a carrier signal.  Amplitude modulation
    %produces an output signal by varying the amplitude of a
    %carrier signal according to the amplitude of a modulating
    %signal.  You specify the carrier signal with the functions
    %in either the Standard Function Output class or the
    %Arbitrary Waveform Output class.  The modulating signal can
    %be an internally generated or an externally generated
    %signal.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureAMEnabled(obj,ChannelName,AMEnabled)
            %CONFIGUREAMENABLED This function specifies whether the
            %function generator applies amplitude modulation to the
            %signal that the function generator produces with the
            %IviFgenStdFunc, IviFgenArbWfm, or IviFgenArbSeq capability
            %groups.  Notes:  (1) This function is part of the
            %IviFgenModulateAM [AM] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AMEnabled = obj.checkScalarBoolArg(AMEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureAMEnabled', session, ChannelName, AMEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAMSource(obj,ChannelName,Source)
            %CONFIGUREAMSOURCE This function configures the source of
            %the signal the function generator uses to apply amplitude
            %modulation to the channel.  Notes:  (1) This function is
            %part of the IviFgenModulateAM [AM] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Source = obj.checkScalarInt32Arg(Source);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureAMSource', session, ChannelName, Source);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAMInternal(obj,ModulationDepth,ModulationWaveform,ModulationFrequency)
            %CONFIGUREAMINTERNAL This function configures the
            %attributes that control the function generator's internal
            %amplitude modulation source.  These attributes are the
            %modulation depth, waveform, and frequency.  Notes:  (1)
            %This function is part of the IviFgenModulateAM [AM]
            %extension group.
            
            narginchk(4,4)
            ModulationDepth = obj.checkScalarDoubleArg(ModulationDepth);
            ModulationWaveform = obj.checkScalarInt32Arg(ModulationWaveform);
            ModulationFrequency = obj.checkScalarDoubleArg(ModulationFrequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureAMInternal', session, ModulationDepth, ModulationWaveform, ModulationFrequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
