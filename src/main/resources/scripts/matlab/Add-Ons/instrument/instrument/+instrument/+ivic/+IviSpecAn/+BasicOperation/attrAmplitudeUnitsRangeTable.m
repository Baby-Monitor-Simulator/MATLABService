classdef attrAmplitudeUnitsRangeTable < instrument.internal.DriverBaseClass
    %ATTRAMPLITUDEUNITSRANGETABLE for instrument.ivic.IviSpecAn.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the spectrum Analyzer to measure in decibels relative to 1  milliwatt.
        IVISPECAN_VAL_AMPLITUDE_UNITS_DBM = 1;
        % Sets the spectrum analyzer to measure in decibels relative to 1  millivolt.
        IVISPECAN_VAL_AMPLITUDE_UNITS_DBMV = 2;
        % Sets the spectrum analyzer to measure in decibels relative to 1  microvolt.
        IVISPECAN_VAL_AMPLITUDE_UNITS_DBUV = 3;
        % Sets the spectrum analyzer to measure in volts.
        IVISPECAN_VAL_AMPLITUDE_UNITS_VOLT = 4;
        % Sets the spectrum analyzer to measure in watts.
        IVISPECAN_VAL_AMPLITUDE_UNITS_WATT = 5;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.BasicOperation.*
            found = ...
                ( e == attrAmplitudeUnitsRangeTable.IVISPECAN_VAL_AMPLITUDE_UNITS_DBM) || ...
                ( e == attrAmplitudeUnitsRangeTable.IVISPECAN_VAL_AMPLITUDE_UNITS_DBMV) || ...
                ( e == attrAmplitudeUnitsRangeTable.IVISPECAN_VAL_AMPLITUDE_UNITS_DBUV) || ...
                ( e == attrAmplitudeUnitsRangeTable.IVISPECAN_VAL_AMPLITUDE_UNITS_VOLT) || ...
                ( e == attrAmplitudeUnitsRangeTable.IVISPECAN_VAL_AMPLITUDE_UNITS_WATT);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
