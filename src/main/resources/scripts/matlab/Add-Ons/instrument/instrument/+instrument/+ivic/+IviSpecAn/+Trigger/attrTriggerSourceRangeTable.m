classdef attrTriggerSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERSOURCERANGETABLE for instrument.ivic.IviSpecAn.Trigger class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The spectrum analyzer waits until it receives a trigger on the external  trigger connector.
        IVISPECAN_VAL_TRIGGER_SOURCE_EXTERNAL = 1;
        % The spectrum analyzer does not wait for a trigger of any kind.
        IVISPECAN_VAL_TRIGGER_SOURCE_IMMEDIATE = 2;
        % The spectrum analyzer waits until the Send Software Trigger function  executes.
        IVISPECAN_VAL_TRIGGER_SOURCE_SOFTWARE = 3;
        % The spectrum analyzer waits until it receives a trigger on the AC line.
        IVISPECAN_VAL_TRIGGER_SOURCE_AC_LINE = 4;
        % The spectrum analyzer waits until it receives a video level.
        IVISPECAN_VAL_TRIGGER_SOURCE_VIDEO = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.Trigger.*
            found = ...
                ( e == attrTriggerSourceRangeTable.IVISPECAN_VAL_TRIGGER_SOURCE_EXTERNAL) || ...
                ( e == attrTriggerSourceRangeTable.IVISPECAN_VAL_TRIGGER_SOURCE_IMMEDIATE) || ...
                ( e == attrTriggerSourceRangeTable.IVISPECAN_VAL_TRIGGER_SOURCE_SOFTWARE) || ...
                ( e == attrTriggerSourceRangeTable.IVISPECAN_VAL_TRIGGER_SOURCE_AC_LINE) || ...
                ( e == attrTriggerSourceRangeTable.IVISPECAN_VAL_TRIGGER_SOURCE_VIDEO);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
