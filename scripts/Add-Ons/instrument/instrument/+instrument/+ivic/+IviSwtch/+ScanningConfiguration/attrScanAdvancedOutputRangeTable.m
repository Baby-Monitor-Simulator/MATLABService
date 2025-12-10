classdef attrScanAdvancedOutputRangeTable < instrument.internal.DriverBaseClass
    %ATTRSCANADVANCEDOUTPUTRANGETABLE for instrument.ivic.IviSwtch.ScanningConfiguration class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The switch module does not produce a Scan Advanced Output trigger.
        IVISWTCH_VAL_NONE = 0;
        % External Trigger. The switch module produces the Scan Advanced Output  trigger on the external trigger output.
        IVISWTCH_VAL_EXTERNAL = 2;
        % The switch module produces the GPIB Service Request  in place of the Scan Advanced Output trigger.
        IVISWTCH_VAL_GPIB_SRQ = 5;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL0 or  PXI TRIG0 line.
        IVISWTCH_VAL_TTL0 = 111;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL1 or  PXI TRIG1 line.
        IVISWTCH_VAL_TTL1 = 112;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL2 or  PXI TRIG2 line.
        IVISWTCH_VAL_TTL2 = 113;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL3 or  PXI TRIG3 line.
        IVISWTCH_VAL_TTL3 = 114;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL4 or  PXI TRIG4 line.
        IVISWTCH_VAL_TTL4 = 115;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL5 or  PXI TRIG5 line.
        IVISWTCH_VAL_TTL5 = 116;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL6 or  PXI TRIG6 line.
        IVISWTCH_VAL_TTL6 = 117;
        % The switch module produces the Scan Advanced Output on the VXIbus TTL7 or  PXI TRIG7 line.
        IVISWTCH_VAL_TTL7 = 118;
        % The switch module produces the Scan Advanced Output on the VXIbus ECL0 line.
        IVISWTCH_VAL_ECL0 = 119;
        % The switch module produces the Scan Advanced Output on the VXIbus ECL1 line.
        IVISWTCH_VAL_ECL1 = 120;
        % The switch module produces the Scan Advanced Output on the PXI STAR trigger bus  before processing the next entry in the scan list.
        IVISWTCH_VAL_PXI_STAR = 125;
        % The switch module produces the Scan Advanced Output on RTSI line 0.
        IVISWTCH_VAL_RTSI_0 = 140;
        % The switch module produces the Scan Advanced Output on RTSI line 1.
        IVISWTCH_VAL_RTSI_1 = 141;
        % The switch module produces the Scan Advanced Output on RTSI line 2.
        IVISWTCH_VAL_RTSI_2 = 142;
        % The switch module produces the Scan Advanced Output on RTSI line 3.
        IVISWTCH_VAL_RTSI_3 = 143;
        % The switch module produces the Scan Advanced Output on RTSI line 4.
        IVISWTCH_VAL_RTSI_4 = 144;
        % The switch module produces the Scan Advanced Output on RTSI line 5.
        IVISWTCH_VAL_RTSI_5 = 145;
        % The switch module produces the Scan Advanced Output on RTSI line 6.
        IVISWTCH_VAL_RTSI_6 = 146;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSwtch.ScanningConfiguration.*
            found = ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_NONE) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_EXTERNAL) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_GPIB_SRQ) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL0) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL1) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL2) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL3) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL4) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL5) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL6) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_TTL7) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_ECL0) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_ECL1) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_PXI_STAR) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_0) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_1) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_2) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_3) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_4) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_5) || ...
                ( e == attrScanAdvancedOutputRangeTable.IVISWTCH_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
