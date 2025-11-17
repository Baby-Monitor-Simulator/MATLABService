classdef attrTriggerCouplingRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERCOUPLINGRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope AC couples the trigger signal.
        IVISCOPE_VAL_AC = 0;
        % The oscilloscope DC couples the trigger signal.
        IVISCOPE_VAL_DC = 1;
        % The oscilloscope rejects low frequencies from the trigger signal.
        IVISCOPE_VAL_LF_REJECT = 4;
        % The oscilloscope rejects high frequencies from the trigger signal.
        IVISCOPE_VAL_HF_REJECT = 3;
        % The oscilloscope rejects noise from the trigger signal.
        IVISCOPE_VAL_NOISE_REJECT = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.*
            found = ...
                ( e == attrTriggerCouplingRangeTable.IVISCOPE_VAL_AC) || ...
                ( e == attrTriggerCouplingRangeTable.IVISCOPE_VAL_DC) || ...
                ( e == attrTriggerCouplingRangeTable.IVISCOPE_VAL_LF_REJECT) || ...
                ( e == attrTriggerCouplingRangeTable.IVISCOPE_VAL_HF_REJECT) || ...
                ( e == attrTriggerCouplingRangeTable.IVISCOPE_VAL_NOISE_REJECT);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
