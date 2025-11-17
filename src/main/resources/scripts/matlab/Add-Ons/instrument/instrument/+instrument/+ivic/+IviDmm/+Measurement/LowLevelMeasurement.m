classdef LowLevelMeasurement < instrument.ivic.IviGroupBase
    %LOWLEVELMEASUREMENT The class contains functions that give
    %low-level control over how the DMM takes measurements.  The
    %functions perform the following operations:  - initiate the
    %measurement process, - send a software trigger,  - fetch
    %measurement values, and  - abort the measurement process.
    %
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Initiate(obj)
            %INITIATE This function initiates a measurement.  After you
            %call this function, the DMM leaves the Idle state and waits
            %for a trigger.  Notes:  (1) This function does not check
            %the instrument status.   Typically, you call this function
            %only in a sequence of calls to other low-level driver
            %functions.  The sequence performs one operation.  You use
            %the low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviDmm_error_query function at
            %the conclusion of the sequence.  (2) This function performs
            %interchangeability checking when the
            %IVIDMM_ATTR_INTERCHANGE_CHECK attribute is set to True.  If
            %the IVIDMM_ATTR_SPY attribute is set to True, you use the
            %NI Spy utility to view interchangeability warnings.  You
            %use the IviDmm_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVIDMM_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVIDMM_ATTR_INTERCHANGE_CHECK attribute.
            %(3) The class driver initiates a simulated measurement when
            %this  function is called and the IVIDMM_ATTR_SIMULATE
            %attribute is set to True and the
            %IVIDMM_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_Initiate', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the DMM.  Call this function if you pass
            %IVIDMM_VAL_SOFTWARE_TRIG for the Trigger Source parameter
            %of the IviDmm_ConfigureTrigger function or the Sample
            %Trigger parameter of the IviDmm_ConfigureMultiPoint
            %function.  Notes:  (1) This function is part of the
            %IviDmmSoftwareTrigger [SWT] extension group.  (2) If
            %neither the IVIDMM_ATTR_TRIGGER_SOURCE nor the
            %IVIDMM_ATTR_SAMPLE_TRIGGER attribute is set to the
            %IVIDMM_VAL_SOFTWARE_TRIG value, this function returns an
            %error.  (3) This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  You use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviDmm_error_query function at the
            %conclusion of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Reading = Fetch(obj,MaximumTimems)
            %FETCH This function returns the value from a previously
            %initiated measurement.  You must first call the
            %IviDmm_Initiate function to initiate a measurement before
            %calling this function.  Notes:  (1) After this function
            %executes, the Reading parameter contains  an actual reading
            %or a value indicating that an over-range condition
            %occurred.  (2) If an over-range condition occurs, the
            %Reading parameter contains an IEEE defined NaN (Not a
            %Number) value and the function returns
            %IVIDMM_WARN_OVER_RANGE (0x3FFA2001).    (3) You can test
            %the measurement value for an over-range condition by
            %calling the IviDmm_IsOverRange function.  (4) The class
            %driver returns a simulated measurement when this  function
            %is called and the IVIDMM_ATTR_SIMULATE attribute is set to
            %True and the IVIDMM_ATTR_USE_SPECIFIC_SIMULATION attribute
            %is set to False.  For information on how to configure a
            %simulated measurement, refer to the online help manual.
            %(5) This function does not check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviDmm_error_query function at the conclusion of
            %the sequence.
            
            narginchk(2,2)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Reading = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviDmm_Fetch', session, MaximumTimems, Reading);
                
                Reading = Reading.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ReadingArray,ActualNumberofPoints] = FetchMultiPoint(obj,MaximumTimems,ArraySize,ReadingArray)
            %FETCHMULTIPOINT This function returns an array of values
            %from a previously initiated multi-point measurement.  The
            %number of measurements the DMM takes is determined by the
            %values you specify for the Trigger Count and Sample Count
            %parameters of the IviDmm_ConfigureMultiPoint function.  You
            %must first call the IviDmm_Initiate function to initiate a
            %measurement before calling this function.  Notes:  (1) This
            %function is part of the IviDmmMultiPoint [MP] extension
            %group.  (2) After this function executes, each element in
            %the Reading Array parameter is an actual reading or a value
            %indicating that an over-range condition occurred.  (3) If
            %an over-range condition occurs, the corresponding Reading
            %Array element contains an IEEE defined NaN (Not a Number)
            %value and the function returns IVIDMM_WARN_OVER_RANGE
            %(0x3FFA2001).   (4) You can test each element in the
            %Reading Array parameter for over-range with the
            %IviDmm_IsOverRange function.  (5) The class driver returns
            %a simulated measurement when this  function is called and
            %the IVIDMM_ATTR_SIMULATE attribute is set to True and the
            %IVIDMM_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.  (6) This
            %function does not check the instrument status.   Typically,
            %you call this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviDmm_error_query function at the conclusion of the
            %sequence.
            
            narginchk(4,4)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            ArraySize = obj.checkScalarInt32Arg(ArraySize);
            ReadingArray = obj.checkVectorDoubleArg(ReadingArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ReadingArray = libpointer('doublePtr', ReadingArray);
                ActualNumberofPoints = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviDmm_FetchMultiPoint', session, MaximumTimems, ArraySize, ReadingArray, ActualNumberofPoints);
                
                ReadingArray = ReadingArray.Value;
                ActualNumberofPoints = ActualNumberofPoints.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Abort(obj)
            %ABORT This function aborts a previously initiated
            %measurement and returns the DMM to the Idle state.  Notes:
            %(1) This function does not check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviDmm_error_query function at the conclusion of
            %the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviDmm_Abort', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function IsOverRange = IsOverRange(obj,MeasurementValue)
            %ISOVERRANGE This function takes a measurement value that
            %you obtain from one of the Read or Fetch functions and
            %determines if the value is a valid measurement value or a
            %value indicating an over-range condition occurred.
            %Notes:  (1) If an over-range condition occurs, the
            %measurement value contains an IEEE defined NaN (Not a
            %Number) value.
            
            narginchk(2,2)
            MeasurementValue = obj.checkScalarDoubleArg(MeasurementValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                IsOverRange = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviDmm_IsOverRange', session, MeasurementValue, IsOverRange);
                
                IsOverRange = IsOverRange.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
