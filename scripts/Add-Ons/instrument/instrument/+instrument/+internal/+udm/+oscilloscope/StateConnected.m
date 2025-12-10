classdef(Hidden)StateConnected < instrument.internal.udm.oscilloscope.StateOscilloscope
    %StateConnected is the state after connection is setup.
    %   StateConnected provides state specific behaviors for all
    %   operations when the instrument has been connected. Most of the
    %   operations are delegated to the underlying adapter to handle.
    
    %    Copyright 2011-2019 The MathWorks, Inc.
    properties
        %redefine the abstract properties in StateOscilloscope class
        AcquisitionTime;
        AcquisitionStartDelay;
        TriggerLevel;
        TriggerSlope;
        TriggerSource;
        WaveformLength  ;
        TriggerMode ;
        SingleSweepMode;
        
    end
    
    %Read only properties
    properties (SetAccess = 'private')
        ChannelNames;
        ChannelsEnabled  ;
    end
    
    methods
        %constructor
        function obj =  StateConnected(scope)
            obj@instrument.internal.udm.oscilloscope.StateOscilloscope(scope);
        end
        
        function autoSetup(obj)
            obj.Oscilloscope.Adaptor.autoSetup();
        end
        
        function value = get.ChannelsEnabled(obj)
            value = obj.Oscilloscope.Adaptor.ChannelsEnabled;
        end
        
        
        function delete(obj)
            if isvalid (obj) && ~isempty (obj.Adaptor)
                obj.Adaptor =[];
            end
        end
        
        
        function reset(obj)
            obj.Oscilloscope.Adaptor.reset();
        end
        
        
        function connect(obj ) %#ok<*MANU>
            error (message('instrument:oscilloscope:alreadyConnected')) ;
        end
        
        function disconnect(obj)
            obj.Oscilloscope.Adaptor.disconnect();
            obj.Oscilloscope.Adaptor =[];
            obj.Oscilloscope.updateConnectionStatus('closed');
            %switch to StateNotConnected object.
            obj.Oscilloscope.changeState('StateNotConnected');
            
        end
        
        function value = get.SingleSweepMode(obj)
            import instrument.internal.udm.oscilloscope.*;
            enumValue = obj.Oscilloscope.Adaptor.SingleSweepMode;
            
            if enumValue == SingleSweepModeEnum.On
                value  ='on';
            else
                value ='off';
            end
        end
        
        function set.SingleSweepMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            SingleSweepModeEnum.validateSingleSweepModeValue(value);
            obj.Oscilloscope.Adaptor.SingleSweepMode = SingleSweepModeEnum.getEnum(value);
        end
        
        function value = get.TriggerMode(obj)
            import instrument.internal.udm.oscilloscope.*
            enumValue = obj.Oscilloscope.Adaptor.TriggerMode;
            if enumValue == TriggerModeEnum.Auto
                value  ='auto';
            else
                value ='normal';
            end
            
        end
        
        function  set.TriggerMode(obj, value)
            import instrument.internal.udm.oscilloscope.*
            TriggerModeEnum.validateTriggerModeValue(value);
            obj.Oscilloscope.Adaptor.TriggerMode =  TriggerModeEnum.getEnum(value);
            
        end
        
        
        function channelNames = get.ChannelNames(obj)
            channelNames = obj.Oscilloscope.Adaptor.ChannelNames;
        end
        
        function set.AcquisitionTime(obj, value)
            
            % input validation
            validateattributes(value,{'numeric'}, {'finite','positive'});
            obj.Oscilloscope.Adaptor.AcquisitionTime = value;
            realValue = obj.Oscilloscope.Adaptor.AcquisitionTime;
            instrument.internal.util.checkSetValue(value, realValue);
            
        end
        
        function value = get.AcquisitionTime(obj)
            
            value = obj.Oscilloscope.Adaptor.AcquisitionTime ;
        end
        
        function set.WaveformLength(obj, value)
            
            obj.checkScalarDoubleArg(value);
            obj.Oscilloscope.Adaptor.WaveformLength = value;
            realValue = obj.Oscilloscope.Adaptor.WaveformLength;
            instrument.internal.util.checkSetValue(value, realValue);
            
        end
        
        function value = get.WaveformLength(obj)
            
            value = obj.Oscilloscope.Adaptor.WaveformLength ;
            
        end
        
        function set.AcquisitionStartDelay(obj, value)
            
            obj.checkScalarDoubleArg(value);
            obj.Oscilloscope.Adaptor.AcquisitionStartDelay = value;
            realValue = obj.Oscilloscope.Adaptor.AcquisitionStartDelay;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.AcquisitionStartDelay(obj)
            
            value = obj.Oscilloscope.Adaptor.AcquisitionStartDelay ;
        end
        
        
        function set.TriggerSlope(obj, value)
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(value);
            TriggerSlopeEnum.validateTriggerSlopeValue(value);
            obj.Oscilloscope.Adaptor.TriggerSlope =  TriggerSlopeEnum.getEnum(value);
            
        end
        
        function value = get.TriggerSlope(obj)
            import instrument.internal.udm.oscilloscope.*
            enumValue = obj.Oscilloscope.Adaptor.TriggerSlope ;
            if enumValue == TriggerSlopeEnum.Falling
                value = 'falling';
            else
                value = 'rising';
            end
        end
        
        function set.TriggerLevel(obj, value)
            
            obj.checkScalarDoubleArg(value);
            obj.Oscilloscope.Adaptor.TriggerLevel =  value;
            realValue = obj.Oscilloscope.Adaptor.TriggerLevel;
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = get.TriggerLevel(obj)
            
            value = obj.Oscilloscope.Adaptor.TriggerLevel ;
        end
        
        function set.TriggerSource(obj, value)
            
            obj.checkScalarStringArg(value);
            % save the value
            level = obj.Oscilloscope.Adaptor.TriggerLevel;
            slope = obj.Oscilloscope.Adaptor.TriggerSlope;
            
            obj.Oscilloscope.Adaptor.TriggerSource =  value;
            % reset them back
            obj.Oscilloscope.Adaptor.TriggerLevel = level ;
            obj.Oscilloscope.Adaptor.TriggerSlope = slope;
            
        end
        
        function value = get.TriggerSource(obj)
            
            value = obj.Oscilloscope.Adaptor.TriggerSource ;
        end
        
        
        function setVerticalCoupling(obj, channnelName, value)
            %setVerticalCoupling sets the selected channel's vertical
            %coupling
            import instrument.internal.udm.oscilloscope.*;
            obj.checkScalarStringArg(channnelName);
            obj.validateChannelName(channnelName);
            obj.checkScalarStringArg(value);
            ChannelCouplingEnum.validateChannelCouplingValue(value);
            
            obj.Oscilloscope.Adaptor.setVerticalControl(channnelName, ...
                VerticalControlEnum.Coupling,...
                ChannelCouplingEnum.getEnum(value));
            
        end
        
        
        function value = getVerticalCoupling(obj, channnelName)
            %getVerticalCoupling returns the selected channel's vertical
            %coupling setting
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);
            enumValue =  obj.Oscilloscope.Adaptor.getVerticalControl(channnelName,  ...
                VerticalControlEnum.Coupling);
            
            if enumValue ==  ChannelCouplingEnum.DC
                value = 'DC';
            elseif enumValue == ChannelCouplingEnum.AC
                value = 'AC';
            elseif enumValue == ChannelCouplingEnum.GND
                value = 'GND';
            end
        end
        
        
        function setVerticalOffset(obj, channnelName, value)
            %setVerticalOffset sets the selected channel's vertical
            %offset
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);
            obj.validateChannelName(channnelName);
            % input validation
            validateattributes(value,{'numeric'}, {'finite'});
            
            obj.Oscilloscope.Adaptor.setVerticalControl(channnelName,...
                VerticalControlEnum.Offset,...
                value);
            realValue = obj.Oscilloscope.Adaptor.getVerticalControl(channnelName,...
                VerticalControlEnum.Offset);
            instrument.internal.util.checkSetValue(value, realValue);
            
        end
        
        function value = getVerticalOffset(obj, channnelName)
            %getVerticalOffset returns the selected channel's vertical
            %offset
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);
            value =  obj.Oscilloscope.Adaptor.getVerticalControl(channnelName,...
                VerticalControlEnum.Offset);
        end
        
        function setVerticalRange(obj, channnelName, value)
            %setVerticalRange sets the absolute value of the input range on the selected channel
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);            
            obj.validateChannelName(channnelName);
            % input validation
            validateattributes(value,{'numeric'}, {'finite','positive'});
            
            obj.Oscilloscope.Adaptor.setVerticalControl(channnelName,...
                VerticalControlEnum.Range,...
                value);
            realValue = obj.Oscilloscope.Adaptor.getVerticalControl(channnelName, ...
                VerticalControlEnum.Range);
            instrument.internal.util.checkSetValue(value, realValue);            
        end
        
        function value = getVerticalRange(obj, channnelName)
            %getVerticalRange returns the absolute value of the input range on the selected channel
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);
            value =  obj.Oscilloscope.Adaptor.getVerticalControl(channnelName, ...
                VerticalControlEnum.Range);
        end
        
        function setProbeAttenuation(obj, channnelName, value)
            %setProbeAttenuation sets the probe attentuation level on the selected channel
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);            
            obj.validateChannelName(channnelName);
            % input validation
            validateattributes(value,{'numeric'},{'finite'});
            
            obj.Oscilloscope.Adaptor.setVerticalControl(channnelName,...
                VerticalControlEnum.ProbeAttenuation,...
                value);
            realValue = obj.Oscilloscope.Adaptor.getVerticalControl(channnelName, ...
                VerticalControlEnum.ProbeAttenuation);
            instrument.internal.util.checkSetValue(value, realValue);
        end
        
        function value = getProbeAttenuation(obj, channnelName)
            %getProbeAttenuation returns probe attentuation level on the selected channel
            import instrument.internal.udm.oscilloscope.*
            obj.checkScalarStringArg(channnelName);
            value =  obj.Oscilloscope.Adaptor.getVerticalControl(channnelName, ...
                VerticalControlEnum.ProbeAttenuation);
        end
        
        
        function enableChannel (obj, varargin)
            %EnableChannel methods enables oscilloscope's channel(s).
            %It can take single channel name as string or a cell array of
            %channel names.
            if iscellstr(varargin{1})
                for idx = 1: size (varargin{1}, 2)
                    channelName = char (varargin{1}{idx});
                    obj.Oscilloscope.Adaptor.enableChannel(channelName, true);
                    
                end
            elseif ischar(varargin{1})
                channelName = char (varargin{1});
                obj.Oscilloscope.Adaptor.enableChannel(channelName, true);
                
            else
                channelName = cell2mat(varargin{1});
                error (message('instrument:qcinstrument:notValidChannelName', channelName, obj.Oscilloscope.getChannelNames));
            end
            
        end
        
        
        function disableChannel (obj, varargin)
            %DisableChannel methods disables oscilloscope's channel(s).
            %It can take single channel name as string or a cell array of
            %channel names.
            
            if iscellstr(varargin{1})
                for idx = 1: size (varargin{1}, 2)
                    channelName = char (varargin{1}{idx});
                    obj.Oscilloscope.Adaptor.enableChannel(channelName, false);
                    
                end
            elseif ischar(varargin{1})
                channelName = char (varargin{1});
                obj.Oscilloscope.Adaptor.enableChannel(channelName, false);
                
            else
                channelName = cell2mat(varargin{1});
                error (message('instrument:qcinstrument:notValidChannelName', channelName, obj.Oscilloscope.getChannelNames));
            end
            
        end
        
        
        function varargout = getWaveform(obj , varargin)
            %GetWaveform method retrieves the waveform(s) from
            %enabled channel(s).
            %By default, it initiates acquisition returns waveform(s) from
            %oscilloscope.
            %To get waveform from only one enabled channel
            %w = getWaveform (o);
            %To get waveforms from two enabled channels
            %[w1, w2] = getWaveform (o);
            %To download captured waveform from oscilloscope without
            %acquisition
            %w = getWaveform (o, 'acquisition', false);
            
            if isempty (obj.ChannelsEnabled)
                error(message('instrument:oscilloscope:noChannelEnabled'));
            end
            
            if (nargout > size (obj.ChannelsEnabled, 2))
                error(message('instrument:oscilloscope:moreWaveformOutputThanChannelsEnabled'));
            end
            
            switch (nargin)
                
                case 1
                    %Default behavior of getWaveform method.
                    %fetch waveform(s) from enabled channels.
                    for i=1:nargout
                        channnelName = obj.ChannelsEnabled{i};
                        varargout{i} =  obj.Oscilloscope.Adaptor.fetchWaveform(channnelName ); %#ok<*AGROW>
                    end
                    
                case 3
                    %getWaveform method with options.
                    propertyName = char(varargin{1});
                    if ~strcmpi (propertyName, 'acquisition')
                        error (message('instrument:oscilloscope:noValidGetWaveformArgs'));
                    end
                    acquisition = varargin{2};
                    validateattributes(acquisition, {'logical'} ,  {'scalar'} );
                    % initiates acquisition returns waveform(s) from enabled channels.
                    if acquisition
                        channnelName = obj.ChannelsEnabled{1};
                        %read waveform from the first channel
                        varargout{1} =  obj.Oscilloscope.Adaptor.readWaveform(channnelName , obj.Oscilloscope.Timeout);
                        %fetch waveform from rest of channels
                        for i=2:nargout
                            channnelName = obj.ChannelsEnabled{i};
                            varargout{i} =  obj.Oscilloscope.Adaptor.fetchWaveform(channnelName );
                        end
                    else
                        %download captured waveform from oscilloscope without acquisition
                        for i=1:nargout
                            channnelName = obj.ChannelsEnabled{i};
                            varargout{i} =  obj.Oscilloscope.Adaptor.fetchWaveform(channnelName );
                        end
                    end
                otherwise
                    error (message('instrument:oscilloscope:noValidGetWaveformArgs' ));
                    
            end
        end
        
    end
    
    methods(Access = private)
          % helper function to validate channel name
        function validateChannelName(obj, channelName)
            instrument.internal.util.validateChannelName(obj.ChannelNames, channelName);
        end        
    end
end
% LocalWords:  GND
