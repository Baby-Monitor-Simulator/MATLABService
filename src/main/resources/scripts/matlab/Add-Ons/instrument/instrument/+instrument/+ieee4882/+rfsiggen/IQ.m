classdef IQ < handle
    % IQ Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2017 The MathWorks, Inc.
    properties (Abstract)
        IQEnabled;
        IQSource;
        IQSwapEnabled;
    end
    
    methods(Abstract)
        ConfigureIQEnabled(obj, value);
    end
    
end

