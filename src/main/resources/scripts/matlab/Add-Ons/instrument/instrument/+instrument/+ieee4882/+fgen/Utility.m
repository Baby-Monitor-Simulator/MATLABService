classdef Utility < handle
    %UTILITY Abstract base Class for Interface-based fgen.
    % A concrete sub class needs to override its abstract methods.
    
    % Copyright 2012 The MathWorks, Inc.
    
    %% Public Read Only Properties
    
    methods  (Abstract)
        reset(obj);
        getInstrumentInfo(obj);
    end
end
