classdef attrArbTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    % ATTRARBTRIGGERSOURCERANGETABLE for
    % instrument.ivic.IviRFSigGen.ARBGenerator.Trigger class

    % Copyright 2016 The MathWorks, Inc.
    
    properties(Constant)
        % The ARB generator system does not wait for a trigger. The ARB
        % runs continuously.
        IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_IMMEDIATE = 0;
        % The sweep is started with an external signal.
        IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_EXTERNAL = 1;
        % The sweep is started with a software programmable trigger.
        IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_SOFTWARE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.ARBGenerator.Trigger.*
            found = ...
                ( e == attrArbTriggerSourceRangeTable.IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_IMMEDIATE) || ...
                ( e == attrArbTriggerSourceRangeTable.IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_EXTERNAL) || ...
                ( e == attrArbTriggerSourceRangeTable.IVIRFSIGGEN_VAL_ARB_TRIGGER_SOURCE_SOFTWARE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
