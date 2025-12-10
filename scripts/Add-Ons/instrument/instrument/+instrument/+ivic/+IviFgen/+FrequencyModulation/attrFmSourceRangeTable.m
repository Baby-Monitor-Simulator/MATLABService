classdef attrFmSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRFMSOURCERANGETABLE for instrument.ivic.IviFgen.FrequencyModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Internal FM Modulating Source.
        IVIFGEN_VAL_FM_INTERNAL = 0;
        % External FM Modulating Source.
        IVIFGEN_VAL_FM_EXTERNAL = 1;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.FrequencyModulation.*
            found = ...
                ( e == attrFmSourceRangeTable.IVIFGEN_VAL_FM_INTERNAL) || ...
                ( e == attrFmSourceRangeTable.IVIFGEN_VAL_FM_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
