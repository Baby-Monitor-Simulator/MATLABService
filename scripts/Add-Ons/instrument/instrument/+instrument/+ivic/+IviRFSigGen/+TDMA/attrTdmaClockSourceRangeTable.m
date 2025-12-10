classdef attrTdmaClockSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRTDMACLOCKSOURCERANGETABLE for instrument.ivic.IviRFSigGen.TDMA class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The internal clock generator is used.
        IVIRFSIGGEN_VAL_TDMA_CLOCK_SOURCE_INTERNAL = 1;
        % A connected external clock generator bit or symbol clock frequency is  used.
        IVIRFSIGGEN_VAL_TDMA_CLOCK_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.TDMA.*
            found = ...
                ( e == attrTdmaClockSourceRangeTable.IVIRFSIGGEN_VAL_TDMA_CLOCK_SOURCE_INTERNAL) || ...
                ( e == attrTdmaClockSourceRangeTable.IVIRFSIGGEN_VAL_TDMA_CLOCK_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
