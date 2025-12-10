classdef (Enumeration) TriggerModeEnum < handle
    %TriggerModeEnum Represents possible trigger mode setting for oscilloscope
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        Auto
        Normal
    end
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.oscilloscope.*
            if strcmpi (value, 'auto')
                enumValue = TriggerModeEnum.Auto;
            else
                enumValue = TriggerModeEnum.Normal;
            end
        end
        
        function validateTriggerModeValue(value)
            if  ~strcmpi (value, 'auto') && ~strcmpi (value, 'normal')
                error(message('instrument:oscilloscope:notValidTriggerMode',value ));
            end
        end
        
    end
end

