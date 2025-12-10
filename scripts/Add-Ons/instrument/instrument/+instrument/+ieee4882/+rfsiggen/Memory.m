classdef Memory < handle
    % MEMORY Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2017 The MathWorks, Inc.
    
    methods(Abstract)
        MemoryDeleteFile(obj,value);
    end
    
end

