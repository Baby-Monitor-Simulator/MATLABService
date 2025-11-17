classdef attrFrequencyStepScalingRangeTable < instrument.internal.DriverBaseClass
    %ATTRFREQUENCYSTEPSCALINGRANGETABLE for instrument.ivic.IviRFSigGen.Sweep.FrequencyStep class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Enables linear scaling.
        IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LINEAR = 1;
        % Enables logarithmic scaling.
        IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LOGARITHMIC = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.Sweep.FrequencyStep.*
            found = ...
                ( e == attrFrequencyStepScalingRangeTable.IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LINEAR) || ...
                ( e == attrFrequencyStepScalingRangeTable.IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LOGARITHMIC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
