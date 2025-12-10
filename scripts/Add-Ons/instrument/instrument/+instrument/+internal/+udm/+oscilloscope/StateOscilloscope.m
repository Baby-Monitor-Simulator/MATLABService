classdef (Hidden) StateOscilloscope <  instrument.internal.DriverBaseClass
    %StateOscilloscope Abstract base class for Oscilloscope state objects.
    %   StateSession is an abstract base class for all concrete Oscilloscope state
    %   objects to override all possible methods.
    
    %    Copyright 2011-2019 The MathWorks, Inc.
    
    properties (SetAccess = private,GetAccess = protected)
        Oscilloscope ;
    end
    
    properties (Abstract )
        %abstract propeties that all concret state objects have to
        %redefine.
        AcquisitionTime;
        AcquisitionStartDelay;
        TriggerLevel;
        TriggerSlope;
        TriggerSource;
        WaveformLength  ;
        TriggerMode ;
        SingleSweepMode;
        
    end
    
    properties (Abstract, SetAccess = 'private')
        ChannelNames;
        ChannelsEnabled  ;
    end
    
    methods
        %Constructor
        function obj = StateOscilloscope(scope)
            obj.Oscilloscope =  scope;
        end
        
        function resetImpl (obj)
            delete (obj);
        end
    end
    
    methods (Abstract )
        %the abasract methods that all concrete state objects have to
        %override.
        
        setVerticalOffset(obj, channelName, value);
        value = getVerticalOffset(obj, channelName);
        
        setVerticalCoupling(obj, channelName, value);
        value = getVerticalCoupling(obj, channelName);
        
        setVerticalRange(obj, channelName, value);
        value = getVerticalRange(obj, channelName);
        
        setProbeAttenuation(obj, channelName, value);
        value = getProbeAttenuation(obj, channelName);
        
        varargout = getWaveform(obj);

        reset (obj);
        autoSetup(obj);
        connect(obj)
        disconnect(obj);
        
        enableChannel(obj, channelName, enable);
    end
    
end