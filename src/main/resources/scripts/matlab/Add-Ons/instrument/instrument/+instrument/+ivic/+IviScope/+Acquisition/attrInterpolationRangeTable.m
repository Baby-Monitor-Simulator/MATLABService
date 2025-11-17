classdef attrInterpolationRangeTable < instrument.internal.DriverBaseClass
    %ATTRINTERPOLATIONRANGETABLE for instrument.ivic.IviScope.Acquisition class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The oscilloscope does not interpolate points in the waveform.   Instead, the driver sets every element in the waveform array for which the  oscilloscope cannot resolve a value to  an IEEE defined NaN Not a Number value.
        IVISCOPE_VAL_NO_INTERPOLATION = 1;
        % sinx/x interpolation
        IVISCOPE_VAL_SINE_X = 2;
        % Linear interpolation
        IVISCOPE_VAL_LINEAR = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.Acquisition.*
            found = ...
                ( e == attrInterpolationRangeTable.IVISCOPE_VAL_NO_INTERPOLATION) || ...
                ( e == attrInterpolationRangeTable.IVISCOPE_VAL_SINE_X) || ...
                ( e == attrInterpolationRangeTable.IVISCOPE_VAL_LINEAR);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
