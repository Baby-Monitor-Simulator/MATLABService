classdef attrGlitchPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRGLITCHPOLARITYRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on a positive glitch.
        IVISCOPE_VAL_GLITCH_POSITIVE = 1;
        % The oscilloscope triggers on a negative glitch.
        IVISCOPE_VAL_GLITCH_NEGATIVE = 2;
        % The oscilloscope triggers on either a positive or negative glitch.
        IVISCOPE_VAL_GLITCH_EITHER = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT.*
            found = ...
                ( e == attrGlitchPolarityRangeTable.IVISCOPE_VAL_GLITCH_POSITIVE) || ...
                ( e == attrGlitchPolarityRangeTable.IVISCOPE_VAL_GLITCH_NEGATIVE) || ...
                ( e == attrGlitchPolarityRangeTable.IVISCOPE_VAL_GLITCH_EITHER);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
