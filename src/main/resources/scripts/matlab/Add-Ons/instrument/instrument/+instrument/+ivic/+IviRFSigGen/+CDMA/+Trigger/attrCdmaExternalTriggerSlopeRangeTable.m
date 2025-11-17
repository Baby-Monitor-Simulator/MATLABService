classdef attrCdmaExternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRCDMAEXTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviRFSigGen.CDMA.Trigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Enables rising edge triggering.
        IVIRFSIGGEN_VAL_CDMA_EXTERNAL_TRIGGER_SLOPE_POSITIVE = 1;
        % Enables falling edge triggering.
        IVIRFSIGGEN_VAL_CDMA_EXTERNAL_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.CDMA.Trigger.*
            found = ...
                ( e == attrCdmaExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_CDMA_EXTERNAL_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrCdmaExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_CDMA_EXTERNAL_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
