classdef attrTvTriggerSignalFormatRangeTable < instrument.internal.DriverBaseClass
    %ATTRTVTRIGGERSIGNALFORMATRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % NTSC video signal
        IVISCOPE_VAL_NTSC = 1;
        % PAL video signal
        IVISCOPE_VAL_PAL = 2;
        % SECAM video signal
        IVISCOPE_VAL_SECAM = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*
            found = ...
                ( e == attrTvTriggerSignalFormatRangeTable.IVISCOPE_VAL_NTSC) || ...
                ( e == attrTvTriggerSignalFormatRangeTable.IVISCOPE_VAL_PAL) || ...
                ( e == attrTvTriggerSignalFormatRangeTable.IVISCOPE_VAL_SECAM);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
