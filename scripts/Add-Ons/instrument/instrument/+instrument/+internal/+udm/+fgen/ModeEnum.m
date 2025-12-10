classdef ModeEnum < uint32
    %ModeEnum represents possible run mode setting for function
    %generator.
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        AM (1)
        FM (2)
        Burst(3)
        Continuous (4)
        NotSupported (5)
  
    end

 
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.fgen.*
            if strcmpi (value, 'AM')
                enumValue = ModeEnum.AM;
            elseif strcmpi (value, 'FM')
                enumValue = ModeEnum.FM;
            elseif strcmpi (value, 'Burst')
                enumValue = ModeEnum.Burst;
            elseif strcmpi (value, 'Continuous')
                enumValue = ModeEnum.Continuous;
            else
                 error(message('instrument:fgen:notValidMode',value ));
            end
        end
        
        function stringValue = getString (value)
            import instrument.internal.udm.fgen.*
            if  value == ModeEnum.AM
                stringValue = 'AM';
            elseif value ==ModeEnum.Burst
                stringValue = 'Burst';
            elseif value ==ModeEnum.FM
                stringValue = 'FM';
            elseif value ==ModeEnum.Continuous
                stringValue = 'Continuous';
            elseif value ==ModeEnum.NotSupported
                stringValue = 'NotSupported';
            else
                error(message('instrument:fgen:unknownMode' ));
            end
        end

    end
end

