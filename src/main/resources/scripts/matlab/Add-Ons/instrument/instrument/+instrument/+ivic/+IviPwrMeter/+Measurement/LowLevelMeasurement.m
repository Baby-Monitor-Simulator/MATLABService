classdef LowLevelMeasurement < instrument.ivic.IviGroupBase
    %LOWLEVELMEASUREMENT The class contains functions that give
    %low-level control over how the Power Meter takes
    %measurements.  The functions perform the following
    %operations:  - initiate the measurement process, - send a
    %software trigger,  - fetch measurement values, and  - abort
    %the measurement process.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Initiate(obj)
            %INITIATE This function initiates a measurement on all
            %enabled channels. When this function executes, the power
            %meter leaves the Idle state and takes a measurement on all
            %enabled channels. Use the IviPwrMeter_Fetch or
            %IviPwrMeter_FetchChannel function to obtain the result of
            %the measurements.  Notes:  (1) This function does not check
            %the instrument status.   Typically, you call this function
            %only in a sequence of calls to other low-level driver
            %functions.  The sequence performs one operation.  You use
            %the low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviPwrMeter_error_query
            %function at the conclusion of the sequence.  (2) This
            %function performs interchangeability checking when the
            %IVIPWRMETER_ATTR_INTERCHANGE_CHECK attribute is set to
            %True.  You may use the NI Spy utility to view
            %interchangeability warnings.  Alternatively, you may use
            %the IviPwrMeter_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings.  For information on
            %interchangeability checking, refer to the online help
            %manual.  (3) The class driver initiates a simulated
            %measurement when this function is called and the
            %IVIPWRMETER_ATTR_SIMULATE attribute is set to True and the
            %IVIPWRMETER_ATTR_USE_SPECIFIC_SIMULATION attribute is set
            %to False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_Initiate', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MeasurementStatus = IsMeasurementComplete(obj)
            %ISMEASUREMENTCOMPLETE This function queries the instrument
            %to determine the status of the measurement initiated by the
            %IviPwrMeter_Initiate function. This function returns the
            %IVIPWRMETER_VAL_MEAS_COMPLETE (1) value  in the Status
            %parameter only when measurements are complete on all
            %enabled channels.  If some measurements are still in
            %progress on one or more channels, the driver returns the
            %IVIPWRMETER_VAL_MEAS_IN_PROGRESS (0) value. If the driver
            %cannot query the instrument to determine its state, the
            %driver returns the IVIPWRMETER_VAL_MEAS_STATUS_UNKNOWN (-1)
            %value.  Note:  This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  You use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviPwrMeter_error_query function at the
            %conclusion of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MeasurementStatus = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviPwrMeter_IsMeasurementComplete', session, MeasurementStatus);
                
                MeasurementStatus = MeasurementStatus.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Reading = Fetch(obj)
            %FETCH This function returns the result from a previously
            %initiated single or dual channel measurement. Call the
            %IviPwrMeter_Initiate function to initiate a measurement
            %before calling this function. After this function executes,
            %the value of the Reading parameter depends on the math
            %operation specified in the IviPwrMeter_ConfigureMeasurement
            %function.  Notes:  (1) This function does not check the
            %instrument status.   Typically, you call this function only
            %in a sequence of calls to other low-level driver functions.
            % The sequence performs one operation.  You use the
            %low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviPwrMeter_error_query
            %function at the conclusion of the sequence.  (2) If an
            %out-of-range condition occurs on one or more enabled
            %channels, the result is a value indicating that an out of
            %range condition occurred. In such a case, the Reading
            %parameter contains an IEEE defined -Inf (Negative Infinity)
            %or +Inf (Positive Infinity) value and the function returns
            %the Under Range (0x3FFA2001) or Over Range (0x3FFA2002)
            %warning. Test if the measurement value is out of range with
            %the IviPwrMeter_QueryResultRangeType function.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviPwrMeter_Fetch', session, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Reading = FetchChannel(obj,ChannelName)
            %FETCHCHANNEL This function returns the result from a
            %previously initiated measurement on a specified channel.
            %Call the IviPwrMeter_Initiate function to initiate a
            %measurement before calling this function.  After this
            %function executes, the Reading parameter contains an actual
            %reading on the channel specified by the Channel parameter.
            %If the specified channel is not enabled for measurement,
            %this function returns the Channel Not Enabled (0xBFFA2001)
            %error. The result is in the same unit as the value of the
            %Units attribute.  Notes:  (1) This function does not check
            %the instrument status.   Typically, you call this function
            %only in a sequence of calls to other low-level driver
            %functions.  The sequence performs one operation.  You use
            %the low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviPwrMeter_error_query
            %function at the conclusion of the sequence.  (2) If an out
            %of range condition occurs, the result is a value indicating
            %that an out-of-range condition occurred. In such a case,
            %the Reading parameter contains an IEEE defined -Inf
            %(Negative Infinity) or +Inf (Positive Infinity) value and
            %the function returns the Under Range (0x3FFA2001) or Over
            %Range (0x3FFA2002) warning. Test if the measurement value
            %is out of range with the IviPwrMeter_QueryResultRangeType
            %function.
            
            narginchk(2,2)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviPwrMeter_FetchChannel', session, ChannelName, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function RangeType = QueryResultRangeType(obj,MeasurementValue)
            %QUERYRESULTRANGETYPE This function takes a measurement
            %value that is returned from one of the Fetch, Fetch
            %Channel, Read, or Read Channel functions and determines if
            %the value is a valid measurement value or a value
            %indicating that an out-of-range condition occurred.
            
            narginchk(2,2)
            MeasurementValue = obj.checkScalarDoubleArg(MeasurementValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                RangeType = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviPwrMeter_QueryResultRangeType', session, MeasurementValue, RangeType);
                
                RangeType = RangeType.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Abort(obj)
            %ABORT  This function aborts all previously initiated
            %measurements and returns the power meter to the Idle state.
            % You initiate measurement with the IviPwrMeter_Initiate
            %function.  Notes:   (1) This function does not check the
            %instrument status.   Typically, you call this function only
            %in a sequence of calls to other low-level driver functions.
            % The sequence performs one operation.  You use the
            %low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviPwrMeter_error_query
            %function at the conclusion of the sequence.   (2) If the
            %instrument cannot abort an initiated acquisition, this
            %function returns the IVI_ERROR_FUNCTION_NOT_SUPPORTED
            %error.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_Abort', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the power meter.  Call this function if you pass
            %IVIPWRMETER_VAL_SOFTWARE_TRIG for the
            %IVIPWRMETER_ATTR_TRIGGER_SOURCE attribute or the Trigger
            %Source parameter of the IviPwrMeter_ConfigureTriggerSource
            %function.  Notes:  (1) If the
            %IVIPWRMETER_ATTR_TRIGGER_SOURCE is not set to the
            %IVIPWRMETER_VAL_SOFTWARE_TRIG value, this function returns
            %a Trigger Not Software (0xBFFA1001) error.  (2) This
            %function does not check the instrument status.   Typically,
            %you call this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviPwrMeter_error_query function at the conclusion of the
            %sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
