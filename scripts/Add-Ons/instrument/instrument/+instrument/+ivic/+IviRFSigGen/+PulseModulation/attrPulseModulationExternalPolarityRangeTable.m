classdef attrPulseModulationExternalPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRPULSEMODULATIONEXTERNALPOLARITYRANGETABLE for instrument.ivic.IviRFSigGen.PulseModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The signal generator modulates the carrier signal with normal pulse  polarity.
        IVIRFSIGGEN_VAL_PULSE_MODULATION_EXTERNAL_POLARITY_NORMAL = 1;
        % The signal generator modulates the carrier signal with inverted pulse  polarity.
        IVIRFSIGGEN_VAL_PULSE_MODULATION_EXTERNAL_POLARITY_INVERSE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseModulation.*
            found = ...
                ( e == attrPulseModulationExternalPolarityRangeTable.IVIRFSIGGEN_VAL_PULSE_MODULATION_EXTERNAL_POLARITY_NORMAL) || ...
                ( e == attrPulseModulationExternalPolarityRangeTable.IVIRFSIGGEN_VAL_PULSE_MODULATION_EXTERNAL_POLARITY_INVERSE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
