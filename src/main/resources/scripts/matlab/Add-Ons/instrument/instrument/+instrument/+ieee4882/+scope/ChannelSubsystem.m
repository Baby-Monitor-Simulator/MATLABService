classdef ChannelSubsystem < handle
    %ChannelSubsystem Abstract base Class for Interface-based oscilloscope.
    % A concrete sub class need to override its abstract methods.
    
    % Copyright 2011-2019 The MathWorks, Inc.
    
    
    properties (Abstract ,SetAccess = private)
        
        ChannelNames;
        EnabledChannels;
    end
    
    
    methods (Abstract)
        enableChannel(obj, channelName , enable);

        value = getVerticalRange(obj, channelName);

        setVerticalRange(obj,channelName, newValue);

        value = getVerticalOffset(obj, channelName);
                
        setVerticalOffset(obj,channelName , newValue);

        value = getVerticalCoupling(obj, channelName);

        setVerticalCoupling(obj,channelName , newValue);

        value = getProbeAttenuation(obj, channelName);

        setProbeAttenuation(obj,channelName , newValue);
        
    end
    
end
