classdef (Hidden) FgenAdaptor < instrument.internal.udm.InstrumentAdaptor
    %FgenAdaptor Abstract base class for fgen adapter objects.
    %   ScopeAdaptor is an abstract base class for all concrete fgen
    %   adaptors to override all possible methods.
    
    %    Copyright 2011-2013 The MathWorks, Inc.
    
    properties (Abstract  )
        
        Amplitude
        AMDepth
        ArbWaveformGain
        BurstCount
        Frequency;
        FMDeviation;
        Mode;
        ModulationWaveform
        ModulationFrequency
        ModulationSource
        Offset;
        OutputImpedance
        TriggerSource;
        StartPhase
        TriggerRate
        
    end
    
    %Read only properties
    properties (Abstract, SetAccess = private )
        ChannelNames;
        SelectedChannel;
    end
    
    
    % methods that concrete adaptor classes have to implement
    methods (Abstract, Access = public)
        
  
        enableOutput(obj, value);
        
        downloadWaveform (obj, array);
        removeWaveform(obj, varargin);
 
        
        reset (obj);
        selectChannel(obj, channelName);
 
    end
    
     methods (Access = protected)
        
        % helper function to validate channel name
        function validateChannelName(obj, channelName)
            instrument.internal.util.validateChannelName(obj.ChannelNames, channelName); 
        end        
    end
    
end