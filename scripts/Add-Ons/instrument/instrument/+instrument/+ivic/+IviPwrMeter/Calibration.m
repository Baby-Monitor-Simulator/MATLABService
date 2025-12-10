classdef Calibration < instrument.ivic.IviGroupBase
    %CALIBRATION This class contains functions to perform the
    %calibration.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Calibrate(obj,ChannelName)
            %CALIBRATE This function performs calibration on the
            %specified sensor. This function returns only after the
            %sensor has been calibrated.  You may use the
            %IviPwrMeter_IsCalibrationComplete function to determine
            %when the calibration is complete.
            
            narginchk(2,2)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_Calibrate', session, ChannelName);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function CalibrationStatus = IsCalibrationComplete(obj)
            %ISCALIBRATIONCOMPLETE This function queries the instrument
            %to determine the status of all calibration operations
            %initiated by the IviPwrMeter_Calibrate function. This
            %function returns the IVIPWRMETER_VAL_CALIBRATION_COMPLETE
            %(1) value in the Status parameter only when calibration is
            %complete on all channels.  If some calibration operations
            %are still in progress on one or more channels, the driver
            %returns the IVIPWRMETER_VAL_CALIBRATION_IN_PROGRESS (0)
            %value. If the driver cannot query the instrument to
            %determine its state, the driver returns the
            %IVIPWRMETER_VAL_CALIBRATION_STATUS_UNKNOWN (-1) value.
            %Note:  This function does not check the instrument status.
            % Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviPwrMeter_error_query function at the conclusion
            %of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                CalibrationStatus = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviPwrMeter_IsCalibrationComplete', session, CalibrationStatus);
                
                CalibrationStatus = CalibrationStatus.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
