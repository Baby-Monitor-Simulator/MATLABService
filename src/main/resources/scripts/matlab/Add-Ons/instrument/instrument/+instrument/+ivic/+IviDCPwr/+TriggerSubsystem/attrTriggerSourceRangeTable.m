classdef attrTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSOURCERANGETABLE for instrument.ivic.IviDCPwr.TriggerSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The power supply does not wait for a trigger of any kind.
        IVIDCPWR_VAL_TRIG_IMMEDIATE = 0;
        % The power supply waits for a trigger on the external trigger input.
        IVIDCPWR_VAL_TRIG_EXTERNAL = 1;
        % The power supply waits until you call the IviDCPwr_SendSoftwareTrigger function.
        IVIDCPWR_VAL_SOFTWARE_TRIG = 2;
        % The power supply waits until it receives a trigger on the PXI TRIG0 line for PXI  instruments or the VXI TTL0 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL0 = 3;
        % The power supply waits until it receives a trigger on the PXI TRIG1 line for PXI  instruments or the VXI TTL1 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL1 = 4;
        % The power supply waits until it receives a trigger on the PXI TRIG2 line for PXI  instruments or the VXI TTL2 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL2 = 5;
        % The power supply waits until it receives a trigger on the PXI TRIG3 line for PXI  instruments or the VXI TTL3 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL3 = 6;
        % The power supply waits until it receives a trigger on the PXI TRIG4 line for PXI  instruments or the VXI TTL4 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL4 = 7;
        % The power supply waits until it receives a trigger on the PXI TRIG5 line for PXI  instruments or the VXI TTL5 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL5 = 8;
        % The power supply waits until it receives a trigger on the PXI TRIG6 line for PXI  instruments or the VXI TTL6 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL6 = 9;
        % The power supply waits until it receives a trigger on the PXI TRIG7 line for PXI  instruments or the VXI TTL7 line for VXI instruments.
        IVIDCPWR_VAL_TRIG_TTL7 = 10;
        % The power supply waits until it receives a trigger on the VXI ECL0 line.
        IVIDCPWR_VAL_TRIG_ECL0 = 11;
        % The power supply waits until it receives a trigger on the VXI ECL1 line.
        IVIDCPWR_VAL_TRIG_ECL1 = 12;
        % The power supply waits until it receives a trigger on the PXI STAR trigger bus.
        IVIDCPWR_VAL_TRIG_PXI_STAR = 13;
        % The power supply waits until it receives a trigger on RTSI line 0 .
        IVIDCPWR_VAL_TRIG_RTSI_0 = 14;
        % The power supply waits until it receives a trigger on RTSI line 1.
        IVIDCPWR_VAL_TRIG_RTSI_1 = 15;
        % The power supply waits until it receives a trigger on RTSI line 2.
        IVIDCPWR_VAL_TRIG_RTSI_2 = 16;
        % The power supply waits until it receives a trigger on RTSI line 3.
        IVIDCPWR_VAL_TRIG_RTSI_3 = 17;
        % The power supply waits until it receives a trigger on RTSI line 4.
        IVIDCPWR_VAL_TRIG_RTSI_4 = 18;
        % The power supply waits until it receives a trigger on RTSI line 5.
        IVIDCPWR_VAL_TRIG_RTSI_5 = 19;
        % The power supply waits until it receives a trigger on RTSI line 6.
        IVIDCPWR_VAL_TRIG_RTSI_6 = 20;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDCPwr.TriggerSubsystem.*
            found = ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_IMMEDIATE) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_EXTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_SOFTWARE_TRIG) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL2) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL3) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL4) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL5) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL6) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_TTL7) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_ECL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_ECL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_PXI_STAR) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_0) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_1) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_2) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_3) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_4) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_5) || ...
                ( e == attrTriggerSourceRangeTable.IVIDCPWR_VAL_TRIG_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
