classdef attrMeasCompleteDestRangeTable < instrument.internal.DriverBaseClass
    %ATTRMEASCOMPLETEDESTRANGETABLE for instrument.ivic.IviDmm.MultiPointAcquisition class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The DMM does not send the measurement-complete signal.
        IVIDMM_VAL_NONE = -1;
        % The DMM sends the measurement-complete signal on the external trigger line.
        IVIDMM_VAL_EXTERNAL = 2;
        % The DMM sends the measurement-complete signal on TTL0 line.
        IVIDMM_VAL_TTL0 = 111;
        % The DMM sends the measurement-complete signal on TTL1 line.
        IVIDMM_VAL_TTL1 = 112;
        % The DMM sends the measurement-complete signal on TTL2 line.
        IVIDMM_VAL_TTL2 = 113;
        % The DMM sends the measurement-complete signal on TTL3 line.
        IVIDMM_VAL_TTL3 = 114;
        % The DMM sends the measurement-complete signal on TTL4 line.
        IVIDMM_VAL_TTL4 = 115;
        % The DMM sends the measurement-complete signal on TTL5 line.
        IVIDMM_VAL_TTL5 = 116;
        % The DMM sends the measurement-complete signal on TTL6 line.
        IVIDMM_VAL_TTL6 = 117;
        % The DMM sends the measurement-complete signal on TTL7 line.
        IVIDMM_VAL_TTL7 = 118;
        % The DMM sends the measurement-complete signal on ECL0 line.
        IVIDMM_VAL_ECL0 = 119;
        % The DMM sends the measurement-complete signal on ECL1 line.
        IVIDMM_VAL_ECL1 = 120;
        % The DMM sends the measurement-complete signal on PXI STAR bus.
        IVIDMM_VAL_PXI_STAR = 131;
        % The DMM sends the measurement-complete signal on RTSI line 0 .
        IVIDMM_VAL_RTSI_0 = 140;
        % The DMM sends the measurement-complete signal on RTSI line 1.
        IVIDMM_VAL_RTSI_1 = 141;
        % The DMM sends the measurement-complete signal on RTSI line 2.
        IVIDMM_VAL_RTSI_2 = 142;
        % The DMM sends the measurement-complete signal on RTSI line 3.
        IVIDMM_VAL_RTSI_3 = 143;
        % The DMM sends the measurement-complete signal on RTSI line 4.
        IVIDMM_VAL_RTSI_4 = 144;
        % The DMM sends the measurement-complete signal on RTSI line 5.
        IVIDMM_VAL_RTSI_5 = 145;
        % The DMM sends the measurement-complete signal on RTSI line 6.
        IVIDMM_VAL_RTSI_6 = 146;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.MultiPointAcquisition.*
            found = ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_NONE) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_EXTERNAL) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL0) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL1) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL2) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL3) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL4) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL5) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL6) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_TTL7) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_ECL0) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_ECL1) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_PXI_STAR) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_0) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_1) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_2) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_3) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_4) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_5) || ...
                ( e == attrMeasCompleteDestRangeTable.IVIDMM_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
