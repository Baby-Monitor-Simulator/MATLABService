classdef IEEE4882ScopeAdaptor < instrument.internal.udm.oscilloscope.ScopeAdaptor
    %IEEE4882ScopeAdaptor class follows the adaptor design pattern and provides
    %bridge between interface Oscilloscope wrapper and Oscilloscope's state machine.
    %It is a concrete class which overrides the methods defined in ScopeAdaptor class.
    
    % Copyright 2011-2019 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        %An instance of instrument.ieee4882.Scope class
        IEEE4882Scope
        
    end
    
    
    properties (Dependent, Access = public)
        %redefines the abstract variables specified in ScopeAdaptor class
        AcquisitionTime;
        AcquisitionStartDelay;
        WaveformLength  ;
        
        TriggerSource;
        TriggerSlope;
        TriggerLevel;
        TriggerMode;
        SingleSweepMode;
        
    end
    
    %Read only properties
    properties (SetAccess = private )
        ChannelNames;
        ChannelsEnabled;
    end
    
    methods (Static)
        function [scopeAdapter, driverName] = createByResource(resource)
            %CreateByResource static method tries to create a IEEE4882 adapter based on the
            %resource info.
            scopeAdapter = [];
            driverName ='';
            try
                
                %calls the constructor
                scopeAdapter = instrument.internal.udm.oscilloscope.IEEE4882ScopeAdaptor('', resource);
                driverName = scopeAdapter.IEEE4882Scope.DriverName ;
            catch e %#ok<*NASGU>
                %In case an ieee488.2 adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
                
            end
            
        end
        
        function [scopeAdapter, driver] = createByDriverAndResource( driverName, resource)
            %CreateByDriverAndResource static method tries to create an interface adapter based on the
            %resource and driver name.
            scopeAdapter =[];
            driver ='';
            % Get list of IEEE488.2 drivers for Oscilloscope class instruments
            supportedIEEE4882Drivers = instrument.ieee4882.DriverUtility.getDrivers('scope');
            for iLoop = 1:length(supportedIEEE4882Drivers)
                % If the drivername matches the user supplied drivername,
                % then try to instantiate. Else, this function will return
                % an empty adapter
                if strcmpi(driverName,supportedIEEE4882Drivers{iLoop}.Name)
                    try
                        %calls the constructor
                        scopeAdapter = instrument.internal.udm.oscilloscope.IEEE4882ScopeAdaptor (driverName, resource);
                        % break out of the loop if the constructor returned
                        % successfully
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
            %DriverUtility and find out the ieee488.2 specific oscilloscope drivers
            
            driverInfo = instrument.ieee4882.DriverUtility.getDrivers('SCOPE');
            
        end
        
        function resource = getResource(varargin)
            %GetResource static method discovers the resource based on
            %resource discovery methods defined in adapters.config file
            resource ={};
            
            if strcmpi (varargin{1}, 'visa')
                visaResource = instrument.internal.udm.InstrumentUtility.getVisaResources;
                resource = horzcat(resource, visaResource);
            end
            
            if strcmpi (varargin{1}, 'tcpip') || ...
                    strcmpi (varargin{1}, 'serial') ||...
                    strcmpi (varargin{1}, 'gpib')
                interfaceResource = instrument.ieee4882.DriverUtility.getResourceByType (varargin{1});
                resource = horzcat(resource, interfaceResource);
            end
        end
    end
    
    
    methods
        %Constructor
        function obj = IEEE4882ScopeAdaptor(driverName, resource )
            %since the adapter is created upon oscilloscope's connect() method
            %it should automatically call connect()
            
            obj.IEEE4882Scope =  instrument.ieee4882.Scope( resource);
            if ~isempty ( driverName ) % overwrite driver name
                obj.IEEE4882Scope.DriverName = driverName;
            end
            
            obj.connect();
            
        end
        
        
        function delete(obj)
            if ~isempty(obj.IEEE4882Scope)
                obj.IEEE4882Scope.disconnect();
                obj.IEEE4882Scope =[];
            end
        end
        
        function autoSetup(obj)
            obj.IEEE4882Scope.Utility.autoSetup();
            
        end
        
        function reset(obj)
            obj.IEEE4882Scope.Utility.reset();
        end
        
        function disconnect(obj)
            obj.IEEE4882Scope.disconnect();
        end
        
        function value = get.SingleSweepMode(obj)
            import instrument.internal.udm.oscilloscope.*
            
            ret = obj.IEEE4882Scope.Acquisition.SingleSweepMode ;
            
            if strcmpi (ret , 'on')
                value = SingleSweepModeEnum.On;
            else
                value = SingleSweepModeEnum.Off;
            end
        end
        
        function set.SingleSweepMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == SingleSweepModeEnum.On
                obj.IEEE4882Scope.Acquisition.SingleSweepMode =  'on';
            else
                obj.IEEE4882Scope.Acquisition.SingleSweepMode =  'off';
            end
        end
        
        
        
        function value = get.ChannelsEnabled(obj)
            
            value = obj.IEEE4882Scope.ChannelSubsystem.EnabledChannels;
            
        end
        
        
        function enableChannel(obj, channelName, enable)
            obj.validateChannelName(channelName);
            obj.IEEE4882Scope.ChannelSubsystem.enableChannel(channelName , enable);
            
        end
        
        
        function value = getInstrumentInfo(obj)
            if obj.IEEE4882Scope.Connected
                value =  obj.IEEE4882Scope.Utility.getInstrumentInfo();
            end
        end
        
        
        function channelNames = get.ChannelNames (obj)
            channelNames = obj.IEEE4882Scope.ChannelSubsystem.ChannelNames;
            
        end
        
        
        function  setVerticalControl(obj, channelName, controlName, value)
            
            import instrument.internal.udm.oscilloscope.*
            switch controlName
                case VerticalControlEnum.Coupling
                    if value == ChannelCouplingEnum.DC
                        obj.IEEE4882Scope.ChannelSubsystem.setVerticalCoupling(channelName, 'DC');                        
                    elseif value == ChannelCouplingEnum.AC
                        obj.IEEE4882Scope.ChannelSubsystem.setVerticalCoupling ( channelName, 'AC');
                    elseif value == ChannelCouplingEnum.GND
                        obj.IEEE4882Scope.ChannelSubsystem.setVerticalCoupling ( channelName, 'GND');
                    end
                case VerticalControlEnum.Offset
                    obj.IEEE4882Scope.ChannelSubsystem.setVerticalOffset ( channelName, value );
                case VerticalControlEnum.Range
                    obj.IEEE4882Scope.ChannelSubsystem.setVerticalRange( channelName, value);
                case VerticalControlEnum.ProbeAttenuation
                    validateattributes(value, {'numeric'},{'nonempty','scalar','nonnegative','finite'}, 'ConfigureChannel', 'ProbeAttenuation');
                    obj.IEEE4882Scope.ChannelSubsystem.setProbeAttenuation( channelName, value);
                otherwise
                    error (message('instrument:oscilloscope:invalidControlType'));
                    
            end
        end
        
        
        function value = getVerticalControl(obj, channelName, controlName)
            
            obj.validateChannelName(channelName);
            
            import instrument.internal.udm.oscilloscope.*
            switch controlName
                case VerticalControlEnum.Coupling
                    value = obj.IEEE4882Scope.ChannelSubsystem.getVerticalCoupling(channelName);
                    if strcmpi ( value, 'dc')
                        value = ChannelCouplingEnum.DC;
                    elseif strcmpi (value, 'ac')
                        value = ChannelCouplingEnum.AC;
                    elseif strcmpi (value, 'gnd')
                        value = ChannelCouplingEnum.GND;
                    end
                case VerticalControlEnum.Offset
                    value = obj.IEEE4882Scope.ChannelSubsystem.getVerticalOffset(channelName);
                case VerticalControlEnum.Range
                    value = obj.IEEE4882Scope.ChannelSubsystem.getVerticalRange(channelName);
                case VerticalControlEnum.ProbeAttenuation
                    value = obj.IEEE4882Scope.ChannelSubsystem.getProbeAttenuation(channelName);
                otherwise
                    error (message('instrument:oscilloscope:invalidControlType'));
            end
        end
        
        
        function set.TriggerLevel(obj, value)
            obj.IEEE4882Scope.TriggerSubsystem.TriggerLevel = value;
        end
        
        function value = get.TriggerLevel(obj)
            value = obj.IEEE4882Scope.TriggerSubsystem.TriggerLevel;
        end
        
        
        function set.WaveformLength(obj, value)
            obj.IEEE4882Scope.Acquisition.WaveformLength = value;
        end
        
        function value = get.WaveformLength(obj)
            value = obj.IEEE4882Scope.Acquisition.WaveformLength;
        end
        
        function set.TriggerSlope(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == TriggerSlopeEnum.Falling
                obj.IEEE4882Scope.TriggerSubsystem.TriggerSlope = 'fall' ;
            elseif value == TriggerSlopeEnum.Rising
                obj.IEEE4882Scope.TriggerSubsystem.TriggerSlope = 'rise' ;
            else
                error (message('instrument:oscilloscope:invalidControlType'));
            end
            
        end
        
        function value = get.TriggerSlope(obj)
            import instrument.internal.udm.oscilloscope.*
            value = obj.IEEE4882Scope.TriggerSubsystem.TriggerSlope;
            if strcmpi (value , 'fall')
                value = TriggerSlopeEnum.Falling  ;
            else
                value =  TriggerSlopeEnum.Rising  ;
            end
        end
        
        function value = get.TriggerSource(obj)
            value = obj.IEEE4882Scope.TriggerSubsystem.TriggerSource;
            
        end
        
        function  set.TriggerSource(obj, value)
            
            obj.IEEE4882Scope.TriggerSubsystem.TriggerSource = value;
            
        end
        
        
        function set.AcquisitionTime(obj, value)
            obj.IEEE4882Scope.Acquisition.AcquisitionTime = value;
        end
        
        function value = get.AcquisitionTime(obj)
            
            value =  obj.IEEE4882Scope.Acquisition.AcquisitionTime ;
            
        end
        
        function set.AcquisitionStartDelay(obj, value)
            
            obj.IEEE4882Scope.Acquisition.AcquisitionStartDelay = value;
        end
        
        
        function value = get.AcquisitionStartDelay(obj)
            value =  obj.IEEE4882Scope.Acquisition.AcquisitionStartDelay;
        end
        
        function WaveformArray = readWaveform(obj, channelName , timeout )
            WaveformArray =  obj.IEEE4882Scope.WaveformAcquisition.readWaveform(channelName, timeout);
        end
        
        
        function WaveformArray = fetchWaveform(obj, channelName  )
            
            WaveformArray =  obj.IEEE4882Scope.WaveformAcquisition.fetchWaveform(channelName);
            
        end
        
        
        function value = get.TriggerMode(obj)
            import instrument.internal.udm.oscilloscope.*
            value =  obj.IEEE4882Scope.TriggerSubsystem.TriggerMode;
            
            if strcmpi ( value , 'normal')
                value =  TriggerModeEnum.Normal;
            else
                value =  TriggerModeEnum.Auto;
            end
            
        end
        
        function set.TriggerMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == TriggerModeEnum.Normal
                obj.IEEE4882Scope.TriggerSubsystem.TriggerMode = 'normal' ;
            else
                obj.IEEE4882Scope.TriggerSubsystem.TriggerMode = 'auto';
            end
        end
        
    end
    
    methods  (Access = protected)
        function connect(obj)
            
            try
                obj.IEEE4882Scope.connect();
            catch e
                throwAsCaller(e);
            end
            
        end
    end    
end

% LocalWords:  ieee FGen drivername GND gnd
