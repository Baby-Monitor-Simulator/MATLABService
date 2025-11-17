classdef attrTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSOURCERANGETABLE for instrument.ivic.IviFgen.Triggering class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The function generator waits for a trigger on the external trigger input.
        IVIFGEN_VAL_EXTERNAL = 1;
        % The function generator waits until you call the IviFgen_SendSoftwareTrigger function.
        IVIFGEN_VAL_SOFTWARE_TRIG = 2;
        % The function generator waits for an internal trigger.
        IVIFGEN_VAL_INTERNAL_TRIGGER = 3;
        % The function generator waits until it receives a trigger on the PXI TRIG0 line for PXI  instruments or the VXI TTL0 line for VXI instruments.
        IVIFGEN_VAL_TTL0 = 111;
        % The function generator waits until it receives a trigger on the PXI TRIG1 line for PXI  instruments or the VXI TTL1 line for VXI instruments.
        IVIFGEN_VAL_TTL1 = 112;
        % The function generator waits until it receives a trigger on the PXI TRIG2 line for PXI  instruments or the VXI TTL2 line for VXI instruments.
        IVIFGEN_VAL_TTL2 = 113;
        % The function generator waits until it receives a trigger on the PXI TRIG3 line for PXI  instruments or the VXI TTL3 line for VXI instruments.
        IVIFGEN_VAL_TTL3 = 114;
        % The function generator waits until it receives a trigger on the PXI TRIG4 line for PXI  instruments or the VXI TTL4 line for VXI instruments.
        IVIFGEN_VAL_TTL4 = 115;
        % The function generator waits until it receives a trigger on the PXI TRIG5 line for PXI  instruments or the VXI TTL5 line for VXI instruments.
        IVIFGEN_VAL_TTL5 = 116;
        % The function generator waits until it receives a trigger on the PXI TRIG6 line for PXI  instruments or the VXI TTL6 line for VXI instruments.
        IVIFGEN_VAL_TTL6 = 117;
        % The function generator waits until it receives a trigger on the PXI TRIG7 line for PXI  instruments or the VXI TTL7 line for VXI instruments.
        IVIFGEN_VAL_TTL7 = 118;
        % The function generator waits until it receives a trigger on the VXI ECL0 line.
        IVIFGEN_VAL_ECL0 = 119;
        % The function generator waits until it receives a trigger on the VXI ECL1 line.
        IVIFGEN_VAL_ECL1 = 120;
        % The function generator waits until it receives a trigger on the PXI STAR trigger bus.
        IVIFGEN_VAL_PXI_STAR = 131;
        % The function generator waits until it receives a trigger on RTSI line 0.
        IVIFGEN_VAL_RTSI_0 = 141;
        % The function generator waits until it receives a trigger on RTSI line 1.
        IVIFGEN_VAL_RTSI_1 = 142;
        % The function generator waits until it receives a trigger on RTSI line 2.
        IVIFGEN_VAL_RTSI_2 = 143;
        % The function generator waits until it receives a trigger on RTSI line 3.
        IVIFGEN_VAL_RTSI_3 = 144;
        % The function generator waits until it receives a trigger on RTSI line 4.
        IVIFGEN_VAL_RTSI_4 = 145;
        % The function generator waits until it receives a trigger on RTSI line 5.
        IVIFGEN_VAL_RTSI_5 = 146;
        % The function generator waits until it receives a trigger on RTSI line 6.
        IVIFGEN_VAL_RTSI_6 = 147;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.Triggering.*
            found = ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_EXTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_SOFTWARE_TRIG) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_INTERNAL_TRIGGER) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL2) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL3) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL4) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL5) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL6) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_TTL7) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_ECL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_ECL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_PXI_STAR) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_0) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_1) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_2) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_3) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_4) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_5) || ...
                ( e == attrTriggerSourceRangeTable.IVIFGEN_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
