classdef ChannelSubsystem < handle
    %ChannelSubsystem Abstract base Class for Interface-based fgen.
    % A concrete sub class needs to override its abstract methods.
    
    % Copyright 2012 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (Abstract, SetAccess = private)
        ChannelNames;
        SelectedChannel;
    end
    
    methods (Abstract)
        selectChannel(obj);
        enableOutput(obj);
        disableOutput(obj);
        getOutputImpedance(obj);
        setOutputImpedance(obj, value);
        getAmplitude(obj);
        setAmplitude(obj, value);
    end
end
