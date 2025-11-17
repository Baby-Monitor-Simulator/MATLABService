classdef attrAmScalingRangeTable < instrument.internal.DriverBaseClass
    %ATTRAMSCALINGRANGETABLE for instrument.ivic.IviRFSigGen.AnalogModulation.AM class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Enables linear attenuation for amplitude modulation.
        IVIRFSIGGEN_VAL_AM_SCALING_LINEAR = 1;
        % Enables logarithmic attenuation for amplitude modulation.
        IVIRFSIGGEN_VAL_AM_SCALING_LOGARITHMIC = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.AnalogModulation.AM.*
            found = ...
                ( e == attrAmScalingRangeTable.IVIRFSIGGEN_VAL_AM_SCALING_LINEAR) || ...
                ( e == attrAmScalingRangeTable.IVIRFSIGGEN_VAL_AM_SCALING_LOGARITHMIC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
