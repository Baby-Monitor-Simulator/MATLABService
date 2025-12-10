classdef attrGlitchConditionRangeTable < instrument.internal.DriverBaseClass
    %ATTRGLITCHCONDITIONRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on a less-than glitch.
        IVISCOPE_VAL_GLITCH_LESS_THAN = 1;
        % The oscilloscope triggers on a greater-than glitch.
        IVISCOPE_VAL_GLITCH_GREATER_THAN = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT.*
            found = ...
                ( e == attrGlitchConditionRangeTable.IVISCOPE_VAL_GLITCH_LESS_THAN) || ...
                ( e == attrGlitchConditionRangeTable.IVISCOPE_VAL_GLITCH_GREATER_THAN);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
