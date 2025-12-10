classdef attrExternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTREXTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviSpecAn.Trigger.ExternalTrigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Sets positive slope.
        IVISPECAN_VAL_EXTERNAL_TRIGGER_SLOPE_POSITIVE = 1;
        % Sets negative slope.
        IVISPECAN_VAL_EXTERNAL_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.Trigger.ExternalTrigger.*
            found = ...
                ( e == attrExternalTriggerSlopeRangeTable.IVISPECAN_VAL_EXTERNAL_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrExternalTriggerSlopeRangeTable.IVISPECAN_VAL_EXTERNAL_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
