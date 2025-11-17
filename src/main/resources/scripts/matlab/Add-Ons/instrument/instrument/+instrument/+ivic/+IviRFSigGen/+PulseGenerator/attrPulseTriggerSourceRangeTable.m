classdef attrPulseTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRPULSETRIGGERSOURCERANGETABLE for instrument.ivic.IviRFSigGen.PulseGenerator class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % No external trigger is used. The pulse period is specified by the  IVIRFSIGGEN_ATTR_PULSE_INTERNAL_TRIGGER_PERIOD [PG]  attribute.
        IVIRFSIGGEN_VAL_PULSE_TRIGGER_SOURCE_INTERNAL = 1;
        % The pulse is started with a trigger after the delay time specified by the  IVIRFSIGGEN_ATTR_PULSE_EXTERNAL_TRIGGER_DELAY [PG]  attribute.
        IVIRFSIGGEN_VAL_PULSE_TRIGGER_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseGenerator.*
            found = ...
                ( e == attrPulseTriggerSourceRangeTable.IVIRFSIGGEN_VAL_PULSE_TRIGGER_SOURCE_INTERNAL) || ...
                ( e == attrPulseTriggerSourceRangeTable.IVIRFSIGGEN_VAL_PULSE_TRIGGER_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
