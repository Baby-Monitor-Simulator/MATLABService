classdef attrCdmaTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRCDMATRIGGERSOURCERANGETABLE for instrument.ivic.IviRFSigGen.CDMA.Trigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The CDMA generator system does not wait for a trigger. Each channel  coding is run continuously.
        IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_IMMEDIATE = 1;
        % Each channel coding is started with an external signal.
        IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_EXTERNAL = 2;
        % Each channel coding is started with a software programmable trigger.
        IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_SOFTWARE = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.CDMA.Trigger.*
            found = ...
                ( e == attrCdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_IMMEDIATE) || ...
                ( e == attrCdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_EXTERNAL) || ...
                ( e == attrCdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_CDMA_TRIGGER_SOURCE_SOFTWARE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
