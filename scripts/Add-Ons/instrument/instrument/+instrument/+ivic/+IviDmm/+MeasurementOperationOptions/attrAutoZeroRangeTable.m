classdef attrAutoZeroRangeTable < instrument.internal.DriverBaseClass
    %ATTRAUTOZERORANGETABLE for instrument.ivic.IviDmm.MeasurementOperationOptions class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Disables the DMM from taking any more Zero Readings.  The DMM subtracts  the last Zero Reading from all subsequent values it measures.
        IVIDMM_VAL_AUTO_ZERO_OFF = 0;
        % Configures the DMM to take a Zero Reading for each measurement.  The DMM  subtracts the Zero Reading from the value it measures.
        IVIDMM_VAL_AUTO_ZERO_ON = 1;
        % Configures the DMM to take a Zero Reading immediately.  The DMM then  subtracts this Zero Reading from all subsequent values it measures.
        IVIDMM_VAL_AUTO_ZERO_ONCE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDmm.MeasurementOperationOptions.*
            found = ...
                ( e == attrAutoZeroRangeTable.IVIDMM_VAL_AUTO_ZERO_OFF) || ...
                ( e == attrAutoZeroRangeTable.IVIDMM_VAL_AUTO_ZERO_ON) || ...
                ( e == attrAutoZeroRangeTable.IVIDMM_VAL_AUTO_ZERO_ONCE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
