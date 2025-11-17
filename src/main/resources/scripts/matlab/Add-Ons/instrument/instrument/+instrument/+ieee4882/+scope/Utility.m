classdef Utility < handle
    %UTILITY Abstract base Class for Interface-based oscilloscope.
    % A concrete sub class need to override its abstract methods.
    
    % Copyright 2011 The MathWorks, Inc.
    
    %% Public Read Only Properties
    
    methods  (Abstract)
        autoSetup(obj);
        reset(obj);

    end
end
