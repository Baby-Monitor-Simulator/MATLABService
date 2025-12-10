classdef TriggerSubsystem < handle
    %TRIGGERSUBSYSTEM Abstract base Class for Interface-based oscilloscope.
    % A concrete sub class need to override its abstract methods.
    
    % Copyright 2011 The MathWorks, Inc.
    
    
    properties (Abstract)
        TriggerSource;
        
        TriggerLevel;
        
        TriggerSlope;
        
        TriggerMode;
    end
end
