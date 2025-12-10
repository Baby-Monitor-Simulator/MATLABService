classdef attrDigitalModulationBasePRBSTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRDIGITALMODULATIONBASEPRBSTYPERANGETABLE for instrument.ivic.IviRFSigGen.DigitalModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Length of PRBS sequence is 2^9 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS9 = 1;
        % Length of PRBS sequence is 2^11 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS11 = 2;
        % Length of PRBS sequence is 2^15 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS15 = 3;
        % Length of PRBS sequence is 2^16 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS16 = 4;
        % Length of PRBS sequence is 2^20 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS20 = 5;
        % Length of PRBS sequence is 2^21 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS21 = 6;
        % Length of PRBS sequence is 2^23 -1.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS23 = 7;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.DigitalModulation.*
            found = ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS9) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS11) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS15) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS16) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS20) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS21) || ...
                ( e == attrDigitalModulationBasePRBSTypeRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_PRBS_TYPE_PRBS23);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
