classdef attrPulseOutputPolarityRangeTable < instrument.internal.DriverBaseClass
    %ATTRPULSEOUTPUTPOLARITYRANGETABLE for instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Specifies normal polarity.
        IVIRFSIGGEN_VAL_PULSE_OUTPUT_POLARITY_NORMAL = 1;
        % Specifies inverted polarity.
        IVIRFSIGGEN_VAL_PULSE_OUTPUT_POLARITY_INVERSE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput.*
            found = ...
                ( e == attrPulseOutputPolarityRangeTable.IVIRFSIGGEN_VAL_PULSE_OUTPUT_POLARITY_NORMAL) || ...
                ( e == attrPulseOutputPolarityRangeTable.IVIRFSIGGEN_VAL_PULSE_OUTPUT_POLARITY_INVERSE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
