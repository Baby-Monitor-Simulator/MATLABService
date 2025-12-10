classdef attrDigitalModulationBaseClockSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRDIGITALMODULATIONBASECLOCKSOURCERANGETABLE for instrument.ivic.IviRFSigGen.DigitalModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % An internal clock generator is used.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_CLOCK_SOURCE_INTERNAL = 1;
        % A connected external clock generator bit or symbol clock frequency is  used.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_CLOCK_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.DigitalModulation.*
            found = ...
                ( e == attrDigitalModulationBaseClockSourceRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_CLOCK_SOURCE_INTERNAL) || ...
                ( e == attrDigitalModulationBaseClockSourceRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_CLOCK_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
