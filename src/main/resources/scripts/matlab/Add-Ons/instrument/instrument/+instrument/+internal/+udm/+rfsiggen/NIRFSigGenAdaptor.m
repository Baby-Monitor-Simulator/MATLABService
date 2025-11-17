classdef NIRFSigGenAdaptor < instrument.internal.udm.rfsiggen.RFSigGenAdaptor 
    % NIRFSIGGENADAPTOR Bridges NI RFSG RFSigGen wrapper and rfsiggen's
    % state machine.
    
    % Copyright 2022-2024 The MathWorks, Inc.
    
    properties (Dependent)
        % Redefine the abstract properties (RFSigGenAdaptor)
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

    properties (GetAccess = ?TestAccessor, SetAccess = private)
        NIRFSigGen
        State instrument.nirfsg.ProgrammingState = "Configuration" 
    end

    % These methods are called on all concrete RFSigGenAdaptors by the
    % InstrumentAdaptorFactory
    methods (Static)
        function [rfsiggenAdaptor, driverName] = createByResource(resource)
            % CREATEBYRESOURCE Static method tries to create an NI-RFSG
            % adaptor based on the resource info.
            import instrument.internal.udm.*;
            
            rfsiggenAdaptor = [];
            driverName = '';
            
            % function pragma is required to ensure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor
            try
                matlabDriverName = instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor.getNIRFSG();

                if matlabDriverName == ""
                    return
                end
                                
                rfsiggenAdaptor = instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor(matlabDriverName, resource);
                driverName = instrument.internal.stringConversionHelpers.str2char(matlabDriverName);
            catch e
                switch e.identifier
                    case {'testmeaslib:Triplines:SupportPackageNotInstalled', ...
                            'instrument:ividev:general:noMATLABDriversInstalled', ...
                            'instrument:ividev:general:invalidMATLABDriver', ...
                            'instrument:ividev:niRFSG:err_0xfffcf1e4', ...
                            'instrument:ividev:general:iviSharedComponentsNotInstalled'}
                        % Translate exception IDs related to failed connections
                        id = 'instrument:qcinstrument:failToConnectToInstrumentByResource';
                        ex = MException(message(id));
                    case 'instrument:rfsiggen:invalidVendorDriverNIRFSG'
                        % Ignore invalid NIRFSG adaptor
                        ex = MException.empty;
                    otherwise
                        % Ignore other errors
                        ex = e;
                end

                if ~isempty(ex)
                    throwAsCaller(ex);
                end
            end
        end
        
        function [rfsiggenAdaptor, driverName] = createByDriverAndResource(matlabDriverName, resource)
            % CREATEBYDRIVERANDRESOURCE Static method tries to create an NI-RFSG adaptor based on the
            % resource and driver info.

            import instrument.internal.udm.*;
            rfsiggenAdaptor = []; 
            driverName = ''; 

            % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
            %#function instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor
            try
                rfsiggenAdaptor = instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor(matlabDriverName, resource);
                driverName = instrument.internal.stringConversionHelpers.str2char(matlabDriverName);
            catch e
                switch e.identifier
                    case {'testmeaslib:Triplines:SupportPackageNotInstalled', ...
                          'instrument:ividev:general:noMATLABDriversInstalled', ...
                          'instrument:ividev:general:invalidMATLABDriver', ...
                          'instrument:ividev:niRFSG:err_0xfffcf1e4', ...
                          'instrument:ividev:general:iviSharedComponentsNotInstalled'}
                        % Translate exception IDs related to failed connections
                        id = 'instrument:qcinstrument:failToConnectToInstrumentByResourceAndDriver';
                        ex = MException(message(id));
                    case 'instrument:rfsiggen:invalidVendorDriverNIRFSG'
                        % Ignore invalid NIRFSG adaptor
                        ex = MException.empty;
                    otherwise
                        % Ignore other errors
                        ex = e;
                end

                if ~isempty(ex)
                    throwAsCaller(ex);
                end
            end
        end
        
        function driverInfo = getDriver()
            % GETDRIVER static method finds niRFSG driver, if installed
            driverInfo = {};            

            [matlabDriverName, nirfsg] = instrument.internal.udm.rfsiggen.NIRFSigGenAdaptor.getNIRFSG();
 
            if matlabDriverName == ""
                return
            end

            supportedModels = join(nirfsg.SupportedModels{1}, ", ");

            info = struct("Name", char(matlabDriverName), ...
                          "SupportedInstrumentModels", char(supportedModels));

            driverInfo = {info};
        end
        
        function resource = getResource(varargin)
            % GETRESOURCE static method discovers the resource based on
            % resource discovery methods defined in adapters.config file
            resource = {};
            
            %#function instrument.internal.NISysCfg.listNIRIOResources
            if strcmpi (varargin{1}, 'nivst')
                vstResources = instrument.internal.stringConversionHelpers.str2char(instrument.internal.NISysCfg.listNIRIOResources);
                resource = horzcat(resource, vstResources);
            end
        end
    end

    methods (Static, Access = private)
        function [matlabDriverName, nirfsg] = getNIRFSG()
            nargoutchk(1, 2)
            driverList = ividriverlist;
            nirfsg = driverList(driverList.VendorDriver == "niRFSG", :);
            matlabDriverName = "";

            if ~isempty(nirfsg)
                matlabDriverName = nirfsg.MATLABDriver;
            end
        end
    end
    
    %% Lifetime
    methods
        function obj = NIRFSigGenAdaptor(matlabDriverName, resource )
            % Create an instance of underlying ividev object (RFSG).
            % Could delegate to instrument.rfsg.NIRfsgSigGen. For now, 
            % directly create an ividev object.
            dev = ividev(matlabDriverName, resource);
            if dev.VendorDriver ~= "niRFSG"
                id = "instrument:rfsiggen:invalidVendorDriverNIRFSG";
                throw(MException(message(id, matlabDriverName)));                
            end

            obj.NIRFSigGen = dev;
            
            % Since the adaptor is created upon rfsiggen's connect() method
            % it should automatically call connect().
            obj.connect();
            
            % By default, outputs are disabled - no need to set them
            % directly; set the generation mode to Arbitrary Waveform
            obj.NIRFSigGen.configureGenerationMode("ARB_WAVEFORM");
        end
        
        function delete(obj)
            % Disconnect the instrument first
            try
                obj.disconnect();
                if ~isempty(obj.NIRFSigGen)
                    obj.NIRFSigGen = [];
                end
            catch
            end
        end
    end

    methods
        % Called by instrument.RFSigGen.displayHelper 
        function value = getInstrumentInfo(obj)
            manufacturer = strip(obj.NIRFSigGen.Manufacturer);
            model = strip(obj.NIRFSigGen.Model);
            value = sprintf ('%s %s', manufacturer, model);
        end
    end

    % RFSigGenAdaptor Property setters/getters
    methods
        function value = get.Frequency(obj)
            value = obj.NIRFSigGen.RF.Frequency;
        end
        
        function set.Frequency(obj, value)
            obj.NIRFSigGen.RF.Frequency = value;
        end
        
        function value = get.PowerLevel(obj)
            value = obj.NIRFSigGen.RF.PowerLevel;
        end
        
        function set.PowerLevel(obj, value)
            obj.NIRFSigGen.RF.PowerLevel = value;
        end
        
        function value = get.OutputEnabled(obj)
            value = obj.NIRFSigGen.RF.OutputEnabled;
        end
        
        function set.OutputEnabled(obj, value)
            obj.NIRFSigGen.RF.OutputEnabled = value;
        end
        
        function value = get.IQEnabled(obj)
            % Attribute IVIRFSIGGEN_ATTR_IQ_ENABLED is not supported by
            % NI-RFSG (see below). Instead use NIRFSG_ATTR_GENERATION_MODE
            % (which is the property corresponding to the
            % configureIQEnabled for niRFSG).
            %
            % IVI-4.10: IviRFSigGen Class Specification (24.2.1)
            % Attribute: IVIRFSIGGEN_ATTR_IQ_ENABLED (1250401)   
            % Returns: 
            %   Vendor Driver Error 0xBFFA0012: IVI: 0xBFFA0012
            %   Attribute or property not supported.
            value = obj.NIRFSigGen.Arb.GenerationMode == "ARB_WAVEFORM";
        end
        
        function set.IQEnabled(obj, value)
            try
                if value
                    generationMode = "ARB_WAVEFORM";
                else
                    generationMode = "CW";
                end

                obj.NIRFSigGen.Arb.GenerationMode = generationMode;
            catch ex
                throwAsCaller(ex);
            end
        end

        function value = get.IQSource(~)
            % Attribute is not supported by NI-RFSG.
            %
            % IQ Source is the source of the signal used for IQ modulation. A
            % traditional RFSigGen (24.2.3) has the following possible sources:
            % DigitalModulation, CDMABase, TDMABase, ArbGenerator, External.
            %
            % Of these, the only value supported by NI-RFSG is
            % "ArbGenerator".
            %
            % IVIRFSIGGEN_ATTR_IQ_SOURCE = 1250403;            
            % Returns: Vendor Driver Error 0xBFFA0012: IVI: (Hex
            % 0xBFFA0012) Attribute or property not supported.

            import instrument.internal.udm.rfsiggen.*
            value = IQSourceEnum.getString(IQSourceEnum.ArbGenerator);
        end
        
        function set.IQSource(~, ~)
            % Function is unused
            throw(getUnsupportedAttributeException("IQSource"));
        end

        function value = get.IQSwapEnabled(obj)
            value = obj.NIRFSigGen.Arb.IQSwapEnabled;
        end
        
        function set.IQSwapEnabled(obj, value)
            obj.NIRFSigGen.Arb.IQSwapEnabled = value;
        end
                
        function value = get.ClockFrequency(obj)
            % ClockFrequency corresponds to Arb Clock Frequency
            % IVI-4.10: IviRFSigGen Class Specification (26.2.2)
            % Attribute: IVIRFSIGGEN_ATTR_ARB_CLOCK_FREQUENCY
            value = obj.NIRFSigGen.Arb.IQRate;
        end
        
        function set.ClockFrequency(obj, value)
            obj.NIRFSigGen.Arb.IQRate = value;
        end

        function value = get.ArbTriggerSource(obj)
            import ividev.niRFSG.enums.*
            instrumentValue = obj.NIRFSigGen.Triggers.Start.StartTriggerType;
            switch instrumentValue
                case Triggers.Start.StartTriggerType.NONE
                    value = 'Immediate';
                case Triggers.Start.StartTriggerType.DIGITAL_EDGE
                    value = 'External';
                case Triggers.Start.StartTriggerType.SOFTWARE
                    value = 'Software';
            end
        end
        
        function set.ArbTriggerSource(obj, instrumentValue)
            import ividev.niRFSG.enums.*

            switch instrumentValue
                case 'Immediate'
                    value = Triggers.Start.StartTriggerType.NONE;
                case 'External'
                    value = Triggers.Start.StartTriggerType.DIGITAL_EDGE;
                case 'Software'
                    value = Triggers.Start.StartTriggerType.SOFTWARE;
            end

            obj.NIRFSigGen.Triggers.Start.StartTriggerType = value;
        end
        
        function value = get.ArbSelectedWaveform(obj)
            value = obj.NIRFSigGen.Arb.WaveformCapabilities.SelectedWaveform;
            value = instrument.internal.stringConversionHelpers.str2char(value);
        end
        
        function set.ArbSelectedWaveform(obj, value)
            obj.NIRFSigGen.Arb.WaveformCapabilities.SelectedWaveform = value;
        end
        
        function value = get.ArbWaveformQuantum(obj)
            value = obj.NIRFSigGen.Arb.WaveformCapabilities.WaveformQuantum;
        end
        
        function value = get.ArbMinWaveformSize(obj)
            value = obj.NIRFSigGen.Arb.WaveformCapabilities.MinWaveformSize;
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            value = obj.NIRFSigGen.Arb.WaveformCapabilities.MaxWaveformSize;
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            value = obj.NIRFSigGen.Arb.WaveformCapabilities.MaxNumberWaveforms;
        end
        
        function value = get.Revision(obj)
            value = obj.NIRFSigGen.InherentIVIAttributes.DriverIdentification.Revision;
        end
        
        function value = get.FirmwareRevision(obj)
            value = obj.NIRFSigGen.InherentIVIAttributes.InstrumentIdentification.FirmwareRevision;
        end
    end

    % RFSigGenAdaptor implementation
    methods
        function configureRF(obj, frequency, powerLevel)
            obj.NIRFSigGen.configureRF(frequency, powerLevel);
        end
        
        function configureIQ(obj, source, swapEnabled)
            % Method is not supported by NI-RFSG. 
            
            % IQ Source is the source of the signal used for IQ modulation.
            % 
            % A traditional RFSigGen (24.2.3) has the following possible
            % sources: DigitalModulation, CDMABase, TDMABase, ArbGenerator,
            % External.
            %
            % NI RFSG supports three generation modes: continuous-wave
            % signal (a sine tone), arbitrary waveform, and scripted
            % waveform. The only possible match is "ArbGenerator".
            import instrument.internal.udm.rfsiggen.*

            switch source
                case IQSourceEnum.ArbGenerator
                    obj.IQSwapEnabled = swapEnabled;
                otherwise
                    obj.IQSource = source;
            end
        end
        
        function configureArbTriggerSource(obj, source)
            % Arb Trigger Source attribute (IVIRFSIGGEN_ATTR_ARB_TRIGGER_SOURCE)
            % Possible values: Immediate, External, Software
            arguments
                obj
                source (1, :) string {mustBeNonzeroLengthText}
            end

            type = lower(source(1));
            
            switch type
                case "immediate"
                    triggerType = "NONE";
                case "external"
                    triggerType = "DIGITAL_EDGE";
                    if numel(source) > 1
                        triggerSource = source(2);
                    else
                        triggerSource = "PFI0";
                    end
                    
                    obj.NIRFSigGen.Triggers.Start.DigitalEdge.DigitalEdgeStartTriggerSource = triggerSource;
                case "software"
                    triggerType = "SOFTWARE";
            end

            obj.NIRFSigGen.Triggers.Start.StartTriggerType = triggerType;
        end

        function enableOutput(obj, enable)
            % ENABLEOUTPUT Configures the signal generator to enable or disable the RF
            % output signal.
            try
                obj.NIRFSigGen.configureOutputEnabled(enable);
                
                if enable
                    obj.initiate();
                else
                    obj.abort();
                end
            catch e
                throwAsCaller(e);
            end
        end
        
        function enableIQ(~, ~)
            % ENABLEIQ Configures the signal generator to apply IQ (vector)
            % modulation to the RF output signal.
            throw(getUnsupportedMethodException("enableIQ"));
        end

        function selectArbWaveform(obj, name)
            obj.NIRFSigGen.selectArbWaveform(name);
        end
        
        function writeArbWaveform(obj, name, numberOfSamples, iData, qData, moreDataPending)
            obj.NIRFSigGen.writeArbWaveform(name, numberOfSamples, iData, qData, moreDataPending);
        end

        function disableAllModulation(obj)
            % DISABLEALLMODULATION Disables all currently enabled modulations.
            try
                obj.NIRFSigGen.RF.LOOutEnabled = false;
                obj.NIRFSigGen.RF.PulseModulationEnabled = false;
            catch
                % Ignore any errors
            end
        end
        
        function sendSoftwareTrigger(obj)
            % SENDSOFTWARETRIGGER Sends a software trigger, which will cause the signal
            % generator to start signal generation.

            % Addendum: this method only sends a previously configured
            % trigger; see, also, configureSoftwareStartTrigger, 
            % configureDigitalEdgeStartTrigger, and disableStartTrigger

            try
                % VST should be in the "Generation" state (requires calling
                % "initiate").
                obj.initiate();
                obj.NIRFSigGen.sendSoftwareEdgeTrigger("START_TRIGGER", "");
            catch e
                throwAsCaller(e);
            end
        end
        
        function reset(obj)
            % RESET
            obj.NIRFSigGen.reset();
        end
        
        function start(obj, centerFrequency, outputPower, loopCount)
            % START Enables the RF signal generator signal output and
            % modulation output.
            %
            % Assumes you have already:
            % 1. Configured the clock frequency and bandwidth
            % 2. Defined the waveform
            import instrument.internal.udm.rfsiggen.*;

            source = ''; %#ok<NASGU>
            runIndefinitely = isinf(loopCount);
            if runIndefinitely 
                source = ArbTriggerSourceEnum.getEnum('Immediate');
            else
                source = ArbTriggerSourceEnum.getEnum('Software');
            end

            obj.enableOutput(false);
            obj.configureRF(centerFrequency, outputPower);
            obj.configureArbTriggerSource(source);

            obj.enableOutput(true);

            % Will run until stop is called.
            if runIndefinitely
                return
            end

            maxWaitTimeMilliseconds = 1000;            
            for index = 1:loopCount
                obj.sendSoftwareTrigger;                
                obj.waitUntilSettled(maxWaitTimeMilliseconds);
            end

            obj.stop();
        end
        
        function stop(obj)
            % STOP Configures the signal generator to disable RF output signal. It
            % also disables all currently enabled modulations.
            obj.NIRFSigGen.configureOutputEnabled(false);
            obj.abort();
        end
        
        function download(obj, waveformDataArray, clockFrequency)
            % DOWNLOAD Allow user to create an Arb waveform with the name
            % 'matlabIQData' if such name exists, it will overwrite the old
            % data with new data.

            minsize =  obj.ArbMinWaveformSize;
            maxsize =  obj.ArbMaxWaveformSize;
            quantum =  obj.ArbWaveformQuantum;
            waveformSize = length(waveformDataArray);            
            
            if isInvalidWaveformSize(minsize, maxsize, quantum, waveformSize)
                error(message("instrument:rfsiggen:wrongWaveformSize", minsize, maxsize, quantum));
            end

            % normalize the waveform so values are between -1 to + 1
            [iData, qData] = ...
                instrument.internal.udm.rfsiggen.normalizeIQWaveformData(waveformDataArray);

            signalName = "matlabIQData";
            moreDataPending = false;
            
            % Steps:
            % 1. Delete previous waveform
            % 2. Create arbitrary waveform
            % 3. Select waveform
            % 4. Set Arb clock frequency
            try
               obj.clearArbWaveform(signalName); 
            catch e
                % checkIfWaveformExists is only supported for PXIe-5673/5673E
                switch e.identifier
                    case 'instrument:ividev:niRFSG:err_0xbffa43f7'
                        % Invalid waveform: ignore this, as it simply means
                        % there is no previous waveform.
                    otherwise
                        throwAsCaller(e)
                end
            end

            % create an Arb waveform
            try
                obj.writeArbWaveform(signalName, waveformSize, iData, qData, moreDataPending);
            catch  e
                error(message ('instrument:rfsiggen:instrumentError'));
            end

            obj.selectArbWaveform(signalName);
            obj.ClockFrequency = clockFrequency;

            function tf = isInvalidWaveformSize(minsize, maxsize, quantum, waveformSize)
                tf = waveformSize > maxsize ||  waveformSize < minsize ||  mod(waveformSize, quantum) ~=0;
            end
        end

        function [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                queryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES Returns the capabilities of the
            % ARB generator.
            [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                obj.NIRFSigGen.queryArbWaveformCapabilities();
        end
        
        function waitUntilSettled(obj, maxTimeMilliseconds)
            % WAITUNTILSETTLED Returns if the state of the RF output signal has settled.
            obj.NIRFSigGen.waitUntilSettled(maxTimeMilliseconds);
        end
        
        function done = isSettled(obj)
            % ISSETTLED Does not query the state of the RF output signal,
            % but instead relies on the state of the driver to determine
            % whether the output is settled (true if state is
            % "Generation").
            done = obj.State.IsSettled;
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            % REVISIONQUERY Retrieves revision information from the instrument.
            driverRev = obj.Revision;
            instrRev = obj.FirmwareRevision;
        end

        function clearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS Deletes all currently defined waveforms
            % and scripts. The NI-RFSG device must be in the Configuration
            % state before calling this function.
            obj.NIRFSigGen.clearAllArbWaveforms;
        end
    end

    % InstrumentAdaptor implementation
    methods
        function disconnect(obj)
            % DISCONNECT
            % abort output generation (do not reset - could cause routes to
            % be reset)
            obj.abort();
        end
    end

    methods (Access = protected)
        function connect(~)
            % For ividev, there's no need to explicitly connect
        end
    end

    % Helper methods
    methods (Access = ?TestAccessor)
        function initiate(obj)
            % It is not ok to call initiate twice in a row
            if obj.State ~= "Generation"
                obj.NIRFSigGen.initiate();
                obj.State = "Generation";
            end
        end

        function abort(obj)
            % It is ok to call abort in any state
            obj.NIRFSigGen.abort();
            obj.State = "Configuration";
        end

        function commit(obj)
            % It is ok to commit in the configuration/commit state
            % It is not ok to commit in generation state
            if obj.State ~= "Generation"
                obj.NIRFSigGen.commit();
                obj.State = "Committed";
            end
        end

        function clearArbWaveform(obj, signalName)
            obj.NIRFSigGen.clearArbWaveform(signalName);
        end
    end
end

function ex = getUnsupportedAttributeException(attribute)
arguments
    attribute (1, 1) string {mustBeNonzeroLengthText}
end
id = "instrument:ividev:general:unsupportedAttribute";
ex = MException(message(id, attribute, "niRFSG"));
end

function ex = getUnsupportedMethodException(method)
arguments
    method (1, 1) string {mustBeNonzeroLengthText}
end
id = "instrument:ividev:general:unsupported";
ex = MException(message(id, method, "niRFSG"));
end