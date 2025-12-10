classdef attrTdmaExternalTriggerSlopeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTDMAEXTERNALTRIGGERSLOPERANGETABLE for instrument.ivic.IviRFSigGen.TDMA.Trigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Enables rising edge triggering.
        IVIRFSIGGEN_VAL_TDMA_EXTERNAL_TRIGGER_SLOPE_POSITIVE = 1;
        % Enables falling edge triggering.
        IVIRFSIGGEN_VAL_TDMA_EXTERNAL_TRIGGER_SLOPE_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.TDMA.Trigger.*
            found = ...
                ( e == attrTdmaExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_TDMA_EXTERNAL_TRIGGER_SLOPE_POSITIVE) || ...
                ( e == attrTdmaExternalTriggerSlopeRangeTable.IVIRFSIGGEN_VAL_TDMA_EXTERNAL_TRIGGER_SLOPE_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
