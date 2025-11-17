classdef ChannelSubsystem < instrument.ieee4882.fgen.ChannelSubsystem & instrument.ieee4882.fgen.Agilent332x0_SCPI.Agilentbase
    %UTILITY Class provides an implementation for Agilent fgen for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2012-2016 The MathWorks, Inc.
    
    %% read only Public Properties
    properties (SetAccess = private )
        %Available channel names
        ChannelNames;
        % Selected Channel
        SelectedChannel;
    end
    
    %% Construction/Clean up
    methods (Hidden = true)
        function obj = ChannelSubsystem(interface)
            % The Agilent 332x0's are one channel instruments, so hard code
            % the constructor to list available channel names accordingly
            % and select the channel at connection
            obj.Interface = interface;
            obj.ChannelNames = {'1'};
            obj.SelectedChannel = '1';
        end
    end
    
    methods
        function selectChannel(obj, channelName)
            % Set the SelectedChannel property
            obj.SelectedChannel = channelName;
        end
        
        function value = getOutputImpedance(obj)
            % Get the output impedance
            value = str2double(obj.queryInstrument('OUTPUT:LOAD?'));
        end
        
        function setOutputImpedance(obj, newValue)
            % Set the output impedance
            if newValue == 0
                newValue = 'INFinity';
            elseif newValue == 1
                newValue = 'MINimum';
            elseif newValue > 1 && newValue < 10000
                newValue = num2str(newValue);
            elseif newValue == 10000
                newValue = 'MAXimum';
            else
                newValue = '50';
            end
            obj.sendCmdToInstrument(['OUTPUT:LOAD ' newValue]);
        end
        
        function value = getAmplitude(obj)
            % Get the output voltage
            value = str2double(obj.queryInstrument('VOLTAGE?'));
        end
        
        function setAmplitude(obj, newValue)
            % Set the output voltage
            obj.sendCmdToInstrument(['VOLTAGE ' num2str(newValue)]);
        end
        
        function enableOutput(obj)
            % Enable the output
            obj.sendCmdToInstrument('OUTPUT ON');
        end
        
        function disableOutput(obj)
            % Disable the output
            obj.sendCmdToInstrument('OUTPUT OFF');
        end
        
    end
end
