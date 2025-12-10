classdef attrTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSLOPERANGETABLE for instrument.ivic.IviDmm.Trigger class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Positive slope
        IVIDMM_VAL_POSITIVE = 0;
        % Negative slope
        IVIDMM_VAL_NEGATIVE = 1;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.Trigger.*
            found = ...
                ( e == attrTriggerSlopeRangeTable.IVIDMM_VAL_POSITIVE) || ...
                ( e == attrTriggerSlopeRangeTable.IVIDMM_VAL_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
