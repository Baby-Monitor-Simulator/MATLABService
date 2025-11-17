classdef WaveformAcquisition < handle
    %WAVEFORMACQUISITION abstract base Class for Interface-based oscilloscope.
    % A concrete sub class need to override its abstract methods.
    
    % Copyright 2011 The MathWorks, Inc.
    properties
        
    end
    
    methods (Abstract)
        WaveformArray = fetchWaveform(obj,channelName);
        WaveformArray = readWaveform(obj,channelName,MaximumTimems);
        
    end

end
