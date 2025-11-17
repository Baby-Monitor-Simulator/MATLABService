classdef attrTvTriggerPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRTVTRIGGERPOLARITYRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Positive video sync pulse
        IVISCOPE_VAL_TV_POSITIVE = 1;
        % Negative video sync pulse
        IVISCOPE_VAL_TV_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*
            found = ...
                ( e == attrTvTriggerPolarityRangeTable.IVISCOPE_VAL_TV_POSITIVE) || ...
                ( e == attrTvTriggerPolarityRangeTable.IVISCOPE_VAL_TV_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
