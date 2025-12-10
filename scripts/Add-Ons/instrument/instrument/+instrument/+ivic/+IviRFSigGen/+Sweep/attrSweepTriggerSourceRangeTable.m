classdef attrSweepTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRSWEEPTRIGGERSOURCERANGETABLE for instrument.ivic.IviRFSigGen.Sweep class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The sweep system does not wait for a trigger of any kind, so it is  running continuously.
        IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_IMMEDIATE = 1;
        % The sweep is started with an external signal.
        IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_EXTERNAL = 2;
        % The sweep is started with a software programmable trigger.
        IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_SOFTWARE = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.Sweep.*
            found = ...
                ( e == attrSweepTriggerSourceRangeTable.IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_IMMEDIATE) || ...
                ( e == attrSweepTriggerSourceRangeTable.IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_EXTERNAL) || ...
                ( e == attrSweepTriggerSourceRangeTable.IVIRFSIGGEN_VAL_SWEEP_TRIGGER_SOURCE_SOFTWARE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
