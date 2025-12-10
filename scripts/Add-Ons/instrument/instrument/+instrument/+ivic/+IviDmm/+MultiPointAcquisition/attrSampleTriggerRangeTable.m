classdef attrSampleTriggerRangeTable < instrument.internal.DriverBaseClass
    %ATTRSAMPLETRIGGERRANGETABLE for instrument.ivic.IviDmm.MultiPointAcquisition class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The DMM does not wait for a trigger of any kind between measurements.
        IVIDMM_VAL_IMMEDIATE = 1;
        % The DMM waits between measurements for a trigger on the external trigger  input.
        IVIDMM_VAL_EXTERNAL = 2;
        % The DMM waits between measurements until you call the  IviDmm_SendSoftwareTrigger function.
        IVIDMM_VAL_SOFTWARE_TRIG = 3;
        % The DMM waits between measurements for the length of time you specify  with the IVIDMM_ATTR_SAMPLE_INTERVAL attribute.
        IVIDMM_VAL_INTERVAL = 10;
        % The DMM waits between measurements until it receives a trigger on the  TTL0 line.
        IVIDMM_VAL_TTL0 = 111;
        % The DMM waits between measurements until it receives a trigger on the  TTL1 line.
        IVIDMM_VAL_TTL1 = 112;
        % The DMM waits between measurements until it receives a trigger on the  TTL2 line.
        IVIDMM_VAL_TTL2 = 113;
        % The DMM waits between measurements until it receives a trigger on the  TTL3 line.
        IVIDMM_VAL_TTL3 = 114;
        % The DMM waits between measurements until it receives a trigger on the  TTL4 line.
        IVIDMM_VAL_TTL4 = 115;
        % The DMM waits between measurements until it receives a trigger on the  TTL5 line.
        IVIDMM_VAL_TTL5 = 116;
        % The DMM waits between measurements until it receives a trigger on the  TTL6 line.
        IVIDMM_VAL_TTL6 = 117;
        % The DMM waits between measurements until it receives a trigger on the  TTL7 line.
        IVIDMM_VAL_TTL7 = 118;
        % The DMM waits between measurements until it receives a trigger on the  ECL0 line.
        IVIDMM_VAL_ECL0 = 119;
        % The DMM waits between measurements until it receives a trigger on the  ECL1 line.
        IVIDMM_VAL_ECL1 = 120;
        % The DMM waits between measurements until it receives a trigger on the PXI  STAR bus.
        IVIDMM_VAL_PXI_STAR = 131;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 0 .
        IVIDMM_VAL_RTSI_0 = 140;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 1.
        IVIDMM_VAL_RTSI_1 = 141;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 2.
        IVIDMM_VAL_RTSI_2 = 142;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 3.
        IVIDMM_VAL_RTSI_3 = 143;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 4.
        IVIDMM_VAL_RTSI_4 = 144;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 5.
        IVIDMM_VAL_RTSI_5 = 145;
        % The DMM waits between measurements until it receives a trigger on the RTSI line 6.
        IVIDMM_VAL_RTSI_6 = 146;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.MultiPointAcquisition.*
            found = ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_IMMEDIATE) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_EXTERNAL) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_SOFTWARE_TRIG) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_INTERVAL) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL0) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL1) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL2) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL3) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL4) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL5) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL6) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_TTL7) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_ECL0) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_ECL1) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_PXI_STAR) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_0) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_1) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_2) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_3) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_4) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_5) || ...
                ( e == attrSampleTriggerRangeTable.IVIDMM_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
