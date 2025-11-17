classdef (Enumeration) TriggerSlopeEnum < handle
    %TriggerSlopeEnum Represents possible trigger slope setting for oscilloscope
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        Rising
        Falling
        
    end
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.oscilloscope.*
            if strcmpi (value, 'rising')
                enumValue = TriggerSlopeEnum.Rising;
            else
                enumValue = TriggerSlopeEnum.Falling;
            end
        end
        
        function validateTriggerSlopeValue(value)
            if ~strcmpi(value,'rising') && ~strcmpi(value,'falling')
                error(message('instrument:oscilloscope:notValidTriggerSlope', value));
            end
        end
        
    end
end

