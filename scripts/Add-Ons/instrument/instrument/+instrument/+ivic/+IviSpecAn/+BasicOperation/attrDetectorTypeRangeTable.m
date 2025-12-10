classdef attrDetectorTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRDETECTORTYPERANGETABLE for instrument.ivic.IviSpecAn.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Allows the detector to capture better readings by using both positive and  negative peak values when noise is present.
        IVISPECAN_VAL_DETECTOR_TYPE_AUTO_PEAK = 1;
        % Average value of samples taken within the bin for a dedicated point on  the display.
        IVISPECAN_VAL_DETECTOR_TYPE_AVERAGE = 2;
        % Obtains the maximum video signal between the last display point and the  present display point.
        IVISPECAN_VAL_DETECTOR_TYPE_MAX_PEAK = 3;
        % Obtains the minimum video signal between the last display point and the  present display point.
        IVISPECAN_VAL_DETECTOR_TYPE_MIN_PEAK = 4;
        % Pick one point within a bin.
        IVISPECAN_VAL_DETECTOR_TYPE_SAMPLE = 5;
        % RMS value of samples taken within the bin for a dedicated point on the  display.
        IVISPECAN_VAL_DETECTOR_TYPE_RMS = 6;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.BasicOperation.*
            found = ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_AUTO_PEAK) || ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_AVERAGE) || ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_MAX_PEAK) || ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_MIN_PEAK) || ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_SAMPLE) || ...
                ( e == attrDetectorTypeRangeTable.IVISPECAN_VAL_DETECTOR_TYPE_RMS);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
