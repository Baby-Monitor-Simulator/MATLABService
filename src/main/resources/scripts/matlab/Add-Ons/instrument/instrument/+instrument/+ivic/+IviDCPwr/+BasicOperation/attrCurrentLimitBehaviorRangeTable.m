classdef attrCurrentLimitBehaviorRangeTable < instrument.internal.DriverBaseClass
    %ATTRCURRENTLIMITBEHAVIORRANGETABLE for instrument.ivic.IviDCPwr.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % When the output current reaches the value of the  IVIDCPWR_ATTR_CURRENT_LIMIT attribute, the power supply  regulates the output current at that value.
        IVIDCPWR_VAL_CURRENT_REGULATE = 0;
        % When the output current reaches or exceeds the value of the  IVIDCPWR_ATTR_CURRENT_LIMIT attribute, the power supply  disables the output.
        IVIDCPWR_VAL_CURRENT_TRIP = 1;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDCPwr.BasicOperation.*
            found = ...
                ( e == attrCurrentLimitBehaviorRangeTable.IVIDCPWR_VAL_CURRENT_REGULATE) || ...
                ( e == attrCurrentLimitBehaviorRangeTable.IVIDCPWR_VAL_CURRENT_TRIP);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
