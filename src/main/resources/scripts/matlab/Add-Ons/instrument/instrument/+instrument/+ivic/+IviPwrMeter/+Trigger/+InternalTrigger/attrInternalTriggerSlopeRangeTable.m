classdef attrInternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRINTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviPwrMeter.Trigger.InternalTrigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the trigger event to occur on the rising edge of the trigger pulse.
        IVIPWRMETER_VAL_POSITIVE = 1;
        % Sets the trigger event to occur on the falling edge of the trigger  pulse.
        IVIPWRMETER_VAL_NEGATIVE = 0;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviPwrMeter.Trigger.InternalTrigger.*
            found = ...
                ( e == attrInternalTriggerSlopeRangeTable.IVIPWRMETER_VAL_POSITIVE) || ...
                ( e == attrInternalTriggerSlopeRangeTable.IVIPWRMETER_VAL_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
