classdef IEEE4882FgenAdaptor < instrument.internal.udm.fgen.FgenAdaptor
    %IEEE4882FgenAdaptor class follows the adaptor design pattern and provides
    %bridge between interface fgen wrapper and fgen's state machine.
    %It is a concrete class which overrides the methods defined in FgenAdaptor class.
    
    % Copyright 2012-2017 The MathWorks, Inc.
    
    properties (Access = private)
        %A instance of instrument.ieee4882.fgen class
        IEEE4882Fgen
        %InternalWaveformHandle maintains the waveform handle
        %when user all downloadWaveForm with giving LHS argument
        InternalWaveformHandle;
    end
    
    %Read only properties
    properties (SetAccess = private)
        ChannelNames;
        SelectedChannel;
    end
    
    properties (Dependent, Access = public)
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
        Waveform;
    end
    
    methods (Static)
        function [fgenAdapter, driverName] = createByResource(resource)
            %CreateByResource static method tries to create a IEEE4882 adapter based on the
            %resource info.
            fgenAdapter = [];
            driverName ='';
            FirmwareVersion = '';
            try
                %calls the constructor
                fgenAdapter = instrument.internal.udm.fgen.IEEE4882FgenAdaptor('', resource);
                driverName = fgenAdapter.IEEE4882Fgen.DriverName;
            catch e %#ok<*NASGU>
                %In case an ieee488.2 adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
            end
            
        end
        
        function [fgenAdapter, driver] = createByDriverAndResource( driverName, resource)
            %CreateByDriverAndResource static method tries to create an interface adapter based on the
            %resource and driver name.
            fgenAdapter =[];
            driver ='';
            % Get list of IEEE488.2 drivers for FGen class instruments
            supportedIEEE4882Drivers = instrument.ieee4882.DriverUtility.getDrivers('fgen');
            for iLoop = 1:length(supportedIEEE4882Drivers)
                % If the drivername matches the user supplied drivername,
                % then try to instantiate. Else, this function will return
                % an empty adapter
                if isequal(driverName,supportedIEEE4882Drivers{iLoop}.Name)
                    try
                        %calls the constructor
                        fgenAdapter = instrument.internal.udm.fgen.IEEE4882FgenAdaptor (driverName, resource);
                        %break out of the loop if the constructor returned
                        %successfully
                        break
                    catch e
                        %In case an ieee488 adapter instance can not be instantiated, an empty adapter
                        %is returned. It hands over the responsibility to the next adapter.
                    end
                end
            end
        end
        
        function driverInfo = getDriver()
            %GetDriver static method delegate the job to
            %DriverUtility and find out the ieee488.2 specific fgen drivers
            driverInfo = instrument.ieee4882.DriverUtility.getDrivers('fgen');
        end
        
        function resource = getResource(varargin)
            %GetResource static method discovers the resource based on
            %resource discovery methods defined in adapters.config file
            resource ={};
            resourceType = lower(varargin{1});
            switch(resourceType)
                case 'visa'
                    visaResource = instrument.internal.udm.InstrumentUtility.getVisaResources;
                    resource = horzcat(resource, visaResource);
                case {'tcpip','serial','gpib'}
                    interfaceResource = instrument.ieee4882.DriverUtility.getResourceByType(resourceType);
                    resource = horzcat(resource, interfaceResource);
            end
        end
    end
    
    methods
        %Constructor
        function obj = IEEE4882FgenAdaptor(driverName, resource )
            %since the adapter is created upon fgen's connect() method
            %it should automatically call connect()
            obj.IEEE4882Fgen =  instrument.ieee4882.Fgen(resource);
            if ~isempty ( driverName ) % overwrite driver name
                obj.IEEE4882Fgen.DriverName = driverName;
            end
            obj.connect();
        end
        
        function delete(obj)
            if ~isempty (obj.IEEE4882Fgen)
                % disconnect the instrument first
                obj.disconnect();
                obj.IEEE4882Fgen =[];
            end
        end
        
        function reset(obj)
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.Utility.reset();
        end
        
        function disconnect(obj)        

            if ~isempty (obj.InternalWaveformHandle)
                try
                    % remove the waveform using waveform handle
                    obj.IEEE4882Fgen.WaveformSubsystem.clearArbWaveform(obj.InternalWaveformHandle);
                catch myException
                    % We could be here since the user manually deleted the
                    % waveform using the instrument front panel. In this
                    % case, silently delete the object
                end
            end
            
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.disconnect();
        end
        
        function value = getInstrumentInfo(obj)
            if obj.IEEE4882Fgen.Connected
                % Query underlying adaptor
                [manufacturer, model] = obj.IEEE4882Fgen.Utility.getInstrumentInfo();
                value = sprintf ('%s %s.', strtrim(manufacturer), strtrim(model));
            else
                value = '';
            end
        end
        
        function selectChannel(obj , channelName)
            obj.validateChannelName (channelName );
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.ChannelSubsystem.selectChannel(channelName);
        end
        
        function value = get.SelectedChannel (obj)
            % Dispatch call to underlying adaptor
            value = obj.IEEE4882Fgen.ChannelSubsystem.SelectedChannel;
        end
        
        function value = validateSelectedChannel (obj)
            % Check to see there is a selected channel and report the value
            if isempty (obj.SelectedChannel)
                error (message ('instrument:fgen:needToSelectChannel'));
            else
                value = obj.SelectedChannel;
            end
        end
        
        function channelNames = get.ChannelNames (obj)
            % Query the underlying adaptor
            channelNames = obj.IEEE4882Fgen.ChannelSubsystem.ChannelNames;
        end
        
        function value = get.OutputImpedance( obj)
            channelName = obj.validateSelectedChannel;
            % Query the underlying adaptor
            value = obj.IEEE4882Fgen.ChannelSubsystem.getOutputImpedance;
        end
        
        function set.OutputImpedance( obj,  value)
            channelName = obj.validateSelectedChannel;
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.ChannelSubsystem.setOutputImpedance(value);
        end
        
        function value = get.Amplitude(obj)
            channelName = obj.validateSelectedChannel;
            % Query the underlying adaptor
            value = obj.IEEE4882Fgen.ChannelSubsystem.getAmplitude;
        end
        
        function  set.Amplitude(obj, value)
            channelName = obj.validateSelectedChannel;
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.ChannelSubsystem.setAmplitude(value)
        end
        
        function enableOutput(obj, enable)
            channelName = obj.validateSelectedChannel;
            if isequal(enable,true)
                % Dispatch call to underlying adaptor
                obj.IEEE4882Fgen.ChannelSubsystem.enableOutput;
            elseif isequal(enable,false)
                % Dispatch call to underlying adaptor
                obj.IEEE4882Fgen.ChannelSubsystem.disableOutput;
            end
        end
        
        function value = get.BurstCount(obj)
            channelName = obj.validateSelectedChannel;
            % Query the underlying adaptor
            value = obj.IEEE4882Fgen.TriggerSubsystem.getBurstCount;
        end
        
        function  set.BurstCount(obj, value)
            channelName = obj.validateSelectedChannel;
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.TriggerSubsystem.setBurstCount(value);
        end
        
        function value = get.TriggerRate(obj)
            % Query the underlying adaptor
            value = obj.IEEE4882Fgen.TriggerSubsystem.getTriggerRate;
        end
        
        function  set.TriggerRate(obj,  newValue)
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.TriggerSubsystem.setTriggerRate(newValue);
        end
        
        function value = get.TriggerSource(obj)
            channelName = obj.validateSelectedChannel;
            % Query the underlying adaptor
            instrumentValue = obj.IEEE4882Fgen.TriggerSubsystem.getTriggerSource;
            import instrument.internal.udm.fgen.*;
            value = TriggerSourceEnum.getString(instrumentValue);
        end
        
        function  set.TriggerSource(obj, value)
            channelName = obj.validateSelectedChannel;
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.TriggerSubsystem.setTriggerSource(value);
        end
        
        function mode = get.Mode (obj )
            import instrument.internal.udm.fgen.*
            mode = ModeEnum.NotSupported;
            channelName = obj.validateSelectedChannel;
            % Query underlying adaptor ans set internal property
            FMEnabled = obj.IEEE4882Fgen.WaveformSubsystem.getFMEnabled;
            AMEnabled =  obj.IEEE4882Fgen.WaveformSubsystem.getAMEnabled;
            BurstEnabled = obj.IEEE4882Fgen.WaveformSubsystem.getBurstMode;
            if (FMEnabled)
                mode = ModeEnum.FM;
            elseif(AMEnabled)
                mode = ModeEnum.AM;
            elseif (BurstEnabled)
                mode = ModeEnum.Burst;
            else
                mode = ModeEnum.Continuous;
            end
            mode = ModeEnum.getString(mode);
        end
        
        function set.Mode (obj, mode)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*
            if mode == ModeEnum.Burst
                % disable FM
                obj.IEEE4882Fgen.WaveformSubsystem.setFMEnabled(false);
                % disable AM
                obj.IEEE4882Fgen.WaveformSubsystem.setAMEnabled(false);
                % switch to burst mode
                obj.IEEE4882Fgen.WaveformSubsystem.setBurstEnabled(true);
            elseif  mode == ModeEnum.AM
                % turn off burst mode
                obj.IEEE4882Fgen.WaveformSubsystem.setBurstEnabled(false);
                % disable FM
                obj.IEEE4882Fgen.WaveformSubsystem.setFMEnabled(false);
                % enable AM
                obj.IEEE4882Fgen.WaveformSubsystem.setAMEnabled(true);
            elseif mode == ModeEnum.FM
                % turn off burst mode
                obj.IEEE4882Fgen.WaveformSubsystem.setBurstEnabled(false);
                % disable AM
                obj.IEEE4882Fgen.WaveformSubsystem.setAMEnabled(false);
                % enable FM
                obj.IEEE4882Fgen.WaveformSubsystem.setFMEnabled(true);
            else
                % switch to continuous mode
                obj.IEEE4882Fgen.WaveformSubsystem.setBurstEnabled(false);
                % also need to disable FM and AM if it is on
                obj.IEEE4882Fgen.WaveformSubsystem.setAMEnabled(false);
                obj.IEEE4882Fgen.WaveformSubsystem.setFMEnabled(false);
            end
        end
        
        function value = get.ModulationWaveform(obj)
            switch lower(char(obj.Mode))
                case 'am'
                    % Query underlying adaptor
                    instrumentValue = obj.IEEE4882Fgen.WaveformSubsystem.getAMWaveform;
                case 'fm'
                    % Query underlying adaptor
                    instrumentValue = obj.IEEE4882Fgen.WaveformSubsystem.getFMWaveform;
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
            import instrument.internal.udm.fgen.*
            value = ModulationWaveformEnum.getString(instrumentValue);
        end
        
        function  set.ModulationWaveform(obj, value)
            switch lower(char(obj.Mode))
                case 'am'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setAMWaveform(value);
                case 'fm'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setFMWaveform(value);
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
                
        function value = get.ModulationSource(obj)
            channelName = obj.validateSelectedChannel;
            switch lower(char(obj.Mode))
                case 'am'
                    % Query the underlying adaptor
                    instrumentValue = obj.IEEE4882Fgen.WaveformSubsystem.getAMModulationSource;
                case 'fm'
                    % Query the underlying adaptor
                    instrumentValue = obj.IEEE4882Fgen.WaveformSubsystem.getFMModulationSource;
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
            import instrument.internal.udm.fgen.*
            value = ModulationSourceEnum.getString(instrumentValue);
        end
        
        function  set.ModulationSource(obj, value)
            channelName = obj.validateSelectedChannel;
            switch lower(char(obj.Mode))
                case 'am'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setAMModulationSource(value);
                case 'fm'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setFMModulationSource(value);
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        function value = get.AMDepth(obj)
            % Query underlying adaptor
            value = obj.IEEE4882Fgen.WaveformSubsystem.getAMDepth;
        end
        
        function  set.AMDepth(obj, value)
            % Query underlying adaptor
            obj.IEEE4882Fgen.WaveformSubsystem.setAMDepth(value);
        end
        
        function value = get.FMDeviation(obj)
            % Query underlying adaptor
            value = obj.IEEE4882Fgen.WaveformSubsystem.getFMDeviation;
        end
        
        function  set.FMDeviation(obj, value)
            % Dispatch call to underlying adaptor
            obj.IEEE4882Fgen.WaveformSubsystem.setFMDeviation(value);
        end
        
        function value = get.ModulationFrequency(obj)
            switch lower(char(obj.Mode))
                case 'am'
                    % Query underlying adaptor
                    value = obj.IEEE4882Fgen.WaveformSubsystem.getAMInternalFrequency;
                case 'fm'
                    % Query underlying adaptor
                    value = obj.IEEE4882Fgen.WaveformSubsystem.getFMInternalFrequency;
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        function  set.ModulationFrequency(obj, value)
            switch lower(char(obj.Mode))
                case 'am'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setAMInternalFrequency(value);
                case 'fm'
                    % Dispatch call to underlying adaptor
                    obj.IEEE4882Fgen.WaveformSubsystem.setFMInternalFrequency(value);
                otherwise
                    error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        function value = get.StartPhase(obj)
            channelName = obj.validateSelectedChannel;
            % Query underlying adaptor
            value = obj.IEEE4882Fgen.WaveformSubsystem.getStartPhase;
        end
        
        function  set.StartPhase(obj,  value)
            channelName = obj.validateSelectedChannel;
            % Query underlying adaptor
            obj.IEEE4882Fgen.WaveformSubsystem.setStartPhase(value);
        end
        
        function  set.Waveform(obj,  value)
            import instrument.internal.udm.fgen.*;
            if value == WaveformEnum.None
                obj.Waveform = WaveformEnum.None ;
                obj.IEEE4882Fgen.ChannelSubsystem.disableOutput;
                return;
            end
            channelName = obj.validateSelectedChannel;
            % set waveform
            obj.IEEE4882Fgen.WaveformSubsystem.setWaveform(value);
        end
        
        function value = get.Waveform (obj)
            channelName = obj.validateSelectedChannel;
            % Query underlying adaptor
            value = obj.IEEE4882Fgen.WaveformSubsystem.getWaveform;
        end
        
        function value = get.Offset(obj)
            channelName =  obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error(message('instrument:fgen:needToSetWaveform'));
            else
                % Query underlying adaptor
                value = obj.IEEE4882Fgen.WaveformSubsystem.getOffset;
            end
        end
        
        function  set.Offset(obj,  value)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
            else
                % Query underlying adaptor
                obj.IEEE4882Fgen.WaveformSubsystem.setOffset(value);
            end
        end
        
        function value = get.Frequency(obj)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
            else
                % Query underlying adaptor
                value = obj.IEEE4882Fgen.WaveformSubsystem.getFrequency;
            end
        end
        
        function  set.Frequency(obj,  value)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
            else
                % Dispatch to underlying adaptor
                obj.IEEE4882Fgen.WaveformSubsystem.setFrequency(value);
            end
        end
        
        % Arb waveform related properties
        function set.ArbWaveformGain (obj,  value)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.IEEE4882Fgen.WaveformSubsystem.getWaveform == WaveformEnum.Arb
                % Dispatch to underlying adaptor
                obj.IEEE4882Fgen.ChannelSubsystem.setAmplitude(value);
            else
                error(message('instrument:fgen:ArbWaveformOnly'));
            end
        end
        
        function value = get.ArbWaveformGain (obj )
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.IEEE4882Fgen.WaveformSubsystem.getWaveform == WaveformEnum.Arb
                % Query the underlying adaptor
                value = obj.IEEE4882Fgen.ChannelSubsystem.getAmplitude;
            else
                error(message('instrument:fgen:ArbWaveformOnly'));
            end
        end
        
        function removeWaveform (obj, varargin)
            channelName = obj.validateSelectedChannel;
            if isempty (varargin)
                if  isempty (obj.InternalWaveformHandle)
                    error (message('instrument:fgen:needWaveformHandle'));
                else
                    waveformHandle = obj.InternalWaveformHandle;
                    %reset internal waveform handle
                    obj.InternalWaveformHandle = [];
                end
            else
                waveformHandle = varargin{1};
            end
            % Dispatch to underlying adaptor to remove the waveform using
            % waveform handle
            obj.IEEE4882Fgen.WaveformSubsystem.clearArbWaveform(waveformHandle);
        end
        
        function selectWaveform(obj, waveformHandle)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*
            if obj.Waveform == WaveformEnum.Arb
                if  isempty (waveformHandle)
                    % user didn't pass in a valid waveform handle
                    error (message ('instrument:fgen:needWaveformHandle'));
                end
                % Dispatch to underlying adaptor to select the waveform using
                % waveform handle
                obj.IEEE4882Fgen.WaveformSubsystem.selectArbWaveform(waveformHandle);
            else
                error (message ('instrument:fgen:ArbWaveformOnly'));
            end
        end
        
        %allow user to create an Arb waveform with a name
        %if such name exist, it will overwrite the old data with new data
        function varargout = downloadWaveform(obj, waveformDataArray)
            channelName = obj.validateSelectedChannel;
            % reuse the old Arb waveform slot if user doesn't provide LHS
            % argument
            if ~isempty (obj.InternalWaveformHandle ) && nargout == 0
                obj.removeWaveform (obj.InternalWaveformHandle);
            end
            % Dispatch to underlying adaptor to create an Arb waveform
            waveformHandle = obj.IEEE4882Fgen.WaveformSubsystem.createArbWaveform(waveformDataArray);
            if nargout == 0
                obj.InternalWaveformHandle = waveformHandle;
                obj.IEEE4882Fgen.WaveformSubsystem.selectArbWaveform(waveformHandle);
            else
                tempOut = cell(1, 1);
                [tempOut{:}] = waveformHandle;
                varargout = tempOut;
            end
        end
    end
    
    methods  (Access = protected)
        function connect(obj)
            try
                % Dispatch to underlying adaptor
                obj.IEEE4882Fgen.connect();
            catch e
                throwAsCaller(e);
            end
        end
    end
end
