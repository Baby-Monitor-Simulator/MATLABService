classdef attrTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSOURCERANGETABLE for instrument.ivic.IviDmm.Trigger class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The DMM does not wait for a trigger of any kind.
        IVIDMM_VAL_IMMEDIATE = 1;
        % The DMM waits for a trigger on the external trigger input.
        IVIDMM_VAL_EXTERNAL = 2;
        % The DMM waits until you call the IviDmm_SendSoftwareTrigger function.
        IVIDMM_VAL_SOFTWARE_TRIG = 3;
        % The DMM waits until it receives a trigger on the PXI TRIG0 line for PXI  instruments or the VXI TTL0 line for VXI instruments.
        IVIDMM_VAL_TTL0 = 111;
        % The DMM waits until it receives a trigger on the PXI TRIG1 line for PXI  instruments or the VXI TTL1 line for VXI instruments.
        IVIDMM_VAL_TTL1 = 112;
        % The DMM waits until it receives a trigger on the PXI TRIG2 line for PXI  instruments or the VXI TTL2 line for VXI instruments.
        IVIDMM_VAL_TTL2 = 113;
        % The DMM waits until it receives a trigger on the PXI TRIG3 line for PXI  instruments or the VXI TTL3 line for VXI instruments.
        IVIDMM_VAL_TTL3 = 114;
        % The DMM waits until it receives a trigger on the PXI TRIG4 line for PXI  instruments or the VXI TTL4 line for VXI instruments.
        IVIDMM_VAL_TTL4 = 115;
        % The DMM waits until it receives a trigger on the PXI TRIG5 line for PXI  instruments or the VXI TTL5 line for VXI instruments.
        IVIDMM_VAL_TTL5 = 116;
        % The DMM waits until it receives a trigger on the PXI TRIG6 line for PXI  instruments or the VXI TTL6 line for VXI instruments.
        IVIDMM_VAL_TTL6 = 117;
        % The DMM waits until it receives a trigger on the PXI TRIG7 line for PXI  instruments or the VXI TTL7 line for VXI instruments.
        IVIDMM_VAL_TTL7 = 118;
        % The DMM waits until it receives a trigger on the VXI ECL0 line.
        IVIDMM_VAL_ECL0 = 119;
        % The DMM waits until it receives a trigger on the VXI ECL1 line.
        IVIDMM_VAL_ECL1 = 120;
        % The DMM waits until it receives a trigger on the PXI STAR trigger bus.
        IVIDMM_VAL_PXI_STAR = 131;
        % The DMM waits until it receives a trigger on RTSI line 0 .
        IVIDMM_VAL_RTSI_0 = 140;
        % The DMM waits until it receives a trigger on RTSI line 1.
        IVIDMM_VAL_RTSI_1 = 141;
        % The DMM waits until it receives a trigger on RTSI line 2.
        IVIDMM_VAL_RTSI_2 = 142;
        % The DMM waits until it receives a trigger on RTSI line 3.
        IVIDMM_VAL_RTSI_3 = 143;
        % The DMM waits until it receives a trigger on RTSI line 4.
        IVIDMM_VAL_RTSI_4 = 144;
        % The DMM waits until it receives a trigger on RTSI line 5.
        IVIDMM_VAL_RTSI_5 = 145;
        % The DMM waits until it receives a trigger on RTSI line 6.
        IVIDMM_VAL_RTSI_6 = 146;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.Trigger.*
            found = ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_IMMEDIATE) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_EXTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_SOFTWARE_TRIG) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL2) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL3) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL4) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL5) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL6) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_TTL7) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_ECL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_ECL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_PXI_STAR) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_2) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_3) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_4) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_5) || ...
                ( e == attrTriggerSourceRangeTable.IVIDMM_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
