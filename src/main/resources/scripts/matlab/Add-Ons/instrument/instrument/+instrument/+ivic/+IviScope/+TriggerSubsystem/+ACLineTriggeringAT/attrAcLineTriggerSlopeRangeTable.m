classdef attrAcLineTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRACLINETRIGGERSLOPERANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.ACLineTriggeringAT class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on positive slope zero crossings of the network supply voltage.
        IVISCOPE_VAL_AC_LINE_POSITIVE = 1;
        % The oscilloscope triggers on negative slope zero crossings of the network supply voltage.
        IVISCOPE_VAL_AC_LINE_NEGATIVE = 2;
        % The oscilloscope triggers on either positive or negative slope zero crossings of the network supply voltage.
        IVISCOPE_VAL_AC_LINE_EITHER = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.ACLineTriggeringAT.*
            found = ...
                ( e == attrAcLineTriggerSlopeRangeTable.IVISCOPE_VAL_AC_LINE_POSITIVE) || ...
                ( e == attrAcLineTriggerSlopeRangeTable.IVISCOPE_VAL_AC_LINE_NEGATIVE) || ...
                ( e == attrAcLineTriggerSlopeRangeTable.IVISCOPE_VAL_AC_LINE_EITHER);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
