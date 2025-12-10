classdef LowlevelAcquisition < instrument.ivic.IviGroupBase
    %LOWLEVELACQUISITION The class contains functions that give
    %low-level control over how the oscilloscope acquires
    %waveforms and waveform measurements.  The functions perform
    %the following operations:  - intiate an acquisition - send
    %a software trigger - return the status of acquisition  -
    %fetch a waveform or waveform measurement - abort an
    %acquisition
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function InitiateAcquisition(obj)
            %INITIATEACQUISITION This function initiates a waveform
            %acquisition.  After you call this function, the
            %oscilloscope leaves the Idle state and waits for a trigger.
            % The oscilloscope acquires a waveform for each channel you
            %have enabled with the  IviScope_ConfigureChannel function.
            %Notes:  (1) This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  You use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviScope_error_query function at the
            %conclusion of the sequence.  (2) This function performs
            %interchangeability checking when the
            %IVISCOPE_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %If the IVISCOPE_ATTR_SPY attribute is set to True, you use
            %the NI Spy utility to view interchangeability warnings.
            %You use the IviScope_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVISCOPE_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVISCOPE_ATTR_INTERCHANGE_CHECK
            %attribute.  (3) The class driver performs a simulated
            %waveform acquisition when this function is called and the
            %IVISCOPE_ATTR_SIMULATE attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %waveform, refer to the online help manual.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_InitiateAcquisition', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AcquisitionStatus = AcquisitionStatus(obj)
            %ACQUISITIONSTATUS This function returns whether an
            %acquisition is in progress, complete, or if the status is
            %unknown.  Notes:  (1) This function does not check the
            %instrument error status.   Typically, you call this
            %function only in a sequence of calls to other low-level
            %driver functions.  The sequence performs one operation.
            %You use the low-level functions to optimize one or more
            %aspects of interaction with the instrument.  If you want to
            %check the instrument status, call the IviScope_error_query
            %function at the conclusion of the sequence.  (2) If the
            %instrument cannot return its acquisition status, this
            %function returns the IVISCOPE_VAL_ACQ_STATUS_UNKNOWN value.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                AcquisitionStatus = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviScope_AcquisitionStatus', session, AcquisitionStatus);
                
                AcquisitionStatus = AcquisitionStatus.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [WaveformArray,ActualPoints,InitialX,XIncrement] = FetchWaveform(obj,ChannelName,WaveformSize,WaveformArray)
            %FETCHWAVEFORM This function returns the waveform the
            %oscilloscope acquires for the channel you specify.  The
            %waveform is from an acquisition that you initiate prior to
            %calling this function.  You use the
            %IviScope_InitiateAcquisition function to start an
            %acquisition on the channels that you enable with the
            %IviScope_ConfigureChannel function.  The oscilloscope
            %acquires waveforms for the enabled channels concurrently.
            %You use the IviScope_AcquisitionStatus function to
            %determine when the acquisition is complete.  You must call
            %this function separately for each enabled channel to obtain
            %the waveforms.  You can call the IviScope_ReadWaveform
            %function instead of the IviScope_InitiateAcquisition
            %function.  The IviScope_ReadWaveform function starts an
            %acquisition on all enabled channels, waits for the
            %acquisition to complete, and returns the waveform for the
            %channel you specify.  You call this function to obtain the
            %waveforms for each of the remaining channels.  Notes:  (1)
            %After this function executes, each element in the Waveform
            %Array parameter is either a voltage or a value indicating
            %that the oscilloscope could not sample a voltage.  (2) You
            %configure the interpolation method the oscilloscope uses
            %with the IviScope_ConfigureInterpolation function.  If you
            %disable interpolation, the oscilloscope does not
            %interpolate points in the waveform.  If the oscilloscope
            %cannot sample a value for a point in the waveform, the
            %driver sets the corresponding element in the Waveform Array
            %to an IEEE defined NaN (Not a Number) value and the
            %function returns IVISCOPE_WARN_INVALID_WFM_ELEMENT.    (3)
            %You can test a waveform value for an invalid value
            %condition by calling the IviScope_IsInvalidWfmElement
            %function.  (4) This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  You use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviScope_error_query function at the
            %conclusion of the sequence.  (5) The class driver returns a
            %simulated waveform when this function is called and the
            %IVISCOPE_ATTR_SIMULATE attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %waveform, refer to the online help manual.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            WaveformSize = obj.checkScalarInt32Arg(WaveformSize);
            WaveformArray = obj.checkVectorDoubleArg(WaveformArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                WaveformArray = libpointer('doublePtr', WaveformArray);
                ActualPoints = libpointer('int32Ptr', 0);
                InitialX = libpointer('doublePtr', 0);
                XIncrement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_FetchWaveform', session, ChannelName, WaveformSize, WaveformArray, ActualPoints, InitialX, XIncrement);
                
                WaveformArray = WaveformArray.Value;
                ActualPoints = ActualPoints.Value;
                InitialX = InitialX.Value;
                XIncrement = XIncrement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [MinWaveformArray,MaxWaveformArray,ActualPoints,InitialX,XIncrement] = FetchMinMaxWaveform(obj,ChannelName,WaveformSize,MinWaveformArray,MaxWaveformArray)
            %FETCHMINMAXWAVEFORM This function returns the minimum and
            %maximum waveforms that the oscilloscope acquires for the
            %channel you specify.  If the channel is not enabled for the
            %acquisition, this function returns
            %IVISCOPE_ERROR_CHANNEL_NOT_ENABLED error.  The waveforms
            %are from an acquisition that you previously initiated.  Use
            %this function to fetch waveforms when you set the
            %acquisition type to IVISCOPE_VAL_PEAK_DETECT or
            %IVISCOPE_VAL_ENVELOPE.  If the acquisition type is not one
            %of the listed types, the function returns the
            %IVISCOPE_ERROR_INVALID_ACQ_TYPE error.  Use the
            %IviScope_InitiateAcquisition function to start an
            %acquisition on the channels that you enable with the
            %IviScope_ConfigureChannel function.  The oscilloscope
            %acquires the min/max waveforms for the enabled channels
            %concurrently. You use the IviScope_AcquisitionStatus
            %function to determine when the acquisition is complete.
            %You must call this function separately for each enabled
            %channel to obtain the min/max waveforms.  You can call the
            %IviScope_ReadMinMaxWaveform function instead of the
            %IviScope_InitiateAcquisition function.  The
            %IviScope_ReadMinMaxWaveform function starts an acquisition
            %on all enabled channels, waits for the acquisition to
            %complete, and returns the min/max waveforms for the channel
            %you specify.  You call this function to obtain the min/max
            %waveforms for each of the remaining channels.  Notes:  (1)
            %After this function executes, each element in the Min
            %Waveform Array and Max Waveform Array parameters is either
            %a voltage or a value indicating that the oscilloscope could
            %not sample a voltage.  (2) You configure the interpolation
            %method the oscilloscope uses with the
            %IviScope_ConfigureInterpolation function.  If you disable
            %interpolation, the oscilloscope does not interpolate points
            %in the waveform.  If the oscilloscope cannot sample a value
            %for a point in the waveform, the driver sets the
            %corresponding element in the Waveform Array to an IEEE
            %defined NaN (Not a Number) value and the function returns
            %IVISCOPE_WARN_INVALID_WFM_ELEMENT.    (3) You can test a
            %waveform value for an invalid value condition by calling
            %the IviScope_IsInvalidWfmElement function.  (4) This
            %function does not check the instrument status.   Typically,
            %you call this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviScope_error_query function at the conclusion of the
            %sequence.  (5) The class driver returns a simulated minimum
            %and maximum waveform when this function is called and the
            %IVISCOPE_ATTR_SIMULATE attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %waveform, refer to the online help manual.  (6) This
            %function is part of the IviScopeMinMaxWaveform [MmW]
            %extension group.
            
            narginchk(5,5)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            WaveformSize = obj.checkScalarInt32Arg(WaveformSize);
            MinWaveformArray = obj.checkVectorDoubleArg(MinWaveformArray);
            MaxWaveformArray = obj.checkVectorDoubleArg(MaxWaveformArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                MinWaveformArray = libpointer('doublePtr', MinWaveformArray);
                MaxWaveformArray = libpointer('doublePtr', MaxWaveformArray);
                ActualPoints = libpointer('int32Ptr', 0);
                InitialX = libpointer('doublePtr', 0);
                XIncrement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_FetchMinMaxWaveform', session, ChannelName, WaveformSize, MinWaveformArray, MaxWaveformArray, ActualPoints, InitialX, XIncrement);
                
                MinWaveformArray = MinWaveformArray.Value;
                MaxWaveformArray = MaxWaveformArray.Value;
                ActualPoints = ActualPoints.Value;
                InitialX = InitialX.Value;
                XIncrement = XIncrement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Measurement = FetchWaveformMeasurement(obj,ChannelName,MeasurementFunction)
            %FETCHWAVEFORMMEASUREMENT This function fetches a waveform
            %measurement from the channel you specify.  If the channel
            %is not enabled for the acquisition, this function returns
            %IVISCOPE_ERROR_CHANNEL_NOT_ENABLED error. The waveform on
            %which the oscilloscope calculates the waveform measurement
            %is from an acquisition that you previously initiated.  Use
            %the IviScope_InitiateAcquisition function to start an
            %acquisition on the channels that you enable with the
            %IviScope_ConfigureChannel function.  The oscilloscope
            %acquires waveforms for the enabled channels concurrently.
            %You use the IviScope_AcquisitionStatus function to
            %determine when the acquisition is complete.  You call this
            %function separately for each waveform measurement you want
            %to obtain on a specific channel.  You can call the
            %IviScope_ReadWaveformMeasurement function instead of the
            %IviScope_InitiateAcquisition function.  The
            %IviScope_ReadWaveformMeasurement function starts an
            %acquisition on all enabled channels.  It then waits for the
            %acquisition to complete, obtains a waveform measurement on
            %the channel you specify, and returns the measurement value.
            % You call this function separately for any other waveform
            %measurement that you want to obtain on a specific channel.
            %Notes:  (1) You must configure the appropriate reference
            %levels before you call this function.  You configure the
            %low, mid, and high references either by calling the
            %IviScope_ConfigureRefLevels function or by setting the
            %following attributes.    IVISCOPE_ATTR_MEAS_HIGH_REF
            %IVISCOPE_ATTR_MEAS_LOW_REF   IVISCOPE_ATTR_MEAS_MID_REF
            %(2) This function does not check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviScope_error_query function at the conclusion of
            %the sequence.  (3) The class driver returns a simulated
            %measurement when this function is called and the
            %IVISCOPE_ATTR_SIMULATE attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.  (4) This
            %function is part of the IviScopeWaveformMeasurement [WM]
            %extension group.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            MeasurementFunction = obj.checkScalarInt32Arg(MeasurementFunction);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                Measurement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_FetchWaveformMeasurement', session, ChannelName, MeasurementFunction, Measurement);
                
                Measurement = Measurement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Abort(obj)
            %ABORT This function aborts an acquisition and returns the
            %oscilloscope to the Idle state.  You initiate an
            %acquisition with the IviScope_InitiateAcquisition function.
            % Notes:  (1) This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  You use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviScope_error_query function at the
            %conclusion of the sequence.  (2) If the instrument cannot
            %abort an initiated acquisition, this function returns the
            %IVI_ERROR_FUNCTION_NOT_SUPPORTED error.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviScope_Abort', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
