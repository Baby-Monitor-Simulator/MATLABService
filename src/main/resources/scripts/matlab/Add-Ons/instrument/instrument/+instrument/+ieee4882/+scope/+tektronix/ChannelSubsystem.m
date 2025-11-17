classdef ChannelSubsystem < instrument.ieee4882.scope.ChannelSubsystem & instrument.ieee4882.scope.tektronix.Tekbase
    %CHANNELSUBSYSTEM Class provides an implementation for Tektronix Oscilloscope for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2011-2019 The MathWorks, Inc.
    
    %% read only Public Properties
    properties (SetAccess = private )
        %Available channel names
        ChannelNames;
        
        % Enabled channels
        EnabledChannels
    end
    
    properties (Hidden, Access = 'private' )
        %this is used to distinguish tek scope firmware version, it may be
        %extended to second tek scope class if more firmware differences
        %are discovered
        FirmWareVersion ;
    end
    
    %% Property access methods
    methods
        
        % Constructor
        function obj = ChannelSubsystem(interface, firmWareVersion)
            obj.Interface = interface;
            obj.FirmWareVersion = firmWareVersion;
        end
        
        
        function enableChannel(obj, channelName , enable)
            obj.validateChannelName( channelName);
            if enable
                cmd = sprintf ('SELect:%s ON', channelName);
            else
                cmd = sprintf ('SELect:%s OFF', channelName);
            end
            obj.sendCmdToInstrument(cmd);
        end
        
        
        
        function enabledChannels = get.EnabledChannels (obj)
            enabledChannels = {};
            for i =1 : length (obj.ChannelNames)
                
                cmd = sprintf ('SELect:%s?', obj.ChannelNames{i});
                value = obj.queryInstrument(cmd);
                value =  str2double(value);
                if value ==1
                    enabledChannels{end+1 }= obj.ChannelNames{i};
                end
                
            end
        end
        
        function channelNames = get.ChannelNames(obj)
            % return available channel names
            
            % if this is done already
            if ~isempty (obj.ChannelNames )
                channelNames =  obj.ChannelNames;
                return;
            end
            
            % need to turn on header to get more info
            fprintf (obj.Interface, 'HEADER ON');
            fprintf (obj.Interface, 'SELect?');
            
            ret = fscanf (obj.Interface);
            fprintf (obj.Interface, 'HEADER OFF');
            
            
            % remove selection
            str = strrep ( ret, ':SELECT:', '');
            channelsInfo= {};
            
            while true
                [str, remain] = strtok(str, ';');
                if isempty(str)
                    break;
                end
                
                str = strtrim (str);
                % only take channel name starts with REF, CH and MATH
                if length (str) >=3 && strcmpi ( str(1:3), 'REF' )
                    channelsInfo{end +1} = str; %#ok<*AGROW>
                end
                if length (str) >=2 && strcmpi ( str(1:2), 'CH' )
                    channelsInfo{end +1} = str;
                end
                if length (str) >=4 && strcmpi ( str(1:4), 'MATH' )
                    channelsInfo{end +1} = str;
                end
                
                str = remain ;
                
            end
            
            channelNames ={};
            for idx = 1:  size (channelsInfo, 2)
                [chanenlName, ~] = strtok(channelsInfo{idx}, ' ');
                channelNames{end+1}  =  chanenlName ;
            end
            
            obj.ChannelNames = channelNames;
            
        end
        
        
        %% VerticalRange specifies the absolute value of the input range the oscilloscope can
        %acquire for the channel.  The units are volts.
        function value = getVerticalRange(obj, channelName)
            obj.validateChannelName(  channelName);
            cmd = sprintf ('%s:SCAle?', channelName);
            value = obj.queryInstrument(cmd);
            value = str2double( value);
        end
        
        function setVerticalRange(obj,channelName, newValue)
            obj.validateChannelName(  channelName);
            cmd = sprintf ('%s:SCAle %f', channelName, newValue);
            obj.sendCmdToInstrument(cmd);
        end
        
        %% VerticalOffset This channel-based attribute specifies the
        %location of the center of the range. Express the
        %value in volts and with respect to ground.
        function value = getVerticalOffset(obj, channelName)
            if (obj.FirmWareVersion ==1 )
                error(message ( 'instrument:ieee4882Driver:notSupported') );
            else
                cmd = sprintf ('%s:OFFSET?', channelName);
                value = obj.queryInstrument(cmd);
                value =   str2double( value);
            end
            
        end
        
        
        function setVerticalOffset(obj,channelName , newValue)
            if (obj.FirmWareVersion ==1 )
                error(message ( 'instrument:ieee4882Driver:notSupported') );
            else
                cmd = sprintf ('%s:OFFSET %f', channelName, newValue);
                obj.sendCmdToInstrument(cmd);
            end
            
        end
        
        %% VerticalCoupling This channel-based attribute specifies
        %how the oscilloscope couples the input signal for the
        %channel.
        function value = getVerticalCoupling(obj, channelName)
            obj.validateChannelName( channelName);
            cmd = sprintf ('%s:COUP?',channelName);
            value =   obj.queryInstrument(cmd);
            value =  strtrim (value);
        end
        
        
        function setVerticalCoupling(obj,channelName , newValue)
            obj.validateChannelName( channelName);
            cmd = sprintf ('%s:COUPling %s', channelName, newValue);
            obj.sendCmdToInstrument(cmd);
        end
        
        %% ProbeAttenuation This channel-based attribute specifies
        %the oscilloscope Probe Attenuation for the
        %channel.
        function value = getProbeAttenuation(obj, channelName)
            obj.validateChannelName(channelName);
            cmd = sprintf ('%s:PRO?',channelName);
            value = obj.queryInstrument(cmd);
            value = str2double(value);
        end
        
        
        function setProbeAttenuation(obj,channelName , newValue)
            obj.validateChannelName(channelName);
            cmd = sprintf ('%s:PRObe %f', channelName, newValue);
            obj.sendCmdToInstrument(cmd);
        end
        
        
    end
    
    methods (Hidden )
        function validateChannelName (obj, channelName)
            
            if ~ismember(channelName, obj.ChannelNames  )
                
                %get available channel names
                channelNames = '';
                for idx = 1: length (obj.ChannelNames)
                    channelNames = sprintf('%s, %s', channelNames, obj.ChannelNames{idx} );
                end
                %remove the space and comma
                channelNames = channelNames(3:end);
                error( message('instrument:ieee4882Driver:invalidChannelName', channelNames));
            end
        end
    end
    
    methods (Access = 'protected')
        
        function value = getVerticalOffsetHook (~, ~)
            value = 'Not supported';        
        end
        
        function value = setVerticalOffsetHook (~, ~ , ~)
            value = 'Not supported'; %#ok<NASGU>
            error( 'instrument:ieee4882:notSupported', 'Not supported');
        end
    end
end
