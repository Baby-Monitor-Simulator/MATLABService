classdef UtilityFunctions < handle
    % UTILITYFUNCTIONS Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.
    
    % Copyright 2017 The MathWorks, Inc.
    methods  (Abstract)
        getInstrumentInfo(obj);
        reset(obj);
    end
end
