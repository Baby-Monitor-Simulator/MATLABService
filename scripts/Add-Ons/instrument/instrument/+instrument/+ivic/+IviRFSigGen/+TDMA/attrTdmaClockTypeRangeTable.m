classdef attrTdmaClockTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTDMACLOCKTYPERANGETABLE for instrument.ivic.IviRFSigGen.TDMA class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The external clock frequency is equal to the bit clock frequency of the  digital modulation.
        IVIRFSIGGEN_VAL_TDMA_EXTERNAL_CLOCK_TYPE_BIT = 1;
        % The external clock frequency is equal to the symbol clock frequency of  the digital modulation.
        IVIRFSIGGEN_VAL_TDMA_EXTERNAL_CLOCK_TYPE_SYMBOL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.TDMA.*
            found = ...
                ( e == attrTdmaClockTypeRangeTable.IVIRFSIGGEN_VAL_TDMA_EXTERNAL_CLOCK_TYPE_BIT) || ...
                ( e == attrTdmaClockTypeRangeTable.IVIRFSIGGEN_VAL_TDMA_EXTERNAL_CLOCK_TYPE_SYMBOL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
