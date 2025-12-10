classdef attrFuncWaveformRangeTable < instrument.internal.DriverBaseClass
    %ATTRFUNCWAVEFORMRANGETABLE for instrument.ivic.IviFgen.StandardFunctionOutput class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the function generator to produce a sinusoid waveform.
        IVIFGEN_VAL_WFM_SINE = 1;
        % Configures the function generator to produce a square waveform.
        IVIFGEN_VAL_WFM_SQUARE = 2;
        % Configures the function generator to produce a triangle waveform.
        IVIFGEN_VAL_WFM_TRIANGLE = 3;
        % Configures the function generator to produce a positive ramp waveform.
        IVIFGEN_VAL_WFM_RAMP_UP = 4;
        % Configures the function generator to produce a negative ramp waveform.
        IVIFGEN_VAL_WFM_RAMP_DOWN = 5;
        % Configures the function generator to produce a constant voltage.
        IVIFGEN_VAL_WFM_DC = 6;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.StandardFunctionOutput.*
            found = ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_SINE) || ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_SQUARE) || ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_TRIANGLE) || ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_RAMP_UP) || ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_RAMP_DOWN) || ...
                ( e == attrFuncWaveformRangeTable.IVIFGEN_VAL_WFM_DC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
