classdef attrTempTcRefJuncTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTEMPTCREFJUNCTYPERANGETABLE for instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Internal Sensor
        IVIDMM_VAL_TEMP_REF_JUNC_INTERNAL = 1;
        % Fixed Value
        IVIDMM_VAL_TEMP_REF_JUNC_FIXED = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.TemperatureMeasurements.Thermocouple.*
            found = ...
                ( e == attrTempTcRefJuncTypeRangeTable.IVIDMM_VAL_TEMP_REF_JUNC_INTERNAL) || ...
                ( e == attrTempTcRefJuncTypeRangeTable.IVIDMM_VAL_TEMP_REF_JUNC_FIXED);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
