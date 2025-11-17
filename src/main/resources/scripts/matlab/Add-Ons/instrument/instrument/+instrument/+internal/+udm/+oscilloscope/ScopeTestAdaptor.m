classdef (Hidden) ScopeTestAdaptor < instrument.internal.udm.oscilloscope.ScopeAdaptor
    %ScopeTestAdaptor class follows the adaptor design pattern and
    %provides a dummy oscilloscope capability to enable test without
    %real hardware. It is a concrete class which overrides
    %the methods defined in ScopeAdaptor class.
    
    % Copyright 2011-2021 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        
        Connected;
        Channels;
        
    end
    
    
    properties
        %redefines the abstract variables specified in ScopeAdaptor class
        AcquisitionTime = 0.1;
        AcquisitionStartDelay =0.0;
        WaveformLength = 1000  ;
        
        TriggerSource = 'Channel1';
        TriggerSlope = 'rising';
        TriggerLevel =  0.1;
        TriggerMode ='auto';
        SingleSweepMode = 0;
        
    end
    
    %Read only properties
    properties (SetAccess = private )
        ChannelNames;
        ChannelsEnabled;
    end
    
    
    methods (Static)
        function [scopeAdapter, driverName] = createByResource(resource)
            
            scopeAdapter =[];
            driverName = '';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.oscilloscope.ScopeTestAdaptor
            try
                if strcmpi(resource, 'testresource')
                    
                    driverName = 'testdriver';
                    scopeAdapter = feval(str2func('instrument.internal.udm.oscilloscope.ScopeTestAdaptor') ,driverName, resource);
                end
            catch e
                %In case an test adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
                scopeAdapter = [];
                driverName ='';
            end
        end
        
        function [scopeAdapter, driverName] = createByDriverAndResource( driver, resource)
            scopeAdapter =[];
            driverName = '';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.oscilloscope.ScopeTestAdaptor
            try
                if strcmpi(driver, 'testdriver')
                    driverName ='testdriver';
                    scopeAdapter = feval(str2func('instrument.internal.udm.oscilloscope.ScopeTestAdaptor') ,driver, resource);
                end
            catch e %#ok<*NASGU>
                %In case an test adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
                scopeAdapter = [];
                driverName ='';
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
        function obj = ScopeTestAdaptor(~, ~ )
            
            obj.ChannelsEnabled ={};
            obj.ChannelsEnabled {end+ 1} = 'Channel1';
            
            obj.Channels =     containers.Map ();
            
            % channel initial parameters
            channel.Coupling ='AC';
            channel.Offset = 0.1;
            channel.Range = 0.2;
            channel.ProbeAttenuation = 1;
            
            %init channels
            for i = 1: 4
                % set up channel names
                key = sprintf('Channel%d', i);
                obj.Channels(key) = channel;
            end
            
            obj.connect();
            
        end
        
        
        
        function delete(obj)
            obj.Channels=[];
        end
        
        function autoSetup(obj)
            
        end
        
        function value = get.SingleSweepMode(obj)
            value =  obj.SingleSweepMode ;
            import instrument.internal.udm.oscilloscope.*
            if strcmpi (value, 'on')
                value = SingleSweepModeEnum.On;
            else
                value = SingleSweepModeEnum.Off;
            end
        end
        
        
        function set.SingleSweepMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == SingleSweepModeEnum.On
                obj.SingleSweepMode = 'on';
            else
                obj.SingleSweepMode = 'off';
            end
            
        end
        
        function channelNames = get.ChannelNames(obj) %#ok<*MANU>
            
            channelNames = cell(1, 4);
            for i = 1: 4
                channelNames{i}  =  sprintf('Channel%d', i) ;
            end
            
        end
        
        function value = get.ChannelsEnabled(obj)
            
            value = obj.ChannelsEnabled;
            
        end
        
        function value = get.TriggerMode(obj)
            
            value = obj.TriggerMode;
            
        end
        
        function set.TriggerMode(obj, value)
            obj.TriggerMode = value;
        end
        
        
        function disconnect(obj)
            obj.Connected  = false;
        end
        
        function reset(obj)
            
            obj.ChannelsEnabled ={};
            obj.ChannelsEnabled {end + 1} = 'Channel1';
            obj.TriggerMode = 'auto';
            
        end
        
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            if obj.Connected
                manufacturer = 'TMW' ;
                model = 'Dummy Scope';
                textToDisp = sprintf ('%s %s.',manufacturer, model);
            end
            value =  textToDisp ;
            
        end
        
        
        
        function set.WaveformLength(obj, value)
            
            obj.WaveformLength = value;
            
        end
        
        function value = get.WaveformLength(obj)
            value = obj.WaveformLength ;
        end
        
        
        function  setVerticalControl(obj, channelName, controlName, value)
            
            
            channel = obj.getChannel(channelName);
            import instrument.internal.udm.oscilloscope.*;
            switch controlName
                case  VerticalControlEnum.Coupling                    
                    channel.Coupling = value;                    
                case VerticalControlEnum.Offset
                    channel.Offset = value;
                case VerticalControlEnum.Range
                    channel.Range = value;
                case VerticalControlEnum.ProbeAttenuation
                    channel.ProbeAttenuation = value;
                    
            end
            %update map
            obj.Channels(channelName)= channel;
        end
        
        
        function value = getVerticalControl(obj, channelName, controlName)
            channel = obj.getChannel(channelName);
            import instrument.internal.udm.oscilloscope.*
            switch controlName
                case VerticalControlEnum.Coupling
                    value =    channel.Coupling   ;
                case VerticalControlEnum.Offset
                    value =  channel.Offset;
                case VerticalControlEnum.Range
                    value = channel.Range ;
                case VerticalControlEnum.ProbeAttenuation
                    value = channel.ProbeAttenuation ;
                    
            end
        end
        
        
        
        %% trigger related controls
        
        function set.TriggerLevel(obj, value)
            obj.TriggerLevel = value ;
        end
        
        
        function value = get.TriggerLevel(obj)
            value = obj.TriggerLevel ;
        end
        
        function set.TriggerSlope(obj, value)
            obj.TriggerSlope  = value;
            
        end
        
        function value = get.TriggerSlope(obj)
            value = obj.TriggerSlope ;
            
        end
        
        function value = get.TriggerSource(obj)
            value = obj.TriggerSource ;
        end
        
        function  set.TriggerSource(obj, value)
            obj.TriggerSource = value;
        end
        
        %% horizontal controls
        function set.AcquisitionTime(obj, value)
            obj.AcquisitionTime = value;
        end
        
        function value = get.AcquisitionTime(obj)
            value = obj.AcquisitionTime;
        end
        
        function set.AcquisitionStartDelay(obj, value)
            obj.AcquisitionStartDelay = value;
        end
        
        function value = get.AcquisitionStartDelay(obj)
            
            value = obj.AcquisitionStartDelay;
            
        end
        
        
        %% read waveform
        function WaveformArray = readWaveform(obj, channelName, timtout ) %#ok<*INUSD>
            
            obj.validateChannelName(channelName);
            switch channelName
                case 'Channel1'
                    WaveformArray = sin(linspace(0, 2*pi, obj.WaveformLength))';
                case 'Channel2'
                    WaveformArray = sin(linspace(0, 4*pi, obj.WaveformLength))';
                case 'Channel3'
                    WaveformArray = sin(linspace(0, 6*pi, obj.WaveformLength))';
                case 'Channel4'
                    WaveformArray = sin(linspace(0, 8*pi, obj.WaveformLength))';
            end
            
        end
        
        %% fetch waveform
        function WaveformArray = fetchWaveform(obj, channelName )
            
            obj.validateChannelName(channelName);
            switch channelName
                case 'Channel1'
                    WaveformArray = sin(linspace(0, 2*pi, obj.WaveformLength))';
                case 'Channel2'
                    WaveformArray = sin(linspace(0, 2*pi, obj.WaveformLength))'/2;
                case 'Channel3'
                    WaveformArray = sin(linspace(0, 2*pi, obj.WaveformLength))'/4;
                case 'Channel4'
                    WaveformArray = sin(linspace(0, 2*pi, obj.WaveformLength))'/8;
            end
            
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
    
end
