classdef attrTriggerTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRIGGERTYPERANGETABLE for instrument.ivic.IviScope.TriggerSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the oscilloscope for edge triggering.  An edge trigger  occurs when the trigger signal passes through the voltage threshold  that you specify with the IVISCOPE_ATTR_TRIGGER_LEVEL  attribute and has the slope that you specify with the  IVISCOPE_ATTR_TRIGGER_SLOPE attribute.
        IVISCOPE_VAL_EDGE_TRIGGER = 1;
        % Configures the oscilloscope for runt triggering.  A runt trigger occurs  when the trigger signal crosses one of the runt thresholds twice without  crossing the other runt threshold.  You specify the runt thresholds  with the IVISCOPE_ATTR_RUNT_HIGH_THRESHOLD  and IVISCOPE_ATTR_RUNT_LOW_THRESHOLD attributes.  You specify  the polarity of the runt with the IVISCOPE_ATTR_RUNT_POLARITY  attribute.
        IVISCOPE_VAL_RUNT_TRIGGER = 3;
        % Configures the oscilloscope for glitch triggering.  A glitch trigger  occurs when the trigger signal has a pulse with a width  that is less than the glitch width.  You specify the  glitch width with the IVISCOPE_ATTR_GLITCH_WIDTH  attribute.   You specify the polarity of the pulse with the  IVISCOPE_ATTR_GLITCH_POLARITY attribute.  The trigger does not  actually occur until the edge of a pulse that corresponds to the  glitch width and polarity you specify crosses the trigger level  you specify with the IVISCOPE_ATTR_TRIGGER_LEVEL attribute.
        IVISCOPE_VAL_GLITCH_TRIGGER = 4;
        % Configures the oscilloscope for width triggering.  A width trigger occurs  when the oscilloscope detects a positive or negative pulse with a width  between, or optionally outside, the width thresholds.  You specify  the width thresholds with the IVISCOPE_ATTR_WIDTH_HIGH_THRESHOLD  and IVISCOPE_ATTR_WIDTH_LOW_THRESHOLD attributes.  You specify whether  the oscilloscope triggers on pulse widths that are within or outside the width  thresholds with the IVISCOPE_ATTR_WIDTH_CONDITION attribute.   You specify the polarity of the pulse with the  IVISCOPE_ATTR_WIDTH_POLARITY attribute.  The trigger does not  actually occur until the edge of a pulse that corresponds to the width thresholds,  width condition, and polarity you specify crosses the trigger level you  specify with the IVISCOPE_ATTR_TRIGGER_LEVEL attribute.\n
        IVISCOPE_VAL_WIDTH_TRIGGER = 2;
        % Configures the oscilloscope for TV triggering.  You configure the TV trigger  with the IVISCOPE_ATTR_TV_TRIGGER_SIGNAL_FORMAT,  IVISCOPE_ATTR_TV_TRIGGER_EVENT,  IVISCOPE_ATTR_TV_TRIGGER_LINE_NUMBER, and  IVISCOPE_ATTR_TV_TRIGGER_POLARITY attributes.
        IVISCOPE_VAL_TV_TRIGGER = 5;
        % Configures the oscilloscope for AC line triggering.
        IVISCOPE_VAL_AC_LINE_TRIGGER = 7;
        % Configures the oscilloscope for immediate triggering.
        IVISCOPE_VAL_IMMEDIATE_TRIGGER = 6;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.*
            found = ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_EDGE_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_RUNT_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_GLITCH_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_WIDTH_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_TV_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_AC_LINE_TRIGGER) || ...
                ( e == attrTriggerTypeRangeTable.IVISCOPE_VAL_IMMEDIATE_TRIGGER);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
