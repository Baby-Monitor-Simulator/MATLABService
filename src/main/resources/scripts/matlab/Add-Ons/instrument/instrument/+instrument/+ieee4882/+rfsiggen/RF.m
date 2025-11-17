classdef RF < handle
    % RF Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2017 The MathWorks, Inc.
    properties (Abstract)
        Frequency
        PowerLevel
        OutputEnabled
    end
    
    methods
       ConfigureRF(obj,varargin);
       ConfigureOutputEnabled(obj,varargin);
    end
    
end

