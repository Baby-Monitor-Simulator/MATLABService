classdef attrTvTriggerEventRangeTable < instrument.internal.DriverBaseClass
    %ATTRTVTRIGGEREVENTRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % Field 1 of the video signal
        IVISCOPE_VAL_TV_EVENT_FIELD1 = 1;
        % Field 2 of the video signal
        IVISCOPE_VAL_TV_EVENT_FIELD2 = 2;
        % Any field of the video signal
        IVISCOPE_VAL_TV_EVENT_ANY_FIELD = 3;
        % Any line of the video signal
        IVISCOPE_VAL_TV_EVENT_ANY_LINE = 4;
        % A specified line of the video signal
        IVISCOPE_VAL_TV_EVENT_LINE_NUMBER = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*
            found = ...
                ( e == attrTvTriggerEventRangeTable.IVISCOPE_VAL_TV_EVENT_FIELD1) || ...
                ( e == attrTvTriggerEventRangeTable.IVISCOPE_VAL_TV_EVENT_FIELD2) || ...
                ( e == attrTvTriggerEventRangeTable.IVISCOPE_VAL_TV_EVENT_ANY_FIELD) || ...
                ( e == attrTvTriggerEventRangeTable.IVISCOPE_VAL_TV_EVENT_ANY_LINE) || ...
                ( e == attrTvTriggerEventRangeTable.IVISCOPE_VAL_TV_EVENT_LINE_NUMBER);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
