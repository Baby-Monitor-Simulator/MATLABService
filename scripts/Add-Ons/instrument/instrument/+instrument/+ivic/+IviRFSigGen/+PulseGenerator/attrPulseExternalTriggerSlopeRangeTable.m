classdef attrPulseExternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRPULSEEXTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviRFSigGen.PulseGenerator class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Enables rising edge triggering.
        IVIRFSIGGEN_VAL_PULSE_EXTERNAL_TRIGGER_SLOPE_POSITIVE = 1;
        % Enables falling edge triggering.
        IVIRFSIGGEN_VAL_PULSE_EXTERNAL_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseGenerator.*
            found = ...
                ( e == attrPulseExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_PULSE_EXTERNAL_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrPulseExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_PULSE_EXTERNAL_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
