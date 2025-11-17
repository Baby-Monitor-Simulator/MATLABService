classdef RFSigGen < instrument.internal.QCInstrument
    % RFSIGGEN Class provides basic functionality to
    % communicate with RF signal generator instruments.
    
    % Copyright 2017-2023 The MathWorks, Inc.

    properties (Access = protected)
        % QUICKCONTROLTYPE defines the type of quick control device.
        QuickControlType = "RFSigGen"
    end
    
    properties (Hidden)
        % An Adaptor used to communicate with instrument
        Adaptor
        % A flag to control two mutually dependent properties
        % Driver and DriverDetectionMode
        UpdateDriverDetectionMode
    end

    properties
        % DRIVER specifies the underlying driver used to communicate with
        % an instrument.
        % See also drivers
        Driver
    end
    
    properties (Hidden)
        % DriverDetectionMode specifies how the driver is configured. When
        % it is set to 'auto', the program will configure the driver name
        % automatically. If it is set to 'manual', the user must provide a
        % driver name before connecting to the instrument.
        DriverDetectionMode = 'auto'
    end
    
    properties
        %RESOURCE specifies the instrument resource to communicate with.
        %See also resources
        Resource
    end
    
    % Read only properties
    properties (Hidden, SetAccess = private)
        % STATUS returns whether a connection to the RF signal generator is
        % open or closed. Read Only.
        Status = 'closed'
        
        % The waveform length must be a multiple of this quantum. Read Only
        ArbWaveformQuantum
        
        % The waveform length must be equal or greater than min size.
        % Read Only.
        ArbMinWaveformSize
        
        % The waveform length must be equal or less than max size.
        % Read Only.
        ArbMaxWaveformSize
        
        % Specifies the maximum number of waveforms the instrument can hold in memory.
        % Read Only.
        ArbMaxNumberWaveforms
        
        % Version information about the specific driver.
        % Read Only.
        Revision
        
        % The firmware revision reported by the physical instrument.
        % Read Only.
        FirmwareRevision
    end
    
    methods (Hidden)
        % Constructor
        function obj = RFSigGen (varargin)
            narginchk(0,2);
            obj.createInternalStateMap();
            obj.changeState('RFSigGenStateNotConnected');
            
            % Convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            % Handle optional args that will allow us to connect now
            if nargin >= 1
                obj.Resource = varargin{1};
                if nargin == 2
                    obj.Driver = varargin{2};
                end
                try
                    obj.connect();
                catch ex
                    throwAsCaller(ex);
                end
            end
        end
        
        function delete(obj)
            % DELETE Removes RF Signal Generator object from memory
            if  ~isempty (obj.Adaptor)
                % Disconnect if still connected
                if isvalid(obj) && strcmpi(obj.Status, 'open')
                    obj.disconnect();
                end
                obj.Adaptor = [];
            end
        end
    end
    
    methods
        function resourceList = resources(~)
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            %
            % Example:
            %   rf = rfsiggen;
            %   resourceList = resources(rf)
            
            formatOutput = isequal(nargout, 0);
            
            % Resources retrieves a list of available instrument resources.
            import instrument.internal.udm.*
            resourceList = ...
                instrument.internal.QCInstrument.instrumentResources(InstrumentType.RFSigGen, formatOutput);
        end
        
        function driversInfo = drivers(~)
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            %
            % Example:
            %   rf = rfsiggen;
            %   driversInfo = drivers(rf)
            
            formatOutput = isequal(nargout, 0);
            
            %drivers retrieves a list of available RF signal generator
            %instrument drivers.
            import instrument.internal.udm.*
            driversInfo = ...
                instrument.internal.QCInstrument.instrumentDrivers(InstrumentType.RFSigGen, formatOutput);
        end
        
        function connect(obj)
            % CONNECT Opens the I/O session to the instrument. Driver
            % functions and properties that access the instrument
            % are only accessible after connection is established.
            %
            % Example:
            %   rf = rfsiggen;
            %   rf.Resource = 'TCPIP0::172.28.22.99::inst0::INSTR';
            %   rf.Driver = 'AgRfSigGen';
            %   connect(rf);
            try
                obj.InternalState.connect();
            catch e
                throwAsCaller (e);
            end
        end
        
        function disconnect(obj)
            % DISCONNECT Closes the instrument I/O session.
            %
            % Example:
            % rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            % disconnect(rf);
            try
                obj.InternalState.disconnect();
            catch e
                throwAsCaller (e);
            end
        end
        
        function start(obj, centerFrequency, outputPower, loopCount)
            % START Enables the RF signal generator signal output and modulation output.
            %
            % Example:
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   CenterFrequency = 4000000
            %   OutputPower = 0
            %   LoopCount = inf
            %   start(rf, CenterFrequency, OutputPower, LoopCount)
            
            narginchk(4,4);
            try
                obj.InternalState.start(centerFrequency, outputPower, loopCount);
            catch e
                throwAsCaller(e);
            end
        end
        
        function stop(obj)
            % STOP Disables the RF signal generator signal output and modulation output.
            try
                obj.InternalState.stop;
            catch e
                throwAsCaller (e);
            end
        end
        
        function download(obj, iqData, clockFrequency)
            % DOWNLOAD Downloads an arbitrary waveform to the RF signal
            % generator.
            %
            % Example:
            %
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   IQData = (-0.98:0.02:1) + 1i*(-0.98:0.02:1);
            %   SampleRate = 800000;
            %   download(rf, IQData, SampleRate)
            
            narginchk(3,3);
            nargoutchk(0,0);
            try
                obj.InternalState.download(iqData, clockFrequency);
            catch e
                throwAsCaller(e);
            end
        end
        
        function reset(obj)
            % RESET sets the RF signal generator to factory state.
            %
            % Example:
            %
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   reset(rf);
            
            try
                obj.InternalState.reset();
            catch e
                throwAsCaller (e);
            end
        end
    end
    
    properties (Dependent, Hidden, SetAccess = protected)
        % Specifies the frequency of the generated RF output signal.
        Frequency
        
        % Specifies the amplitude (power/level) of the RF output signal.
        PowerLevel
        
        % Enables or disables the RF output signal.
        OutputEnabled
        
        % Enables or disables IQ (vector) modulation of the RF output
        % signal.
        IQEnabled
        
        % Specifies the source of the signal that the signal generator uses
        %for IQ modulation.
        IQSource
       
        % Enables or disables the inverse phase rotation of the IQ signal
        % by swapping the I and Q inputs.
        IQSwapEnabled
        
        % Specifies the sample frequency.
        ClockFrequency
        
        % Specifies the trigger source for the ARB waveform.
        ArbTriggerSource
        
        % Specifies the selected waveform from the pool of available
        % waveforms.
        ArbSelectedWaveform
    end
    
    methods (Hidden)
        function enableOutput(obj)
            % ENABLEOUTPUT Enables the RF signal generator to
            % produce signal that appears at the output connector.
            try
                obj.InternalState.enableOutput(true);
            catch e
                throwAsCaller (e);
            end
        end
        
        function disableOutput(obj)
            % DISABLEOUTPUT disables the signal that appears at the
            % output connector.
            try
                obj.InternalState.enableOutput(false);
            catch e
                throwAsCaller (e);
            end
        end
        
        function enableIQ(obj)
            % ENABLEIQ Configures the signal generator to apply IQ (vector)
            % modulation to the RF output signal.
            try
                obj.InternalState.enableIQ(true);
            catch e
                throwAsCaller (e);
            end
        end
        
        function disableIQ(obj)
            % DISABLEIQ Configures the signal generator to stop applying IQ
            % (vector) modulation to the RF output signal.
            try
                obj.InternalState.enableIQ(false);
            catch e
                throwAsCaller (e);
            end
        end
        
        function disableAllModulation(obj)
            % DISABLEALLMODULATION Disables all currently enabled modulations.
            try
                obj.InternalState.disableAllModulation;
            catch e
                throwAsCaller (e);
            end
        end
        
        function sendSoftwareTrigger(obj)
            % SENDSOFTWARETRIGGER Sends a software trigger, which will cause the signal
            % generator to start signal generation.
            try
                obj.InternalState.sendSoftwareTrigger;
            catch e
                throwAsCaller (e);
            end
        end
        
        function [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                queryArbWaveformCapabilities(obj)
            % QUERYARBWAVEFORMCAPABILITIES Returns the capabilities of the ARB generator.
            %
            % Example:
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   [MaxNumberWaveforms, WaveformQuantum, MinWaveformSize, MaxWaveformSize] = queryArbWaveformCapabilities(rf);
            %
            % MaxNumberWaveforms - Maximum number of waveforms the instrument can hold in memory
            % WaveformQuantum - Waveform length must be a multiple of this quantum
            % MinWaveformSize - Waveform length must be equal or greater than min size.
            % MaxWaveformSize - Waveform length must be equal or less than max size.
            
            narginchk(1,1);
            try
                [maxNumberWaveforms, waveformQuantum, minWaveformSize, maxWaveformSize] = ...
                    obj.InternalState.queryArbWaveformCapabilities;
            catch e
                throwAsCaller(e);
            end
        end
        
        function waitUntilSettled(obj, maxTimeMilliseconds)
            % WAITUNTILSETTLED Returns if the state of the RF output signal has settled.
            % input:
            % maxTimeMilliseconds - Defines the maximum time the function
            % waits for the output to be settled. The units are
            % milliseconds.
            %
            % Example:
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   maxTimeMilliseconds = 1000;
            %   waitUntilSettled(rf, maxTimeMilliseconds);
            
            narginchk(2,2);
            obj.InternalState.waitUntilSettled(maxTimeMilliseconds);
        end
        
        function value = isSettled(obj)
            % ISSETTLED Queries the state of the RF output signal.
            %
            % Example:
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   Done = isSettled(rf);
            %
            % Done - Returns true if the output signal is in settled, false otherwise.
            
            narginchk(1,1);
            value = obj.InternalState.isSettled;
        end
        
        function [driverRev, instrRev] = revisionQuery(obj)
            % REVISIONQUERY Queries revision information from the instrument.
            %
            % Example:
            %   rf = rfsiggen('TCPIP0::172.28.22.99::inst0::INSTR','AgRfSigGen')
            %   [driverRev, instrRev] = revisionQuery(rf);
            %
            % driverRev - Returns the revision of the specific driver.
            % instrRev - Returns the firmware revision of the instrument.
            
            narginchk(1,1);
            [driverRev, instrRev] = obj.InternalState.revisionQuery;
        end
        
        function configureRF(obj, frequency, powerLevel)
            % CONFIGURERF Configures the frequency and the power level of
            % the RF output signal.
            
            narginchk(3,3);
            try
                obj.InternalState.configureRF(frequency, powerLevel);
            catch e
                throwAsCaller(e);
            end
        end
        
        function configureIQ(obj, source, swapEnabled)
            % CONFIGUREIQ Configures the attributes that control the
            % signal generator's IQ modulation.
            %
            % The IQSOurce parameter can be set to one of the following:
            % 'ArbGenerator', 'CDMA', 'DigitalModulation', 'External' or
            % 'TDMA'.
            narginchk(3,3);
            
            % Convert to char in order to accept string datatype
            source = instrument.internal.stringConversionHelpers.str2char(source);
            swapEnabled = instrument.internal.stringConversionHelpers.str2char(swapEnabled);
            if strcmpi(source,'ArbGenerator') && isempty(obj.InternalState.ArbSelectedWaveform)
                error(message('instrument:rfsiggen:needToSelectWaveform'));
            end
            try
                obj.InternalState.configureIQ(source, swapEnabled);
            catch e
                throwAsCaller(e);
            end
        end
        
        function configureArbTriggerSource(obj, source)
            % CONFIGUREARBTRIGGERSOURCE Configures the trigger source for
            % waveform generation. The output waveform may be generated
            % continuously or once based on the value of the Arb Trigger
            % Source attribute.
            %
            % The ArbTriggerSource parameter can be set to one of the
            % following:
            % 'External', 'Immediate' or 'Software'.
            
            narginchk(2,2);
            
            % Convert to char in order to accept string datatype
            source = instrument.internal.stringConversionHelpers.str2char(source);
            
            try
                obj.InternalState.configureArbTriggerSource(source);
            catch e
                throwAsCaller(e);
            end
        end
        
        function selectArbWaveform(obj, name)
            % SELECTARBWAVEFORM Selects a waveform from the pool of waveforms to become
            % active.
            
            narginchk(2,2);
            
            % Convert to char in order to accept string datatype
            name = instrument.internal.stringConversionHelpers.str2char(name);
            
            try
                obj.InternalState.selectArbWaveform(name);
            catch e
                throwAsCaller(e);
            end
        end
        
        function writeArbWaveform(obj, name, numberOfSamples, iData, qData, moreDataPending)
            % WRITEARBWAVEFORM Stores the waveform in instrument's memory.
            
            narginchk(6, 6);
            try
                obj.InternalState.writeArbWaveform(name, numberOfSamples, iData, qData, moreDataPending);
            catch e
                throwAsCaller(e);
            end
        end
        
        function clearAllArbWaveforms(obj)
            % CLEARALLARBWAVEFORMS Deletes all waveforms from the pool of
            %waveforms. It only clear the volatile memory.
            
            try
                obj.InternalState.clearAllArbWaveforms;
            catch e
                throwAsCaller(e);
            end
        end
    end
    
    %% Property access methods
    methods
        function value = get.Status(obj)
            value =  obj.Status;
        end
        
        function Resource = get.Resource(obj)
            Resource = obj.Resource;
        end
        
        function set.Resource(obj, value)
            if strcmpi(obj.Status, 'open')
                error(message('instrument:qcinstrument:cannotChangeProperty') );
            end
            
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.checkScalarStringArg(value);
                obj.Resource = value;
            catch e
                throwAsCaller (e);
            end
        end
        
        function driver = get.Driver(obj)
            driver = obj.Driver;
        end
        
        function set.Driver(obj, value)
            if strcmpi(obj.Status, 'open')
                error(message('instrument:qcinstrument:cannotChangeProperty') );
            end
            
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            if isempty (value)
                obj.Driver = value;
                return;
            end
            
            % Switch DriverDetectionMode to manual
            obj.DriverDetectionMode = 'manual';
            try
                obj.checkScalarStringArg(value);
                obj.Driver = value;
            catch e
                throwAsCaller (e);
            end
        end
        
        function value = get.Frequency(obj)
            try
                value = obj.InternalState.Frequency;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.Frequency(obj, value)
            try
                obj.InternalState.Frequency = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.PowerLevel(obj)
            try
                value = obj.InternalState.PowerLevel;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.PowerLevel(obj, value)
            try
                obj.InternalState.PowerLevel = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.OutputEnabled(obj)
            try
                value = obj.InternalState.OutputEnabled;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.OutputEnabled(obj, value)
            try
                obj.InternalState.OutputEnabled = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.IQEnabled(obj)
            try
                value = obj.InternalState.IQEnabled;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.IQEnabled(obj, value)
            try
                obj.InternalState.IQEnabled = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.IQSource(obj)
            try
                value = obj.InternalState.IQSource;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.IQSource(obj, value)
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.IQSource = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.IQSwapEnabled(obj)
            try
                value = obj.InternalState.IQSwapEnabled;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.IQSwapEnabled(obj, value)
            try
                obj.InternalState.IQSwapEnabled = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ClockFrequency(obj)
            try
                value = obj.InternalState.ClockFrequency;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.ClockFrequency(obj, value)
            try
                obj.InternalState.ClockFrequency = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbTriggerSource(obj)
            try
                value = obj.InternalState.ArbTriggerSource;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.ArbTriggerSource(obj, value)
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.ArbTriggerSource = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbSelectedWaveform(obj)
            try
                value = obj.InternalState.ArbSelectedWaveform;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.ArbSelectedWaveform(obj, value)
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.ArbSelectedWaveform = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbWaveformQuantum(obj)
            try
                value = obj.InternalState.ArbWaveformQuantum;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbMinWaveformSize(obj)
            try
                value = obj.InternalState.ArbMinWaveformSize;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbMaxWaveformSize(obj)
            try
                value = obj.InternalState.ArbMaxWaveformSize;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbMaxNumberWaveforms(obj)
            try
                value = obj.InternalState.ArbMaxNumberWaveforms;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Revision(obj)
            try
                value = obj.InternalState.Revision;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.FirmwareRevision(obj)
            try
                value = obj.InternalState.FirmwareRevision;
            catch e
                throwAsCaller(e);
            end
        end
        
        function driver = get.DriverDetectionMode(obj)
            driver = obj.DriverDetectionMode;
        end
        
        function set.DriverDetectionMode(obj, value)
            % Convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            if strcmpi(obj.Status, 'open') %#ok<*MCSUP>
                error(message('instrument:qcinstrument:cannotChangeProperty'));
            end
            
            if ~obj.UpdateDriverDetectionMode
                return;
            end
            
            try
                obj.checkScalarStringArg(value);
            catch e
                throwAsCaller(e);
            end
            
            if strcmpi (value, 'auto') ||  strcmpi (value, 'manual')
                obj.DriverDetectionMode = value;
                if strcmpi (value, 'auto')
                    obj.Driver = [];
                end
            else
                error (message('instrument:qcinstrument:notValidDriverDetectionMode', value));
            end
        end
    end
    
    methods (Hidden)
        % Internal helper function to update connection status
        function updateConnectionStatus(obj, value)
            obj.Status = value;
        end
        
        function resetImpl(obj)
            delete(obj);
        end
        
        function changeState(obj, targetState)
            try
                % Update the state machine.
                obj.InternalState = obj.InternalStateMap(targetState);
            catch e
                if strcmpi(e.identifier,'MATLAB:Containers:Map:NoKey')
                    error(message('instrument:qcinstrument:badState'));
                else
                    rethrow(e)
                end
            end
        end
        
        function varargout = invoke(obj, varargin)
            % For backward compatibility.
            if nargin == 1
                error (message('instrument:qcinstrument:noMethodName'));
            end
            methodName =  varargin{1};
            
            % Check if the method name is valid
            if ~ ismember (methodName, methods(obj))
                error (message('instrument:qcinstrument:notValidMethodName', methodName));
            end
            
            try
                if nargout == 0
                    obj.(methodName)(varargin{2:end})
                else
                    tempOut = cell(1, nargout);
                    [tempOut{:}] = obj.(methodName)(varargin{2:end});
                    varargout = tempOut;
                end
            catch e
                throwAsCaller(e)
            end
        end
        
        function displayHelper(obj)
            if ~isempty(obj.Adaptor)
                textToDisp = sprintf('rfsiggen: %s',  obj.Adaptor.getInstrumentInfo());
                textToDisp = sprintf('%s\n%s', textToDisp, obj.generatePropertyDisp());
                % Line feed and methods footer
                textToDisp = sprintf('%s\n%s\n',textToDisp , obj.generateFooter());

                % Display it all at once
                fprintf(textToDisp);
            end
        end
        
        function textToDisp = generatePropertyDisp(obj)
            % GENERATEPROPERTYDISP Provide a summary of RF signal generator
            % object's properties and values.
            
            textToDisp = '';
            
            % General properties
            frequency        = getPropertyInfo('Frequency');
            powerLevel       = getPropertyInfo('PowerLevel');
            outputEnabled    = getPropertyInfo('OutputEnabled');
            iqEnabled        = getPropertyInfo('IQEnabled');
            iqSource         = getPropertyInfo('IQSource');
            iqSwapEnabled    = getPropertyInfo('IQSwapEnabled');
            textToDisp      = message("instrument:qcinstrument:instrumentHeaderDisp", ...
                textToDisp, frequency, powerLevel, outputEnabled, ...
                iqEnabled, iqSource, iqSwapEnabled, "", "").getString;
            
            % Extra run mode info
            try
                if strcmpi(obj.IQSource, 'ArbGenerator')
                    clockFrequency = getPropertyInfo('ClockFrequency');
                    arbTriggerSource = getPropertyInfo('ArbTriggerSource');
                    arbSelectedWaveform = getPropertyInfo('ArbSelectedWaveform');
                    textToDisp          = message("instrument:rfsiggen:arbGeneratorHeaderDisp", ...
                        textToDisp, clockFrequency, arbTriggerSource, arbSelectedWaveform).getString;
                end
            catch  e
            end
            
            % Connection status
            status     = getPropertyInfo('Status');
            resource   = getPropertyInfo('Resource');
            textToDisp = message("instrument:qcinstrument:communicationHeaderDisp", textToDisp, status, resource).getString;
            
            function propertyInfo = getPropertyInfo(propertyName)
                % GETPROPERTYINFO Provide a formatted output for each
                % property.
                propNames = properties(obj);
                maxPropNameLength = max(cellfun(@length,propNames))+ 6;
                try
                    % Attempt to get the value of each property
                    propertyValue = eval(['obj.' propertyName]);
                    value = obj.renderProperty(propertyValue);
                catch e
                    % If an error occurs, for instance, the instrument
                    % isn't connected, capture that.
                    value = sprintf('Error: %s',e.message);
                end
                
                if isempty(strfind(lower(value), 'error'))
                    if strcmpi(propertyName, 'Frequency')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' Hz');
                    elseif strcmpi(propertyName, 'PowerLevel')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' dBm');
                    elseif strcmpi(propertyName, 'ClockFrequency')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' Hz');
                    else
                        propertyInfo =  sprintf('%s%s: %s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value);
                    end
                else
                    propertyInfo =  sprintf('%s%s: %s\n',...
                        blanks(maxPropNameLength - length(propertyName)),...
                        propertyName,...
                        value);
                end
            end
        end
        
        function textToDisp = generateFooter(obj)
            if ~feature('hotlinks')
                % No hyperlinked footer if hotlinks are off
                textToDisp = '';
                return
            end
            % Print the footer, with hyperlinks to methods.
            textToDisp = sprintf('list of <a href="matlab:methods(''%s'')">methods</a>',class(obj));
        end
    end
    
    methods (Access = private)
        function createInternalStateMap(obj)
            % CREATEINTERNALSTATEMAP Creates the internal state map
            obj.InternalStateMap = containers.Map();
            addState('RFSigGenStateNotConnected');
            addState('RFSigGenStateConnected');
            
            function addState(stateName)
                % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
                %#function instrument.internal.udm.rfsiggen.RFSigGenStateNotConnected instrument.internal.udm.rfsiggen.RFSigGenStateConnected
				
                % Dynamically instantiates state machine objects and stores
                % in the state map where
                % key =state machine name
                % value = state machine object.
                obj.InternalStateMap(stateName) =...
                    feval(str2func(['instrument.internal.udm.rfsiggen.' stateName]), obj);
            end
        end
    end
    
    methods
        function varargout = get(obj, varargin)
            if ~all(isvalid(obj))
                error(message('MATLAB:class:InvalidHandle'))
            end
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            if isempty(obj.Adaptor) % if get method is called prior to establishing connection
                error(message('instrument:qcinstrument:notConnected'));
            else % if get method is called after connection is established
                if nargout == 0 && nargin == 1 % user calls get(obj)
                    % displays the properties and their values to the
                    % command line
                    propertiesDisplay(obj);
                    return;
                end
                
                if nargout >= 0 && nargin > 1 % user calls get(obj, <property_name>)
                    varargout = {get@hgsetget(obj,varargin{:})};
                end
                
                if nargout > 0 && nargin == 1% user calls out = get(obj)
                    sortedGet = struct([]);
                    for index = 1:length(obj) % for each element of the array
                        propList = properties(obj);
                        for i = 1:numel(propList)
                            fldName   = propList{i};
                            propVal = obj.([propList{i}]);
                            % update the unSortedGet structure
                            evalc(['unSortedGet.' fldName '= propVal']);
                        end
                        % the properties are hard sorted in the class
                        % definition. If they aren't sorted, then the
                        % below command sorts it
                        f = sort(fieldnames(unSortedGet));
                        for i = 1:length(f)
                            sortedGet(index, 1).(f{i}) = unSortedGet.(f{i});
                        end
                    end
                    % Assign the result to the output
                    varargout = {sortedGet};
                end
            end
        end
    end
    
    methods (Access = private)
        function propertiesDisplay(obj)
            %PROPERTIESDISPLAY creates a string containing all the
            %accessible properties and their respective values. The
            %accessibility of properties depends on the mode of operation
            %of the RFSigGen, and the Waveform selected
            sortedpropertyNames = properties(obj);
            dispStr = '';
            for i = 1:length(sortedpropertyNames)
                try
                    propertyToDisplay = obj.([sortedpropertyNames{i}]);
                catch
                    % If unable to read the value of the requested
                    % property
                    msg = message('instrument:qcinstrument:instrumentError');
                    propertyToDisplay = msg.getString;
                end
                if isempty(propertyToDisplay) % empty property case
                    strToDisp = sprintf('    %s = %s', sortedpropertyNames{i}, '[]');
                elseif iscell(propertyToDisplay)
                    % If property value is a cell array, then converting it
                    % to a concatenated string for display
                    txtToDisp = [];
                    for cindx = 1:numel(propertyToDisplay)
                        txtToDisp = [txtToDisp, propertyToDisplay{cindx}, ', ']; %#ok<AGROW>
                    end
                    txtToDisp = txtToDisp(1:end-2);
                    strToDisp = sprintf('    %s = %s', sortedpropertyNames{i}, num2str(txtToDisp));
                else
                    strToDisp = sprintf('    %s = %s', sortedpropertyNames{i}, num2str(propertyToDisplay));
                end
                dispStr = sprintf('%s%s\n', dispStr, strToDisp);
            end
            disp(dispStr);
        end
    end    
end

% LocalWords:  Vpp Arb qcinstrument rfsiggen waveformhandle wh fm udm
