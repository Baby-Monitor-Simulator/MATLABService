classdef WaveformSubsystem < handle
    %WAVEFORM Abstract base Class for Interface-based fgen.
    % A concrete sub class needs to override its abstract methods.

    % Copyright 2012 The MathWorks, Inc.
        
    methods
        getBurstMode(obj);
        setBurstEnabled(obj, value);
        getFMEnabled(obj);
        setFMEnabled(obj, value);
        getAMEnabled(obj);
        setAMEnabled(obj, value);
        getAMWaveform(obj);
        setAMWaveform(obj, value);
        getFMWaveform(obj);
        setFMWaveform(obj, value);
        getOffset(obj);
        setOffset(obj, value);
        getAMModulationSource(obj);
        setAMModulationSource(obj,value);
        getFMModulationSource(obj);
        setFMModulationSource(obj,value);
        getAMDepth(obj);
        setAMDepth(obj,value);
        getFMDeviation(obj)
        setFMDeviation(obj,value);
        getAMInternalFrequency(obj);
        setAMInternalFrequency(obj, value)
        getFMInternalFrequency(obj);
        setFMInternalFrequency(obj, value);
        getStartPhase(obj);
        setStartPhase(obj,value);
        getWaveform(obj);
        setWaveform(obj,value);
        getFrequency(obj);
        setFrequency(obj,value);
        clearArbWaveform(obj, value);
        selectArbWaveform(obj, value);
        createArbWaveform(obj, value);
    end
    
end

