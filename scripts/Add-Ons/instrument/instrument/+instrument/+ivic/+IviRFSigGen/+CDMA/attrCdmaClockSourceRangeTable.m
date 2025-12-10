classdef attrCdmaClockSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRCDMACLOCKSOURCERANGETABLE for instrument.ivic.IviRFSigGen.CDMA class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The internal clock generator is used.
        IVIRFSIGGEN_VAL_CDMA_CLOCK_SOURCE_INTERNAL = 1;
        % A connected external clock generator bit or symbol clock frequency is  used.
        IVIRFSIGGEN_VAL_CDMA_CLOCK_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.CDMA.*
            found = ...
                ( e == attrCdmaClockSourceRangeTable.IVIRFSIGGEN_VAL_CDMA_CLOCK_SOURCE_INTERNAL) || ...
                ( e == attrCdmaClockSourceRangeTable.IVIRFSIGGEN_VAL_CDMA_CLOCK_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
