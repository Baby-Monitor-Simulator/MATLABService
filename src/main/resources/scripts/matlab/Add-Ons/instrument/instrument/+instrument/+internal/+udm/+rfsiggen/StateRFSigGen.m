classdef (Hidden) StateRFSigGen <  instrument.internal.DriverBaseClass
    % STATERFSIGGEN Abstract base class for RFSigGen state objects.
    % StateSession is an abstract base class for all concrete RFSigGen
    % state objects to override all possible methods.
    
    %    Copyright 2016 The MathWorks, Inc.
    
    properties (SetAccess = private,GetAccess = protected)
        RFSigGen;
    end
    
    properties (Abstract)
        % Abstract properties that all concrete state objects have to
        % redefine.
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
    
    methods
        % Constructor
        function obj = StateRFSigGen(rfsiggen)
            obj.RFSigGen = rfsiggen;
        end
        
        function resetImpl (obj)
            delete(obj);
        end
    end
    
    methods (Abstract)
        % The abstract methods that all concrete state objects have to
        % override.
        
        connect(obj);
        disconnect(obj);
        configureRF(obj, varargin);
        configureIQ(obj, varargin);
        configureArbTriggerSource(obj, value);
        enableOutput(obj, value);
        enableIQ(obj, value);
        disableAllModulation(obj);
        writeArbWaveform(obj, varargin);
        clearAllArbWaveforms(obj);
        selectArbWaveform(obj, value);
        sendSoftwareTrigger(obj);
        reset(obj);
        download(obj, varargin);
        queryArbWaveformCapabilities(obj);
        waitUntilSettled(obj, value);
        isSettled(obj);
        revisionQuery(obj);
        start(obj, varargin);
        stop(obj);
    end
end