classdef attrFunctionRangeTable < instrument.internal.DriverBaseClass
    %ATTRFUNCTIONRANGETABLE for instrument.ivic.IviDmm.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % DC Volts
        IVIDMM_VAL_DC_VOLTS = 1;
        % AC Volts
        IVIDMM_VAL_AC_VOLTS = 2;
        % DC Current
        IVIDMM_VAL_DC_CURRENT = 3;
        % AC Current
        IVIDMM_VAL_AC_CURRENT = 4;
        % 2 Wire Resistance
        IVIDMM_VAL_2_WIRE_RES = 5;
        % 4 Wire Resistance
        IVIDMM_VAL_4_WIRE_RES = 101;
        % AC + DC Volts
        IVIDMM_VAL_AC_PLUS_DC_VOLTS = 106;
        % AC + DC Current
        IVIDMM_VAL_AC_PLUS_DC_CURRENT = 107;
        % Frequency
        IVIDMM_VAL_FREQ = 104;
        % Period
        IVIDMM_VAL_PERIOD = 105;
        % Temperature
        IVIDMM_VAL_TEMPERATURE = 108;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.BasicOperation.*
            found = ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_DC_VOLTS) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_AC_VOLTS) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_DC_CURRENT) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_AC_CURRENT) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_2_WIRE_RES) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_4_WIRE_RES) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_AC_PLUS_DC_VOLTS) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_AC_PLUS_DC_CURRENT) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_FREQ) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_PERIOD) || ...
                ( e == attrFunctionRangeTable.IVIDMM_VAL_TEMPERATURE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
