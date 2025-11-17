classdef attrTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSLOPERANGETABLE for instrument.ivic.IviScope.TriggerSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % A positive rising edge passing through the trigger level triggers  the oscilloscope.
        IVISCOPE_VAL_POSITIVE = 1;
        % A negative falling edge passing through the trigger level triggers  the oscilloscope.
        IVISCOPE_VAL_NEGATIVE = 0;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.*
            found = ...
                ( e == attrTriggerSlopeRangeTable.IVISCOPE_VAL_POSITIVE) || ...
                ( e == attrTriggerSlopeRangeTable.IVISCOPE_VAL_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
