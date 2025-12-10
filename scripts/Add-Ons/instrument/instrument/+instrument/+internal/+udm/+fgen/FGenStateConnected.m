classdef(Hidden)FGenStateConnected <  instrument.internal.udm.fgen.StateFgen
    %StateConnected is the state after connection is setup.
    %   StateConnected provides state specific behaviors for all
    %   operations when the instrument has been connected. Most of the
    %   operations are delegated to the underlying adapter to handle.
    
    %    Copyright 2011-2016 The MathWorks, Inc.
    properties
        %redefine the abstract properties in StateFgen class
        Amplitude;
        AMDepth;
        ArbWaveformGain;
        BurstCount;
        Frequency;
        FMDeviation;
        Mode;
        ModulationWaveform;
        ModulationFrequency;
        ModulationSource;
        Offset;
        OutputImpedance;
        
        TriggerSource;
        StartPhase;
        TriggerRate;
        
        Waveform;        
    end
    
    %Read only properties
    properties (SetAccess = 'private')
        ChannelNames;
        SelectedChannel;
    end
    
    methods
        %constructor
        function obj =  FGenStateConnected(fgen)
            % base constructor
            obj@instrument.internal.udm.fgen.StateFgen(fgen);
        end
        
        function enableOutput(obj, enable)
            obj.Fgen.Adaptor.enableOutput(enable);
        end
        
        function removeWaveform(obj, varargin)
            
            % waveformHandle has to be numeric value
            if ~isempty (varargin)
                waveformHandle = varargin{1};
                validateattributes(waveformHandle,{'numeric'}, {'scalar','finite','integer','nonnan','>' , 0 });
            end
                
            obj.Fgen.Adaptor.removeWaveform(varargin{:});
        end
        
        function varargout = downloadWaveform(obj, waveformArray)
            validateattributes(waveformArray,{'numeric'}, {'vector','finite'});
            if nargout == 0
              obj.Fgen.Adaptor.downloadWaveform(waveformArray);

            else
                waveformHandle = obj.Fgen.Adaptor.downloadWaveform(waveformArray);
                tempOut = cell(1, 1);
                [tempOut{:}] = waveformHandle;
                varargout = tempOut;
            end
        end
        
        function selectWaveform(obj, waveformHandle)
            validateattributes(waveformHandle,{'numeric'},{'scalar','finite','integer','nonnan','>',0});
            obj.Fgen.Adaptor.selectWaveform(waveformHandle);
        end
        
        function  selectChannel(obj, channelName)
            narginchk(2,2);
            obj.checkScalarStringArg(channelName);
            obj.Fgen.Adaptor.selectChannel(channelName);
        end
                
        function value = get.SelectedChannel(obj)
            value = obj.Fgen.Adaptor.SelectedChannel;
        end
        function value =get.Amplitude(obj)
            value = obj.Fgen.Adaptor.Amplitude;
        end
        
        function set.Amplitude(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite'});
            obj.Fgen.Adaptor.Amplitude = value;
            realValue = obj.Fgen.Adaptor.Amplitude;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function delete(obj)
            if isvalid (obj) && ~isempty (obj.Adaptor)
                obj.Fgen.Adaptor = [];
            end
        end
        
        function reset(obj)
            obj.Fgen.Adaptor.reset();
        end
        
        
        function connect(obj ) %#ok<*MANU>
             error (message('instrument:qcinstrument:alreadyConnected'));
        end
        
        function disconnect(obj)
            obj.Fgen.Adaptor.disconnect();
            obj.Fgen.Adaptor = [];
            obj.Fgen.updateConnectionStatus('closed');
            %switch to StateNotConnected object.
            obj.Fgen.changeState('FGenStateNotConnected');            
        end        
        
        function value = get.AMDepth(obj) %#ok<*STOUT>
            value = obj.Fgen.Adaptor.AMDepth;
        end
        
        function  set.AMDepth(obj, value)   %#ok<*INUSD>
            validateattributes(value,{'numeric'}, {'scalar','finite','>=' , 0, '<=', 100});
            obj.Fgen.Adaptor.AMDepth = value;
            realValue = obj.Fgen.Adaptor.AMDepth;
            instrument.internal.util.checkSetValue(value, realValue);            
        end
                
        function channelNames = get.ChannelNames(obj)   %#ok<*STOUT,*MANU>
            channelNames = obj.Fgen.Adaptor.ChannelNames ;
        end
                
        function set.ArbWaveformGain(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.Fgen.Adaptor.ArbWaveformGain = value;
            realValue = obj.Fgen.Adaptor.ArbWaveformGain;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.ArbWaveformGain(obj)
            value = obj.Fgen.Adaptor.ArbWaveformGain;
        end
        
        function set.BurstCount(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.Fgen.Adaptor.BurstCount = value;
            realValue = obj.Fgen.Adaptor.BurstCount;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.BurstCount(obj)
            value = obj.Fgen.Adaptor.BurstCount;
        end
        
        function set.Frequency(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.Fgen.Adaptor.Frequency = value;
            realValue = obj.Fgen.Adaptor.Frequency;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.Frequency(obj)
            value = obj.Fgen.Adaptor.Frequency;
        end
        
        function set.FMDeviation(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','>=' , 0});
            obj.Fgen.Adaptor.FMDeviation = value;
            realValue = obj.Fgen.Adaptor.FMDeviation;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.FMDeviation(obj)
            value = obj.Fgen.Adaptor.FMDeviation;
        end
        
        function set.ModulationWaveform(obj, value)
            obj.checkScalarStringArg(value);
            import instrument.internal.udm.fgen.*;
            obj.Fgen.Adaptor.ModulationWaveform = ModulationWaveformEnum.getEnum(value);
        end
        
        function value = get.ModulationWaveform(obj)

            value = obj.Fgen.Adaptor.ModulationWaveform;
        end
        
        function set.TriggerSource(obj, value)
            obj.checkScalarStringArg(value);
            import instrument.internal.udm.fgen.*;
            obj.Fgen.Adaptor.TriggerSource = TriggerSourceEnum.getEnum(value);
        end
        
        function value = get.TriggerSource(obj)
            value = obj.Fgen.Adaptor.TriggerSource;
        end
        
        function set.TriggerRate(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.Fgen.Adaptor.TriggerRate = value;
            realValue = obj.Fgen.Adaptor.TriggerRate;
            instrument.internal.util.checkSetValue(value, realValue);           
        end
        
        function value = get.TriggerRate(obj)
            value = obj.Fgen.Adaptor.TriggerRate;
        end        
        
        function set.ModulationFrequency(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','positive'});
            obj.Fgen.Adaptor.ModulationFrequency = value;
            realValue = obj.Fgen.Adaptor.ModulationFrequency;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.ModulationFrequency(obj)
            value = obj.Fgen.Adaptor.ModulationFrequency;
        end
                
        function set.ModulationSource(obj, value)
            obj.checkScalarStringArg(value);
            import instrument.internal.udm.fgen.*;
            obj.Fgen.Adaptor.ModulationSource = ModulationSourceEnum.getEnum( value);            
        end
        
        function value = get.ModulationSource(obj)
            value = obj.Fgen.Adaptor.ModulationSource;
        end
        
        function set.Offset(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite'});
            obj.checkScalarDoubleArg(value);
            obj.Fgen.Adaptor.Offset = value;
            realValue = obj.Fgen.Adaptor.Offset;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.Offset(obj)
            value = obj.Fgen.Adaptor.Offset;
        end
        
        function  set.OutputImpedance(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','nonnegative'});
            obj.Fgen.Adaptor.OutputImpedance = value;
            realValue = obj.Fgen.Adaptor.OutputImpedance;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.OutputImpedance (obj)
            value = obj.Fgen.Adaptor.OutputImpedance;
        end        
        
        function  set.Mode(obj, value)
            obj.checkScalarStringArg(value);
            import instrument.internal.udm.fgen.*
            obj.Fgen.Adaptor.Mode = ModeEnum.getEnum(value);
        end
        
        function value = get.Mode(obj)
            value = obj.Fgen.Adaptor.Mode;
        end
        
        function  set.StartPhase(obj, value)
            validateattributes(value,{'numeric'}, {'scalar','finite','>=', 0, '<=', 360});
            obj.Fgen.Adaptor.StartPhase = value;
            realValue = obj.Fgen.Adaptor.StartPhase;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.StartPhase(obj)
            value = obj.Fgen.Adaptor.StartPhase;
        end
        
        function  set.Waveform(obj , value)
            import instrument.internal.udm.fgen.*;
            obj.checkScalarStringArg(value);
            obj.Fgen.Adaptor.Waveform = WaveformEnum.getEnum(value);
        end
        
        function  value = get.Waveform(obj)
            import instrument.internal.udm.fgen.*;
            value = WaveformEnum.getString(obj.Fgen.Adaptor.Waveform );
        end
        
    end
end