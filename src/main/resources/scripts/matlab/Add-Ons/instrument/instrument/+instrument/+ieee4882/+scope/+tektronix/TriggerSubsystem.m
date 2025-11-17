classdef TriggerSubsystem < instrument.ieee4882.scope.TriggerSubsystem & instrument.ieee4882.scope.tektronix.Tekbase
    %TRIGGERSUBSYSTEM Class provides an implementation for Tektronix Oscilloscope for
    %the abstract methods defined in its abstract parent class.
    
    % Copyright 2011-2012 The MathWorks, Inc.
    
    %% Construction
    methods (Hidden=true)
        function obj = TriggerSubsystem(interface)
            obj.Interface = interface;
        end
    end
    
    %% Public Properties
    properties
        
        TriggerSource
        
        %TRIGGERLEVEL Specifies the voltage threshold for the
        %trigger subsystem.  The units are volts.
        TriggerLevel
        
        %TRIGGERSLOPE Specifies whether a rising or a falling edge
        %triggers the oscilloscope.
        TriggerSlope
        
        %TRIGGERMode Specifies the trigger modifier.  The
        %trigger modifier determines the oscilloscope's behavior in
        %the absence of the trigger you configure.
        TriggerMode
    end
    
    
    
    %% Property access methods
    methods
        
        
        %% TriggerSource property access methods
        function value = get.TriggerSource(obj)
            value = obj.queryInstrument ( 'Trigger:Main:Edge:Source?')  ;
            value =    strtrim (value);
        end
        function set.TriggerSource(obj,newValue)
            cmd = sprintf ('Trigger:Main:Edge:Source %s' , newValue);
            obj.sendCmdToInstrument(cmd);
        end
        
        
        %% TriggerLevel property access methods
        function value = get.TriggerLevel(obj)
            value = obj.queryInstrument('TRIGGer:MAIN:LEVel?');
            value = str2double(value);
        end
        
        function set.TriggerLevel(obj,value)
            
            source = obj.TriggerSource;
            
            %get the scale
            scale = obj.queryInstrument([source,':SCAle?']);
            scale = str2double(scale);
            
            %when source is zeroed, Trigger Level can go to plus or minus 8 times the scale or the source
            range = 16*scale;
            
            %get the source's position
            position = obj.queryInstrument([source,':POSition?']);
            position = str2double(position);
            
            %position is in divs, we need it in volts, scale is volts/div
            position = position*scale;
            
            minimum = -1*range/2 - position;
            maximum = range/2 - position;
            
            if value > maximum || value < minimum
                error(message('instrument:ieee4882Driver:invalidLevelValue',num2str(minimum),num2str(maximum)));
            end%if propertyValue > maximum || propertyValue < minimum
            
            %set the value
            obj.sendCmdToInstrument(['TRIGGer:MAIN:LEVel ',num2str(value)]);
        end
        
        %% Trigger_Slope property access methods
        function value = get.TriggerSlope(obj)
            value = obj.queryInstrument('Trigger:Main:Edge:Slope?')  ;
            
        end
        function set.TriggerSlope(obj,newValue)
            cmd = sprintf('Trigger:Main:Edge:Slope %s', newValue)  ;
            obj.sendCmdToInstrument(cmd);
        end
        
        %% Trigger_Modifier_TM property access methods
        function value = get.TriggerMode(obj)
            value = obj.queryInstrument('Trigger:Main:Mode?');
            
        end
        function set.TriggerMode(obj,newValue)
            cmd =  sprintf('Trigger:Main:Mode %s', newValue);
            obj.sendCmdToInstrument(cmd);
        end
        
    end
end
