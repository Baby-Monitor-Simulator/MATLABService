classdef ARBGenerator < handle
    % ARBGENERATOR Abstract base class for Interface-based rfsiggen.
    % A concrete sub class needs to override its abstract methods.
    
    % Copyright 2017 The MathWorks, Inc.
    
    %% Public Properties
    properties (Abstract)
        ClockFrequency;
        SelectedWaveform;
        TriggerSource;
        ByteOrder;
    end
        
    methods  (Abstract)
        ConfigureArbTriggerSource(obj, value);
        WriteArbWaveform(obj,fileName,iWave,qWave,moreDataPending);
        SetClockFrequency(obj, value);
        SetDefaultByteOrder(obj, model);
    end
end
