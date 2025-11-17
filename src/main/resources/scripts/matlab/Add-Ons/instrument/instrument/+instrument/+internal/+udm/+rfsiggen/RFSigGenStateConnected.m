classdef(Hidden)RFSigGenStateConnected <  instrument.internal.udm.rfsiggen.StateRFSigGen
    %   RFSIGGENSTATECONNECTED Provides state specific behaviors for all
    %   operations when the instrument has been connected. Most of the
    %   operations are delegated to the underlying adapter to handle.
    
    %    Copyright 2016-2017 The MathWorks, Inc.
    properties (Dependent = true)
        % Redefine the abstract properties in StateRFSigGen class
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
        function obj =  RFSigGenStateConnected(rfsiggen)
            % Base constructor
            obj@instrument.internal.udm.rfsiggen.StateRFSigGen(rfsiggen);
        end
        
        function enableOutput(obj, enable)
            obj.RFSigGen.Adaptor.enableOutput(enable);
        end
        
        function enableIQ(obj, enable)
            obj.RFSigGen.Adaptor.enableIQ(enable);
        end
        
        function disableAllModulation(obj)
            obj.RFSigGen.Adaptor.disableAllModulation;
        end
        
        function sendSoftwareTrigger(obj)
            obj.RFSigGen.Adaptor.sendSoftwareTrigger;
        end
        
        function removeWaveform(obj, varargin)
            
            % WaveformHandle has to be numeric value
            if ~isempty (varargin)
                waveformHandle = varargin{1};
                validateattributes(waveformHandle,{'numeric'}, {'scalar','finite','integer','nonnan','>' , 0 });
            end
            
            obj.RFSigGen.Adaptor.removeWaveform(varargin{:});
        end
        
        function download(obj, iqData, clockFrequency)
            validateattributes(iqData,{'numeric'}, {'row','finite'});
            validateattributes(clockFrequency,{'numeric'}, {'scalar','finite','positive'});
            obj.RFSigGen.Adaptor.download(iqData, clockFrequency);
        end
        
        function [v1,v2,v3,v4] = queryArbWaveformCapabilities(obj)
            [v1,v2,v3,v4] = obj.RFSigGen.Adaptor.queryArbWaveformCapabilities;
        end
        
        function waitUntilSettled(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.RFSigGen.Adaptor.waitUntilSettled(value);
        end
        
        function value = isSettled(obj)
            value = obj.RFSigGen.Adaptor.isSettled;
        end
        
        function [v1,v2] = revisionQuery(obj)
            [v1,v2] = obj.RFSigGen.Adaptor.revisionQuery;
        end
        
        function selectWaveform(obj, waveformHandle)
            validateattributes(waveformHandle,{'numeric'},{'scalar','finite','integer','nonnan','>',0});
            obj.RFSigGen.Adaptor.selectWaveform(waveformHandle);
        end
        
        function start(obj, centerFrequency, outputPower, loopCount)
            validateattributes(centerFrequency,{'numeric'}, {'scalar','finite','positive'});
            validateattributes(outputPower,{'numeric'}, {'scalar','finite'});
            validateattributes(loopCount,{'numeric'}, {'scalar','positive'});
            obj.RFSigGen.Adaptor.start(centerFrequency, outputPower, loopCount);
        end
        
        function stop(obj)
            obj.RFSigGen.Adaptor.stop;
        end
        
        function delete(obj)
            if isvalid (obj) && ~isempty (obj.Adaptor)
                obj.RFSigGen.Adaptor = [];
            end
        end
        
        function reset(obj)
            obj.RFSigGen.Adaptor.reset();
        end
        
        
        function connect(obj ) %#ok<*MANU>
            error (message('instrument:qcinstrument:alreadyConnected'));
        end
        
        function disconnect(obj)
            obj.RFSigGen.Adaptor.disconnect();
            obj.RFSigGen.Adaptor = [];
            obj.RFSigGen.updateConnectionStatus('closed');
            %switch to StateNotConnected object.
            obj.RFSigGen.changeState('RFSigGenStateNotConnected');
        end
        
        function set.Frequency(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.RFSigGen.Adaptor.Frequency = value;
            realValue = obj.RFSigGen.Adaptor.Frequency;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.Frequency(obj)
            value = obj.RFSigGen.Adaptor.Frequency;
        end
        
        function set.PowerLevel(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite'});
            obj.RFSigGen.Adaptor.PowerLevel = value;
            realValue = obj.RFSigGen.Adaptor.PowerLevel;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.PowerLevel(obj)
            value = obj.RFSigGen.Adaptor.PowerLevel;
        end
        
        function set.OutputEnabled(obj, value)
            value = obj.checkScalarBoolArg(value);
            obj.RFSigGen.Adaptor.OutputEnabled = value;
        end
        
        function value = get.OutputEnabled(obj)
            value = obj.RFSigGen.Adaptor.OutputEnabled;
            value = obj.checkScalarBoolArg(value);
        end
        
        function set.IQEnabled(obj, value)
            value = obj.checkScalarBoolArg(value);
            obj.RFSigGen.Adaptor.IQEnabled = value;
        end
        
        function value = get.IQEnabled(obj)
            value = obj.RFSigGen.Adaptor.IQEnabled;
            value = obj.checkScalarBoolArg(value);
        end
        
        function set.ClockFrequency(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.RFSigGen.Adaptor.ClockFrequency = value;
            realValue = obj.RFSigGen.Adaptor.ClockFrequency;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.ClockFrequency(obj)
            value = obj.RFSigGen.Adaptor.ClockFrequency;
        end
        
        function set.IQSource(obj, value)
            obj.checkScalarStringArg(value);
            obj.RFSigGen.Adaptor.IQSource = instrument.internal.udm.rfsiggen.IQSourceEnum.getEnum(value);
        end
        
        function value = get.IQSource(obj)
            value = obj.RFSigGen.Adaptor.IQSource;
        end
        
        function set.IQSwapEnabled(obj, value)
            value = obj.checkScalarBoolArg(value);
            obj.RFSigGen.Adaptor.IQSwapEnabled = value;
        end
        
        function value = get.IQSwapEnabled(obj)
            value = obj.RFSigGen.Adaptor.IQSwapEnabled;
            value = obj.checkScalarBoolArg(value);
        end
        
        function set.ArbTriggerSource(obj, value)
            obj.checkScalarStringArg(value);
            obj.RFSigGen.Adaptor.ArbTriggerSource = instrument.internal.udm.rfsiggen.ArbTriggerSourceEnum.getEnum(value);
        end
        
        function value = get.ArbTriggerSource(obj)
            value = obj.RFSigGen.Adaptor.ArbTriggerSource;
        end
        
        function set.ArbSelectedWaveform(obj, value)
            obj.checkScalarStringArg(value);
            obj.RFSigGen.Adaptor.ArbSelectedWaveform = value;
        end
        
        function value = get.ArbSelectedWaveform(obj)
            value = obj.RFSigGen.Adaptor.ArbSelectedWaveform;
            % If no waveform has been set the IVI driver will return a 2
            % byte value ' ' (0), not an empty string. Convert that to an
            % empty string so we can correctly determine if a waveform
            % hasn't been set.
            if isequal(uint16(value),0)
                value = '';
            end
        end
        
        function value = get.ArbWaveformQuantum(obj)
            value = obj.RFSigGen.Adaptor.ArbWaveformQuantum;
        end
        
        function value = get.ArbMinWaveformSize(obj)
            value = obj.RFSigGen.Adaptor.ArbMinWaveformSize;
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            value = obj.RFSigGen.Adaptor.ArbMaxWaveformSize;
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            value = obj.RFSigGen.Adaptor.ArbMaxNumberWaveforms;
        end
        
        function value = get.Revision(obj)
            value = obj.RFSigGen.Adaptor.Revision;
        end
        
        function value = get.FirmwareRevision(obj)
            value = obj.RFSigGen.Adaptor.FirmwareRevision;
        end
        
        function  configureRF(obj, frequency, powerLevel)
            validateattributes(frequency,{'numeric'}, {'scalar','finite','positive'},...
                'configureRF','frequency');
            validateattributes(powerLevel,{'numeric'}, {'scalar','finite'},...
                'configureRF','powerLevel');
            obj.RFSigGen.Adaptor.configureRF(frequency, powerLevel);
            
            realValue = obj.RFSigGen.Adaptor.Frequency;
            instrument.internal.util.checkSetValue(frequency, realValue);
            
            realValue = obj.RFSigGen.Adaptor.PowerLevel;
            instrument.internal.util.checkSetValue(powerLevel, realValue);
        end
        
        function  configureIQ(obj, source, swapEnabled)
            swapEnabled = logical(swapEnabled);
            validateattributes(source,{'char'}, {'vector'},'configureIQ','source');
            validateattributes(swapEnabled, {'logical'} ,{'scalar'},'configureIQ','swapEnabled' );
            source = instrument.internal.udm.rfsiggen.IQSourceEnum.getEnum(source);
            obj.RFSigGen.Adaptor.configureIQ(source, swapEnabled);
        end
        
        function  configureArbTriggerSource(obj, source)
            validateattributes(source,{'char'}, {'vector'},'configureArbTriggerSource','source');
            source = instrument.internal.udm.rfsiggen.ArbTriggerSourceEnum.getEnum(source);
            obj.RFSigGen.Adaptor.configureArbTriggerSource(source);
        end
        
        function  selectArbWaveform(obj, name)
            obj.checkScalarStringArg(name);
            name = strtrim(name);
            obj.RFSigGen.Adaptor.selectArbWaveform(name);
        end
        
        function  writeArbWaveform(obj, name, numberOfSamples, iData, qData, moreDataPending)
            obj.checkScalarStringArg(name);
            validateattributes(numberOfSamples,{'numeric'}, {'scalar','finite','positive','even'},...
                'writeArbWaveform','numberOfSamples');
            validateattributes(iData,{'double'}, {'row','finite','>=' , -1,'<=' , 1,'size',[1,numberOfSamples]},...
                'writeArbWaveform','iData');
            validateattributes(qData,{'double'}, {'row','finite','>=' , -1,'<=' , 1,'size',[1,numberOfSamples]},...
                'writeArbWaveform','qData');
            moreDataPending = obj.checkScalarBoolArg(moreDataPending);
            obj.RFSigGen.Adaptor.writeArbWaveform(strtrim(name), numberOfSamples, iData, qData, moreDataPending);
        end
        
        function  clearAllArbWaveforms(obj)
            obj.RFSigGen.Adaptor.clearAllArbWaveforms;
        end
    end
end