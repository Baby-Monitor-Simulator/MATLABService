classdef IvicFgenAdaptor < instrument.internal.udm.fgen.FgenAdaptor
    %IvicFgenAdaptor class follows the adaptor design pattern and provides
    %bridge between IVI-C class compliant Fgen wrapper and
    %fgen's state machine. It is a concrete class which overrides
    %the methods defined in FgenAdaptor class.
    
    % Copyright 2011-2024 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        %A instance of instrument.ivic.IviFgen class
        IvicFgen
        
        %Properties used to store temporary entries in configuration store
        HardwareAsset
        Session
        LogicalName
        
        %InternalWaveformHandle maintains the waveform handle
        %when user all downloadWaveForm with giving LHS argument
        InternalWaveformHandle
        
    end
    
    
    properties (Dependent, Access = public)
        %redefines the abstract variables specified in FgenAdaptor class
        
        Amplitude
        AMDepth
        ArbWaveformGain
        BurstCount
        Frequency
        FMDeviation
        Mode
        ModulationWaveform
        ModulationFrequency
        ModulationSource
        Offset
        OutputImpedance
        TriggerSource
        StartPhase
        TriggerRate
        
        
    end
    
    properties
        Waveform
        
    end
    
    
    properties (Hidden, Dependent, Access = private)
        %OutputMode Determines the kind of waveform the function
        %generator produces.
        OutputMode
    end
    
    %Read only properties
    properties (SetAccess = private )
        ChannelNames
        SelectedChannel
    end
    
    methods (Static)
        function [fgenAdapter, driverName] = createByResource(resource)
            %CreateByResource static method tries to create a IVI-C adapter based on the
            %resource info.
            fgenAdapter = [];
            driverName ='';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.fgen.IvicFgenAdaptor
            try
                %use resource info , find out available IVI function generator drivers
                %from configuration store.
                import    instrument.internal.udm.*;
                iviFgenDrivers = instrument.internal.udm.ConfigStoreUtility.getIVIInstrumentDriversFromResource(InstrumentType.Fgen, resource);
                if bitand(iviFgenDrivers{1}.type , IVITypeEnum.IVIC)
                    driverName = iviFgenDrivers{1}.Name;
                    %calls the constructor
                    fgenAdapter = feval(str2func('instrument.internal.udm.fgen.IvicFgenAdaptor') ,driverName, resource);
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
        
        function [fgenAdapter, driver] = createByDriverAndResource( driverName, resource)
            %CreateByDriverAndResource static method tries to create a IVI-C adapter based on the
            %resource and driver info.
            fgenAdapter =[];
            driver ='';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.fgen.IvicFgenAdaptor
            try
                import instrument.internal.udm.*;
                iviFgenDriver = instrument.internal.udm.ConfigStoreUtility.getIviInstrumentDriver(InstrumentType.Fgen, driverName);
                if bitand(iviFgenDriver.type , IVITypeEnum.IVIC)
                    %calls the constructor
                    fgenAdapter = feval(str2func('instrument.internal.udm.fgen.IvicFgenAdaptor') ,driverName, resource);
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
            %and find out the IVI-C specific fgen drivers
            
            %all ivi function generator drivers
            import instrument.internal.udm.*;
            iviFgenDriverInfo =  instrument.internal.udm.ConfigStoreUtility.getInstalledIVIInstrumentDrivers(InstrumentType.Fgen);
            
            % ivi-c function generator driver only
            driverInfo = {};
            for i = 1: size (iviFgenDriverInfo, 2)
                if bitand(iviFgenDriverInfo{i}.type ,IVITypeEnum.IVIC)
                    driverInfo{end+1} = iviFgenDriverInfo{i}; %#ok<*AGROW>
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
        function obj = IvicFgenAdaptor(driverName, resource)
            %IvicFgenAdaptor constructor creates temporary entries
            %(hardware asset, session and logical name )in configuration
            %store. This step is necessary before using IVI-C function generator wrapper.
            [~, name, ~] = fileparts(tempname) ;
            obj.HardwareAsset = sprintf('%s_FgenHardwareAsset', name);
            obj.Session = sprintf('%s_FgenSession', name);
            obj.LogicalName = sprintf('%s_Fgen', name);
            
            %create temporary configuration store entries used
            %by connect () method
            instrument.internal.udm.ConfigStoreUtility.addLogicalName(  obj.HardwareAsset, resource ,  obj.Session, driverName, obj.LogicalName);
            
            % Suppresses IviFgen remove functionality warning.
            warnState = instrument.internal.udm.WarningUtility.disableWarnings();
            c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

            %create an instance of underlying IVI-C IvicFgen wrapper.
            obj.IvicFgen = instrument.ivic.IviFgen;
            
            %since the adapter is created upon fgen' connect() method
            %it should automatically call connect()
            obj.connect();
            
            import instrument.internal.udm.fgen.*;
            obj.Waveform =WaveformEnum.None ;
            
        end
        
        
        function delete(obj)
            
            % disconnect the instrument first
            obj.disconnect();
            
            obj.IvicFgen =[];
            
            %removes temporary configuration store entries created during
            %class constructor.
            instrument.internal.udm.ConfigStoreUtility.removeLogicalName(obj.HardwareAsset, obj.Session, obj.LogicalName);
        end
        
        
        function reset(obj)
            obj.IvicFgen.UtilityFunctions.reset();
        end
        
        
        function disconnect(obj)
            
            if ~isempty (obj.InternalWaveformHandle)
                % remove the arb waveform handle if there is any
                obj.removeWaveform(obj.InternalWaveformHandle);
                obj.InternalWaveformHandle = [];
            end
            
            % Check to make sure IvicFgen object exists before executing
            % close
            if ~isempty(obj.IvicFgen)
                obj.IvicFgen.close();
            end
        end
        
        
        function enableOutput(obj, enable)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
            
            %Initiate generation of the signal
            try
                obj.IvicFgen.ActionStatusFunctions.InitiateGeneration;
            catch ex
                if ~contains(ex.message, '-1074126847')
                   throw(ex);
                end
            end

            % enable the selected output channel
            obj.IvicFgen.BasicOperation.Output_Enabled =  enable;
        end
        
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            
            if obj.IvicFgen.initialized
                manufacturer = obj.IvicFgen.InherentIVIAttributes.InstrumentIdentification.Manufacturer;
                model = obj.IvicFgen.InherentIVIAttributes.InstrumentIdentification.Model;
                manufacturer = deblank (manufacturer);
                model = deblank(model);
                textToDisp = sprintf ('%s %s', strtrim(manufacturer), strtrim(model));
            end
            value =  textToDisp;
            
        end
        
        
        function channelNames = get.ChannelNames(obj)
            
            channelNames ={};
            channelCount =  obj.IvicFgen.InherentIVIAttributes.SpecificDriverCapabilities.Channel_Count;
            for channelIndex = 1: channelCount
                
                channelName =obj.IvicFgen.UtilityFunctions.GetChannelName(channelIndex, 256);
                % remove string terminator at the end
                if double(channelName(end) == 0)
                    channelName = channelName(1:end-1);
                end
                channelNames{end+1}  =  channelName;
            end
            
            % For single channel instruments
            if ((numel(channelNames) == 1) && isempty(channelNames{:}))
                channelNames{1} = '1';
            end
        end
        
        
        function value = get.BurstCount(obj)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.Burst.RepCapIdentifier = channelName;
            value = obj.IvicFgen.Burst.Burst_Count_BST;
            
        end
        
        function  set.BurstCount(obj, value)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.Burst.RepCapIdentifier = channelName;
            obj.IvicFgen.Burst.Burst_Count_BST = value;
            
        end
        
        function value = get.TriggerRate(obj)
            % no repcap allowed
            obj.IvicFgen.Triggering.RepCapIdentifier = '';
            value = obj.IvicFgen.Triggering.Internal_Trigger_Rate_IT;
        end
        
        function  set.TriggerRate(obj,  value)
            % no repcap allowed
            obj.IvicFgen.Triggering.RepCapIdentifier = '';
            obj.IvicFgen.Triggering.Internal_Trigger_Rate_IT = value;
            
        end
        
        
        function value = get.TriggerSource(obj)
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.Triggering.RepCapIdentifier = channelName;
            instrumentValue = obj.IvicFgen.Triggering.Trigger_Source_TRG;
            import instrument.internal.udm.fgen.*;
            value = TriggerSourceEnum.getString (instrumentValue);
        end
        
        
        function  set.TriggerSource(obj, value)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.Triggering.RepCapIdentifier = channelName;
            obj.IvicFgen.Triggering.Trigger_Source_TRG = value;
            
        end
        
        
        function value = get.Offset(obj)
            channelName =  obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
                
            elseif  obj.Waveform == WaveformEnum.Arb
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
                value = obj.IvicFgen.ArbitraryWaveformOutput.Arbitrary_Waveform_Offset_ARB;
            else
                
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
                value = obj.IvicFgen.StandardFunctionOutput.DC_Offset_STD ;
            end
        end
        
        function  set.Offset(obj,  value)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
                
            elseif  obj.Waveform == WaveformEnum.Arb
                
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
                obj.IvicFgen.ArbitraryWaveformOutput.Arbitrary_Waveform_Offset_ARB = value;
                
            else
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
                obj.IvicFgen.StandardFunctionOutput.DC_Offset_STD  = value;
            end
            
        end
        
        function value = get.Waveform (obj)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.OutputMode ==  1
                value = WaveformEnum.Arb;
            else
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
                value = obj.IvicFgen.StandardFunctionOutput.Waveform_STD;
            end
            
        end
        
        
        function  set.Waveform(obj,  value)
            
            import instrument.internal.udm.fgen.*;
            if value == WaveformEnum.None
                obj.Waveform = WaveformEnum.None ;
                return;
            end
            
            channelName = obj.validateSelectedChannel;
            
            if value == WaveformEnum.Arb
                %switch to Arb output mode
                obj.OutputMode =  1; %#ok<*MCSUP>
                
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
            else
                %switch to standard output mode
                obj.OutputMode =  0;
                
                % config standard waveform
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
                obj.IvicFgen.StandardFunctionOutput.Waveform_STD  = uint32 (value);
                
            end
            obj.Waveform = value;
            
        end
        
        % switch between regular function to arb function
        function set.OutputMode (obj,  value)
            
            % 0 is IVIFGEN_VAL_OUTPUT_FUNC
            % 1 is IVIFGEN_VAL_OUTPUT_ARB
            
            % can't set RepCapIdentifier
            obj.IvicFgen.BasicOperation.RepCapIdentifier = '';
            obj.IvicFgen.BasicOperation.Output_Mode =  value;
        end
        
        function value = get.OutputMode (obj)
            
            % 0 is IVIFGEN_VAL_OUTPUT_FUNC
            % 1 is IVIFGEN_VAL_OUTPUT_ARB
            obj.IvicFgen.BasicOperation.RepCapIdentifier = '';
            value = obj.IvicFgen.BasicOperation.Output_Mode;
        end
        
        function value = get.Frequency(obj)
            
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
                
            elseif  obj.Waveform == WaveformEnum.Arb
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
                value = obj.IvicFgen.ArbitraryWaveformOutput.Arb_Frequency_AF;
            else
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName ;
                value = obj.IvicFgen.StandardFunctionOutput.Frequency_STD;
            end
        end
        
        function  set.Frequency(obj,  value)
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*;
            if obj.Waveform ==  WaveformEnum.None
                error (message ('instrument:fgen:needToSetWaveform'));
                
            elseif  obj.Waveform == WaveformEnum.Arb
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
                obj.IvicFgen.ArbitraryWaveformOutput.Arb_Frequency_AF = value;
            else
                
                obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName ;
                obj.IvicFgen.StandardFunctionOutput.Frequency_STD  = value;
            end
            
        end
        
        function value = get.Amplitude(obj)
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
            value = obj.IvicFgen.StandardFunctionOutput.Amplitude_STD;
        end
        
        function  set.Amplitude(obj, value)
            channelName = obj.validateSelectedChannel;
            
            obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
            obj.IvicFgen.StandardFunctionOutput.Amplitude_STD  = value;
            
        end
        
        
        function value = get.StartPhase(obj)
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
            value = obj.IvicFgen.StandardFunctionOutput.Start_Phase_STD;
        end
        
        function  set.StartPhase(obj,  value)
            channelName = obj.validateSelectedChannel;
            
            obj.IvicFgen.StandardFunctionOutput.RepCapIdentifier = channelName;
            obj.IvicFgen.StandardFunctionOutput.Start_Phase_STD  = value;
            
        end
        
        
        function set.OutputImpedance( obj,  value)
            channelName = obj.validateSelectedChannel;
            
            obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
            obj.IvicFgen.BasicOperation.Output_Impedance = value ;
            
        end
        
        function value = get.OutputImpedance(obj)
            channelName = obj.validateSelectedChannel;
            
            obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
            value = obj.IvicFgen.BasicOperation.Output_Impedance;
            
        end
        
        function value = get.FMDeviation(obj)
            % no repcap allowed
            obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
            value = obj.IvicFgen.FrequencyModulation.FM_Internal_Deviation_FM;
        end
        
        function  set.FMDeviation(obj, value)
            % no repcap allowed
            obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
            obj.IvicFgen.FrequencyModulation.FM_Internal_Deviation_FM  = value;
            
        end
        
        
        function mode = get.Mode(obj)
            
            import instrument.internal.udm.fgen.*
            mode = ModeEnum.NotSupported;
            channelName = obj.validateSelectedChannel;
            
            obj.IvicFgen.FrequencyModulation.RepCapIdentifier = channelName;
            FMEnabled = obj.IvicFgen.FrequencyModulation.FM_Enabled_FM;
            
            obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = channelName;
            AMEnabled =  obj.IvicFgen.AmplitudeModulation.AM_Enabled_AM;
            
            obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
            opMode =  obj.IvicFgen.BasicOperation.Operation_Mode;
            
            
            if (FMEnabled )
                mode = ModeEnum.FM;
            elseif( AMEnabled)
                mode = ModeEnum.AM;
            elseif (opMode == 1 )
                mode =ModeEnum.Burst;
            elseif (opMode ==0 )
                mode =ModeEnum.Continuous;
            end
            
            mode = ModeEnum.getString(mode);
        end
        
        function set.Mode (obj, mode)
            
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*
            if mode == ModeEnum.Burst
                %disable FM
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.FrequencyModulation.FM_Enabled_FM = false;
                
                % disable AM
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.AmplitudeModulation.AM_Enabled_AM = false;
                
                % switch to burst mode
                obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
                obj.IvicFgen.BasicOperation.Operation_Mode = 1;
            elseif  mode == ModeEnum.AM
                
                % switch to continuous mode
                obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
                obj.IvicFgen.BasicOperation.Operation_Mode = 0;
                
                % disable FM
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.FrequencyModulation.FM_Enabled_FM = false;
                
                % enable AM
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.AmplitudeModulation.AM_Enabled_AM = true;
                
            elseif mode == ModeEnum.FM
                
                % switch to continuous mode
                obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
                obj.IvicFgen.BasicOperation.Operation_Mode = 0;
                
                % disable AM
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.AmplitudeModulation.AM_Enabled_AM = false;
                
                % enable FM
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.FrequencyModulation.FM_Enabled_FM = true;
            else
                % switch to continuous mode
                obj.IvicFgen.BasicOperation.RepCapIdentifier = channelName;
                obj.IvicFgen.BasicOperation.Operation_Mode = 0;
                
                % also need to disable FM and AM if it is on
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.FrequencyModulation.FM_Enabled_FM = false;
                
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = channelName;
                obj.IvicFgen.AmplitudeModulation.AM_Enabled_AM = false;
            end
            
            
        end
        
        
        function value = get.ModulationSource(obj)
            
            channelName = obj.validateSelectedChannel;
            
            if strcmpi (obj.Mode , 'AM' )
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier =  channelName;
                instrumentValue = obj.IvicFgen.AmplitudeModulation.AM_Source_AM;
            elseif strcmpi (obj.Mode , 'FM')
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier =  channelName;
                instrumentValue = obj.IvicFgen.FrequencyModulation.FM_Source_FM;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            
            import instrument.internal.udm.fgen.*
            value = ModulationSourceEnum.getString(instrumentValue);
            
        end
        
        function  set.ModulationSource(obj, value)
            channelName = obj.validateSelectedChannel;
            
            if strcmpi (obj.Mode , 'AM' )
                
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier =  channelName;
                obj.IvicFgen.AmplitudeModulation.AM_Source_AM  = uint32(value);
            elseif strcmpi (obj.Mode , 'FM')
                
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier =  channelName;
                obj.IvicFgen.FrequencyModulation.FM_Source_FM  = uint32(value);
            else
                
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        
        function value = get.ModulationWaveform(obj)
            
            if strcmpi (obj.Mode , 'AM' )
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
                instrumentValue = obj.IvicFgen.AmplitudeModulation.AM_Internal_Waveform_AM;
                
            elseif strcmpi (obj.Mode , 'FM')
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
                instrumentValue = obj.IvicFgen.FrequencyModulation.FM_Internal_Waveform_FM;
                
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            
            import instrument.internal.udm.fgen.*
            value = ModulationWaveformEnum.getString(instrumentValue);
        end
        
        function  set.ModulationWaveform(obj, value)
            
            if strcmpi (obj.Mode , 'AM' )
                % can not set the repeated capability
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
                obj.IvicFgen.AmplitudeModulation.AM_Internal_Waveform_AM  = uint32(value);
            elseif strcmpi (obj.Mode , 'FM')
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
                obj.IvicFgen.FrequencyModulation.FM_Internal_Waveform_FM  = uint32(value);
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
            
        end
        
        function value = get.ModulationFrequency(obj)
            
            if strcmpi (obj.Mode , 'AM' )
                % can not set the repeated capability
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
                value = obj.IvicFgen.AmplitudeModulation.AM_Internal_Frequency_AM;
                
            elseif strcmpi (obj.Mode , 'FM')
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
                value = obj.IvicFgen.FrequencyModulation.FM_Internal_Frequency_FM;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        
        function  set.ModulationFrequency(obj, value)
            if strcmpi (obj.Mode , 'AM' )
                % can not set the repeated capability
                obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
                obj.IvicFgen.AmplitudeModulation.AM_Internal_Frequency_AM  = value;
            elseif strcmpi (obj.Mode , 'FM')
                obj.IvicFgen.FrequencyModulation.RepCapIdentifier ='';
                obj.IvicFgen.FrequencyModulation.FM_Internal_Frequency_FM  = value;
            else
                error (message ('instrument:fgen:needToSetAMFM'));
            end
        end
        
        % this property can be set differently via front panel
        % however , we can not do it through driver ( don't support repcap
        function value = get.AMDepth(obj)
            % can not set the repcap
            obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
            value = obj.IvicFgen.AmplitudeModulation.AM_Internal_Depth_AM ;
        end
        
        function  set.AMDepth(obj, value)
            % can not set the repcap
            obj.IvicFgen.AmplitudeModulation.RepCapIdentifier = '';
            obj.IvicFgen.AmplitudeModulation.AM_Internal_Depth_AM  = value;
        end
        
        
        function removeWaveform (obj, varargin)
            channelName = obj.validateSelectedChannel;
            
            if isempty (varargin)
                if  isempty (obj.InternalWaveformHandle)
                    error (message ('instrument:fgen:needWaveformHandle'));
                else
                    waveformHandle = obj.InternalWaveformHandle;
                    %reset internal waveform handle
                    obj.InternalWaveformHandle = [];
                end
            else
                waveformHandle = varargin{1};
            end
            
            try
                obj.IvicFgen.ConfigurationFunctions.ArbitraryWaveform.ClearArbWaveform(waveformHandle);
            catch eIvi
                if strcmpi(eIvi.identifier, 'instrument:ivic:failedToExecute')
                    error(message('instrument:fgen:needWaveformHandle'));
                else
                    rethrow(eIvi);
                end
            end
            
            try
                % make sure fgen stay in Arb mode if it was
                import instrument.internal.udm.fgen.*
                if obj.Waveform == WaveformEnum.Arb
                    obj.OutputMode = 1;
                end
            catch e % ignore this error
            end
        end
        
        function selectWaveform(obj, waveformHandle)
            
            channelName = obj.validateSelectedChannel;
            import instrument.internal.udm.fgen.*
            if obj.Waveform == WaveformEnum.Arb
                
                if  isempty (waveformHandle)
                    error (message ('instrument:fgen:needWaveformHandle'));
                end
                
                obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
                obj.IvicFgen.ArbitraryWaveformOutput.Arbitrary_Waveform_Handle_ARB = waveformHandle;
            else
                error (message ('instrument:fgen:ArbWaveformOnly'));
            end
        end
        
        %% Arb waveform related properties
        function set.ArbWaveformGain (obj, value)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
            
            obj.IvicFgen.ArbitraryWaveformOutput.Arbitrary_Waveform_Gain_ARB = value;
        end
        
        function value = get.ArbWaveformGain (obj)
            
            channelName = obj.validateSelectedChannel;
            obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier = channelName;
            
            value = obj.IvicFgen.ArbitraryWaveformOutput.Arbitrary_Waveform_Gain_ARB ;
        end
        
        %allow user to create an Arb waveform with a name
        %if such name exist, it will overwrite the old data with new data
        function varargout = downloadWaveform(obj, waveformDataArray)
            
            channelName = obj.validateSelectedChannel;
            % have to disable repeated capability before query Max_Number_of_Waveforms_ARB
            obj.IvicFgen.ArbitraryWaveformOutput.RepCapIdentifier ='';
            % check waveform min and max size
            minsize =  obj.IvicFgen.ArbitraryWaveformOutput.Min_Waveform_Size_ARB;
            maxsize =  obj.IvicFgen.ArbitraryWaveformOutput.Max_Waveform_Size_ARB;
            waveformSize = length (waveformDataArray);
            if waveformSize > maxsize ||   waveformSize < minsize
                error (message ('instrument:fgen:wrongWaveformSize', minsize , maxsize));
            end
            
            % normalize the waveform so values are between -1 to + 1
            if  max ( abs (waveformDataArray )) ~= 0
                waveformDataArray =  ( waveformDataArray./ max (waveformDataArray ))';
            end
            
            % reuse the old Arb waveform slot if user doesn't provide LHS
            % argument
            if ~isempty (obj.InternalWaveformHandle) && nargout == 0
                obj.removeWaveform (obj.InternalWaveformHandle);
            end
            
            % create an Arb waveform
            try
                waveformHandle = obj.IvicFgen.ConfigurationFunctions.ArbitraryWaveform.CreateArbWaveform(waveformSize,waveformDataArray);
            catch e
                switch e.identifier
                    case {'instrument:ivic:errorCode', ...
                          'instrument:ivic:failedToExecute'}
                        rethrow(e)
                    otherwise 
                        error(message('instrument:fgen:noMemorySpace'));
                end                
            end
            
            if nargout == 0
                obj.InternalWaveformHandle = waveformHandle;
            else
                tempOut = cell(1, 1);
                [tempOut{:}] = waveformHandle;
                varargout = tempOut;
            end
        end
        
        function selectChannel(obj , channelName)
            
            obj.validateChannelName(channelName);
            % single channel
            if isempty (obj.ChannelNames{1} ) || (numel(obj.ChannelNames) == 1)
                obj.SelectedChannel = '';
            else        % dual channel
                if ~isempty (obj.SelectedChannel)
                    if ~strcmpi (obj.SelectedChannel,channelName)
                        error (message ('instrument:fgen:cannotChangeChannel'));
                    end
                else
                    obj.SelectedChannel = channelName;
                end
            end
        end
        
        
        function value = get.SelectedChannel(obj)
            % single channel without channel name
            if isempty (obj.ChannelNames{1})
                value = '1';
                % single channel with channel name
            elseif (length(obj.ChannelNames) == 1)
                value = obj.ChannelNames{1};
                
            else   % dual channel case, this can't be empty
                if isempty (obj.SelectedChannel)
                    value = '';
                else
                    value = obj.SelectedChannel;
                end
            end
        end
        
        function value = validateSelectedChannel(obj)
            
            % single channel without channel name
            if isempty (obj.ChannelNames{1})
                value = '1';
                % single channel with channel name
            elseif (length (obj.ChannelNames) == 1)
                value = obj.ChannelNames{1};
                % dual channel case, this can't be empty
            else
                if isempty (obj.SelectedChannel)
                    error (message ('instrument:fgen:needToSelectChannel'));
                else
                    value = obj.SelectedChannel;
                end
            end
        end
    end
    
    methods  (Access = protected)
        function connect(obj)
            obj.IvicFgen.init( obj.LogicalName, false, false  );
        end
    end
end

% LocalWords:  IVI Fgen fgen's ivic Ivi udm fgen ivi arb repcap IVIFGEN FUNC
% LocalWords:  AMFM qcinstrument
