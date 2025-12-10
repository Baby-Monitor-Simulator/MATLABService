classdef attrTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSOURCERANGETABLE for instrument.ivic.IviPwrMeter.Trigger class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The power meter exits the Wait-For-Trigger state immediately after  entering.  It does not wait for a trigger of any kind.
        IVIPWRMETER_VAL_IMMEDIATE = 1;
        % The power meter exits the Wait-For-Trigger state when a trigger occurs on  the external trigger input.
        IVIPWRMETER_VAL_EXTERNAL = 2;
        % The power meter exits the Wait-For-Trigger state when an internal trigger  event occurs on the measurement signal.
        IVIPWRMETER_VAL_INTERNAL = 3;
        % The power meter exits the Wait-For-Trigger state when it receives a  software trigger.
        IVIPWRMETER_VAL_SOFTWARE_TRIG = 4;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL0.
        IVIPWRMETER_VAL_TTL0 = 100;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL1.
        IVIPWRMETER_VAL_TTL1 = 101;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL2.
        IVIPWRMETER_VAL_TTL2 = 102;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL3.
        IVIPWRMETER_VAL_TTL3 = 103;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL4.
        IVIPWRMETER_VAL_TTL4 = 104;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL5.
        IVIPWRMETER_VAL_TTL5 = 105;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL6.
        IVIPWRMETER_VAL_TTL6 = 106;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on TTL7.
        IVIPWRMETER_VAL_TTL7 = 107;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on ECL0.
        IVIPWRMETER_VAL_ECL0 = 200;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on ECL1.
        IVIPWRMETER_VAL_ECL1 = 201;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on PXI Star trigger bus.
        IVIPWRMETER_VAL_PXI_STAR = 300;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI0 line.
        IVIPWRMETER_VAL_RTSI_0 = 400;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI1 line.
        IVIPWRMETER_VAL_RTSI_1 = 401;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI2 line.
        IVIPWRMETER_VAL_RTSI_2 = 402;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI3 line.
        IVIPWRMETER_VAL_RTSI_3 = 403;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI4 line.
        IVIPWRMETER_VAL_RTSI_4 = 404;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI5 line.
        IVIPWRMETER_VAL_RTSI_5 = 405;
        % The power meter exits the Wait-For-Trigger state when it receives a  trigger on the RTSI6 line.
        IVIPWRMETER_VAL_RTSI_6 = 406;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviPwrMeter.Trigger.*
            found = ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_IMMEDIATE) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_EXTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_INTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_SOFTWARE_TRIG) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL2) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL3) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL4) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL5) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL6) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_TTL7) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_ECL0) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_ECL1) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_PXI_STAR) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_0) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_1) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_2) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_3) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_4) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_5) || ...
                ( e == attrTriggerSourceRangeTable.IVIPWRMETER_VAL_RTSI_6);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
