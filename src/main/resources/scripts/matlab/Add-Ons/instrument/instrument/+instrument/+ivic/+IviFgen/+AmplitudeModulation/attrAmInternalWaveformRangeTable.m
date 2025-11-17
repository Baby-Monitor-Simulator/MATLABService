classdef attrAmInternalWaveformRangeTable < instrument.internal.DriverBaseClass
    %ATTRAMINTERNALWAVEFORMRANGETABLE for instrument.ivic.IviFgen.AmplitudeModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the function generator to modulate the carrier signal with a  sinusoid waveform.
        IVIFGEN_VAL_AM_INTERNAL_SINE = 1;
        % Configures the function generator to modulate the carrier signal with a  square waveform.
        IVIFGEN_VAL_AM_INTERNAL_SQUARE = 2;
        % Configures the function generator to modulate the carrier signal with a  triangle waveform.
        IVIFGEN_VAL_AM_INTERNAL_TRIANGLE = 3;
        % Configures the function generator to modulate the carrier signal with a  positive ramp waveform.
        IVIFGEN_VAL_AM_INTERNAL_RAMP_UP = 4;
        % Configures the function generator to modulate the carrier signal with a  negative ramp waveform.
        IVIFGEN_VAL_AM_INTERNAL_RAMP_DOWN = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.AmplitudeModulation.*
            found = ...
                ( e == attrAmInternalWaveformRangeTable.IVIFGEN_VAL_AM_INTERNAL_SINE) || ...
                ( e == attrAmInternalWaveformRangeTable.IVIFGEN_VAL_AM_INTERNAL_SQUARE) || ...
                ( e == attrAmInternalWaveformRangeTable.IVIFGEN_VAL_AM_INTERNAL_TRIANGLE) || ...
                ( e == attrAmInternalWaveformRangeTable.IVIFGEN_VAL_AM_INTERNAL_RAMP_UP) || ...
                ( e == attrAmInternalWaveformRangeTable.IVIFGEN_VAL_AM_INTERNAL_RAMP_DOWN);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
