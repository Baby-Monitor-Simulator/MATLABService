classdef IvicScopeAdaptor < instrument.internal.udm.oscilloscope.ScopeAdaptor
    %IvicScopeAdaptor class follows the adaptor design pattern and provides
    %bridge between IVI-C class compliant Oscilloscope wrapper and
    %Oscilloscope's state machine. It is a concrete class which overrides
    %the methods defined in ScopeAdaptor class.
    
    % Copyright 2011-2022 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        %A instance of instrument.ivic.IvicScope class
        IvicScope
        
        %Properties used to store temporary entries in configuration store
        HardwareAsset
        Session
        LogicalName
    end
    
    
    properties (Dependent, Access = public)
        %redefines the abstract variables specified in ScopeAdaptor class
        AcquisitionTime
        AcquisitionStartDelay
        WaveformLength
        
        TriggerSource
        TriggerSlope
        TriggerLevel
        TriggerMode
        SingleSweepMode
        
    end
    
    %Read only properties
    properties (SetAccess = private )
        ChannelNames
        ChannelsEnabled
    end
    
    methods (Static)
        function [scopeAdapter, driverName] = createByResource(resource)
            %CreateByResource static method tries to create a IVI-C adapter based on the
            %resource info.
            scopeAdapter = [];
            driverName ='';
            
            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.oscilloscope.IvicScopeAdaptor
            try
                %use resource info , find out available IVI scope drivers
                %from configuration store.
                import    instrument.internal.udm.*;
                iviScopeDrivers = instrument.internal.udm.ConfigStoreUtility.getIVIInstrumentDriversFromResource(InstrumentType.Scope, resource);
                if bitand(iviScopeDrivers{1}.type , IVITypeEnum.IVIC)  
                    driverName = iviScopeDrivers{1}.Name;
                    %calls the constructor
                    scopeAdapter = feval(str2func('instrument.internal.udm.oscilloscope.IvicScopeAdaptor') ,driverName, resource);
                end
            catch e %#ok<*NASGU>
                % throw this specific error ( need mex-setup ) and ignore
                % other errors
                if strcmpi(e.identifier , 'MATLAB:CompilerConfiguration:NoSelectedOptionsFile')
                    throwAsCaller(e);
                end
                %In case an IVI-C adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
            end
            
        end
        
        function [scopeAdapter, driver] = createByDriverAndResource( driverName, resource)
            %CreateByDriverAndResource static method tries to create a IVI-C adapter based on the
            %resource and driver info.
            scopeAdapter =[];
            driver ='';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.oscilloscope.IvicScopeAdaptor
            try
                import    instrument.internal.udm.*;
                iviScopeDriver = instrument.internal.udm.ConfigStoreUtility.getIviInstrumentDriver(InstrumentType.Scope, driverName);
                if bitand(iviScopeDriver.type , IVITypeEnum.IVIC)  
                    
                    %calls the constructor
                    scopeAdapter = feval(str2func('instrument.internal.udm.oscilloscope.IvicScopeAdaptor') ,driverName, resource);
                    
                end
            catch e
                
                % throw this specific error ( need mex-setup ) and ignore
                % other errors
                if strcmpi(e.identifier , 'MATLAB:CompilerConfiguration:NoSelectedOptionsFile')
                    throwAsCaller(e);
                end
                %In case an IVI-C adapter instance can not be instantiated, an empty adapter
                %is returned. It hands over the responsibility to the next adapter.
            end
            
        end
        
        function driverInfo = getDriver()
            %GetDriver static method iterates through configuration store
            %and find out the IVI-C specific oscilloscope drivers
            
            %all ivi scope drivers
            import instrument.internal.udm.*;
            iviScopeDriverInfo =  instrument.internal.udm.ConfigStoreUtility.getInstalledIVIInstrumentDrivers(InstrumentType.Scope);
            
            % ivi-c scope driver only
            driverInfo = {};
            for i = 1: size (iviScopeDriverInfo, 2)
                if bitand(iviScopeDriverInfo{i}.type ,IVITypeEnum.IVIC)
                    driverInfo{end+1} = iviScopeDriverInfo{i}; %#ok<*AGROW>
                end
            end
        end
        
        function resource = getResource(varargin)
            %GetResource static method discovers the resource based on
            %resource discovery methods defined in adapters.config file
            resource ={};
            
            if strcmpi (varargin{1}, 'visa')
                visaResource = instrument.internal.udm.InstrumentUtility.getVisaResources;
                resource = horzcat(resource, visaResource);
            end

        end
    end
    
    
    methods
        %Constructor
        function obj = IvicScopeAdaptor(driverName, resource)
            %IvicScopeAdaptor constructor creates temporary entries
            %(hardware asset, session and logical name )in configuration
            %store. This step is necessary before using IVI-C scope wrapper.
            tmp_nam = tempname ;
            [~, name, ~] = fileparts(tmp_nam) ;
            obj.HardwareAsset = sprintf('%s_ScopeHardwareAsset', name);
            obj.Session = sprintf('%s_ScopeSession', name);
            obj.LogicalName = sprintf('%s_Scope', name);
            
            %create temporary configuration store entries used
            %by connect () method
            instrument.internal.udm.ConfigStoreUtility.addLogicalName(  obj.HardwareAsset, resource ,  obj.Session, driverName, obj.LogicalName);
            
            % Suppresses IviScope remove functionality warning.
            warnState = instrument.internal.udm.WarningUtility.disableWarnings();
            c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

            %create an instance of underlying IVI-C scope wrapper.
            obj.IvicScope = instrument.ivic.IviScope();
            
            %since the adapter is created upon oscilloscope' connect() method
            %it should automatically call connect()
            obj.connect();
            
        end
        
        
        function delete(obj)
            
            obj.IvicScope =[];
            %removes temporary configuration store entries created during
            %class constructor.
            instrument.internal.udm.ConfigStoreUtility.removeLogicalName(obj.HardwareAsset, obj.Session, obj.LogicalName);
        end
        
        function autoSetup(obj)
            obj.IvicScope.Configuration.AutoSetup();
        end
        
        function reset(obj)
            obj.IvicScope.Utility.reset;
        end
        
        function disconnect(obj)
            obj.IvicScope.close();
        end
        
        function value = get.SingleSweepMode(obj)
            import instrument.internal.udm.oscilloscope.*
            if obj.IvicScope.Acquisition.Initiate_Continuous_CA
                value = SingleSweepModeEnum.Off;
            else
                value = SingleSweepModeEnum.On;
            end
        end
        
        function set.SingleSweepMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == SingleSweepModeEnum.On
                obj.IvicScope.Acquisition.Initiate_Continuous_CA = 0;
            else
                obj.IvicScope.Acquisition.Initiate_Continuous_CA = 1;
            end
        end
        
        function value = get.ChannelsEnabled(obj)
            
            value ={};
            for i=1: size (obj.ChannelNames, 2)
                channelName = obj.ChannelNames{i};
                obj.IvicScope.ChannelSubsystem.RepCapIdentifier = channelName ;
                if obj.IvicScope.ChannelSubsystem.Channel_Enabled
                    value{end+1} = obj.ChannelNames{i};
                end
            end
            
        end
        
        function enableChannel(obj, channelName, enable)
            
            obj.validateChannelName(channelName);
            obj.IvicScope.ChannelSubsystem.RepCapIdentifier = channelName ;
            obj.IvicScope.ChannelSubsystem.Channel_Enabled = enable;
        end
        
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            
            if obj.IvicScope.initialized
                manufacturer = obj.IvicScope.InherentIVIAttributes.InstrumentIdentification.Manufacturer ;
                model = obj.IvicScope.InherentIVIAttributes.InstrumentIdentification.Model ;
                
                textToDisp = sprintf ('%s %s.', strtrim(manufacturer), strtrim(model));
            end
            value =  textToDisp ;
            
        end
        
        
        function channelNames = get.ChannelNames (obj)
            
            channelNames ={};
            channelCount =  obj.IvicScope.InherentIVIAttributes.SpecificDriverCapabilities.Channel_Count ;
            for channelIndex = 1: channelCount
                
                channelName =obj.IvicScope.Utility.GetChannelName(channelIndex, 256);
                % remove string terminator at the end
                if double(channelName(end) == 0)
                    channelName = channelName(1:end-1);
                end
                channelNames{end+1}  =  channelName ;
            end
            
            
        end
        
        
        function  setVerticalControl(obj, channelName, controlName, value)            
            
            obj.IvicScope.ChannelSubsystem.RepCapIdentifier = channelName;
            import instrument.internal.udm.oscilloscope.*
            switch controlName
                case VerticalControlEnum.Coupling
                    if value == ChannelCouplingEnum.AC
                        obj.IvicScope.ChannelSubsystem.Vertical_Coupling = 0;
                    elseif value == ChannelCouplingEnum.DC
                        obj.IvicScope.ChannelSubsystem.Vertical_Coupling = 1;
                    elseif value == ChannelCouplingEnum.GND
                        obj.IvicScope.ChannelSubsystem.Vertical_Coupling = 2;
                    end
                case VerticalControlEnum.Offset
                    obj.IvicScope.ChannelSubsystem.Vertical_Offset = value;
                case VerticalControlEnum.Range
                    obj.IvicScope.ChannelSubsystem.Vertical_Range =  value;
                case VerticalControlEnum.ProbeAttenuation
                    obj.IvicScope.ChannelSubsystem.Probe_Attenuation =  value;
            end
        end
        
        
        function value = getVerticalControl(obj, channelName, controlName)
            obj.validateChannelName(channelName);
            obj.IvicScope.ChannelSubsystem.RepCapIdentifier = channelName ;
            import instrument.internal.udm.oscilloscope.*
            switch controlName
                case VerticalControlEnum.Coupling
                    value =  obj.IvicScope.ChannelSubsystem.Vertical_Coupling ;
                    if value == 0
                        value = ChannelCouplingEnum.AC;
                    elseif value == 1
                        value = ChannelCouplingEnum.DC;
                    elseif value == 2
                        value = ChannelCouplingEnum.GND;
                    end
                case VerticalControlEnum.Offset
                    value = obj.IvicScope.ChannelSubsystem.Vertical_Offset ;
                case VerticalControlEnum.Range
                    value = obj.IvicScope.ChannelSubsystem.Vertical_Range ;
                case VerticalControlEnum.ProbeAttenuation
                    value = obj.IvicScope.ChannelSubsystem.Probe_Attenuation;
                    
            end
        end
        
        
        function set.TriggerLevel(obj, value)
            obj.IvicScope.TriggerSubsystem.Trigger_Level = value;
        end
        
        function value = get.TriggerLevel(obj)
            value =obj.IvicScope.TriggerSubsystem.Trigger_Level ;
        end
        
        
        function set.WaveformLength(obj, value)
            obj.IvicScope.Acquisition.Horizontal_Minimum_Number_of_Points = value;
        end
        
        function value = get.WaveformLength(obj)
            try
                value =obj.IvicScope.Acquisition.Horizontal_Record_Length ;
                if value == 0
                    % in normal case, the value is not zero, however, this is
                    %a fix for Agilent 546XX driver (g712669)
                    value = 1000;
                end
            catch e
                value = 1000;
            end
        end
        
        function set.TriggerSlope(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == TriggerSlopeEnum.Falling
                obj.IvicScope.TriggerSubsystem.Trigger_Slope = 0;
            elseif value == TriggerSlopeEnum.Rising
                obj.IvicScope.TriggerSubsystem.Trigger_Slope = 1;
            end
            
        end
        
        function value = get.TriggerSlope(obj)
            import instrument.internal.udm.oscilloscope.*
            value = obj.IvicScope.TriggerSubsystem.Trigger_Slope  ;
            if value == 0
                value = TriggerSlopeEnum.Falling  ;
            else
                value =  TriggerSlopeEnum.Rising  ;
            end
        end
        
        function value = get.TriggerSource(obj)
            value = obj.IvicScope.TriggerSubsystem.Trigger_Source  ;
            % remove string terminator
            if double(value(end) == 0)
                value = value(1:end-1);
            end
            
        end
        
        function  set.TriggerSource(obj, value)
            try
            obj.IvicScope.TriggerSubsystem.Trigger_Source = value  ;
            catch e
                error(message('instrument:oscilloscope:notValidTriggerSource',value));
            end
        end
        
        
        function set.AcquisitionTime(obj, value)
            obj.IvicScope.Acquisition.Horizontal_Time_Per_Record = value;
        end
        
        function value = get.AcquisitionTime(obj)
            value = obj.IvicScope.Acquisition.Horizontal_Time_Per_Record;
        end
        
        function set.AcquisitionStartDelay(obj, value)
            obj.IvicScope.Acquisition.Acquisition_Start_Time = value;
        end
        
        
        function value = get.AcquisitionStartDelay(obj)
            value = obj.IvicScope.Acquisition.Acquisition_Start_Time;
        end
        
        
        function WaveformArray = readWaveform(obj, channelName , timeout )
            obj.validateChannelName(channelName);
            % get record length
            size = obj.WaveformLength ;
            WaveformArray = zeros(1, size);
            MaximumTimems = timeout *1000;
            [WaveformArray,~,~,~,] = obj.IvicScope.WaveformAcquisition.ReadWaveform(channelName,size,MaximumTimems, WaveformArray);
            
        end
        
        function WaveformArray = fetchWaveform(obj, channelName  )
            
            obj.validateChannelName(channelName);
            % get record length
            size = obj.WaveformLength ;
            WaveformArray = zeros(1, size);
            [WaveformArray,~,~,~,] = obj.IvicScope.WaveformAcquisition.LowlevelAcquisition.FetchWaveform(channelName,size, WaveformArray);
            
        end
        
        
        function value = get.TriggerMode(obj)
            import instrument.internal.udm.oscilloscope.*
            triggerMode = obj.IvicScope.TriggerSubsystem.Trigger_Modifier_TM;
            
            if triggerMode == 1
                value =  TriggerModeEnum.Normal;
            else
                value =  TriggerModeEnum.Auto;
            end
            
        end
        
        function set.TriggerMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            if value == TriggerModeEnum.Normal
                obj.IvicScope.TriggerSubsystem.Trigger_Modifier_TM = 1; %Normal
            else
                obj.IvicScope.TriggerSubsystem.Trigger_Modifier_TM = 2; % auto
            end
        end
        
    end
    
    methods  (Access = protected)
        function connect(obj)
            obj.IvicScope.init( obj.LogicalName, false, false  );
        end
    end    
end

% LocalWords:  IVI ivic udm ivi Agilent
