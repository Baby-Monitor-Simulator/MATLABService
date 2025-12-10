classdef attrVideoTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRVIDEOTRIGGERSLOPERANGETABLE for instrument.ivic.IviSpecAn.Trigger.VideoTrigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Sets positive slope.
        IVISPECAN_VAL_VIDEO_TRIGGER_SLOPE_POSITIVE = 1;
        % Sets negative slope.
        IVISPECAN_VAL_VIDEO_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.Trigger.VideoTrigger.*
            found = ...
                ( e == attrVideoTriggerSlopeRangeTable.IVISPECAN_VAL_VIDEO_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrVideoTriggerSlopeRangeTable.IVISPECAN_VAL_VIDEO_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
