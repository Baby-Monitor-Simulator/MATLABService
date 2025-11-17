classdef attrTriggerModifierRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERMODIFIERRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope waits indefinitely for the trigger you specify.
        IVISCOPE_VAL_NO_TRIGGER_MOD = 1;
        % If the trigger you specify does not occur within the oscilloscope's timeout  period, the oscilloscope automatically triggers.
        IVISCOPE_VAL_AUTO = 2;
        % If the trigger you specify does not occur within the oscilloscope's timeout  period, the oscilloscope automatically adjusts the trigger level to a value  that causes a trigger.  The trigger level remains at the new value.
        IVISCOPE_VAL_AUTO_LEVEL = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.*
            found = ...
                ( e == attrTriggerModifierRangeTable.IVISCOPE_VAL_NO_TRIGGER_MOD) || ...
                ( e == attrTriggerModifierRangeTable.IVISCOPE_VAL_AUTO) || ...
                ( e == attrTriggerModifierRangeTable.IVISCOPE_VAL_AUTO_LEVEL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
