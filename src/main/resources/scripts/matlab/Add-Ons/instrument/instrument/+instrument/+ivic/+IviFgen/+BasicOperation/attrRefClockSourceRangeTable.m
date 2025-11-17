classdef attrRefClockSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRREFCLOCKSOURCERANGETABLE for instrument.ivic.IviFgen.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The function generator produces the reference clock internally.
        IVIFGEN_VAL_REF_CLOCK_INTERNAL = 0;
        % The function generator receives the reference clock signal from an  external source.
        IVIFGEN_VAL_REF_CLOCK_EXTERNAL = 1;
        % The function generator receives the reference clock signal from the  RTSI clock source.
        IVIFGEN_VAL_REF_CLOCK_RTSI_CLOCK = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.BasicOperation.*
            found = ...
                ( e == attrRefClockSourceRangeTable.IVIFGEN_VAL_REF_CLOCK_INTERNAL) || ...
                ( e == attrRefClockSourceRangeTable.IVIFGEN_VAL_REF_CLOCK_EXTERNAL) || ...
                ( e == attrRefClockSourceRangeTable.IVIFGEN_VAL_REF_CLOCK_RTSI_CLOCK);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
