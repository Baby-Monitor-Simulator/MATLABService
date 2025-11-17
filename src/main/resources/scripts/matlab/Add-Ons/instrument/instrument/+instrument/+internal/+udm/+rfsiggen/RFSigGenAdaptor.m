classdef (Hidden) RFSigGenAdaptor < instrument.internal.udm.InstrumentAdaptor
    % RFSIGGENADAPTOR Abstract base class for rfsiggen adapter objects.
    %   RFSigGenAdaptor is an abstract base class for all concrete rfsiggen
    %   adaptors to override all possible methods.
    
    %    Copyright 2016 The MathWorks, Inc.
    
    properties (Abstract)
        Frequency
        PowerLevel
        OutputEnabled
        IQEnabled
        IQSource
        IQSwapEnabled
        ClockFrequency
        ArbTriggerSource
        ArbSelectedWaveform
        ArbWaveformQuantum
        ArbMinWaveformSize
        ArbMaxWaveformSize
        ArbMaxNumberWaveforms
        Revision
        FirmwareRevision
    end
    
    % Methods that concrete adaptor classes have to implement
    methods (Abstract)
        configureRF(obj, varargin);
        configureIQ(obj, varargin);
        configureArbTriggerSource(obj, value);
        enableOutput(obj, value);
        enableIQ(obj,value);
        selectArbWaveform(obj,value);
        writeArbWaveform(obj, varargin);
        disableAllModulation(obj);
        sendSoftwareTrigger(obj);
        reset (obj);
        start(obj, varargin);
        stop(obj);
        download(obj, varargin);
        queryArbWaveformCapabilities(obj);
        waitUntilSettled(obj, value);
        isSettled(obj);
        revisionQuery(obj);
        clearAllArbWaveforms(obj);
    end
end