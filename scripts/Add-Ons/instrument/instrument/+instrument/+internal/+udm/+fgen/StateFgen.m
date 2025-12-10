classdef (Hidden) StateFgen <  instrument.internal.DriverBaseClass
    % StateFgen Abstract base class for FGen state objects.
    % StateSession is an abstract base class for all concrete FGen state
    % objects to override all possible methods.
    
    %    Copyright 2011-2013 The MathWorks, Inc.
    
    properties (SetAccess = private,GetAccess = protected)
        Fgen;
    end
    
    properties (Abstract )
        %abstract properties that all concrete state objects have to
        %redefine.
        Amplitude;
        AMDepth;
        ArbWaveformGain;
        BurstCount;
        Frequency;
        FMDeviation;
        Mode;
        ModulationWaveform;
        ModulationFrequency;
        ModulationSource;
        Offset;
        OutputImpedance;
        
        TriggerSource;
        StartPhase;
        TriggerRate;
        Waveform;
    end
    
    properties (Abstract, SetAccess = 'private')
        ChannelNames;
        SelectedChannel;
    end
    
    
    
    methods
        %Constructor
        function obj = StateFgen(fgen)
            obj.Fgen = fgen;
        end
        
        function resetImpl (obj)
            delete(obj);
        end
    end
    
    methods (Abstract )
        %the abstract methods that all concrete state objects have to
        %override.
        
        connect(obj);
        disconnect(obj);
        
        enableOutput(obj, enable);
        
        removeWaveform(obj, varargin);
        
        reset(obj);
        selectChannel(obj, channelName);
    end    
end