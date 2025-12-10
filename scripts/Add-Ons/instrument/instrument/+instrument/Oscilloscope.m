classdef Oscilloscope < instrument.internal.QCInstrument
    %OSCILLOSCOPE class provides basic functionality to
    %communicate with oscilloscope instruments.
    
    % Copyright 2011-2023 The MathWorks, Inc.
    
    properties (Access = protected, Hidden)
        % QUICKCONTROLTYPE defines the type of quick control device.
        QuickControlType = "Oscilloscope"
    end
    
    properties (Hidden)
        %An Adaptor used to communicate with instrument
        Adaptor;
        %A flag to control two mutually dependent properties
        %Driver and DriverDetectionMode
        UpdateDriverDetectionMode;
        %List of to be deprecated methods
        DeprecatedMethods = char('getDrivers','getResources','getWaveform',...
            'getVerticalOffset','getVerticalRange','getVerticalCoupling',...
            'setVerticalOffset','setVerticalRange','setVerticalCoupling')
    end

    properties (Dependent = true)
        %ACQUISTIONSTARTDELAY The length of time in seconds from the
        %trigger event to the first point in the waveform length.
        %If positive, the first point in the waveform occurs after
        %the trigger.  If negative, the first point in the waveform
        %occurs before the trigger.
        AcquisitionStartDelay;
        
        %ACQUISITIONTIME The time in seconds that corresponds to the
        %waveform length.
        AcquisitionTime;
    end
    
    properties (Dependent = true, SetAccess = 'private')
        %CHANNELNAMES returns available channel names of the oscilloscope. Read Only.
        ChannelNames;
        
        %ENABLEDCHANNELS returns a list of enabled channels of the oscilloscope. Read Only.
        ChannelsEnabled;
    end
    
    properties
        %DRIVER specifies the underlying driver used to communicate with an
        %instrument.
        %See also drivers
        Driver;
        
        %DriverDetectionMode specifies how the driver is configured. When it is set to
        %'auto', the program will configure the driver name automatically. If
        %it is set to 'manual', user has to provide a driver name before
        %connecting to the instrument.
        DriverDetectionMode = 'auto';
        
        %RESOURCE specifies the instrument resource to communicate.
        %See also getResources
        Resource;
    end
    
    properties (Dependent = true)
        %SINGLESWEEPMODE specifies whether the oscilloscope
        %automatically stops acquiring after one acquisition is complete.
        %Available values are 'on' and 'off'.
        SingleSweepMode;
    end
    
    %Read only properties
    properties (SetAccess = 'private')
        %CONNECTIONSTATUS returns whether a connection to the oscilloscope is
        %open or closed. Read Only.
        Status = 'closed';
    end
    
    properties
        %TIMEOUT specifies the period when oscilloscope initiates an acquisition
        %then waits for the acquisition to complete.
        Timeout = 10;
        
    end
    
    properties (Dependent = true)
        %TRIGGERMODE specifies the oscilloscope's behavior in
        %the absence of the trigger you configure. Available values are:
        %'normal' � the oscilloscope waits until the trigger the user
        %specifies occurs,
        %'auto' � the oscilloscope automatically triggers if the configured
        % trigger does not occur within the oscilloscope�s timeout period.
        TriggerMode;
        
        %TRIGGERLEVEL specifies the voltage threshold in volts for the trigger control.
        TriggerLevel;
        
        %TRIGGERSLOPE specifies whether a rising or a falling edge
        %triggers the oscilloscope. Available values are 'rising' and
        %'falling'.
        TriggerSlope;
        
        %TRIGGERSOURCE specifies the source the oscilloscope
        %monitors for a trigger. It can be channel name or other values.
        TriggerSource;
        
        %WAVEFORMLENGTH specifies the number of points the oscilloscope
        %acquires for the waveform.
        WaveformLength;
    end
    
    
    methods (Hidden)
        %constructor
        function obj = Oscilloscope (varargin)
            narginchk(0,2);
            
            obj.createInternalStateMap();
            obj.changeState('StateNotConnected');
            
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
            %Delete removes Oscilloscope object from memory
            if ~isempty (obj.Adaptor)
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
            resourceList = ....
                instrument.internal.QCInstrument.instrumentResources(InstrumentType.Scope, formatOutput);
        end
                
        function driversInfo = drivers(~)            
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);
            
            %drivers retrieves a list of available oscilloscope
            %instrument drivers.   
            import instrument.internal.udm.*
            driversInfo = ...
                instrument.internal.QCInstrument.instrumentDrivers(InstrumentType.Scope, formatOutput);
        end
        
        function autoSetup(obj)
            %AUTOSETUP automatically configures the
            %instrument based on the input signal.
            try
                obj.InternalState.autoSetup;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.SingleSweepMode(obj)
            try
                value = obj.InternalState.SingleSweepMode;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.SingleSweepMode(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.SingleSweepMode = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.ChannelsEnabled(obj)
            try
                value = obj.InternalState.ChannelsEnabled;
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function set.Timeout(obj, value)
            
            obj.checkScalarDoubleArg(value);
            if (value < 0)
                error(message('instrument:oscilloscope:timeoutCannotbeNegative'));
            end
            obj.Timeout = value;
        end
        
        function value = get.Timeout(obj)
            value = obj.Timeout;
            
        end
        
        function value = get.Status(obj)
            value =  obj.Status;
        end
        
        function reset(obj)
            %RESET sets the oscilloscope to factory state.
            try
                obj.InternalState.reset();
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function connect(obj)
            %CONNECT opens the I/O session to the instrument.
            %Driver functions and properties that access the instrument
            %are only accessible after connection is established.
            try
                obj.InternalState.connect();
            catch e
                throwAsCaller(e);
            end
            
        end
        
        function disconnect(obj)
            %Closes the instrument I/O session.
            try
                obj.InternalState.disconnect();
            catch e
                throwAsCaller(e);
            end
        end
               
        function Resource = get.Resource(obj)
            Resource = obj.Resource;
        end
        
        function set.Resource(obj, value)
            if strcmp(obj.Status, 'open')
                error(message('instrument:oscilloscope:cannotChangeProperty'));
            end
            
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.checkScalarStringArg(value);
                obj.Resource = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function driver = get.Driver(obj)
            driver = obj.Driver;
        end
                
        function set.Driver(obj, value)
            
            if strcmp(obj.Status, 'open')
                error(message('instrument:oscilloscope:cannotChangeProperty') );
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
        
        
        function value = get.TriggerMode(obj)
            try
                value = obj.InternalState.TriggerMode;
            catch e
                throwAsCaller (e);
            end
        end
        
        function set.TriggerMode(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.TriggerMode = value;
            catch e
                throwAsCaller (e);
            end
        end
        
        function driver = get.DriverDetectionMode(obj)
            driver = obj.DriverDetectionMode;
        end
        
        function set.DriverDetectionMode(obj, value)
            if strcmpi(obj.Status, 'open') %#ok<*MCSUP>
                error(message('instrument:oscilloscope:cannotChangeProperty' ));
            end
            
            if ~obj.UpdateDriverDetectionMode
                return;
            end
            
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            obj.checkScalarStringArg(value);
            if strcmpi (value, 'auto') ||  strcmpi (value, 'manual')
                obj.DriverDetectionMode = value;
                if strcmpi (value, 'auto')
                    obj.Driver = [];
                end
            else
                error (message('instrument:oscilloscope:notValidDriverDetectionMode', value));
            end
        end
        
        function channelNames = get.ChannelNames(obj)
            
            try
                channelNames = obj.InternalState.ChannelNames;
            catch e
                throwAsCaller(e);
            end
            
        end
        
        
        function set.AcquisitionTime(obj, value)       
            
            try
                obj.InternalState.AcquisitionTime = value;
            catch e
                throwAsCaller(e);
            end
            
        end
        
        function value = get.AcquisitionTime(obj)
            try
                value = obj.InternalState.AcquisitionTime;
            catch e
                throwAsCaller(e);
            end
            
        end
        
        function set.WaveformLength(obj, value)         
            
            try
                obj.InternalState.WaveformLength = value;
            catch e
                throwAsCaller(e);
            end
            
        end
        
        function value = get.WaveformLength(obj)
            
            try
                value = obj.InternalState.WaveformLength;
            catch e
                throwAsCaller(e);
            end
            
            
        end
        
        function set.AcquisitionStartDelay(obj, value)
            
            try
                obj.InternalState.AcquisitionStartDelay = value ;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.AcquisitionStartDelay(obj)
            
            try
                value = obj.InternalState.AcquisitionStartDelay;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.TriggerSlope(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            try
                obj.InternalState.TriggerSlope = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.TriggerSlope(obj)
            
            try
                value =obj.InternalState.TriggerSlope;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.TriggerLevel(obj, value)
            
            try
                obj.InternalState.TriggerLevel = value;
            catch e
                throwAsCaller(e);
            end
        end
        
        function value = get.TriggerLevel(obj)
            
            try
                value = obj.InternalState.TriggerLevel;
            catch e
                throwAsCaller(e);
            end
        end
        
        function set.TriggerSource(obj, value)
            % convert to char in order to accept string datatype
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            try
                obj.InternalState.TriggerSource = value;
            catch e
                throwAsCaller(e);
            end
            
        end
        
        function value = get.TriggerSource(obj)
            
            try
                value = obj.InternalState.TriggerSource;
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function varargout = configureChannel(obj, channelName, property, value)
            %CONFIGURECHANNEL(OBJ, CHANNELNAME, PROPERTY, VALUE)
            %Sets or returns the value of the specified PROPERTY. 
            %
            %PROPERTY 'VerticalCoupling'
            %           
            %Specifies how the oscilloscope couples the input signal
            %for the selected channel name as a MATLAB string.
            %Valid values are 'AC', 'DC' and 'GND'.
            %Examples:
            %configureChannel(o, 'Channel1', 'VerticalCoupling', 'AC');
            %coupling = configureChannel(o, 'Channel1', 'VerticalCoupling');
            %
            %PROPERTY 'VerticalOffset'
            %
            %Specifies location of the center of the range that is specified by
            %oscilloscope's setVerticalRange function for the selected channel
            %name as a MATLAB string.
            %For example, to acquire a sine wave that spans between 0.0 and
            %10.0 volts, set this attribute to 5.0 volts.
            %For example:
            %configureChannel(o, 'Channel1', 'VerticalOffset', 5);
            %offset = configureChannel(o, 'Channel1', 'VerticalOffset');
            %
            %PROPERTY 'VerticalRange'
            %
            %Specifies the absolute value of the input range the oscilloscope
            %can acquire for the selected channel name as a MATLAB string.
            %The units are volts.
            %For example:
            %configureChannel (o, 'Channel1', 'VerticalRange, 10);
            %range = configureChannel (o, 'Channel1', 'VerticalRange');
            %
            %PROPERTY 'ProbeAttenuation'
            %
            %Specifies the Probe Attenuation setting for the oscilloscope.
            %The value is specified as a multiple of 10. Example values
            %are: 1, 10, 100.
            %For example:
            %configureChannel (o, 'Channel1', 'ProbeAttenuation', 10);
            %probeattenuation = configureChannel (o, 'Channel1', 'ProbeAttenuation');
            %
            %See also ChannelNames
            
            nargoutchk(0,1);
            
            % Multiple cases need to be handled here:
            % Set - nargout == 0, nargin == 4
            % Get - nargout == 0, nargin == 3
            % Get - nargout == 1, nargin == 3
            
            if (nargout > 0)
                narginchk(3,3);
            else
                narginchk(3,4);
            end
            
            try
                if (nargin == 4) % set
                    % convert to char in order to accept string datatype
                    channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
                    property = instrument.internal.stringConversionHelpers.str2char(property);
                    value = instrument.internal.stringConversionHelpers.str2char(value);
                    
                    obj.channelProperty(channelName,property,value);
                else % get
                    % convert to char in order to accept string datatype
                    channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
                    property = instrument.internal.stringConversionHelpers.str2char(property);
                    
                    varargout{1} = obj.channelProperty(channelName,property);
                end
            catch e
                throwAsCaller(e);
            end
            
        end               
        
        function enableChannel (obj, varargin)
            %ENABLECHANNEL (OBJ, VARARGIN) enables
            %channel(s) from which waveform(s) will be retrieved.
            %VARARGIN could be a single channel name or a cell array of
            %channel names.
            %
            %For example:
            %enableChannel(o, 'Channel1');
            %enableChannel(o, {'Channel1', 'Channel2'});
            %
            %See also ChannelNames ChannelsEnabled
            narginchk(2,2);
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            try
                obj.InternalState.enableChannel(varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function disableChannel (obj, varargin)
            %DISABLECHANNEL(OBJ, VARARGIN) disables oscilloscope's channel(s).
            %VARARGIN could be a single channel name or a cell array of
            %channel names.
            %
            %For example:
            %disableChannel('Channel1');
            %disableChannel({'Channel1', 'Channel2'});
            %
            %See also ChannelNames ChannelsEnabled
            
            narginchk(2,2);
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            try
                obj.InternalState.disableChannel(varargin{:});
            catch e
                throwAsCaller(e);
            end
        end
        
        
        function varargout = readWaveform(obj, varargin)
            %VARARGOUT = READWAVEFORM(OBJ, VARARGIN) retrieves the
            %waveform(s) from enabled channel(s).
            %By default, it downloads captured waveform from oscilloscope without
            %acquisition.
            %
            %For example:
            %To get waveform from only one enabled channel without
            %acquisition.
            %w = readWaveform (o);
            %
            %To get waveforms from two enabled channels
            %Note: The order of the waveforms is the same as ChannelEnabled
            %[w1, w2] = readWaveform (o);
            %
            %To initiate acquisition and to return waveform(s) from
            %oscilloscope.
            %Note: The 'acquisition' property is false by default.
            %w = readWaveform (o, 'acquisition', true);
            %
            %To get waveform from one enabled channel without acquisition.
            %w = readWaveform (o, 'acquisition', false);
            %
            %See also ChannelsEnabled
            narginchk(1,3);
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            try
                tempOut = cell(1, nargout);
                [tempOut{:}] = obj.InternalState.getWaveform(varargin{:});
                varargout = tempOut;
            catch e
                throwAsCaller(e);
            end
        end
    end         
    
    methods (Hidden = true)
        
        function resetImpl(obj)
            delete (obj);
        end
        
        function displayHelper(obj)
            
            textToDisp = sprintf('oscilloscope: %s',  obj.Adaptor.getInstrumentInfo());
            
            textToDisp = sprintf('%s\n%s', textToDisp, obj.generatePropertyDisp());
            
            % Line feed and methods footer
            textToDisp = sprintf('%s\n%s',textToDisp , obj.generateFooter());
            
            % Display it all at once
            disp(textToDisp);
        end
        
        
        function textToDisp = generatePropertyDisp(obj)
            % GeneratePropertyDisp provide a summary of oscilloscope
            % object's properties and values. This is the custom display
            % function written for QC-Oscilloscope class.
            
            textToDisp = '';
            % Each property is individually fetched and wrapped in
            % try-catch. This is to ensure that an error in reading one of
            % the properties does not generate an error for the display()
            % method.
            
            getResult = propertyRead(obj);
            
            % Acquisition Start Delay            
            acqStartDelay   = getPropertyInfo('AcquisitionStartDelay', getResult.AcquisitionStartDelay);
            acqTime         = getPropertyInfo('AcquisitionTime', getResult.AcquisitionTime);
            channelNames    = getPropertyInfo('ChannelNames', getResult.ChannelNames);
            channelsEnabled = getPropertyInfo('ChannelsEnabled', getResult.ChannelsEnabled);
            singleSweepMode = getPropertyInfo('SingleSweepMode', getResult.SingleSweepMode);
            timeOut         = getPropertyInfo('Timeout', getResult.Timeout);
            waveformLength  = getPropertyInfo('WaveformLength', getResult.WaveformLength);
            textToDisp      = message("instrument:qcinstrument:instrumentHeaderDisp", ...
                textToDisp, acqStartDelay, acqTime, channelNames, ...
                channelsEnabled, singleSweepMode, timeOut, waveformLength, "").getString;
            
            % trigger property
            triggerMode = getPropertyInfo  ('TriggerMode' , getResult.TriggerMode);
            if strcmpi(getResult.TriggerMode ,'normal' )
                triggerLevel  = getPropertyInfo('TriggerLevel' , getResult.TriggerLevel );
                triggerSource = getPropertyInfo('TriggerSource', getResult.TriggerSource);
                triggerSlope  = getPropertyInfo('TriggerSlope' , getResult.TriggerSlope );
                textToDisp    = message("instrument:oscilloscope:triggerHeaderDisp", ...
                    textToDisp, triggerLevel, triggerSource, ...
                    triggerSlope, triggerMode).getString;
            else
                textToDisp    = message("instrument:oscilloscope:triggerHeaderDisp", ...
                    textToDisp, triggerMode, '', '', '').getString;
            end
            
            % connection status
            status     = getPropertyInfo('Status'   , getResult.Status  );
            resource   = getPropertyInfo('Resource' , getResult.Resource);
            textToDisp = message("instrument:qcinstrument:communicationHeaderDisp", ...
                textToDisp, status, resource).getString;
            
            
            function propertyInfo = getPropertyInfo(propertyName, propertyValue)
                %getPropertyInfo provide a formatted output for each
                %property.
                propNames = properties(obj);
                maxPropNameLength = max(cellfun(@length,propNames))+ 6;
                
                if isempty(strfind(lower(propertyValue), 'not supported'))
                    if strcmpi(propertyName, 'AcquisitionTime') || strcmpi(propertyName, 'Timeout')
                        propertyInfo =  sprintf('%s%s: %s%s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            renderProperty(propertyValue), ' s') ;
                    elseif strcmpi(propertyName, 'AcquisitionStartDelay')
                        if strcmpi(propertyValue, 'Not supported')
                            propertyInfo =  sprintf('%s%s: %s\n',...
                                blanks(maxPropNameLength - length(propertyName)),...
                                propertyName,...
                                renderProperty(propertyValue)) ;
                        else
                            propertyInfo =  sprintf('%s%s: %s%s\n',...
                                blanks(maxPropNameLength - length(propertyName)),...
                                propertyName,...
                                renderProperty(propertyValue), ' s') ;
                        end
                    else
                        propertyInfo =  sprintf('%s%s: %s\n',...
                            blanks(maxPropNameLength - length(propertyName)),...
                            propertyName,...
                            renderProperty(propertyValue)) ;
                    end
                else
                    propertyInfo =  sprintf('%s%s: %s\n',...
                        blanks(maxPropNameLength - length(propertyName)),...
                        propertyName,...
                        renderProperty(propertyValue)) ;
                end
            end
            
            function valueStr = renderProperty(value)
                %renderProperty defines the format for each type of
                %properties.
                if isempty(value)
                    % If it's empty, print nothing
                    valueStr = '';
                elseif iscell(value)
                    valueStr ='';
                    for i = 1:size(value, 2)
                        valueStr =  sprintf('%s ''%s'',',valueStr , value{i});                        
                    end
                    valueStr(1) = []; % remove empty space
                    valueStr(length(valueStr)) = [];
                    
                elseif isscalar(value)
                    if islogical(value)
                        % if it's a logical, print true/false
                        if value
                            valueStr = 'true';
                        else
                            valueStr = 'false';
                        end
                    else
                        % If it's a scalar numeric, print value
                        valueStr = num2str(value);
                    end
                elseif ischar(value)
                    % If it's a string, print it in single quotes
                    valueStr = ['''' value ''''];
                else
                    
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
        
        
        function changeState(obj, targetState)
            try
                % update the state machine.
                obj.InternalState = obj.InternalStateMap(targetState);
            catch e
                if strcmp(e.identifier,'MATLAB:Containers:Map:NoKey')
                    error(message('instrument:oscilloscope:badState'));
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
            value(1:2 ) =[];
        end
        
        function varargout = invoke(obj, varargin)
            %For backward compatibility.
            if nargin == 1
                error(message('instrument:oscilloscope:noMethodName'));
            end
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            methodName =  varargin{1};
            
            % check if the method name is valid. the list of to be
            % deprecated methods is included for backwards compatibility.
            if ~ ismember (methodName, [methods(obj); cellstr(obj.DeprecatedMethods)])
                error(message('instrument:oscilloscope:notValidMethodName', methodName));
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
        
              
        %internal helper function to update connection status
        function updateConnectionStatus(obj, value)
            obj.Status = value;
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
                instrument.internal.QCInstrument.instrumentDrivers(InstrumentType.Scope, formatOutput); 
        end
        
        function resourceList = getResources(obj)
            % getResources will be removed in a future release.
            % Use resources instead.
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getResources', 'resources');
            
            % Note: Not calling through to new method to retain
            % compatibility with previous code.            
            
            % If there is no output arg, format the output for display,
            % otherwise return a cell array of structs.
            formatOutput = isequal(nargout, 0);

            %resources retrieves a list of available instrument resources.
            import instrument.internal.udm.*
            resourceList = ...
                instrument.internal.QCInstrument.instrumentResources(InstrumentType.Scope, formatOutput); 
        end
        
        function varargout = getWaveform(obj, varargin)
            %GETWAVEFORM will be removed in a future release.
            % Use readWaveform instead.
            narginchk(1,3);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getWaveform', 'readWaveform');
            tempOut = cell(1, nargout);
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            [tempOut{:}] = readWaveform(obj, varargin{:});
            varargout = tempOut;
        end 
        
        function setVerticalCoupling(obj, channelName, value)
            %SETVERTICALCOUPLING will be removed in a future release.
            % Use configureChannel instead.
            narginchk(3,3);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('setVerticalCoupling', 'configureChannel');
            
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            value = instrument.internal.stringConversionHelpers.str2char(value);
            
            configureChannel(obj, channelName, 'VerticalCoupling', value);
        end 
        
        function value = getVerticalCoupling(obj, channelName)
            %V=GETVERTICALCOUPLING will be removed in a future release.
            % Use configureChannel instead.
            narginchk(2,2);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getVerticalCoupling', 'configureChannel');
            
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            
            value = configureChannel(obj, channelName, 'VerticalCoupling');
        end
        
        function setVerticalOffset(obj, channelName, value)
            %SETVERTICALOFFSET will be removed in a future release.
            % Use configureChannel instead.
            narginchk(3,3);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('setVerticalOffset', 'configureChannel');
            
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            
            configureChannel(obj, channelName, 'VerticalOffset', value);
        end
        
        function value = getVerticalOffset(obj, channelName)
            %V= GETVERTICALOFFSET will be removed in a future release.
            % Use configureChannel instead.
            narginchk(2,2);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getVerticalOffset', 'configureChannel');
            
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            
            value = configureChannel(obj, channelName, 'VerticalOffset');
        end
        
        function setVerticalRange(obj, channelName, value)
            %SETVERTICALRANGE will be removed in a future release.
            % Use configureChannel instead.
            narginchk(3,3);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('setVerticalRange', 'configureChannel');
            
            % convert to char in order to accept string datatype
            channelName = instrument.internal.stringConversionHelpers.str2char(channelName);
            
            configureChannel(obj, channelName, 'VerticalRange', value);            
        end
        
        function value = getVerticalRange(obj, channelName)
            %V = GETVERTICALRANGE will be removed in a future release.
            % Use configureChannel instead.
            narginchk(2,2);
            instrument.internal.QCInstrument.issueDeprecatedMethodWarning('getVerticalRange', 'configureChannel');
            value = configureChannel(obj, channelName, 'VerticalRange');
        end        
    end
    
    methods (Hidden = true, Access = 'private')
        
        function createInternalStateMap(obj)
            % Create the internal state map
            obj.InternalStateMap = containers.Map();
            addState('StateNotConnected');
            addState('StateConnected');
            
            function addState(stateName)
                % function pragma is required to make sure that MATLAB Compiler's dependency analysis detects the functions and include them in the compilation
                %#function instrument.internal.udm.oscilloscope.StateNotConnected instrument.internal.udm.oscilloscope.StateConnected

                %Dynamically instantiates state machine objects and stores
                %in the state map where
                %key =state machine name
                %value = state machine object.
                obj.InternalStateMap(stateName) =...
                    feval(str2func(['instrument.internal.udm.oscilloscope.' stateName]),obj);
            end
        end
                
        function varargout = channelProperty(obj, channel, property, value)
            % CHANNELPROPERTY - Helper function to get/set channel
            % properties. Used by configureChannel.
            
            % Call set or get for the passed in channel property
            if (nargin == 4)                
                obj.InternalState.(['set' property])(channel, value);  
            else
                varargout = cell(1, nargout);
                [varargout{:}] = obj.InternalState.(['get' property])(channel);                
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
            
            
            if nargout == 0 && nargin == 1
                
                % Read each property of the object
                getResult = propertyRead(obj);
                                
                fldNames  = fieldnames(getResult);
                dispStr = '';
                for i = 1:numel(fldNames)
                    propVal = getResult.(fldNames{i});
                    if ischar(propVal)
                        txtToDisp = sprintf('    %s = %s', fldNames{i}, getResult.(fldNames{i}));
                    elseif isnumeric(propVal)
                        txtToDisp = sprintf('    %s = %d', fldNames{i}, getResult.(fldNames{i}));
                    elseif iscell(propVal)
                        strToDisp = '';
                        for cindx = 1:numel(propVal)
                            strToDisp = [strToDisp, propVal{cindx}, ', ']; %#ok<AGROW>
                        end
                        strToDisp = strToDisp(1:end-2);
                        txtToDisp = sprintf('    %s = %s', fldNames{i}, strToDisp);
                    elseif strcmpi(class(propVal), 'event.listener')
                        txtToDisp = '';
                    end
                    
                    dispStr = sprintf('%s%s\n', dispStr, txtToDisp);
                    
                end
                disp(dispStr);
            else
                varargout{1} = get@hgsetget(obj,varargin{:});
            end
        end
    end
    
    methods (Access = private, Hidden = true)
        function getResult = propertyRead(obj)
            % Individually read each property and return a structure with
            % property values.
            
            sortedPropertyList = properties(obj);
            
            % Get the error message from the message catalog. This will be
            % used when an error occurs in reading property value.
            msg = message('instrument:qcinstrument:instrumentError');
            
            for i = 1:numel(sortedPropertyList)
                try
                    getResult.(sortedPropertyList{i}) = obj.(sortedPropertyList{i});
                catch
                    % If property value is not provided by the driver or
                    % the instrument
                    getResult.(sortedPropertyList{i}) = msg.getString;
                end
            end            
            
        end        
    end    
end
% LocalWords:  ACQUISITIONTIME ACQUISTIONSTARTDELAY TRIGGERLEVEL TRIGGERSLOPE
% LocalWords:  TRIGGERSOURCE WAVEFORMLENGTH TRIGGERMODE SINGLESWEEPMODE
% LocalWords:  CHANNELNAMES ENABLEDCHANNELS CONNECTIONSTATUS AUTOSETUP Cannotbe
% LocalWords:  SETVERTICALCOUPLING CHANNELNAME GETVERTICALCOUPLING
% LocalWords:  SETVERTICALOFFSET GETVERTICALOFFSET SETVERTICALRANGE
% LocalWords:  GETVERTICALRANGE ENABLECHANNEL DISABLECHANNEL GETWAVEFORM