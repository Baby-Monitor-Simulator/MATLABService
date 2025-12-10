classdef attrTdmaTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTDMATRIGGERSOURCERANGETABLE for instrument.ivic.IviRFSigGen.TDMA.Trigger class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The TDMA generator system does not wait for a trigger of any kind, so it  is running the frames continuously.
        IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_IMMEDIATE = 1;
        % Each frame is started with an external signal.
        IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_EXTERNAL = 2;
        % Each frame is started with a software programmable trigger.
        IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_SOFTWARE = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.TDMA.Trigger.*
            found = ...
                ( e == attrTdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_IMMEDIATE) || ...
                ( e == attrTdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_EXTERNAL) || ...
                ( e == attrTdmaTriggerSourceRangeTable.IVIRFSIGGEN_VAL_TDMA_TRIGGER_SOURCE_SOFTWARE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
