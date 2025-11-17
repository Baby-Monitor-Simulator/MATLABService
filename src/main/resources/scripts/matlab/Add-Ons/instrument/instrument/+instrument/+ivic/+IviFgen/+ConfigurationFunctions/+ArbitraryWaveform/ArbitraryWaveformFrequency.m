classdef ArbitraryWaveformFrequency < instrument.ivic.IviGroupBase
    %ARBITRARYWAVEFORMFREQUENCY This class contains functions
    %that configure the function generator to produce arbitrary
    %waveform output and specify the rate at which an entire
    %arbitrary waveform is generated.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureArbFrequency(obj,ChannelName,Frequency)
            %CONFIGUREARBFREQUENCY This function configures the
            %arbitrary waveform frequency attribute, which determines
            %the rate at which the function generator produces entire
            %arbitrary waveforms.    Notes:  (1) This function is part
            %of the IviFgenArbFrequency [AF] extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Frequency = obj.checkScalarDoubleArg(Frequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureArbFrequency', session, ChannelName, Frequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
