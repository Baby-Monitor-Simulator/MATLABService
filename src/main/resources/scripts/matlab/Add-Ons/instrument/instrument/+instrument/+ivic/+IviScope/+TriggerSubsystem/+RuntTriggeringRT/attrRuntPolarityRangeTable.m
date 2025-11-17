classdef attrRuntPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRRUNTPOLARITYRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.RuntTriggeringRT class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on a positive runt.  A positive runt occurs when  a rising edge crosses the low runt threshold and does not cross the high  runt threshold before re-crossing the low runt threshold.
        IVISCOPE_VAL_RUNT_POSITIVE = 1;
        % The oscilloscope triggers on a negative runt.  A negative runt occurs when  a falling edge crosses the high runt threshold and does not cross the low  runt threshold before re-crossing the high runt threshold.
        IVISCOPE_VAL_RUNT_NEGATIVE = 2;
        % The oscilloscope triggers on either a positive or negative runt.
        IVISCOPE_VAL_RUNT_EITHER = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.RuntTriggeringRT.*
            found = ...
                ( e == attrRuntPolarityRangeTable.IVISCOPE_VAL_RUNT_POSITIVE) || ...
                ( e == attrRuntPolarityRangeTable.IVISCOPE_VAL_RUNT_NEGATIVE) || ...
                ( e == attrRuntPolarityRangeTable.IVISCOPE_VAL_RUNT_EITHER);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
