classdef attrWidthPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRWIDTHPOLARITYRANGETABLE for instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT class

    % Copyright 2010-2011 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope triggers on a positive pulse.
        IVISCOPE_VAL_WIDTH_POSITIVE = 1;
        % The oscilloscope triggers on a negative pulse.
        IVISCOPE_VAL_WIDTH_NEGATIVE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT.*
            found = ...
                ( e == attrWidthPolarityRangeTable.IVISCOPE_VAL_WIDTH_POSITIVE) || ...
                ( e == attrWidthPolarityRangeTable.IVISCOPE_VAL_WIDTH_NEGATIVE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
