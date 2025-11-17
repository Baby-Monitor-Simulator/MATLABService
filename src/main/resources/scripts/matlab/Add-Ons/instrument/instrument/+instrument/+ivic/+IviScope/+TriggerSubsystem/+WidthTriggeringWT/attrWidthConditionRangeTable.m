classdef attrWidthConditionRangeTable < instrument.internal.DriverBaseClass
    %ATTRWIDTHCONDITIONRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on pulses that have a width that is less than  the high threshold and greater than the low threshold.
        IVISCOPE_VAL_WIDTH_WITHIN = 1;
        % The oscilloscope triggers on pulses that have a width that is either  greater than the high width threshold or less than a low width threshold.
        IVISCOPE_VAL_WIDTH_OUTSIDE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT.*
            found = ...
                ( e == attrWidthConditionRangeTable.IVISCOPE_VAL_WIDTH_WITHIN) || ...
                ( e == attrWidthConditionRangeTable.IVISCOPE_VAL_WIDTH_OUTSIDE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
