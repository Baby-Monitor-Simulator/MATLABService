classdef TriggerSubsystem < instrument.ieee4882.fgen.TriggerSubsystem & instrument.ieee4882.fgen.Agilent332x0_SCPI.Agilentbase
    %UTILITY Class provides an implementation for Agilent fgen for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2012 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = TriggerSubsystem(interface)
            obj.Interface = interface;
        end
    end
    
    %% Public Read Only Properties
    methods
        function value = getBurstCount(obj)
            value = str2double(obj.queryInstrument('BURSt:NCYCles?'));
        end
        
        function setBurstCount(obj, newValue)
            obj.sendCmdToInstrument(['BURSt:NCYCles ' num2str(newValue)]);
        end
        
        function value = getTriggerRate(obj)
            value = str2double(obj.queryInstrument('BURSt:INTernal:PERiod?'));
        end
        
        function setTriggerRate(obj, newValue)
            obj.sendCmdToInstrument(['BURSt:INTernal:PERiod ' num2str(newValue)]);
        end
        
        function value = getTriggerSource(obj)
            value = obj.queryInstrument('TRIGger:SOURce?');
            if strncmpi(value,'imm',3)
                value = 3;
            elseif strncmpi(value,'ext',3)
                value = 1;
            elseif strncmpi(value,'bus',3)
                value = 2;
            else
                error(message('instrument:fgen:unknownTriggerSource'));
            end
        end
        
        function setTriggerSource(obj, newValue)
            if strcmpi(char(newValue),'internal')
                newValue = 'IMMEDIATE';
            elseif strcmpi(char(newValue),'external')
                newValue = 'EXTERNAL';
            elseif strcmpi(char(newValue),'software')
                newValue = 'BUS';
            else
                % Agilent 332x0 class instruments only support internal,
                % external and software triggers. Let the SCPI adaptor
                % error out if user tries to set a different trigger mode.
                error(message('instrument:fgen:notValidAgilent332x0TriggerSource',char(newValue)));
            end
            obj.sendCmdToInstrument(['TRIGger:SOURce ' newValue]);
        end
        
    end
end
