classdef (Hidden)FGenStateNotConnected <   instrument.internal.udm.fgen.StateFgen
    %StateNotConnected is the state before connection to instrument is established.
    %   StateNotConnected provides state specific behaviors for all
    %   operations when the instrument is not connected.
    
    %    Copyright 2011-2012 The MathWorks, Inc.
    
    properties
        %redefine the abstract properties in StateFgen class
        
        Amplitude
        AMDepth
        ArbWaveformGain
        BurstCount
        Frequency;
        FMDeviation;
        Mode;
        ModulationWaveform
        ModulationFrequency
        ModulationSource
        Offset
        OutputImpedance
        
        TriggerSource;
        StartPhase
        TriggerRate
        Waveform;
        
    end
    
    %Read only properties
    properties (SetAccess = 'private')
        ChannelNames;
        SelectedChannel;
    end
    
    
    methods
        %Constructor
        function obj =  FGenStateNotConnected(fgen)
            %base
            obj@instrument.internal.udm.fgen.StateFgen(fgen);
        end
        
        function cannotChangeProperty (obj)    %#ok<*MANU>
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function enableOutput(obj, enable)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function removeWaveform(obj, varargin)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function downloadWaveform(obj, waveformArray)
            error (message('instrument:qcinstrument:notConnected'));
        end
        
        function  selectChannel(obj, channelName)
            obj.cannotChangeProperty();
        end
        
        function  selectWaveform(obj, channelName)
            obj.cannotChangeProperty();
        end
        
        function value = get.SelectedChannel(obj) %#ok<*STOUT>
            obj.cannotChangeProperty();
        end
        
        function value =get.Amplitude(obj)
            obj.cannotChangeProperty();
        end
        
        function set.Amplitude(obj, value) %#ok<*INUSD>
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
            %Connect method iterates through adapter list and use chain of
            %responsibility design pattern to create proper fgen adapter
            %and connect to the instrument.
            
            if isempty (obj.Fgen.Resource)
                error (message('instrument:qcinstrument:noResource')) ;
            end
            
            import instrument.internal.udm.*
            % use Resource info to build fgen adaptor
            if strcmpi (obj.Fgen.DriverDetectionMode, 'auto')
                
                [obj.Fgen.Adaptor  , driver]   = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.Fgen,obj.Fgen.Resource );
                
                obj.Fgen.UpdateDriverDetectionMode = false;
                obj.Fgen.Driver = driver;
                obj.Fgen.UpdateDriverDetectionMode = true;
                
                if isempty(obj.Fgen.Adaptor)
                    error (message('instrument:qcinstrument:failToConnectToInstrumentByResource')) ;
                end
                
            else %  use Resource and driver info to build fgen adaptor
                if isempty (obj.Fgen.Driver )
                    error(message('instrument:qcinstrument:needDriverName'));
                end
                
                obj.Fgen.Adaptor = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.Fgen, obj.Fgen.Resource ,obj.Fgen.Driver );
                
                if isempty(obj.Fgen.Adaptor)
                    error (message('instrument:qcinstrument:failToConnectToInstrumentByResourceAndDriver')) ;
                end
            end
            
            
            obj.Fgen.updateConnectionStatus('open');
            %switch to StateConnected object.
            obj.Fgen.changeState('FGenStateConnected');
            
        end
        
        
        function disconnect(obj)
            obj.cannotChangeProperty();
        end
        
        function set.TriggerRate(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.TriggerRate(obj)
            obj.cannotChangeProperty();
        end
        
        function value = get.AMDepth(obj)
            obj.cannotChangeProperty();
        end
        
        function  set.AMDepth(obj, value)
            obj.cannotChangeProperty();
        end
        
        
        function channelNames = get.ChannelNames(obj)
            obj.cannotChangeProperty();
        end
        
        
        function set.ArbWaveformGain(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ArbWaveformGain(obj)
            obj.cannotChangeProperty();
        end
        
        function set.BurstCount(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.BurstCount(obj)
            obj.cannotChangeProperty();
        end
        
        function set.Frequency(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.Frequency(obj)
            obj.cannotChangeProperty();
        end
        
        function set.FMDeviation(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.FMDeviation(obj)
            obj.cannotChangeProperty();
        end
        
        function set.ModulationWaveform(obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ModulationWaveform(obj)
            obj.cannotChangeProperty();
        end
        
        
        function set.ModulationFrequency (obj, value)
            obj.cannotChangeProperty();
        end
        
        function value = get.ModulationFrequency (obj)
            obj.cannotChangeProperty();
        end
        
        
        function set.ModulationSource(obj, value)
            obj.cannotChangeProperty();
            
        end
        
        function value = get.ModulationSource(obj)
            obj.cannotChangeProperty();
        end
        
        function set.Offset(obj,  value)
            obj.cannotChangeProperty();
        end
        
        function value = get.Offset(obj)
            obj.cannotChangeProperty();
        end
        
        function  set.OutputImpedance  (obj , value )
            obj.cannotChangeProperty();
        end
        function value = get.OutputImpedance (obj  )
            obj.cannotChangeProperty();
        end
        
        
        function  set.Mode  (obj , value )
            obj.cannotChangeProperty();
        end
        function value = get.Mode (obj  )
            obj.cannotChangeProperty();
        end
        
        function set.TriggerSource(obj, value)
            obj.cannotChangeProperty();
            
        end
        
        function value = get.TriggerSource(obj)
            obj.cannotChangeProperty();
        end
        
        function  set.StartPhase  (obj , value )
            obj.cannotChangeProperty();
        end
        function value = get.StartPhase (obj  )
            obj.cannotChangeProperty();
        end
        
        
        function  set.Waveform  (obj , value )
            obj.cannotChangeProperty();
        end
        function value = get.Waveform (obj  )
            obj.cannotChangeProperty();
        end
        
        
        function disp(obj)
            
            disp( getString(message('instrument:qcinstrument:noConnection', 'fgen', 'fgen')));
        end
        
    end
end