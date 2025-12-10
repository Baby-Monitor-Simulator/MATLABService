classdef (Hidden) ScopeAdaptor < instrument.internal.udm.InstrumentAdaptor
    %ScopeAdaptor Abstract base class for Oscilloscope adaptor objects.
    %   ScopeAdaptor is an abstract base class for all concrete Oscilloscope
    %   adaptors to override all possible methods.
    
    %    Copyright 2011-2013 The MathWorks, Inc.
    
    properties (Abstract  )
        
        AcquisitionTime;
        AcquisitionStartDelay;
        WaveformLength;
        
        TriggerSource;
        TriggerSlope;
        TriggerLevel;
        TriggerMode ;
        
        SingleSweepMode;
        
    end
    
    %Read only properties
    properties (Abstract, SetAccess = private )
        ChannelNames;
        ChannelsEnabled;
    end
    
    
    % methods that concrete adaptor classes have to implement
    methods (Abstract, Access = public)
        
        setVerticalControl(obj, channelName, controlType, value);
        getVerticalControl(obj, channelName, controlType);
        
        varargout = fetchWaveform(obj, channelName);
        varargout = readWaveform(obj, channelName , timeout )
        
        reset (obj);
        autoSetup(obj);
        
        enableChannel(obj, channelName, enable);
        
    end
    
     methods (Access = protected)

         function validateChannelName(obj, channelName)
             instrument.internal.util.validateChannelName(obj.ChannelNames, channelName);
         end     
    end
end