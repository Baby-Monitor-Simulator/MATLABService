classdef attrLfGeneratorWaveformRangeTable < instrument.internal.DriverBaseClass
    %ATTRLFGENERATORWAVEFORMRANGETABLE for instrument.ivic.IviRFSigGen.LFGenerator class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the LF generator to produce a sinusoidal waveform.
        IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_SINE = 1;
        % Configures the LF generator to produce a square waveform.
        IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_SQUARE = 2;
        % Configures the LF generator to produce a triangle waveform.
        IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_TRIANGLE = 3;
        % Configures the LF generator to produce a rising ramp waveform.
        IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_RAMP_UP = 4;
        % Configures the LF generator to produce a falling ramp waveform.
        IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_RAMP_DOWN = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.LFGenerator.*
            found = ...
                ( e == attrLfGeneratorWaveformRangeTable.IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_SINE) || ...
                ( e == attrLfGeneratorWaveformRangeTable.IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_SQUARE) || ...
                ( e == attrLfGeneratorWaveformRangeTable.IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_TRIANGLE) || ...
                ( e == attrLfGeneratorWaveformRangeTable.IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_RAMP_UP) || ...
                ( e == attrLfGeneratorWaveformRangeTable.IVIRFSIGGEN_VAL_LF_GENERATOR_WAVEFORM_RAMP_DOWN);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
