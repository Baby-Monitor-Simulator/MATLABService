classdef attrVerticalScaleRangeTable < instrument.internal.DriverBaseClass
    %ATTRVERTICALSCALERANGETABLE for instrument.ivic.IviSpecAn.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the vertical scale in linear units.
        IVISPECAN_VAL_VERTICAL_SCALE_LINEAR = 1;
        % Sets the vertical scale in logarithmic units.
        IVISPECAN_VAL_VERTICAL_SCALE_LOGARITHMIC = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.BasicOperation.*
            found = ...
                ( e == attrVerticalScaleRangeTable.IVISPECAN_VAL_VERTICAL_SCALE_LINEAR) || ...
                ( e == attrVerticalScaleRangeTable.IVISPECAN_VAL_VERTICAL_SCALE_LOGARITHMIC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
