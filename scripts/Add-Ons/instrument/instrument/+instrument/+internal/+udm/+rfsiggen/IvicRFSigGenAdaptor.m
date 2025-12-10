classdef IvicRFSigGenAdaptor < instrument.internal.udm.rfsiggen.RFSigGenAdaptor
    % IVICRFSIGGENADAPTOR Class follows the adaptor design pattern and
    % provides bridge between IVI-C class compliant RFSigGen wrapper and
    % rfsiggen's state machine. It is a concrete class which overrides
    % the methods defined in RFSigGenAdaptor class.
    
    % Copyright 2016-2023 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        % A instance of instrument.ivic.IviRFSigGen class
        IvicRFSigGen
        
        % Properties used to store temporary entries in configuration store
        HardwareAsset
        Session
        LogicalName
    end
    
    
    properties (Dependent = true)
        % Redefines the abstract properties specified in RFSigGenAdaptor class
        
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
    
    
    
    methods (Static)
        function [rfsiggenAdapter, driverName] = createByResource(resource)
            % CREATEBYRESOURCE Static method tries to create a IVI-C
            % adapter based on the resource info.
            import instrument.internal.udm.*;
            
            rfsiggenAdapter = [];
            driverName ='';

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor
            try
                % Use resource info, find out available IVI function
                % generator drivers from configuration store.
                iviRFSigGenDrivers = instrument.internal.udm.ConfigStoreUtility.getIVIInstrumentDriversFromResource(InstrumentType.RFSigGen, resource);
                if bitand(iviRFSigGenDrivers{1}.type , IVITypeEnum.IVIC)
                    driverName = iviRFSigGenDrivers{1}.Name;
                    % Calls the constructor
                    rfsiggenAdapter = feval(str2func('instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor') ,driverName, resource);
                end
            catch e %#ok<*NASGU>
                
                % Throw this specific error (need mex-setup) and ignore
                % other errors
                if strcmpi(e.identifier , 'MATLAB:CompilerConfiguration:NoSelectedOptionsFile')
                    throwAsCaller(e);
                end
                
                % In case an IVI-C adapter instance cannot be instantiated, an empty adapter
                % is returned. It hands over the responsibility to the next adapter.
            end
            
        end
        
        function [rfsiggenAdapter, driver] = createByDriverAndResource( driverName, resource)
            % CREATEBYDRIVERANDRESOURCE Static method tries to create a IVI-C adapter based on the
            % resource and driver info.

            import instrument.internal.udm.*;
            rfsiggenAdapter =[];
            driver ='';

            if driverName == "niRFSG"
                return
            end

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor
            try
                iviRFSigGenDriver = instrument.internal.udm.ConfigStoreUtility.getIviInstrumentDriver(InstrumentType.RFSigGen, driverName);
                if bitand(iviRFSigGenDriver.type , IVITypeEnum.IVIC)
                    % Calls the constructor
                    rfsiggenAdapter = feval(str2func('instrument.internal.udm.rfsiggen.IvicRFSigGenAdaptor') ,driverName, resource);
                end
            catch e
                % Throw this specific error (need mex-setup) and ignore
                % other errors
                if strcmpi(e.identifier , 'MATLAB:CompilerConfiguration:NoSelectedOptionsFile')
                    throwAsCaller(e);
                end
                % In case an IVI-C adapter instance cannot be instantiated, an empty adapter
                % is returned. It hands over the responsibility to the next adapter.
            end
        end
        
        function driverInfo = getDriver()
            % GETDRIVER static method iterates through configuration store
            % and find out the IVI-C specific rfsiggen drivers
            
            % All ivi function generator drivers
            import instrument.internal.udm.*;
            iviRFSigGenDriverInfo =  ConfigStoreUtility.getInstalledIVIInstrumentDrivers(InstrumentType.RFSigGen);
            
            % ivi-c function generator driver only
            driverInfo = {};
            for i = 1: size (iviRFSigGenDriverInfo, 2)
                if bitand(iviRFSigGenDriverInfo{i}.type ,IVITypeEnum.IVIC)
                    driverInfo{end+1} = iviRFSigGenDriverInfo{i}; %#ok<*AGROW>
                end
            end
        end
        
        function resource = getResource(varargin)
            % GETRESOURCE static method discovers the resource based on
            % resource discovery methods defined in adapters.config file
            resource ={};
            
            if strcmpi (varargin{1}, 'visa')
                visaResource = instrument.internal.udm.InstrumentUtility.getVisaResources;
                resource = horzcat(resource, visaResource);
            end
        end
    end
    
    
    methods
        %Constructor
        function obj = IvicRFSigGenAdaptor(driverName, resource )
            % IVICRFSIGGENADAPTOR Constructor creates temporary entries
            % (hardware asset, session and logical name) in configuration
            % store. This step is necessary before using IVI-C function
            % generator wrapper.
            [~, name, ~] = fileparts(tempname);
            obj.HardwareAsset = sprintf('%s_RFSigGenHardwareAsset', name);
            obj.Session = sprintf('%s_RFSigGenSession', name);
            obj.LogicalName = sprintf('%s_RFSigGen', name);
            
            % Create temporary configuration store entries used by
            % connect() method.
            instrument.internal.udm.ConfigStoreUtility.addLogicalName(  obj.HardwareAsset, resource ,  obj.Session, driverName, obj.LogicalName);
            
            % Suppresses IviRFSigGen remove functionality warning.
            warnState = instrument.internal.udm.WarningUtility.disableWarnings();
            c = onCleanup(@()instrument.internal.udm.WarningUtility.restoreWarnState(warnState));

            % Create an instance of underlying IVI-C IvicRFSigGen wrapper.
            obj.IvicRFSigGen = instrument.ivic.IviRFSigGen;
            % Since the adapter is created upon rfsiggen's connect() method
            % it should automatically call connect().
            obj.connect();
            
            % Configures the attributes that control the signal generator's
            % IQ modulation.
            % Specifies internally generated Arb signal to be the source of
            % the signal that the signal generator uses for IQ modulation.
            % Disables the inverse phase rotation of the IQ signal by
            % swapping the I and Q inputs.
            iqSource = instrument.internal.udm.rfsiggen.IQSourceEnum.ArbGenerator;
            iqSwapEnabled = false;
            obj.configureIQ(iqSource,iqSwapEnabled);
            obj.enableOutput(false);
            obj.IQEnabled = false;
        end
        
        function delete(obj)
            
            % Disconnect the instrument first
            obj.disconnect();
            
            obj.IvicRFSigGen =[];
            
            % Removes temporary configuration store entries created during
            % class constructor.
            instrument.internal.udm.ConfigStoreUtility.removeLogicalName(obj.HardwareAsset, obj.Session, obj.LogicalName);
        end
        
        
        function reset(obj)
            obj.IvicRFSigGen.UtilityFunctions.reset();
        end
        
        function disconnect(obj)
            % DISCONNECT Check to make sure IvicRFSigGen object exists before executing
            % close
            if ~isempty(obj.IvicRFSigGen)
                obj.IvicRFSigGen.close();
            end
        end
        
        function enableOutput(obj, enable)
            % ENABLEOUTPUT Configures the signal generator to enable or disable the RF
            % output signal.
            try
                obj.IvicRFSigGen.ConfigurationFunctions.RF.ConfigureOutputEnabled(enable);
            catch e
                throwAsCaller(e);
            end
        end
        
        function enableIQ(obj, enable)
            
            % ENABLEIQ Configures the signal generator to apply IQ (vector)
            % modulation to the RF output signal.
            try
                obj.IvicRFSigGen.ConfigurationFunctions.IQ.ConfigureIQEnabled(enable);
            catch e
                throwAsCaller(e);
            end
        end
        
        function disableAllModulation(obj)
            
            % DISABLEALLMODULATION Disables all currently enabled modulations.
            try
                obj.IvicRFSigGen.ActionFunctions.DisableAllModulation;
            catch e
                throwAsCaller(e);
            end
        end
        
        function sendSoftwareTrigger(obj)
            
            % SENDSOFTWARETRIGGER Sends a software trigger, which will cause the signal
            % generator to start signal generation.
            try
                obj.IvicRFSigGen.ActionFunctions.SendSoftwareTrigger;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            
            if obj.IvicRFSigGen.initialized
                manufacturer = obj.IvicRFSigGen.InherentIVIProperties.InstrumentIdentification.Manufacturer;
                model = obj.IvicRFSigGen.InherentIVIProperties.InstrumentIdentification.Model;
                manufacturer = deblank (manufacturer);
                model = deblank(model);
                textToDisp = sprintf ('%s %s', strtrim(manufacturer), strtrim(model));
            end
            value =  textToDisp;
            
        end
        
        function value = get.Frequency(obj)
            value = obj.IvicRFSigGen.RF.Frequency;
        end
        
        function  set.Frequency(obj,  value)
            obj.IvicRFSigGen.RF.Frequency = value;
        end
        
        function value = get.PowerLevel(obj)
            value = obj.IvicRFSigGen.RF.Power_Level;
        end
        
        function  set.PowerLevel(obj,  value)
            obj.IvicRFSigGen.RF.Power_Level = value;
        end
        
        function value = get.OutputEnabled(obj)
            value = obj.IvicRFSigGen.RF.Output_Enabled;
        end
        
        function  set.OutputEnabled(obj,  value)
            obj.IvicRFSigGen.RF.Output_Enabled = value;
        end
        
        function value = get.IQEnabled(obj)
            value = obj.IvicRFSigGen.IQ.IQ_Enabled_MIQ;
        end
        
        function  set.IQEnabled(obj,  value)
            obj.IvicRFSigGen.IQ.IQ_Enabled_MIQ = value;
        end
        
        function value = get.ClockFrequency(obj)
            value = obj.IvicRFSigGen.ARBGenerator.ARB_Clock_Frequency_ARB;
        end
        
        function  set.ClockFrequency(obj,  value)
            obj.IvicRFSigGen.ARBGenerator.ARB_Clock_Frequency_ARB = value;
        end
        
        function value = get.IQSource(obj)
            instrumentValue = obj.IvicRFSigGen.IQ.IQ_Source_MIQ;
            value = instrument.internal.udm.rfsiggen.IQSourceEnum.getString (instrumentValue);
        end
        
        function  set.IQSource(obj, value)
            obj.IvicRFSigGen.IQ.IQ_Source_MIQ = value;
        end
        
        function value = get.IQSwapEnabled(obj)
            value = obj.IvicRFSigGen.IQ.IQSwap_Enabled_MIQ;
        end
        
        function  set.IQSwapEnabled(obj, value)
            obj.IvicRFSigGen.IQ.IQSwap_Enabled_MIQ = value;
        end
        
        function value = get.ArbTriggerSource(obj)
            instrumentValue = obj.IvicRFSigGen.ARBGenerator.Trigger.ARB_Trigger_Source_ARB;
            value = instrument.internal.udm.rfsiggen.ArbTriggerSourceEnum.getString (instrumentValue);
        end
        
        function  set.ArbTriggerSource(obj, value)
            obj.IvicRFSigGen.ARBGenerator.Trigger.ARB_Trigger_Source_ARB = value;
        end
        
        function value = get.ArbSelectedWaveform(obj)
            value = obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Selected_Waveform_ARB;
        end
        
        function  set.ArbSelectedWaveform(obj, value)
            obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Selected_Waveform_ARB = value;
        end
        
        function value = get.ArbWaveformQuantum(obj)
            value = obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Quantum_ARB;
        end
        
        function value = get.ArbMinWaveformSize(obj)
            value = obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Size_Min_ARB;
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            value = obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Size_Max_ARB;
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            value = obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Max_Number_Waveforms_ARB;
        end
        
        function value = get.Revision(obj)
            value = obj.IvicRFSigGen.InherentIVIProperties.DriverIdentification.Revision;
        end
        
        function value = get.FirmwareRevision(obj)
            value = obj.IvicRFSigGen.InherentIVIProperties.InstrumentIdentification.Firmware_Revision;
        end
        
        function  configureRF(obj, frequency, powerLevel)
            obj.IvicRFSigGen.ConfigurationFunctions.RF.ConfigureRF(frequency,powerLevel);
        end
        
        function  configureIQ(obj, source, swapEnabled)
            obj.IvicRFSigGen.ConfigurationFunctions.IQ.ConfigureIQ(source,swapEnabled);
        end
        
        function  configureArbTriggerSource(obj, source)
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.ConfigureArbTriggerSource(source);
        end
        
        function  selectArbWaveform(obj, name)
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.SelectArbWaveform(name);
        end
        
        function  writeArbWaveform(obj, name, numberOfSamples, iData, qData, moreDataPending)
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.WriteArbWaveform(name, numberOfSamples, iData, qData, moreDataPending);
        end
        
        function  clearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS Deletes all waveforms from the pool of
            % waveforms in volatile memory. It will not clear the waveform
            % in the NVWFM memory which is none volatile.
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.ClearAllArbWaveforms;
        end
        
        function  [value, actualSize] = systemIoRead(obj,valueSize)
            % SYSTEMIOREAD Provides direct read access to the underlying
            % instrument I/O interface.
            [value, actualSize] = obj.IvicRFSigGen.System.SystemIoRead(valueSize);
            
        end
        
        function  systemIoWrite(obj,commandString)
            % SYSTEMIOWRITE Provides direct read access to the underlying
            % instrument I/O interface.
            obj.IvicRFSigGen.System.SystemIoWrite(commandString);
            
        end
        
        function memoryDeleteFile(obj,fileNameBufferSize,fileName)
            obj.IvicRFSigGen.Memory.MemoryDeleteFile(fileNameBufferSize,fileName);
        end
        
        
        function download(obj, waveformDataArray, clockFrequency)
            % DOWNLOAD Allow user to create an Arb waveform with the name
            % 'matlabIQData' if such name exists, it will overwrite the old
            % data with new data.
            
            % Check waveform min and max size
            minsize =  obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Size_Min_ARB;
            maxsize =  obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Size_Max_ARB;
            quantum =  obj.IvicRFSigGen.ARBGenerator.Waveform.ARB_Waveform_Quantum_ARB;
            waveformSize = length (waveformDataArray);
            if waveformSize > maxsize ||  waveformSize < minsize ||  mod(waveformSize,quantum) ~=0
                error (message ('instrument:rfsiggen:wrongWaveformSize', minsize , maxsize, quantum));
            end

            % normalize the waveform so values are between -1 to + 1
            [iData, qData] = ...
                instrument.internal.udm.rfsiggen.normalizeIQWaveformData(waveformDataArray);

            dataName = 'matlabIQData';
            moreDataPending = false;
            
            % create an Arb waveform
            try
                obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.WriteArbWaveform(dataName, waveformSize, iData, qData, moreDataPending);
            catch  e
                error (message ('instrument:rfsiggen:instrumentError'));
            end
            
            % Selects the downloaded waveform to become active.
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.SelectArbWaveform(dataName);
            % Sets the Arb Clock Frequency.
            obj.IvicRFSigGen.ARBGenerator.ARB_Clock_Frequency_ARB = clockFrequency;
        end
        
        function start(obj,  centerFrequency, outputPower, loopCount)
            % START Enables the RF signal generator signal output and modulation output.
            import instrument.internal.udm.rfsiggen.*;
            source = '';
            if isinf(loopCount)
                source = ArbTriggerSourceEnum.getEnum('Immediate');
            else
                source = ArbTriggerSourceEnum.getEnum('Software');
            end
            obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.ConfigureArbTriggerSource(source);
            enabled = true;
            % Configures the frequency and the power level of the RF output signal.
            obj.IvicRFSigGen.ConfigurationFunctions.RF.ConfigureRF(centerFrequency,outputPower);
            % Enable RF output.
            obj.IvicRFSigGen.ConfigurationFunctions.RF.ConfigureOutputEnabled(enabled);
            % Disable all modulation output.
            obj.IvicRFSigGen.ActionFunctions.DisableAllModulation;
            % Enable IQ modulation output only.
            obj.IvicRFSigGen.ConfigurationFunctions.IQ.ConfigureIQEnabled(enabled);
            % Send loopCount times software trigger signal to trigger the
            % modulation output if the loopCount is not Inf. Wait for the
            % previous trigger to be completed before sending another
            % software trigger.
            if ~isinf(loopCount)
                for index = 1 : loopCount
                    obj.IvicRFSigGen.ActionFunctions.SendSoftwareTrigger;
                    maxTimeMilliseconds = 1000;
                    obj.IvicRFSigGen.ActionFunctions.WaitUntilSettled(maxTimeMilliseconds);
                end
                stop(obj);
            end
        end
        
        function stop(obj)
            % STOP Configures the signal generator to disable RF output signal. It
            % also disables all currently enabled modulations.
            enabled = false;
            try
                % Disable all modulation output.
                obj.IvicRFSigGen.ActionFunctions.DisableAllModulation;
                % Disable IQ modulation output.
                obj.IvicRFSigGen.ConfigurationFunctions.IQ.ConfigureIQEnabled(enabled);
                % Disable RF output.
                obj.IvicRFSigGen.ConfigurationFunctions.RF.ConfigureOutputEnabled(enabled);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                queryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES Returns the capabilities of the
            % ARB generator.
            [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                obj.IvicRFSigGen.ConfigurationFunctions.ARBGenerator.QueryArbWaveformCapabilities;
        end
        
        function waitUntilSettled(obj, maxTimeMilliseconds)
            % WAITUNTILSETTLED Returns if the state of the RF output signal has settled.
            obj.IvicRFSigGen.ActionFunctions.WaitUntilSettled(maxTimeMilliseconds);
        end
        
        function done = isSettled(obj)
            % ISSETTLED Queries the state of the RF output signal.
            done = obj.IvicRFSigGen.ActionFunctions.IsSettled;
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            % REVISIONQUERY Retrieves revision information from the instrument.
            [driverRev, instrRev]=obj.IvicRFSigGen.UtilityFunctions.revision_query;
        end
        
    end
    methods (Hidden = true, Access = protected)
        % The connect() function has to be protected as super class is.
        function connect(obj)
            obj.IvicRFSigGen.init( obj.LogicalName, false, false  );
        end
    end
end
