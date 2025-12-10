classdef attrArbExternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRARBEXTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviRFSigGen.ARBGenerator.Trigger class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Enables rising edge triggering.
        IVIRFSIGGEN_VAL_ARB_EXTERNAL_TRIGGER_SLOPE_POSITIVE = 1;
        % Enables falling edge triggering.
        IVIRFSIGGEN_VAL_ARB_EXTERNAL_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.ARBGenerator.Trigger.*
            found = ...
                ( e == attrArbExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_ARB_EXTERNAL_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrArbExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_ARB_EXTERNAL_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
