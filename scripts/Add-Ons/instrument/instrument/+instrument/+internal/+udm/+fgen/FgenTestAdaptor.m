classdef (Hidden) FgenTestAdaptor < instrument.internal.udm.fgen.FgenAdaptor
    %FgenTestAdaptor class follows the adaptor design pattern and
    %provides a dummy fgen capability to enable test without
    %real hardware. It is a concrete class which overrides
    %the methods defined in FgenAdaptor class.
    
    % Copyright 2011-2021 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        
        Connected;
        Channels;
        
        ArbWaveformOffset;
        ArbFrequency;
        StdWaveformOffset;
        StdFrequency;
        
        internalArbWaveformGain
        internalAMDepth
        internalBurstCount
        internalFMDeviation
        internalFMWaveform
        internalAMWaveform
        internalFMFrequency
        internalAMFrequency
        internalFMSource
        internalAMSource
        
        % Arb related
        ArbWaveforms;
        WaveformHandle;
        Min_Waveform_Size_ARB;
        Max_Waveform_Size_ARB;
        
    end
    
    
    properties
        %redefines the abstract variables specified in FgenAdaptor class
        Amplitude;
        AMDepth;
        ArbWaveformGain;
        BurstCount;
        Frequency;
        FMDeviation;
        Mode  ;
        ModulationWaveform;
        ModulationFrequency;
        ModulationSource;
        Offset;
        OutputImpedance ;
        TriggerSource;
        StartPhase;
        TriggerRate;
        Waveform ;
        
    end
    
    %Read only properties
    properties (SetAccess = private )
        ChannelNames;
        SelectedChannel;
        
    end
    
    
    methods (Static)
        function [fgenAdapter, driverName] = createByResource(resource)
            
            fgenAdapter =[];
            driverName = '';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.fgen.FgenTestAdaptor
            try
                if strcmpi(resource, 'testresource')
                    
                    driverName = 'testdriver';
                    fgenAdapter = feval(str2func('instrument.internal.udm.fgen.FgenTestAdaptor') ,driverName, resource);
                end
            catch e
                %In case an test adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
            end
        end
        
        function [fgenAdapter, driverName] = createByDriverAndResource( driver, resource)
            fgenAdapter =[];
            driverName = '';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.fgen.FgenTestAdaptor
            try
                if strcmpi(driver, 'testdriver')
                    driverName ='testdriver';
                    fgenAdapter = feval(str2func('instrument.internal.udm.fgen.FgenTestAdaptor') ,driver, resource);
                end
            catch e %#ok<*NASGU>
                %In case an test adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
            end
        end
        
        function driverInfo = getDriver()
            driverInfo ={};
            testDriver.Name ='testDriver';
            testDriver.type ='test';
            testDriver.SupportedInstrumentModels ='Dummy';
            driverInfo{end+1}= testDriver;
        end
        
        function resource = getResource(varargin)
            resource = 'testresource';
        end
    end
    
    methods
        function obj = FgenTestAdaptor(~, ~ )
            
            obj.Channels =  containers.Map ();
            obj.ArbWaveforms =  containers.Map('KeyType', 'int32', 'ValueType', 'any');
            
            % channel initial parameters
            channel.Mode ='AM';
            channel.Offset = 1.0;
           
            %init channels
            for i = 1: 2
                % set up channel names
                key = sprintf('%d', i);
                obj.Channels(key) = channel;
            end
            
            obj.reset();
            
            obj.connect();
            
        end
        
        
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            if obj.Connected
                manufacturer = 'TMW' ;
                model = 'Dummy Fgen';
                textToDisp = sprintf ('%s %s.',manufacturer, model);
            end
            value =  textToDisp ;
            
        end
        
        function delete(obj)
            obj.Channels=[];
        end
        
        
        function channelNames = get.ChannelNames(obj) %#ok<*MANU>
            
            channelNames = cell(1, 2);
            for i = 1: 2
                channelNames{i}  =  sprintf('%d', i) ;
            end
            
        end
        
        
        
        function enableOutput(obj, enable)
            
            if (~enable)
                return;
            end
            
            WaveformLength = 1000;
            import instrument.internal.udm.fgen.*
            if obj.Waveform == WaveformEnum.Sine
                data = sin(linspace(0, 2*pi, WaveformLength));

            elseif obj.Waveform == WaveformEnum.Square
                data = sin(linspace(0, 2*pi, WaveformLength));
            elseif obj.Waveform == WaveformEnum.Arb
                % complex Arb waveform
                time = 0:0.001:1; % Define time vector to contain whole number of cycles of waveform
                Amp1 = 0.2; % Amplitude for each component of waveform
                Amp2 = 0.8;
                Amp3 = 0.6;
                frequency1 = 10; % Frequency for each component of waveform
                frequency2 = 14;
                frequency3 = 18;
                wave1 = Amp1*sin(2*pi*frequency1*time); % Waveform component 1
                wave2 = Amp2*sin(2*pi*frequency2*time); % Waveform component 2
                wave3 = Amp3*sin(2*pi*frequency3*time); % Waveform component 3
                wave = wave1 + wave2 + wave3; % Some combination of individual waveforms
                wave = wave + 0.3*rand(1,size(wave,2)); % Now add random noise into the signal
                data = (wave./max(wave))'; % Normalize so values are between -1 to + 1

            end
            
        end
        
        function removeWaveform(obj, waveformHandle)
            
            if isempty (obj.ArbWaveforms) || ~isKey(obj.ArbWaveforms,waveformHandle)
                  error (message ('instrument:fgen:needWaveformHandle'));
            else
                remove(obj.ArbWaveforms,waveformHandle) ;
            end
        end
        
         
        
        function varargout = downloadWaveform(obj, WaveformDataArray)
            
            narginchk(2,2);
            classes = {'numeric'};
            attributes = {'finite' };
            validateattributes(WaveformDataArray,classes,attributes)
            
            % check waveform min and max size
            minsize =  obj.Min_Waveform_Size_ARB;
            maxsize =  obj.Max_Waveform_Size_ARB;
            WaveformSize = length (WaveformDataArray);
            
            if WaveformSize > maxsize ||   WaveformSize < minsize
                error (message ('instrument:fgen:wrongWaveformSize', minsize , maxsize));
            end
            
            
            % normalize the waveform so values are between -1 to + 1
            if  max ( abs (WaveformDataArray )) ~= 0
                WaveformDataArray =  ( WaveformDataArray./ max (WaveformDataArray ))';
            end
            
            % create a Arb waveform
            if length (obj.ArbWaveforms) >=4
                error (message ('instrument:fgen:noMemorySpace'));
            else
                waveformHandle = length( obj.ArbWaveforms)+ 1 ;
                obj.ArbWaveforms(waveformHandle) = WaveformDataArray ;
            end
            if nargout == 0
                obj.WaveformHandle = waveformHandle;
            else
                tempOut = cell(1, 1);
                [tempOut{:}] = waveformHandle;
                varargout = tempOut;
            end
            
        end
        
        function selectWaveform(obj, waveformHandle)
            import instrument.internal.udm.fgen.*
            if obj.Waveform == WaveformEnum.Arb
                
                if  isempty (waveformHandle)
                    error (message ('instrument:fgen:needWaveformHandle'));
                end
                
            else
                error (message ('instrument:fgen:ArbWaveformOnly'));
                
            end
            
        end
        
        function  selectChannel(obj, channelName)
            obj.validateChannelName(channelName);
            obj.SelectedChannel = channelName ;
        end
        
        
        function value = get.SelectedChannel(obj)
            value = obj.SelectedChannel;
        end
        function value =get.Amplitude(obj)
            
            value = obj.Amplitude;
        end
        
        function set.Amplitude(obj, value)
            
            obj.Amplitude = value;
            
        end
        
        
        function reset(obj)
            
            try
                
                import instrument.internal.udm.fgen.*;
                obj.Mode = ModeEnum.AM;
                obj.Waveform = WaveformEnum.Sine ;
                
                obj.OutputImpedance = 50;
                obj.Amplitude = 10;
                %
                obj.TriggerSource = TriggerSourceEnum.Internal;
                obj.StartPhase = 0;
                obj.TriggerRate = 1000;
                
                %internal use
                obj.ArbWaveformOffset = 0;
                obj.ArbFrequency  = 1000;
                obj.StdWaveformOffset = 0;
                obj.StdFrequency = 2000;
                obj.internalAMDepth = 0;
                obj.internalArbWaveformGain = 0;
                obj.internalBurstCount = 1;
                obj.internalFMDeviation = 0;
                obj.internalAMWaveform = WaveformEnum.Sine;
                obj.internalAMFrequency = 500;
                obj.internalAMSource = ModulationSourceEnum.Internal;
                obj.internalFMWaveform = WaveformEnum.Sine;
                obj.internalFMFrequency = 500;
                obj.internalFMSource = ModulationSourceEnum.Internal;
                
                
                obj.Min_Waveform_Size_ARB = 2;
                obj.Max_Waveform_Size_ARB = 10000;
            catch e
                disp (e.message)
            end
        end
        
        function disconnect(obj)
            obj.reset();
            
        end
        
        
        function value = get.AMDepth(obj) %#ok<*STOUT>
            value = obj.AMDepth ;
        end
        
        function  set.AMDepth(obj, value)   %#ok<*INUSD>
            obj.AMDepth = value;
            
        end
        
        
        function value = get.Waveform (obj)
            value = obj.Waveform;
        end
        
        
        function  set.Waveform(obj,  value)
            
            import instrument.internal.udm.fgen.*;
            if value == WaveformEnum.None
                obj.Waveform = WaveformEnum.None ;
                return;
            end
            obj.Waveform = value;
            
        end
        
        function set.ArbWaveformGain(obj, value)
            if isequal(lower(char(obj.Waveform)),'arb')
                obj.internalArbWaveformGain = value;
            else
                error(message('instrument:fgen:ArbWaveformOnly'));
            end
        end
        
        function value = get.ArbWaveformGain(obj)
            
            value =  obj.internalArbWaveformGain;
            
        end
        
        function set.BurstCount(obj, value)
            
            obj.internalBurstCount = value;
            
        end
        
        function value = get.BurstCount(obj)
            
            value =  obj.internalBurstCount;
            
        end
        
        function set.Frequency(obj, value)
            import instrument.internal.udm.fgen.*;
            if  obj.Waveform == WaveformEnum.Arb
                obj.ArbFrequency = value;
            else
                obj.StdFrequency = value;
                
            end
        end
        
        function value = get.Frequency(obj)
            import instrument.internal.udm.fgen.*;
            if  obj.Waveform == WaveformEnum.Arb
                value = obj.ArbFrequency ;
            else
                value = obj.StdFrequency ;
                
            end
        end
        
        function set.FMDeviation(obj, value)
            
            obj.internalFMDeviation = value;
            
        end
        
        function value = get.FMDeviation(obj)
            value = obj.internalFMDeviation ;
        end
        
        function set.ModulationWaveform(obj, value)
            
            if strcmpi (obj.Mode, 'FM')
                obj.internalFMWaveform = value;
            elseif strcmpi ( obj.Mode , 'AM' )
                obj.internalAMWaveform = value;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        function value = get.ModulationWaveform(obj)
            
            if strcmpi (obj.Mode, 'FM')
                value = obj.internalFMWaveform ;
            elseif strcmpi ( obj.Mode , 'AM' )
                value = obj.internalAMWaveform ;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            import instrument.internal.udm.fgen.*
            value = WaveformEnum.getString(value);           
        end
        
        function set.TriggerSource(obj, value)
            obj.TriggerSource = value ;
            
        end
        
        
        
        function value = get.TriggerSource(obj)
            value =  obj.TriggerSource ;
            import instrument.internal.udm.fgen.*
            value = TriggerSourceEnum.getString(value);
        end
        
        
        function set.ModulationFrequency (obj, value)
            
            if strcmpi (obj.Mode, 'FM')
                obj.internalFMFrequency = value ;
            elseif strcmpi( obj.Mode , 'AM')
                obj.internalAMFrequency = value;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        function value = get.ModulationFrequency (obj)
            
            if strcmpi (obj.Mode, 'FM')
                value = obj.internalFMFrequency ;
            elseif strcmpi( obj.Mode , 'AM')
                value = obj.internalAMFrequency ;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        
        function set.ModulationSource(obj, value)
            
            if strcmpi (obj.Mode, 'FM')
                obj.internalFMSource = value ;
            elseif strcmpi( obj.Mode , 'AM')
                obj.internalAMSource = value;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            
        end
        
        function value = get.ModulationSource(obj)
            
            if strcmpi (obj.Mode, 'FM')
                value = obj.internalFMSource ;
            elseif strcmpi( obj.Mode , 'AM')
                value = obj.internalAMSource ;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            import instrument.internal.udm.fgen.*
            value = ModulationSourceEnum.getString(value);
        end
        
        function set.Offset(obj,  value)
            if strcmpi (obj.Waveform , 'arb')
                obj.ArbWaveformOffset = value ;
            else
                obj.StdWaveformOffset = value;
            end
        end
        
        function value = get.Offset(obj)
            if strcmpi (obj.Waveform , 'arb')
                value = obj.ArbWaveformOffset ;
            else
                value = obj.StdWaveformOffset;
            end
        end
        
        function  set.OutputImpedance  (obj , value )
            obj.OutputImpedance = value ;
        end
        function value = get.OutputImpedance (obj  )
            value =  obj.OutputImpedance ;
        end
        
        
        function  set.Mode  (obj , value )
            obj.Mode = value ;
        end
        
        function value = get.Mode (obj  )
            import instrument.internal.udm.fgen.*
            
            value = ModeEnum.getString (obj.Mode);
        end
        
        function  set.StartPhase  (obj , value )
            obj.StartPhase = value;
            
        end
        
        function value = get.StartPhase (obj  )
            
            value = obj.StartPhase;
        end
        
        
        
        function enableChannel(obj, channelName, enable)
            
            obj.validateChannelName(channelName);
            
            if isempty(obj.ChannelsEnabled) && enable
                obj.ChannelsEnabled{end+1}  = channelName;
            end
            
            for i = 1: size (obj.ChannelsEnabled, 2)
                if enable
                    [tf, ~]= ismember (channelName, obj.ChannelsEnabled);
                    if ~tf
                        obj.ChannelsEnabled{end+1}  = channelName;
                        break;
                    end
                end
                
                if ~enable
                    
                    [tf, loc]= ismember (channelName , obj.ChannelsEnabled );
                    if tf
                        obj.ChannelsEnabled(loc)  = [];
                        break;
                    end
                end
            end
        end
        
    end
    
    methods  (Access = protected)
        function connect(obj)
            
            obj.Connected  = true;
            
        end
    end
    
    methods(Access = private, Hidden = true)
        
        % helper function to get channel object
        function channel = getChannel(obj, channelName )
            
            obj.validateChannelName(channelName);
            channel = obj.Channels(channelName);
            
        end
    end
    
    methods (Static )
        
        function unitTest
            resource = 'testResource';
            f = instrument.internal.udm.fgen.FgenTestAdaptor.createByResource (resource);
        end
    end
    
    
end
