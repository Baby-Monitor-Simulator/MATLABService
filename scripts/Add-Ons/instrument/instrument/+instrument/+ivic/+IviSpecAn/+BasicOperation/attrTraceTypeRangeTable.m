classdef attrTraceTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRTRACETYPERANGETABLE for instrument.ivic.IviSpecAn.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the spectrum analyzer to clear previous sweep data off the display  before performing a sweep.  Subsequent sweeps may or may not clear the  display first, but the data array at the end of the sweep is entirely  new.
        IVISPECAN_VAL_TRACE_TYPE_CLEAR_WRITE = 1;
        % Sets the spectrum analyzer to keep the data from either the previous data  or the new sweep data, which ever is higher.
        IVISPECAN_VAL_TRACE_TYPE_MAX_HOLD = 2;
        % Sets the spectrum analyzer to keep the data from either the previous data  or the new sweep data, which ever is lower.
        IVISPECAN_VAL_TRACE_TYPE_MIN_HOLD = 3;
        % Sets the spectrum analyzer to maintain a running average of the swept  data.
        IVISPECAN_VAL_TRACE_TYPE_VIDEO_AVERAGE = 4;
        % Disables acquisition into this trace but displays the existing trace  data.
        IVISPECAN_VAL_TRACE_TYPE_VIEW = 5;
        % Disables acquisition and disables the display of the existing trace  data.
        IVISPECAN_VAL_TRACE_TYPE_STORE = 6;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSpecAn.BasicOperation.*
            found = ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_CLEAR_WRITE) || ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_MAX_HOLD) || ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_MIN_HOLD) || ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_VIDEO_AVERAGE) || ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_VIEW) || ...
                ( e == attrTraceTypeRangeTable.IVISPECAN_VAL_TRACE_TYPE_STORE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
