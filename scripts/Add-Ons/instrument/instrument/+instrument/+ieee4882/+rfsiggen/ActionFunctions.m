classdef ActionFunctions < handle
    % ACTIONFUNCTIONS Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2017 The MathWorks, Inc.
    
    methods(Abstract)
        DisableAllModulation(obj);
        SendSoftwareTrigger(obj);
        WaitUntilSettled(obj, value);
        IsSettled(obj);
    end
    
end

