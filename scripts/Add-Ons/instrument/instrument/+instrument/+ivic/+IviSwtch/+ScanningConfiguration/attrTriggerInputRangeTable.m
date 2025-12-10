classdef attrTriggerInputRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERINPUTRANGETABLE for instrument.ivic.IviSwtch.ScanningConfiguration class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Immediate Trigger. The switch module does not wait  for a trigger before processing the next entry in the  scan list.
        IVISWTCH_VAL_IMMEDIATE = 1;
        % External Trigger. The switch module waits until it receives a trigger  from an external source through the external trigger input before  processing the next entry in the scan list.
        IVISWTCH_VAL_EXTERNAL = 2;
        % The switch module waits until you call the IviSwtch_SendSoftwareTrigger function  before processing the next entry in the scan list.
        IVISWTCH_VAL_SOFTWARE_TRIG = 3;
        % The switch module waits until it receives a trigger on the VXIbus TTL0 or  PXI TRIG0 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL0 = 111;
        % The switch module waits until it receives a trigger on the VXIbus TTL1 or  PXI TRIG1 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL1 = 112;
        % The switch module waits until it receives a trigger on the VXIbus TTL2 or  PXI TRIG2 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL2 = 113;
        % The switch module waits until it receives a trigger on the VXIbus TTL3 or  PXI TRIG3 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL3 = 114;
        % The switch module waits until it receives a trigger on the VXIbus TTL4 or  PXI TRIG4 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL4 = 115;
        % The switch module waits until it receives a trigger on the VXIbus TTL5 or  PXI TRIG5 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL5 = 116;
        % The switch module waits until it receives a trigger on the VXIbus TTL6 or  PXI TRIG6 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL6 = 117;
        % The switch module waits until it receives a trigger on the VXIbus TTL7 or  PXI TRIG7 line before processing the next entry in the scan list.
        IVISWTCH_VAL_TTL7 = 118;
        % The switch module waits until it receives a trigger on the VXIbus ECL0 line  before processing the next entry in the scan list.
        IVISWTCH_VAL_ECL0 = 119;
        % The switch module waits until it receives a trigger on the VXIbus ECL1 line  before processing the next entry in the scan list.
        IVISWTCH_VAL_ECL1 = 120;
        % The switch module waits until it receives a trigger on the PXI STAR trigger bus  before processing the next entry in the scan list.
        IVISWTCH_VAL_PXI_STAR = 125;
        % The switch module waits until it receives a trigger on RTSI line 0  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_0 = 140;
        % The switch module waits until it receives a trigger on RTSI line 1  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_1 = 141;
        % The switch module waits until it receives a trigger on RTSI line 2  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_2 = 142;
        % The switch module waits until it receives a trigger on RTSI line 3  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_3 = 143;
        % The switch module waits until it receives a trigger on RTSI line 4  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_4 = 144;
        % The switch module waits until it receives a trigger on RTSI line 5  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_5 = 145;
        % The switch module waits until it receives a trigger on RTSI line 6  before processing the next entry in the scan list.
        IVISWTCH_VAL_RTSI_6 = 146;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSwtch.ScanningConfiguration.*
            found = ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_IMMEDIATE) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_EXTERNAL) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_SOFTWARE_TRIG) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL0) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL1) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL2) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL3) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL4) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL5) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL6) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_TTL7) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_ECL0) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_ECL1) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_PXI_STAR) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_0) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_1) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_2) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_3) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_4) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_5) || ...
                ( e == attrTriggerInputRangeTable.IVISWTCH_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
