classdef (Hidden)RFSigGenStateNotConnected <   instrument.internal.udm.rfsiggen.StateRFSigGen
    %   RFSIGGENSTATENOTCONNECTED Provides state specific behaviors for all
    %   operations when the instrument is not connected.
    
    %   Copyright 2016 The MathWorks, Inc.
    
    properties
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
        function obj =  RFSigGenStateNotConnected(rfsiggen)
            % Base
            obj@instrument.internal.udm.rfsiggen.StateRFSigGen(rfsiggen);
        end
        
        function cannotChangeProperty (obj)    %#ok<*MANU>
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function enableOutput(obj, enable)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function enableIQ(obj, enable)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function disableAllModulation(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function sendSoftwareTrigger(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function removeWaveform(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function download(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function start(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function stop(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function varargout = queryArbWaveformCapabilities(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function waitUntilSettled(obj, value)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function value = isSettled(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function varargout = revisionQuery(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  selectWaveform(obj, value)
            obj.cannotChangeProperty();
        end
        
        function delete(obj)
            if isvalid (obj) && ~isempty (obj.Adaptor)
                obj.Adaptor =[];
            end
        end
        
        
        function reset(obj)
            obj.cannotChangeProperty();
        end
        
        
        function connect(obj )
            % CONNECT Iterates through adapter list and use chain of
            % responsibility design pattern to create proper rfsiggen
            % adapter and connect to the instrument.
            
            if isempty (obj.RFSigGen.Resource)
                error (message('instrument:qcinstrument:noResource'));
            end
            
            import instrument.internal.udm.*
            % Use resource info to build rfsiggen adaptor
            if strcmpi (obj.RFSigGen.DriverDetectionMode, 'auto')
                
                [obj.RFSigGen.Adaptor, driver] = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.RFSigGen,obj.RFSigGen.Resource );
                
                obj.RFSigGen.UpdateDriverDetectionMode = false;
                obj.RFSigGen.Driver = driver;
                obj.RFSigGen.UpdateDriverDetectionMode = true;
                
                if isempty(obj.RFSigGen.Adaptor)
                    error (message('instrument:qcinstrument:failToConnectToInstrumentByResource'));
                end
                
            else %  Use resource and driver info to build rfsiggen adaptor
                if isempty (obj.RFSigGen.Driver )
                    error(message('instrument:qcinstrument:needDriverName'));
                end
                
                obj.RFSigGen.Adaptor = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.RFSigGen, obj.RFSigGen.Resource ,obj.RFSigGen.Driver );
                
                if isempty(obj.RFSigGen.Adaptor)
                    error (message('instrument:qcinstrument:failToConnectToInstrumentByResourceAndDriver'));
                end
            end
            
            
            obj.RFSigGen.updateConnectionStatus('open');
            % Switch to StateConnected object.
            obj.RFSigGen.changeState('RFSigGenStateConnected');
            
        end
        
        
        function disconnect(obj)
            obj.cannotChangeProperty();
        end
        
        function set.Frequency(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.Frequency(obj)
            obj.cannotChangeProperty();
        end
        
        function set.PowerLevel(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.PowerLevel(obj)
            obj.cannotChangeProperty();
        end
        
        function set.OutputEnabled(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.OutputEnabled(obj)
            obj.cannotChangeProperty();
        end
        
        function set.IQEnabled(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.IQEnabled(obj)
            obj.cannotChangeProperty();
        end
        
        function set.ClockFrequency(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ClockFrequency(obj)
            obj.cannotChangeProperty();
        end
        
        function set.ArbTriggerSource(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbTriggerSource(obj)
            obj.cannotChangeProperty();
        end
        
        function set.ArbSelectedWaveform(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbSelectedWaveform(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbWaveformQuantum(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbMinWaveformSize(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.Revision(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.FirmwareRevision(obj)
            obj.cannotChangeProperty();
        end
        
        function  configureRF(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  configureIQ(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  configureArbTriggerSource(obj, value)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  selectArbWaveform(obj, value)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  writeArbWaveform(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  clearAllArbWaveforms(obj)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function set.IQSource(obj, value)
            obj.cannotChangeProperty();
            
        end
        
        function value = get.IQSource(obj)
            obj.cannotChangeProperty();
        end
        
        function set.IQSwapEnabled(obj, value)
            obj.cannotChangeProperty();
            
        end
        
        function value = get.IQSwapEnabled(obj)
            obj.cannotChangeProperty();
        end
        
        function disp(obj)
            disp( getString(message('instrument:qcinstrument:noConnection', 'rfsiggen', 'rfsiggen')));
        end
        
    end
end