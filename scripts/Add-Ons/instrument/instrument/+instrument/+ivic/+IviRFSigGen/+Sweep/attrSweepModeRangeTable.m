classdef attrSweepModeRangeTable < instrument.internal.DriverBaseClass
    %ATTRSWEEPMODERANGETABLE for instrument.ivic.IviRFSigGen.Sweep class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The RF output of the signal generator is a non-swept signal Continuous  Wave. Frequency and power level from base capability group is used.
        IVIRFSIGGEN_VAL_SWEEP_MODE_NONE = 1;
        % The signal generator sweeps the RF output signal's frequency in an analog  form non-stepped.
        IVIRFSIGGEN_VAL_SWEEP_MODE_FREQUENCY_SWEEP = 2;
        % The signal generator sweeps the RF output signal's power level in an  analog form non-stepped.
        IVIRFSIGGEN_VAL_SWEEP_MODE_POWER_SWEEP = 3;
        % The signal generator sweeps the RF output signals frequency in steps.
        IVIRFSIGGEN_VAL_SWEEP_MODE_FREQUENCY_STEP = 4;
        % The signal generator sweeps the RF output signals power level in steps.
        IVIRFSIGGEN_VAL_SWEEP_MODE_POWER_STEP = 5;
        % The signal generator uses two lists with frequency and power level values  to sweep the RF output signals.
        IVIRFSIGGEN_VAL_SWEEP_MODE_LIST = 6;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.Sweep.*
            found = ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_NONE) || ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_FREQUENCY_SWEEP) || ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_POWER_SWEEP) || ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_FREQUENCY_STEP) || ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_POWER_STEP) || ...
                ( e == attrSweepModeRangeTable.IVIRFSIGGEN_VAL_SWEEP_MODE_LIST);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
