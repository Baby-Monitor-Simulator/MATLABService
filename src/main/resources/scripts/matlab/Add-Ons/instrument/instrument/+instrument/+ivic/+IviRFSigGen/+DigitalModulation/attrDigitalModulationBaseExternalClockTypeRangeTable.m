classdef attrDigitalModulationBaseExternalClockTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRDIGITALMODULATIONBASEEXTERNALCLOCKTYPERANGETABLE for instrument.ivic.IviRFSigGen.DigitalModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The external clock frequency is equal to the bit clock frequency of the  digital modulation.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_EXTERNAL_CLOCK_TYPE_BIT = 1;
        % The external clock frequency is equal to the symbol clock frequency of  the digital modulation.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_EXT_CLOCK_TYPE_SYMBOL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.DigitalModulation.*
            found = ...
                ( e == attrDigitalModulationBaseExternalClockTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_EXTERNAL_CLOCK_TYPE_BIT) || ...
                ( e == attrDigitalModulationBaseExternalClockTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_EXTERNAL_CLOCK_TYPE_SYM);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
