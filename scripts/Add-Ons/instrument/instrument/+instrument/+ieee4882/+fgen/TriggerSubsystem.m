classdef TriggerSubsystem < handle
    %TRIGGERSUBSYSTEM Abstract base Class for Interface-based fgen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2012 The MathWorks, Inc.
    
    methods(Abstract)
        getBurstCount(obj);
        setBurstCount(obj, newValue);
        value = getTriggerRate(obj);
        setTriggerRate(obj, newValue);
        value = getTriggerSource(obj);
        setTriggerSource(obj, newValue);
    end
    
end

