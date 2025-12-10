classdef (Hidden) RFSigGenTestAdaptor < instrument.internal.udm.rfsiggen.RFSigGenAdaptor
    % RFSIGGENTESTADAPTOR Class follows the adaptor design pattern and
    % provides a dummy rfsiggen capability to enable test without
    % real hardware. It is a concrete class which overrides
    % the methods defined in RFSigGenAdaptor class.
    
    % Copyright 2016-2021 The MathWorks, Inc.
    
    properties (Hidden, Access = private)
        Connected
    end
    
    
    properties
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
    end
    
    
    % Read only properties
    properties
        ArbWaveformQuantum = 2;
        ArbMinWaveformSize = 60;
        ArbMaxWaveformSize = 8000000;
        ArbMaxNumberWaveforms = 29609375;
        Revision = '1.6.0.0 ';
        FirmwareRevision = 'C.05.84.S015';
    end
    
    
    methods (Static)
        function [rfsiggenAdapter, driverName] = createByResource(resource)
            
            rfsiggenAdapter =[];
            driverName = '';
            try
                if strcmpi(resource, 'testresource')
                    driverName = 'testdriver';
                    rfsiggenAdapter = instrument.internal.udm.rfsiggen.RFSigGenTestAdaptor(driverName, resource);
                end
            catch e
                % In case a test adapter instance cannot be instantiated,
                % an empty adapter is returned. It hands over the
                % responsibility to the next adapter.
            end
        end
        
        function [rfsiggenAdapter, driverName] = createByDriverAndResource(driver, resource)
            rfsiggenAdapter =[];
            driverName = '';
            try
                if strcmpi(driver, 'testdriver')
                    driverName ='testdriver';
                    rfsiggenAdapter = instrument.internal.udm.rfsiggen.RFSigGenTestAdaptor(driver, resource);
                end
            catch e %#ok<*NASGU>
                % In case a test adapter instance cannot be instantiated, an empty adapter
                % is returned. It hands over the responsibility to the next adapter.
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
        % Constructor
        function obj = RFSigGenTestAdaptor(~, ~ )
            % Initialize parameters
            reset(obj);
        end
        
        function value = getInstrumentInfo(obj)
            textToDisp = '';
            if obj.Connected
                manufacturer = 'TMW';
                model = 'Dummy RFSigGen';
                textToDisp = sprintf ('%s %s.',manufacturer, model);
            end
            value =  textToDisp;
        end
    end
    
    methods
        function value = get.Frequency(obj)
            value = obj.Frequency;
        end
        
        function set.Frequency(obj, value)
            obj.Frequency = value;
        end
        
        function value = get.PowerLevel(obj)
            value = obj.PowerLevel;
        end
        
        function  set.PowerLevel(obj,  value)
            if value > 20
                value = 20;
            elseif value < -136
                value = -136;
            end
            obj.PowerLevel = value;
        end
        
        function value = get.OutputEnabled(obj)
            value = obj.OutputEnabled;
        end
        
        function  set.OutputEnabled(obj,  value)
            obj.OutputEnabled = value;
        end
        
        function value = get.IQEnabled(obj)
            value = obj.IQEnabled;
        end
        
        function  set.IQEnabled(obj,  value)
            obj.IQEnabled = value;
        end
        
        function value = get.ClockFrequency(obj)
            value = obj.ClockFrequency;
        end
        
        function  set.ClockFrequency(obj,  value)
            obj.ClockFrequency = value;
        end
        
        function value = get.IQSource(obj)
            value = instrument.internal.udm.rfsiggen.IQSourceEnum.getString (obj.IQSource);
        end
        
        function  set.IQSource(obj, value)
            obj.IQSource = value;
        end
        
        function  set.IQSwapEnabled(obj, value)
            obj.IQSwapEnabled = value;
        end
        
        function value = get.IQSwapEnabled(obj)
            value = obj.IQSwapEnabled;
        end
        
        function value = get.ArbTriggerSource(obj)
            value = instrument.internal.udm.rfsiggen.ArbTriggerSourceEnum.getString (obj.ArbTriggerSource);
        end
        
        function  set.ArbTriggerSource(obj, value)
            obj.ArbTriggerSource = value;
        end
        
        function value = get.ArbSelectedWaveform(obj)
            value = obj.ArbSelectedWaveform;
        end
        
        function  set.ArbSelectedWaveform(obj, value)
            obj.ArbSelectedWaveform = value;
        end
        
        function value = get.ArbWaveformQuantum(obj)
            value = obj.ArbWaveformQuantum;
        end
        
        function value = get.ArbMinWaveformSize(obj)
            value = obj.ArbMinWaveformSize;
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            value = obj.ArbMaxWaveformSize;
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            value = obj.ArbMaxNumberWaveforms;
        end
        
        function value = get.Revision(obj)
            value = obj.ArbMaxNumberWaveforms;
        end
        
        function value = get.FirmwareRevision(obj)
            value = obj.ArbMaxNumberWaveforms;
        end
        
    end
    
    methods
        function  configureRF(obj, frequency, powerLevel)
            obj.Frequency = frequency;
            obj.PowerLevel = powerLevel;
        end
        
        function  configureIQ(obj, source, swapEnabled)
            obj.IQSource = source;
            obj.IQSwapEnabled = swapEnabled;
        end
        
        function  configureArbTriggerSource(obj, source)
            obj.ArbTriggerSource = source;
        end
        
        function  selectArbWaveform(obj, name)
            obj.ArbSelectedWaveform = name;
        end
        
        function  writeArbWaveform(obj, name, numberOfSamples, iData, qData, moreDataPending)
            % Do nothing.
            % There is no properties need to be updated.
        end
        
        function  clearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS Deletes all waveforms from the pool of
            % waveforms in volatile memory. It will not clear the waveform
            % in the NVWFM memorry which is none volatile.
            obj.ArbSelectedWaveform = '';
        end
        
        function memoryDeleteFile(obj,fileNameBufferSize,fileName)
            % Do nothing.
            % There is no properties need to be updated.
        end
        
        function download(obj, waveformDataArray, clockFrequency)
            % DOWNLOAD Allow user to create an Arb waveform with the name
            % 'matlabIQData' if such name exists, it will overwrite the old
            % data with new data.
            
            % Check waveform min and max size
            minsize =  obj.ArbMinWaveformSize;
            maxsize =  obj.ArbMaxWaveformSize;
            quantum =  obj.ArbWaveformQuantum;
            waveformSize = length (waveformDataArray);
            if waveformSize > maxsize ||  waveformSize < minsize ||  mod(waveformSize,quantum) ~=0
                error (message ('instrument:rfsiggen:wrongWaveformSize', minsize , maxsize, quantum));
            end
            
            % Normalize the waveform so values are between -1 to + 1
            [iData, qData] = ...
                instrument.internal.udm.rfsiggen.normalizeIQWaveformData(waveformDataArray);
            
            dataName = 'matlabIQData';
            moreDataPending = false;
            % Create an Arb waveform
            obj.writeArbWaveform(dataName, waveformSize, iData, qData, moreDataPending);
            % Selects the downloaded waveform to become active.
            obj.selectArbWaveform(dataName)
            % Sets the Arb Clock Frequency.
            obj.ClockFrequency = clockFrequency;
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
            obj.configureArbTriggerSource(source);
            enabled = true;
            % Configures the frequency and the power level of the RF output signal.
            obj.configureRF(centerFrequency,outputPower);
            % Enable RF output.
            obj.enableOutput(enabled);
            % Disable all modulation output.
            obj.disableAllModulation;
            % Enable IQ modulation output only.
            obj.enableIQ(enabled);
            % Send loopCount times software trigger signal to trigger the
            % modulation output if the loopCount is not Inf. Wait for the
            % previous trigger to be completed before sending another
            % software trigger.
            if ~isinf(loopCount)
                for index = 1 : loopCount
                    obj.sendSoftwareTrigger;
                    maxTimeMilliseconds = 1000;
                    obj.waitUntilSettled(maxTimeMilliseconds);
                end
                stop(obj);
            end
        end
        
        function stop(obj)
            % STOP Configures the signal generator to disable RF output signal. It
            % also disables all currently enabled modulations.
            enabled = false;
            % Disable all modulation output.
            obj.disableAllModulation;
            % Disable IQ modulation output.
            obj.enableIQ(enabled);
            % Disable RF output.
            obj.enableOutput(enabled);
            
        end
        
        function [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                queryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES returns the capabilities of the
            % ARB generator.
            maxNumberWaveforms = obj.ArbMaxNumberWaveforms;
            waveformQuantum = obj.ArbWaveformQuantum;
            minWaveformSize = obj.ArbMinWaveformSize;
            maxWaveformSize = obj.ArbMaxWaveformSize;
        end
        
        function waitUntilSettled(obj, maxTimeMilliseconds)
            % WAITUNTILSETTLED Returns if the state of the RF output signal has settled.
            
            % Do nothing
            % There is no property need to be updated.
        end
        
        function done = isSettled(obj)
            % ISSETTLED Queries the state of the RF output signal.
            done = true;
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            % REVISIONQUERY Queries revision information from the instrument.
            driverRev = obj.Revision;
            instrRev = obj.FirmwareRevision;
        end
        
        function delete(obj)
            % DELETE Disconnects the instrument first
            obj.disconnect();
        end
        
        
        function reset(obj)
            try
                import instrument.internal.udm.rfsiggen.*;
                obj.Frequency = 4000000;
                obj.PowerLevel = 0;
                obj.OutputEnabled = 0;
                obj.IQEnabled = 0;
                obj.IQSource = IQSourceEnum.ArbGenerator;
                obj.IQSwapEnabled = 0;
                obj.ClockFrequency = 800000;
                obj.ArbTriggerSource = ArbTriggerSourceEnum.Immediate;
                obj.ArbSelectedWaveform = 'matlabIQData';
                obj.ArbWaveformQuantum = 2;
                obj.ArbMinWaveformSize = 60;
                obj.ArbMaxWaveformSize = 8000000;
                obj.ArbMaxNumberWaveforms = 29609375;
                obj.Revision = '1.6.0.0 ';
                obj.FirmwareRevision = 'C.05.84.S015';
            catch e
                disp (e.message)
            end
        end
        
        function disconnect(obj)
            obj.reset();
            obj.Connected = false;
        end
        
        function enableOutput(obj, enable)
            % ENABLEOUTPUT Configures the signal generator to enable or
            % disable the RF output signal.
            obj.OutputEnabled = enable;
        end
        
        function enableIQ(obj, enable)
            % ENABLEIQ Configures the signal generator to apply IQ (vector)
            % modulation to the RF output signal.
            obj.IQEnabled = enable;
        end
        
        function disableAllModulation(obj)
            % DISABLEALLMODULATION Disables all currently enabled
            % modulations.
            obj.IQEnabled = false;
        end
        
        function sendSoftwareTrigger(obj)
            % SENDSOFTWARETRIGGER Sends a software trigger, which will
            % cause the signal generator to start signal generation.
            
            % Do nothing
            % There is no property need to be updated.
        end
    end
    methods (Hidden = true, Access = protected)
        % The connect() function has to be protected as super class is.
        function connect(obj)
            obj.Connected  = true;
        end
    end
end
