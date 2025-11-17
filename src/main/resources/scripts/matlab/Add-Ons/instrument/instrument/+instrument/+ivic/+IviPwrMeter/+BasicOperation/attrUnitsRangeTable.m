classdef attrUnitsRangeTable < instrument.internal.DriverBaseClass
    %ATTRUNITSRANGETABLE for instrument.ivic.IviPwrMeter.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the units to dBm.
        IVIPWRMETER_VAL_DBM = 1;
        % Sets the units to dB millivolts.
        IVIPWRMETER_VAL_DBMV = 2;
        % Sets the units to dB microvolts.
        IVIPWRMETER_VAL_DBUV = 3;
        % Sets the units to Watts.
        IVIPWRMETER_VAL_WATTS = 4;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviPwrMeter.BasicOperation.*
            found = ...
                ( e == attrUnitsRangeTable.IVIPWRMETER_VAL_DBM) || ...
                ( e == attrUnitsRangeTable.IVIPWRMETER_VAL_DBMV) || ...
                ( e == attrUnitsRangeTable.IVIPWRMETER_VAL_DBUV) || ...
                ( e == attrUnitsRangeTable.IVIPWRMETER_VAL_WATTS);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
