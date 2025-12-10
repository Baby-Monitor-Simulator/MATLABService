classdef attrVerticalCouplingRangeTable < instrument.internal.DriverBaseClass
    %ATTRVERTICALCOUPLINGRANGETABLE for instrument.ivic.IviScope.ChannelSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope AC couples the input signal.
        IVISCOPE_VAL_AC = 0;
        % The oscilloscope DC couples the input signal.
        IVISCOPE_VAL_DC = 1;
        % The oscilloscope ground couples the input signal.
        IVISCOPE_VAL_GND = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.ChannelSubsystem.*
            found = ...
                ( e == attrVerticalCouplingRangeTable.IVISCOPE_VAL_AC) || ...
                ( e == attrVerticalCouplingRangeTable.IVISCOPE_VAL_DC) || ...
                ( e == attrVerticalCouplingRangeTable.IVISCOPE_VAL_GND);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
