classdef attrTempTcTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTEMPTCTYPERANGETABLE for instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % B-type
        IVIDMM_VAL_TEMP_TC_B = 1;
        % C-type
        IVIDMM_VAL_TEMP_TC_C = 2;
        % D-type
        IVIDMM_VAL_TEMP_TC_D = 3;
        % E-type
        IVIDMM_VAL_TEMP_TC_E = 4;
        % G-type
        IVIDMM_VAL_TEMP_TC_G = 5;
        % J-type
        IVIDMM_VAL_TEMP_TC_J = 6;
        % K-type
        IVIDMM_VAL_TEMP_TC_K = 7;
        % N-type
        IVIDMM_VAL_TEMP_TC_N = 8;
        % R-type
        IVIDMM_VAL_TEMP_TC_R = 9;
        % S-type
        IVIDMM_VAL_TEMP_TC_S = 10;
        % T-type
        IVIDMM_VAL_TEMP_TC_T = 11;
        % U-type
        IVIDMM_VAL_TEMP_TC_U = 12;
        % V-type
        IVIDMM_VAL_TEMP_TC_V = 13;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple.*
            found = ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_B) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_C) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_D) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_E) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_G) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_J) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_K) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_N) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_R) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_S) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_T) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_U) || ...
                ( e == attrTempTcTypeRangeTable.IVIDMM_VAL_TEMP_TC_V);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
