classdef (Hidden)StateNotConnected <   instrument.internal.udm.oscilloscope.StateOscilloscope
    %StateNotConnected is the state before connection to instrument is established.
    %   StateNotConnected provides state specific behaviors for all
    %   operations when the instrument is not connected.
    
    %    Copyright 2011-2019 The MathWorks, Inc.
    
    properties
        %redefine the abstract propeties in StateOscilloscope class
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
        %Constructor
        function obj =  StateNotConnected(scope)
            obj@instrument.internal.udm.oscilloscope.StateOscilloscope(scope);
        end
        
        function autoSetup(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.ChannelsEnabled(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value =get.SingleSweepMode(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.SingleSweepMode(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
         
        function delete(obj)
            if isvalid (obj) && ~isempty (obj.Adaptor)
                obj.Adaptor =[];
            end
        end
        
        
        function reset(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function connect(obj )
            %Connect method iterates through adapter list and use chain of
            %responsibility design pattern to create proper scope adapter
            %and connect to the instrument.
            
            if isempty (obj.Oscilloscope.Resource)
                error (message('instrument:oscilloscope:noResource')) ;
            end
            
            import instrument.internal.udm.*
            % use Resource info to build scope adaptor
            if strcmpi (obj.Oscilloscope.DriverDetectionMode, 'auto')
                
                [obj.Oscilloscope.Adaptor  , driver]   = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.Scope,obj.Oscilloscope.Resource );
                
                obj.Oscilloscope.UpdateDriverDetectionMode = false;
                obj.Oscilloscope.Driver = driver;
                obj.Oscilloscope.UpdateDriverDetectionMode = true;
                
                if isempty(obj.Oscilloscope.Adaptor)
                    error (message('instrument:oscilloscope:failToConnectToScopeByResource')) ;
                end
                
            else %  use Resource and driver info to build scope adaptor
                if isempty (obj.Oscilloscope.Driver )
                    error(message('instrument:oscilloscope:NeedDriverName'));
                end
               
                obj.Oscilloscope.Adaptor = instrument.internal.udm.InstrumentAdaptorFactory.createAdaptor(InstrumentType.Scope, obj.Oscilloscope.Resource ,obj.Oscilloscope.Driver );
                
                if isempty(obj.Oscilloscope.Adaptor)
                    error (message('instrument:oscilloscope:failToConnectToScopeByResourceAndDriver')) ;
                end
            end
            
            
            obj.Oscilloscope.updateConnectionStatus('open');
            %switch to StateConnected object.
            obj.Oscilloscope.changeState('StateConnected');
            
        end
        
        
        function disconnect(obj) %#ok<*MANU>
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function value = get.TriggerMode(obj) %#ok<*STOUT>
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function  set.TriggerMode(obj, value)   %#ok<*INUSD>
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function channelNames = get.ChannelNames(obj)   %#ok<*STOUT,*MANU>
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function set.AcquisitionTime(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.AcquisitionTime(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.WaveformLength(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.WaveformLength(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.AcquisitionStartDelay(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.AcquisitionStartDelay(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.TriggerSlope(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.TriggerSlope(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.TriggerLevel(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = get.TriggerLevel(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function set.TriggerSource(obj, value)
            error (message('instrument:oscilloscope:notConnected'));
            
        end
        
        function value = get.TriggerSource(obj)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function setVerticalCoupling(obj, channnelName, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = getVerticalCoupling(obj, channnelName)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function setVerticalOffset(obj, channnelName, value)
            error (message('instrument:oscilloscope:notConnected'));
            
        end
        
        function value = getVerticalOffset(obj, channnelName)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function setVerticalRange(obj, channnelName, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = getVerticalRange(obj, channnelName)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function setProbeAttenuation(obj, channnelName, value)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function value = getProbeAttenuation(obj, channnelName)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        function enableChannel (obj, varargin)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function disableChannel (obj, varargin)
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function varargout = getWaveform(obj , varargin )
            error (message('instrument:oscilloscope:notConnected'));
        end
        
        
        function disp(obj)
            
            textToDisp = 'oscilloscope: No connection has been setup with instrument, type help oscilloscope for more information' ;
            disp(textToDisp);
        end
        
    end
end