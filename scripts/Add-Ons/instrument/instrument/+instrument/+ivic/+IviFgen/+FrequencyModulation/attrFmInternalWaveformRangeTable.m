classdef attrFmInternalWaveformRangeTable < instrument.internal.DriverBaseClass
    %ATTRFMINTERNALWAVEFORMRANGETABLE for instrument.ivic.IviFgen.FrequencyModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the function generator to modulate the carrier signal with a  sinusoid waveform.
        IVIFGEN_VAL_FM_INTERNAL_SINE = 1;
        % Configures the function generator to modulate the carrier signal with a  square waveform.
        IVIFGEN_VAL_FM_INTERNAL_SQUARE = 2;
        % Configures the function generator to modulate the carrier signal with a  triangle waveform.
        IVIFGEN_VAL_FM_INTERNAL_TRIANGLE = 3;
        % Configures the function generator to modulate the carrier signal with a  positive ramp waveform.
        IVIFGEN_VAL_FM_INTERNAL_RAMP_UP = 4;
        % Configures the function generator to modulate the carrier signal with a  negative ramp waveform.
        IVIFGEN_VAL_FM_INTERNAL_RAMP_DOWN = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.FrequencyModulation.*
            found = ...
                ( e == attrFmInternalWaveformRangeTable.IVIFGEN_VAL_FM_INTERNAL_SINE) || ...
                ( e == attrFmInternalWaveformRangeTable.IVIFGEN_VAL_FM_INTERNAL_SQUARE) || ...
                ( e == attrFmInternalWaveformRangeTable.IVIFGEN_VAL_FM_INTERNAL_TRIANGLE) || ...
                ( e == attrFmInternalWaveformRangeTable.IVIFGEN_VAL_FM_INTERNAL_RAMP_UP) || ...
                ( e == attrFmInternalWaveformRangeTable.IVIFGEN_VAL_FM_INTERNAL_RAMP_DOWN);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
