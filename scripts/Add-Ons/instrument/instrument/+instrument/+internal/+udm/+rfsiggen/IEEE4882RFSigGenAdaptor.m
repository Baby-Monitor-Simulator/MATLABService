classdef IEEE4882RFSigGenAdaptor < instrument.internal.udm.rfsiggen.RFSigGenAdaptor
    % IEEE4882RFSigGenAdaptor class follows the adaptor design pattern and provides
    % bridge between interface rfsiggen wrapper and rfsiggen's state machine.
    % It is a concrete class which overrides the methods defined in RFSigGenAdaptor class.
    
    % Copyright 2017-2021 The MathWorks, Inc.
    
    properties (Access = private)
        % An instance of instrument.ieee4882.rfsiggen class
        IEEE4882RFSigGen
    end
    
    properties (Dependent, Access = public)
        % Redefines the abstract variables specified in RFSigGenAdaptor class
        Frequency
        PowerLevel
        OutputEnabled
        IQEnabled
        IQSource
        IQSwapEnabled
        ClockFrequency
        FilterFrequency
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
            % CREATEBYRESOURCE Static method tries to create a IEEE4882 adapter based on the
            % resource info.
            rfsiggenAdapter = [];
            driverName ='';
            FirmwareVersion = '';
            try
                % Calls the constructor
                rfsiggenAdapter = instrument.internal.udm.rfsiggen.IEEE4882RFSigGenAdaptor('', resource);
                driverName = rfsiggenAdapter.IEEE4882RFSigGen.DriverName;
            catch e %#ok<*NASGU>
                % In case an ieee488.2 adapter instance can not be instantiated, an empty adapter
                % is returned. It hands over the responsibility to the next adapter.
            end
            
        end
        
        function [rfsiggenAdapter, driver] = createByDriverAndResource( driverName, resource)
            % CREATEBYDRIVERANDRESOURCE static method tries to create an interface adapter based on the
            % resource and driver name.
            rfsiggenAdapter =[];
            driver ='';
            % Get list of IEEE488.2 drivers for RFSigGen class instruments
            supportedIEEE4882Drivers = instrument.ieee4882.DriverUtility.getDrivers('rfsiggen');
            for iLoop = 1:length(supportedIEEE4882Drivers)
                % If the drivername matches the user supplied drivername,
                % then try to instantiate. Else, this function will return
                % an empty adapter
                if isequal(driverName,supportedIEEE4882Drivers{iLoop}.Name)
                    try
                        % Calls the constructor
                        rfsiggenAdapter = instrument.internal.udm.rfsiggen.IEEE4882RFSigGenAdaptor (driverName, resource);
                        % Break out of the loop if the constructor returned
                        % successfully
                        break
                    catch e
                        % In case an ieee488 adapter instance can not be instantiated, an empty adapter
                        % is returned. It hands over the responsibility to the next adapter.
                    end
                end
            end
        end
        
        function driverInfo = getDriver()
            % GETDRIVER Static method delegate the job to
            % DriverUtility and find out the ieee488.2 specific rfsiggen drivers
            driverInfo = instrument.ieee4882.DriverUtility.getDrivers('rfsiggen');
        end
        
        function resource = getResource(varargin)
            % GETRESOURCE Static method discovers the resource based on
            % resource discovery methods defined in adapters.config file
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
        % Constructor
        function obj = IEEE4882RFSigGenAdaptor(driverName, resource )
            % IEEE4882RFSIGGENADAPTOR Since the adapter is created upon rfsiggen's connect() method
            % it should automatically call connect()
            obj.IEEE4882RFSigGen =  instrument.ieee4882.RFSigGen(resource);
            if ~isempty ( driverName ) % overwrite driver name
                obj.IEEE4882RFSigGen.DriverName = driverName;
            end
            obj.connect();
        end
        
        function delete(obj)
            % DELETE Disconnect the instrument first
            if ~isempty(obj.IEEE4882RFSigGen)
                obj.disconnect();
                obj.IEEE4882RFSigGen =[];
            end
        end
        
        function reset(obj)
            % RESET the connected instrument.
            obj.IEEE4882RFSigGen.UtilityFunctions.reset();
        end
        
        function disconnect(obj)
            % DISCONNECT Dispatch call to underlying adaptor.
            obj.IEEE4882RFSigGen.disconnect();
        end
        
        function enableOutput(obj, enable)
            % ENABLEOUTPUT Configures the signal generator to enalbe or disable the RF
            % output signal.
            try
                obj.IEEE4882RFSigGen.RF.ConfigureOutputEnabled(enable);
            catch e
                throwAsCaller(e);
            end
        end
        
        function enableIQ(obj, enable)
            % ENABLEIQ Configures the signal generator to apply IQ (vector)
            % modulation to the RF output signal.
            try
                obj.IEEE4882RFSigGen.IQ.IQEnabled = enable;
            catch e
                throwAsCaller(e);
            end
        end
        
        function disableAllModulation(obj)
            % DISABLEALLMODULATION This function disables all currently enabled modulations.
            try
                obj.IEEE4882RFSigGen.ActionFunctions.DisableAllModulation;
            catch e
                throwAsCaller(e);
            end
        end
        
        function sendSoftwareTrigger(obj)
            % SENDSOFTWARETRIGGER Sends a software trigger, which will cause the signal
            % generator to start signal generation.
            try
                obj.IEEE4882RFSigGen.ActionFunctions.SendSoftwareTrigger;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = getInstrumentInfo(obj)
            % GETINSTRUMENTINFO Get information of the connected instrument. 
            textToDisp = '';
            
            if obj.IEEE4882RFSigGen.Connected
                [manufacturer, model] = obj.IEEE4882RFSigGen.UtilityFunctions.getInstrumentInfo;
                manufacturer = deblank (manufacturer);
                model = deblank(model);
                textToDisp = sprintf ('%s %s', strtrim(manufacturer), strtrim(model));
            end
            value =  textToDisp;
        end
        
        function value = get.Frequency(obj)
            value = obj.IEEE4882RFSigGen.RF.Frequency;
        end
        
        function  set.Frequency(obj,  value)
            obj.IEEE4882RFSigGen.RF.Frequency = value;
        end
        
        function value = get.PowerLevel(obj)
            value = obj.IEEE4882RFSigGen.RF.PowerLevel;
        end
        
        function  set.PowerLevel(obj,  value)
            obj.IEEE4882RFSigGen.RF.PowerLevel = value;
        end
        
        function value = get.OutputEnabled(obj)
            value = obj.IEEE4882RFSigGen.RF.OutputEnabled;
        end
        
        function  set.OutputEnabled(obj,  value)
            obj.IEEE4882RFSigGen.RF.OutputEnabled = value;
        end
        
        function value = get.IQEnabled(obj)
            value = obj.IEEE4882RFSigGen.IQ.IQEnabled;
        end
        
        function  set.IQEnabled(obj,  value)
            obj.IEEE4882RFSigGen.IQ.IQEnabled = value;
        end
        
        function value = get.ClockFrequency(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.ClockFrequency;
        end
        
        function  set.ClockFrequency(obj,  value)
            obj.IEEE4882RFSigGen.ARBGenerator.SetClockFrequency(value);
        end
        
        function value = get.FilterFrequency(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.FilterFrequency;
        end
        
        function  set.FilterFrequency(obj,  value)
            obj.IEEE4882RFSigGen.ARBGenerator.FilterFrequency = value;
        end
        
        function value = get.IQSource(obj)
            instrumentValue = obj.IEEE4882RFSigGen.IQ.IQSource;
            import instrument.internal.udm.rfsiggen.*;
            value = IQSourceEnum.getString (instrumentValue);
        end
        
        function  set.IQSource(obj, value)
            obj.IEEE4882RFSigGen.IQ.IQSource = value;
        end
        
        function value = get.IQSwapEnabled(obj)
            value = obj.IEEE4882RFSigGen.IQ.IQSwapEnabled;
        end
        
        function set.IQSwapEnabled(obj, value)
            obj.IEEE4882RFSigGen.IQ.IQSwapEnabled = value;
        end
        
        function value = get.ArbTriggerSource(obj)
            instrumentValue = obj.IEEE4882RFSigGen.ARBGenerator.TriggerSource;
            import instrument.internal.udm.rfsiggen.*;
            value = ArbTriggerSourceEnum.getString (instrumentValue);
        end
        
        function set.ArbTriggerSource(obj, value)
            obj.IEEE4882RFSigGen.ARBGenerator.TriggerSource = value;
        end
        
        function value = get.ArbSelectedWaveform(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.SelectedWaveform;
        end
        
        function set.ArbSelectedWaveform(obj, value)
            obj.IEEE4882RFSigGen.ARBGenerator.SelectedWaveform = value;
        end
        
        function value = get.ArbWaveformQuantum(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.WaveformQuantum;
        end
        
        function value = get.ArbMinWaveformSize(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.WaveformSizeMin;
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.WaveformSizeMax;
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            value = obj.IEEE4882RFSigGen.ARBGenerator.MaxNumberOfWaveforms;
        end
        
        function value = get.Revision(obj)
            value = obj.IEEE4882RFSigGen.UtilityFunctions.Revision;
        end
        
        function value = get.FirmwareRevision(obj)
            value = obj.IEEE4882RFSigGen.UtilityFunctions.FirmwareRevision;
        end
        
        function configureRF(obj, frequency, powerLevel)
            obj.IEEE4882RFSigGen.RF.ConfigureRF(frequency,powerLevel);
        end
        
        function configureIQ(obj, source, swapEnabled)
            obj.IEEE4882RFSigGen.IQ.ConfigureIQ(source,swapEnabled);
        end
        
        function configureArb(obj, clockFrequency, filterFrequency)
            obj.IEEE4882RFSigGen.IQ.ConfigureIQ(clockFrequency,filterFrequency);
        end
        
        function configureArbTriggerSource(obj, source)
            obj.IEEE4882RFSigGen.ARBGenerator.ConfigureArbTriggerSource(source);
        end
        
        function selectArbWaveform(obj, name)
            obj.IEEE4882RFSigGen.ARBGenerator.SelectArbWaveform(name);
        end
        
        function writeArbWaveform(obj, name, ~, iData, qData, moreDataPending)
            obj.IEEE4882RFSigGen.ARBGenerator.WriteArbWaveform(name, iData, qData, moreDataPending);
        end
        
        function clearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS This function deletes all waveforms from the pool of
            % waveforms in volatile memory. It will not clear the waveform
            % in the NVWFM memorry which is none volatile.
            obj.IEEE4882RFSigGen.ARBGenerator.ClearAllArbWaveforms;
        end
        
        function [value, actualSize] = systemIoRead(obj,valueSize)
            % SYSTEMIOREAD This function provides direct read access to the underlying
            % instrument I/O interface.
            [value, actualSize] = obj.IEEE4882RFSigGen.System.SystemIoRead(valueSize);
            
        end
        
        function  systemIoWrite(obj,commandString)
            % SYSTEMIOWRITE This function provides direct read access to the underlying
            % instrument I/O interface.
            obj.IEEE4882RFSigGen.System.SystemIoWrite(commandString);
            
        end
        
        function memoryDeleteFile(obj,fileNameBufferSize,fileName)
            obj.IEEE4882RFSigGen.Memory.MemoryDeleteFile(fileNameBufferSize,fileName);
        end
        
        
        function download(obj, waveformDataArray, clockFrequency)
            % DOWNLOAD Allow user to create an Arb waveform with the name
            % 'matlabIQData' if such name exist, it will overwrite the old
            % data with new data.
            
            % check waveform min and max size
            minsize =  obj.IEEE4882RFSigGen.ARBGenerator.WaveformSizeMin;
            maxsize =  obj.IEEE4882RFSigGen.ARBGenerator.WaveformSizeMax;
            quantum =  obj.IEEE4882RFSigGen.ARBGenerator.WaveformQuantum;
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
                obj.IEEE4882RFSigGen.ARBGenerator.WriteArbWaveform(dataName, iData, qData, moreDataPending);
            catch  e
                error (message ('instrument:rfsiggen:instrumentError'));
            end
            % Selects the downloaded waveform to become active.
            obj.IEEE4882RFSigGen.ARBGenerator.SelectArbWaveform(dataName)
            % Sets the Arb Clock Frequency.
            obj.IEEE4882RFSigGen.ARBGenerator.SetClockFrequency(clockFrequency);
        end
        
        function start(obj,  centerFrequency, outputPower, loopCount)
            % START Enables the RF signal generator to produce signal that
            % appears at the output connector. And it aslo enables the
            % modulation output.
            import instrument.internal.udm.rfsiggen.*;
            source = '';
            if isinf(loopCount)
                source = ArbTriggerSourceEnum.getEnum('Immediate');
                obj.IEEE4882RFSigGen.ARBGenerator.ConfigureArbTriggerSource(source);
            else
                source = ArbTriggerSourceEnum.getEnum('Software');
                obj.IEEE4882RFSigGen.ARBGenerator.ConfigureArbTriggerSource(source);
            end
            enabled = true;
            % Configures the frequency and the power level of the RF output signal.
            obj.IEEE4882RFSigGen.RF.ConfigureRF(centerFrequency,outputPower);
            % Enable RF output.
            obj.IEEE4882RFSigGen.RF.ConfigureOutputEnabled(enabled);
            % Disable all modulation output.
            obj.IEEE4882RFSigGen.ActionFunctions.DisableAllModulation;
            % Enable IQ modulation output only.
            obj.IEEE4882RFSigGen.IQ.ConfigureIQEnabled(enabled);
            % Send loopCount times software trigger sigle to triger the
            % modulation output if the loopCount is not Inf. And Waiting
            % for the previous trigger to be completted before sending
            % another software trigger.
            if ~isinf(loopCount)
                for index = 1 : loopCount
                    obj.IEEE4882RFSigGen.ActionFunctions.SendSoftwareTrigger;
                    maxTimeMilliseconds = 1000;
                    obj.IEEE4882RFSigGen.ActionFunctions.WaitUntilSettled(maxTimeMilliseconds);
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
                obj.IEEE4882RFSigGen.ActionFunctions.DisableAllModulation;
                % Disable IQ modulation output.
                obj.IEEE4882RFSigGen.IQ.ConfigureIQEnabled(enabled);
                % Disable RF output.
                obj.IEEE4882RFSigGen.RF.ConfigureOutputEnabled(enabled);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                queryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES This function returns the capabilities of the ARB generator.
            [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                obj.IEEE4882RFSigGen.ARBGenerator.QueryArbWaveformCapabilities;
        end
        
        function waitUntilSettled(obj, maxTimeMilliseconds)
            % WAITUNTILSETTLED This function returns if the state of the RF output signal has settled.
            obj.IEEE4882RFSigGen.ActionFunctions.WaitUntilSettled(maxTimeMilliseconds);
        end
        
        function done = isSettled(obj)
            % ISSETTLED This function queries the state of the RF output signal.
            done = obj.IEEE4882RFSigGen.ActionFunctions.IsSettled;
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            % REVISIONQUERY Retrieves revision information from the instrument.
            [driverRev, instrRev]=obj.IEEE4882RFSigGen.UtilityFunctions.revisionQuery;
        end
    end
    
    methods  (Access = protected)
        function connect(obj)
            try
                % CONNECT Dispatch to underlying adaptor
                obj.IEEE4882RFSigGen.connect();
            catch e
                throwAsCaller(e);
            end
        end
    end
end
