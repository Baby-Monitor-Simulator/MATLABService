classdef attrAcquisitionTypeRangeTable < instrument.internal.DriverBaseClass
    %ATTRACQUISITIONTYPERANGETABLE for instrument.ivic.IviScope.Acquisition class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Sets the oscilloscope to the normal acquisition mode.  The oscilloscope  acquires one sample for each point in the waveform record.  The oscilloscope  can use real-time or equivalent-time sampling.
        IVISCOPE_VAL_NORMAL = 0;
        % Sets the oscilloscope to the peak-detect acquisition mode.  The oscilloscope  oversamples the input signal and keeps the minimum and maximum values that  correspond to each position in the waveform record.  The oscilloscope uses  only real-time sampling.
        IVISCOPE_VAL_PEAK_DETECT = 1;
        % Sets the oscilloscope to the high-resolution acquisition mode.  The  oscilloscope oversamples the input signal and calculates an average  value for each position in the  waveform record.  The oscilloscope uses only real-time sampling.
        IVISCOPE_VAL_HI_RES = 2;
        % Sets the oscilloscope to the envelope acquisition mode.  The oscilloscope  acquires multiple waveforms and keeps the minimum and maximum voltages it  acquires for each point in the waveform record.  You specify the number of  waveforms the oscilloscope acquires with the  IVISCOPE_ATTR_NUM_ENVELOPES attribute.  The oscilloscope can use  real-time or equivalent-time sampling.
        IVISCOPE_VAL_ENVELOPE = 3;
        % Sets the oscilloscope to the average acquisition mode.  The oscilloscope  acquires multiple waveforms and calculates an average  value for each point in the waveform record.  You specify the number of  waveforms the oscilloscope acquires with the  IVISCOPE_ATTR_NUM_AVERAGES attribute.  The oscilloscope  can use real-time or equivalent-time sampling.
        IVISCOPE_VAL_AVERAGE = 4;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.Acquisition.*
            found = ...
                ( e == attrAcquisitionTypeRangeTable.IVISCOPE_VAL_NORMAL) || ...
                ( e == attrAcquisitionTypeRangeTable.IVISCOPE_VAL_PEAK_DETECT) || ...
                ( e == attrAcquisitionTypeRangeTable.IVISCOPE_VAL_HI_RES) || ...
                ( e == attrAcquisitionTypeRangeTable.IVISCOPE_VAL_ENVELOPE) || ...
                ( e == attrAcquisitionTypeRangeTable.IVISCOPE_VAL_AVERAGE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
