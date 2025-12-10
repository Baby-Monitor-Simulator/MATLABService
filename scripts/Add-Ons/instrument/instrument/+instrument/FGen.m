classdef FGen < instrument.internal.QCInstrument
    %FGEN class provides basic functionality to
    %communicate with function generator instruments.
    
    % Copyright 2011-2023 The MathWorks, Inc.
    
    properties (Access = protected, Hidden)
        % QUICKCONTROLTYPE defines the type of quick control device.
        QuickControlType = "Fgen"
    end
    
    properties ( Hidden )
        %An Adaptor used to communicate with instrument
        Adaptor;
        %A flag to control two mutually dependent properties
        %Driver and DriverDetectionMode
        UpdateDriverDetectionMode;
    end
    
    properties ( Dependent = true)
        %AMDepth Specifies the extent of modulation
        %the function generator applies to the carrier signal.  The
        %units are a percentage of full modulation.  At 0% depth,
        %the output amplitude equals the carrier signal's amplitude.
        % At 100% depth, the output amplitude equals twice the
        %carrier signal's amplitude. This property affects
        %function generator behavior only when the Mode is set to AM and
        %ModulationResource is set to internal.
        %See also Mode ModulationSource
        AMDepth
        
        %Amplitude specifies the amplitude of the standard waveform.
        %The value is the amplitude at the output terminal.
        %The units are volts peak-to-peak (Vpp).  For
        %example, to produce a waveform ranging from -5.0 to +5.0
        %volts, you set this value to 10.0 volts.
        Amplitude
        
        
        %ArbWaveformGain specifies the factor by which the function generator scales
        %the arbitrary waveform data.  Use this property to scale the
        %arbitrary waveform to ranges other than -1.0 to +1.0.  When it is
        %set to 2.0, the output signal ranges from -2.0 to +2.0 volts.
        %See also Waveform
        ArbWaveformGain
        
        
        %BurstCount specifies the number of waveform cycles that
        %the function generator produces after it receives a trigger.
        BurstCount
        
    end
    
    properties (Dependent = true , SetAccess = 'private')
        %CHANNELNAMES returns available channel names of the function generator.
        %Read Only.
        ChannelNames;
    end
    
    properties
        %DRIVER specifies the underlying driver used to communicate with an
        %instrument.
        %See also drivers
        Driver;
        
        %DriverDetectionMode specifies how the driver is configured. When it is set to
        %'auto', the program will configure the driver name automatically. If
        %it is set to 'manual', the user must provide a driver name before
        %connecting to the instrument.
        DriverDetectionMode = 'auto';
    end
    
    properties ( Dependent = true)
        %FMDeviation specifies the maximum frequency
        %deviation the modulating waveform applies to the carrier
        %waveform.  This deviation corresponds to the maximum
        %amplitude level of the modulating signal.  The units are
        %Hertz (Hz). This property affects function generator
        %behavior only when Mode is set FM and ModulationSource
        %is set to internal.
        %See also Mode, ModulationSource
        FMDeviation
        
        %Frequency specifies the rate at which the function
        %generator outputs an entire arbitrary waveform when Waveform is
        %set to Arb. It specifies the frequency of the standard waveform
        %when Waveform is set to standard waveform types.
        %The units are Hertz (Hz).
        %See also Waveform
        Frequency;
        
        %Mode specifies how the function generator produces waveforms. It
        %configures the instrument to generate output continuously
        %or to generate a discrete number of waveform cycles based
        %on a trigger event, it can also be set to AM and FM.
        Mode;
        
        %ModulationFrequency specifies the frequency of the
        %standard waveform that the function generator uses to
        %modulate the output signal.  The units are Hertz (Hz).
        %This attribute affects function generator behavior only
        %when Mode is set to AM or FM and the ModulationSource
        %attribute is set to internal.
        %See also Mode, ModulationSource
        ModulationFrequency
        
        %ModulationSource specifies the signal that the function
        %generator uses to modulate the output signal.
        ModulationSource
        
        %ModulationWaveform specifies the standard waveform
        %type that the function generator uses to modulate the
        %output signal. This affects function generator
        %behavior only when Mode is set to AM or FM and
        %the ModulationSource is set to internal.
        %See also Mode, ModulationSource
        ModulationWaveform
        
        %Offset specifies the DC offset of the standard waveform
        %when WAVEFORM is set to standard waveform. For example,
        %a standard waveform ranging from +5.0 volts to 0.0 volts
        %has a DC offset of 2.5 volts.
        %When WAVEFORM is set to Arb, this property shifts
        %the arbitrary waveform's range.  For example, when it is set
        %to 1.0, the output signal ranges from 2.0 volts to 0.0 volts.
        %See also Waveform
        Offset
        
        %OutputImpedance specifies the function generator's output
        %impedance at the output connector.
        OutputImpedance
    end
    
    properties
        %RESOURCE specifies the instrument resource to communicate with.
        %See also resources
        Resource;
    end
    
    properties (Dependent = true , SetAccess = 'private')
        %SelectedChannel returns the selected channel of the function generator.
        SelectedChannel;
    end
    
    properties ( Dependent = true )
        %StartPhase specifies the horizontal offset of the standard
        %waveform the function generator produces.  The units are
        %degrees  of one waveform cycle.  For example, a 180 degree phase
        %offset means output generation begins half way through the
        %waveform.
        StartPhase
    end
    
    
    %Read only properties
    properties (SetAccess = 'private')
        %STATUS returns whether a connection to the function generator is
        %open or closed. Read Only.
        Status = 'closed';
    end
    
    properties ( Dependent = true)
        %TriggerRate specifies the rate at which the function generator's
        %internal trigger source produces a trigger, in triggers
        %per second. This property affects function generator
        %behavior only when the triggerSource is set to internal.
        %See also TriggerSource
        TriggerRate
        
        %TriggerSource specifies the trigger source. After the function
        %generator receives a trigger, it generates an output signal
        %if Mode is set to Burst.
        %See also Mode,TriggerRate
        TriggerSource;
        
        %Waveform specifies which waveform the function generator produces.
        Waveform
    end
    
    methods (Hidden)
        %constructor
        function obj = FGen (varargin)

            narginchk(0,2);

            obj.createInternalStateMap();
            obj.changeState('FGenStateNotConnected');
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            % Handle optional args that will allow us to connect now
            if (nargin >= 1)
                obj.Resource = varargin{1};
                if (nargin == 2)
                    obj.Driver = varargin{2};
                end
                obj.connect();
            end            
        end
        
        function delete(obj)
            %Delete removes Function Generator object from memory
            if  ~isempty (obj.Adaptor)
                % Disconnect if still connected
                if isvalid(obj) && strcmp(obj.Status, 'open')
                    obj.disconnect();
                end
                obj.Adaptor =[];
            end
        end
    end
    
    methods
        
        function resourceList = resources(~)
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);

            %resources retrieves a list of available instrument resources.
            import instrument.internal.udm.*
            resourceList = ...
                instrument.internal.QCInstrument.instrumentResources(InstrumentType.Fgen, formatOutput);            
        end
        
        function driversInfo = drivers(~)
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);
            
            %drivers retrieves a list of available function generator
            %instrument drivers.   
            import instrument.internal.udm.*            
            driversInfo = ...
                instrument.internal.QCInstrument.instrumentDrivers(InstrumentType.Fgen, formatOutput);
        end
        
        function enableOutput(obj)
            %EnableOutput enables the function generator to
            %produce signal that appears at the output connector.
            try
                obj.InternalState.enableOutput(true);
            catch e
                throwAsCaller (e);
            end
        end
        
        function disableOutput(obj)
            %DisableOutput disables the signal that appears at the
            %output connector.
            try
                obj.InternalState.enableOutput(false);
            catch e
                throwAsCaller (e);
            end
        end
        
        function value = get.Status(obj)
            value =  obj.Status;
        end
        
        function reset(obj)
            %RESET sets the function generator to factory state.
            try
                obj.InternalState.reset();
            catch e
                throwAsCaller (e);
            end
        end
        
        function connect(obj)
            %CONNECT opens the I/O session to the instrument.
            %Driver functions and properties that access the instrument
            %are only accessible after connection is established.
            try
                obj.InternalState.connect();
            catch e
                throwAsCaller (e);
            end
        end
        
        function disconnect(obj)
            % Closes the instrument I/O session.
            try
                obj.InternalState.disconnect();
            catch e
                throwAsCaller (e);
            end
        end
        
        function Resource = get.Resource(obj)
            Resource = obj.Resource;
        end
        
        function  set.Resource(obj, value)
            if strcmp(obj.Status, 'open')
                error(message('instrument:qcinstrument:cannotChangeProperty') );
            end
            
            % convert to char in order to accept string datatype
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
        
        function  set.Driver(obj, value)
            
            if strcmp(obj.Status, 'open')
                error(message('instrument:qcinstrument:cannotChangeProperty') );
            end
            
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            if isempty (value)
                obj.Driver = value;
                return;
            end
            
            %switch DriverDetectionMode to manual
            obj.DriverDetectionMode = 'manual';
            obj.checkScalarStringArg(value);
            obj.Driver = value;
        end
        
        function value = get.BurstCount(obj)
            
            try
                value  = obj.InternalState.BurstCount ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.BurstCount(obj, value)
            try
                obj.InternalState.BurstCount = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.TriggerRate(obj)
            try
                value = obj.InternalState.TriggerRate ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.TriggerRate(obj,  value)
            try
                obj.InternalState.TriggerRate = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.TriggerSource(obj)
            try
                value = obj.InternalState.TriggerSource ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.TriggerSource(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.TriggerSource = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Offset(obj)
            try
                value = obj.InternalState.Offset ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.Offset(obj, value)
            try
                obj.InternalState.Offset = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Frequency(obj)
            
            try
                value = obj.InternalState.Frequency;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.Frequency(obj, value)
            try
                obj.InternalState.Frequency = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Amplitude(obj)
            try
                value = obj.InternalState.Amplitude;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.Amplitude(obj, value)
            try
                obj.InternalState.Amplitude = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.StartPhase(obj)
            try
                value = obj.InternalState.StartPhase;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.StartPhase(obj, value)
            try
                obj.InternalState.StartPhase = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.OutputImpedance(obj, value)
            try
                obj.InternalState.OutputImpedance = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.OutputImpedance(obj)
            try
                value = obj.InternalState.OutputImpedance;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ModulationSource(obj)
            try
                value = obj.InternalState.ModulationSource;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.ModulationSource(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.ModulationSource = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.FMDeviation(obj)
            try
                value = obj.InternalState.FMDeviation;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.FMDeviation(obj, value)
            try
                obj.InternalState.FMDeviation = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ModulationFrequency(obj)
            try
                value = obj.InternalState.ModulationFrequency;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.ModulationFrequency(obj, value)
            try
                obj.InternalState.ModulationFrequency = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ModulationWaveform(obj)
            try
                value = obj.InternalState.ModulationWaveform;
            catch e
                throwAsCaller(e);
            end
        end
        
        function  set.ModulationWaveform(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            try
                obj.InternalState.ModulationWaveform = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.Waveform(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            try
                obj.InternalState.Waveform = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Waveform(obj)
            try
                value = obj.InternalState.Waveform;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.Mode(obj)
            try
                value = obj.InternalState.Mode;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.Mode (obj, mode)
            % convert to char in order to accept string datatype
            mode = instrument.internal.stringConversionHelpers.str2char(mode);
            try
                obj.InternalState.Mode = mode;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.AMDepth(obj)
            try
                value = obj.InternalState.AMDepth;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.AMDepth(obj, value)
            try
                obj.InternalState.AMDepth = value ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function driver = get.DriverDetectionMode(obj)
            driver = obj.DriverDetectionMode;
        end
        
        function  set.DriverDetectionMode(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            if strcmpi(obj.Status, 'open') %#ok<*MCSUP>
                error(message('instrument:qcinstrument:cannotChangeProperty'));
            end
            
            if ~obj.UpdateDriverDetectionMode
                return;
            end
            
            obj.checkScalarStringArg(value);
            if strcmpi (value, 'auto') ||  strcmpi (value, 'manual')
                obj.DriverDetectionMode = value;
                if strcmpi (value, 'auto')
                    obj.Driver = [];
                end
            else
                error (message('instrument:qcinstrument:notValidDriverDetectionMode', value));
            end
        end
        
        function channelNames = get.ChannelNames(obj)
            try
                channelNames = obj.InternalState.ChannelNames;
            catch e
                throwAsCaller(e);
            end
        end
               
        function removeWaveform(obj, varargin)
            %RemoveWaveform removes a previously created arbitrary
            %waveform from the function generator's memory.
            %If waveform handle is provided, it removes the waveform
            %represented by the waveform handle.
            %
            %For example:
            %To remove a waveform from fgen with waveform handle 10000
            %removeWaveform (f, 10000);
            %
            %To remove a waveform created without supplying waveform handle
            %removeWaveform (f);
            %
            %See also downloadWaveform
            
            narginchk(1,2);
            try
                obj.InternalState.removeWaveform (varargin{:});
            catch e                
                throwAsCaller(e);
            end
        end
        
        
        function set.ArbWaveformGain(obj, value)
            try
                obj.InternalState.ArbWaveformGain = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ArbWaveformGain(obj)
            
            try
                value = obj.InternalState.ArbWaveformGain;
            catch e
                throwAsCaller(e);
            end
        end
        
        function varargout = downloadWaveform(obj, WaveformDataArray)
            %DownloadWaveform downloads an arbitrary waveform to the
            %function generator.
            %If you provide an output variable, a waveformhandle is
            %returned. It can be used in the selectWaveform() and
            %removeWaveform() methods.
            %If you don't provide an output variable, function generator will
            %overwrite the waveform when a new waveform is downloaded and
            %deletes it upon disconnection.
            %For example:
            %To download the following waveform to fgen
            %w = 1:0.001:2;
            %downloadWaveform (f, w);
            %
            %To download waveform to fgen and return a waveform handle
            %wh = downloadWaveform (f, w);
            %
            %See also selectWaveform, removeWaveform
            
            narginchk(2,2);
            nargoutchk(0,1);
            try
                if nargout == 0
                    obj.InternalState.downloadWaveform(WaveformDataArray);                    
                elseif nargout == 1
                    waveformHandle = obj.InternalState.downloadWaveform(WaveformDataArray);
                    tempOut = cell(1, 1);
                    [tempOut{:}] = waveformHandle;
                    varargout = tempOut;
                end
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function selectWaveform(obj, waveformHandle)
            %SelectWaveform specifies which arbitrary waveform the
            %function generator produces.
            %
            %For example:
            %selectWaveform(f, h);
            %where h is the waveform handle.
            %
            %See also downloadWaveform, removeWaveform
            
            narginchk(2,2);
            try
                obj.InternalState.selectWaveform(waveformHandle) ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function selectChannel(obj, channelName)
            %SelectChannel specifies the channel name from which the
            %function generator produces the waveform.
            %For example:
            %selectChannel(f, '1');
            %
            %See also channelNames
            
            narginchk(2,2);
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            try
                obj.InternalState.selectChannel(channelName);
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.SelectedChannel(obj)
            try
                value= obj.InternalState.SelectedChannel;
            catch e
                throwAsCaller(e);
            end
        end
    end

    methods (Hidden = true)
        
        %internal helper function to update connection status
        function updateConnectionStatus(obj, value)
            obj.Status = value;
        end
        
        function resetImpl(obj)
            delete(obj);
        end
        
        function changeState(obj, targetState)
            try
                % update the state machine.
                obj.InternalState = obj.InternalStateMap(targetState);
            catch e
                if strcmp(e.identifier,'MATLAB:Containers:Map:NoKey')
                    error(message('instrument:qcinstrument:badState'));
                else
                    rethrow(e)
                end
            end
        end
        
        function value = getChannelNames(obj)
            value = '';
            for idx = 1: size( obj.ChannelNames, 2)
                value = sprintf('%s, %s',value, char(obj.ChannelNames(idx)));
            end
            value(1:2 )=[];
        end
        
        function varargout = invoke(obj, varargin)
            %For backward compatibility.
            if nargin == 1
                error (message('instrument:qcinstrument:noMethodName'));
            end
            methodName =  varargin{1};
            
            % check if the method name is valid
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
            textToDisp = sprintf('fgen: %s',  obj.Adaptor.getInstrumentInfo());
            textToDisp = sprintf('%s\n%s', textToDisp, obj.generatePropertyDisp());
            % Line feed and methods footer
            textToDisp = sprintf('%s\n%s',textToDisp , obj.generateFooter());
            
            % Display it all at once
            disp(textToDisp);
        end
        
        function textToDisp = generatePropertyDisp(obj)
            %generatePropertyDisp provide a summary of function generator
            %object's properties and values.
            
            textToDisp = '';
            
            % general properties
            amplitude       = getPropertyInfo('Amplitude'       );
            channelNames    = getPropertyInfo('ChannelNames'    );
            frequency       = getPropertyInfo('Frequency'       );
            runMode         = getPropertyInfo('Mode'            );
            outputImpedance = getPropertyInfo('OutputImpedance' );
            offset          = getPropertyInfo('Offset'          );
            activeChannel   = getPropertyInfo('SelectedChannel' );
            waveform        = getPropertyInfo('Waveform'        );
            textToDisp      = message("instrument:qcinstrument:instrumentHeaderDisp", textToDisp, activeChannel, channelNames, ...
                amplitude, frequency, runMode, offset, outputImpedance, waveform).getString;
            
            % extra run mode info
            try
                if strcmpi(obj.Mode, 'burst')
                    BurstCount    = getPropertyInfo('BurstCount'    );
                    TriggerSource = getPropertyInfo('TriggerSource' );
                    if ~isempty (strfind(lower(TriggerSource), 'internal'))
                        TriggerInternalRate = getPropertyInfo('TriggerRate' );
                        textToDisp          = message("instrument:fgen:burstHeaderDisp", ...
                            textToDisp, BurstCount, TriggerSource, ...
                            TriggerInternalRate).getString;
                    else
                        textToDisp = message("instrument:fgen:burstHeaderDisp", ...
                            textToDisp, BurstCount, TriggerSource, '').getString;
                    end
                end
                if strcmpi (obj.Mode, 'am')
                    if  strcmpi (obj.ModulationSource , 'internal')
                        AMInternalDepth     = getPropertyInfo  ('AMDepth'            );
                        AMInternalFrequency = getPropertyInfo  ('ModulationFrequency');
                        AMSource            = getPropertyInfo  ('ModulationSource'   );
                        AMInternalWaveform  = getPropertyInfo  ('ModulationWaveform' );
                        textToDisp          = message("instrument:fgen:amHeaderDisp", ...
                            textToDisp, AMInternalDepth, ...
                            AMInternalFrequency, AMSource, ...
                            AMInternalWaveform).getString;
                    else
                        AMSource = getPropertyInfo  ('ModulationSource' );
                        textToDisp = message("instrument:fgen:amHeaderDisp", textToDisp, AMSource, '', '', '').getString;
                    end
                    
                end
                if strcmpi (obj.Mode, 'fm')
                    if strcmpi (obj.ModulationSource , 'internal')
                        FMInternalDeviation = getPropertyInfo  ('FMDeviation'   );
                        FMInternalFrequency = getPropertyInfo  ('ModulationFrequency' );
                        FMSource            = getPropertyInfo  ('ModulationSource' );
                        FMInternalWaveform  = getPropertyInfo  ('ModulationWaveform' );
                        textToDisp          = message("instrument:fgen:fmHeaderDisp", ...
                            textToDisp, FMInternalDeviation, ...
                            FMInternalFrequency, FMSource, ...
                            FMInternalWaveform).getString;
                    else
                        FMSource = getPropertyInfo  ('ModulationSource' );
                        textToDisp = message("instrument:fgen:fmHeaderDisp", textToDisp, FMSource, '', '', '').getString;
                    end
                end
            catch  e
            end
            
            % connection status
            status     = getPropertyInfo('Status');
            resource   = getPropertyInfo('Resource');
            textToDisp = message("instrument:qcinstrument:communicationHeaderDisp", ...
                textToDisp, status, resource).getString;
            
            function propertyInfo = getPropertyInfo(propertyName)
                %getPropertyInfo provide a formatted output for each
                %property.
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
                    if strcmpi(propertyName, 'OutputImpedance')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' Ohms') ;
                    elseif strcmpi(propertyName, 'Amplitude') || strcmpi(propertyName, 'Offset')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' V') ;
                    elseif strcmpi(propertyName, 'Frequency') || strcmpi(propertyName, 'FMDeviation')...
                            ||strcmpi(propertyName, 'ModulationFrequency')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, ' Hz') ;
                    elseif strcmpi(propertyName, 'AMDepth')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value, '%') ;
                    else
                        propertyInfo =  sprintf('%s%s: %s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            value) ;
                    end
                else
                    propertyInfo =  sprintf('%s%s: %s\n',...
                        blanks(maxPropNameLength - length(propertyName)),...
                        propertyName,...
                        value) ;
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
            textToDisp = sprintf('lists of <a href="matlab:methods(''%s'')">methods</a>',class(obj));
        end                       
    end
    
    % To be deprecated
    methods (Hidden=true)
        function driversInfo = getDrivers(obj)
            % getDrivers will be removed in a future release.
            % Use drivers instead.
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getDrivers', 'drivers');

            % Note: Not calling through to new method to retain
            % compatibility with previous code.
            
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);

            %resources retrieves a list of available instrument resources.
            import instrument.internal.udm.*
            driversInfo = ...
                instrument.internal.QCInstrument.instrumentDrivers(InstrumentType.Fgen, formatOutput);  
        end
        
        function resourceList = getResources(obj)
            % getResources will be removed in a future release
            % Use resources instead            
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getResources', 'resources');
            
            % Note: Not calling through to new method to retain
            % compatibility with previous code.            
            
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);

            %resources retrieves a list of available instrument resources.
            import instrument.internal.udm.*
            resourceList = ...
                instrument.internal.QCInstrument.instrumentResources(InstrumentType.Fgen, formatOutput);  
        end        
    end
    
    methods (Hidden = true , Access = 'private')
        
        function createInternalStateMap(obj)
            % Create the internal state map
            obj.InternalStateMap = containers.Map();
            addState('FGenStateNotConnected');
            addState('FGenStateConnected');
            
            function addState(stateName)
                % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
                %#function instrument.internal.udm.fgen.FGenStateNotConnected instrument.internal.udm.fgen.FGenStateConnected

                %Dynamically instantiates state machine objects and stores
                %in the state map where
                %key =state machine name
                %value = state machine object.
                obj.InternalStateMap(stateName) =...
                    feval(str2func(['instrument.internal.udm.fgen.' stateName]), obj);
            end
        end              
    end    
    
    methods
        function varargout = get(obj, varargin)
            if ~all(isvalid(obj))
                error(message('MATLAB:class:InvalidHandle'))
            end
            
            % Driver specific operations are performed later
            QCDriver= obj.Driver;
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            if isempty(obj.Adaptor) % if get method is called prior to establishing connection
                varargout = {get@hgsetget(obj,varargin{:})};
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
                        if ~strcmpi(QCDriver, 'Agilent332x0_SCPI') && (strcmpi(obj.Mode, 'AM') || strcmpi(obj.Mode, 'FM')) % For AM and FM modes and IVI adaptor
                            % calling the get method provided by the
                            % hgsetget class
                            unSortedGet = get@hgsetget(obj(index));
                        elseif strcmpi(QCDriver, 'Agilent332x0_SCPI') && (strcmpi(obj.Mode, 'AM') || strcmpi(obj.Mode, 'FM')) % For AM and FM modes and SCPI adaptor
                            propList = properties(obj);
                            for i = 1:numel(propList)
                                fldName   = propList{i};
                                % For the SCPI adaptor, ArbWaveformGain is
                                % accessible only when Waveform property is
                                % set to Arb
                                if strcmpi(fldName, 'ArbWaveformGain')
                                    if ~strcmpi(obj.Waveform, 'Arb')
                                        msg = message('instrument:fgen:notAvailablePropWfm', obj.Waveform);
                                        propVal = msg.getString; %#ok
                                    else
                                        propVal = obj.([propList{i}]); %#ok
                                    end
                                else
                                    propVal = obj.([propList{i}]); %#ok
                                end
                                % update the unSortedGet structure
                                evalc(['unSortedGet.' fldName '= propVal']);
                            end
                        else %if mode is either 'Burst' or 'Continuous' for both IVI and SCPI adaptors
                            propList = properties(obj);
                            for i = 1:numel(propList)
                                fldName   = propList{i};
                                % ModulationFrequency, ModulationWaveform,
                                % and ModulationSource are not supported in
                                % 'Burst' and 'Continuous' modes of
                                % operation
                                if strcmpi(fldName, 'ModulationFrequency')...
                                        || strcmpi(fldName, 'ModulationWaveform')...
                                        || strcmpi(fldName, 'ModulationSource')
                                    msg = message('instrument:fgen:notAvailableMode', obj.Mode);
                                    propVal = msg.getString; %#ok 
                                else
                                    % If SCPI adaptor is being used,
                                    % ArbWaveformGain property is
                                    % accessible only when Waveform property
                                    % is set to Arb
                                    if strcmpi(fldName, 'ArbWaveformGain')
                                        if strcmpi(obj.Driver, 'Agilent332x0_SCPI') && ~strcmpi(obj.Waveform, 'Arb')
                                            msg = message('instrument:fgen:notAvailablePropWfm', obj.Waveform); 
                                            propVal = msg.getString;                                            
                                        else
                                            propVal = obj.([propList{i}]); %#ok
                                        end
                                    else
                                        propVal = obj.([propList{i}]); %#ok
                                    end
                                end
                                % update the unSortedGet structure
                                evalc(['unSortedGet.' fldName '= propVal']);
                            end
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
            %of the FGen, and the Waveform selected
            sortedpropertyNames = properties(obj);
            dispStr = '';
            
            for i = 1:length(sortedpropertyNames)
                try
                    % Some instruments do not support different 'Modes' as
                    % defined by IVI. Therefore, check if 'Mode; property
                    % is defined. An error is generated if Mode is not
                    % available.
                    
                    instrMode = obj.Mode; %#ok
                    instrModeAvailability = 1;
                catch
                    instrModeAvailability = 0;
                end
                
                % (If Mode is available) and (set to Burst or Continuous),
                % then ModulationFrequency, ModulationSource, and
                % ModulationWaveform cannot be accessed
                if (instrModeAvailability) && ((strcmpi(obj.Mode, 'Burst')...
                        || strcmpi(obj.Mode, 'Continuous')) ...
                        && (strcmpi(sortedpropertyNames{i}, 'ModulationFrequency')...
                        || strcmpi(sortedpropertyNames{i}, 'ModulationSource')...
                        || strcmpi(sortedpropertyNames{i}, 'ModulationWaveform')))
                    msg = message('instrument:fgen:notAvailableMode', obj.Mode);
                    propertyToDisplay = msg.getString;                    
                else
                    % If Mode is unavailable, then read all properties
                    
                    % If the SCPI adaptor is being used, ArbWaveformGain is
                    % available only when the Waveform property is set to
                    % Arb
                    if strcmpi(sortedpropertyNames{i}, 'ArbWaveformGain')
                        if (strcmpi(obj.Driver, 'Agilent332x0_SCPI')|| strcmpi(obj.Driver, 'hp33120a')) && ~strcmpi(obj.Waveform, 'Arb')
                            msg = message('instrument:fgen:notAvailablePropWfm', obj.Waveform);
                            propertyToDisplay = msg.getString;
                        else
                            try
                                propertyToDisplay = obj.([sortedpropertyNames{i}]);
                            catch
                                % If unable to read the value of the
                                % requested property
                                msg = message('instrument:qcinstrument:instrumentError');
                                propertyToDisplay = msg.getString;
                            end
                        end
                    else
                        try
                            propertyToDisplay = obj.([sortedpropertyNames{i}]);
                        catch
                            % If unable to read the value of the requested
                            % property
                            msg = message('instrument:qcinstrument:instrumentError');
                            propertyToDisplay = msg.getString;
                        end
                        
                    end
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

% LocalWords:  Vpp Arb CHANNELNAMES qcinstrument fgen waveformhandle wh fm udm
