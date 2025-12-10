classdef attrTempTransducerTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTEMPTRANSDUCERTYPERANGETABLE for instrument.ivic.IviDmm.TemperatureMeasurements class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Thermocouple
        IVIDMM_VAL_THERMOCOUPLE = 1;
        % Thermistor
        IVIDMM_VAL_THERMISTOR = 2;
        % 2-Wire Resistance Temperature Device
        IVIDMM_VAL_2_WIRE_RTD = 3;
        % 4-Wire Resistance Temperature Device
        IVIDMM_VAL_4_WIRE_RTD = 4;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.TemperatureMeasurements.*
            found = ...
                ( e == attrTempTransducerTypeRangeTable.IVIDMM_VAL_THERMOCOUPLE) || ...
                ( e == attrTempTransducerTypeRangeTable.IVIDMM_VAL_THERMISTOR) || ...
                ( e == attrTempTransducerTypeRangeTable.IVIDMM_VAL_2_WIRE_RTD) || ...
                ( e == attrTempTransducerTypeRangeTable.IVIDMM_VAL_4_WIRE_RTD);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
