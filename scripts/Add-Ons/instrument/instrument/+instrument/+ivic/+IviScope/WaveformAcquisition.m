classdef WaveformAcquisition < instrument.ivic.IviGroupBase
    %WAVEFORMACQUISITION This class contains functions and
    %sub-classes that initiate and retrieve waveforms and
    %waveform measurements using the current configuration.  The
    %class contains high-level read functions that intiate an
    %acquisition and fetch the data in one operation.  The class
    %also contains low-level functions that intiate an
    %acquisition, and fetch a waveform or wavefrom measurement
    %in separate operations.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = WaveformAcquisition()
            %% Initialize properties
            obj.LowlevelAcquisition = instrument.ivic.IviScope.WaveformAcquisition.LowlevelAcquisition();
        end
        
        function delete(obj)
            obj.LowlevelAcquisition = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.LowlevelAcquisition.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %LOWLEVELACQUISITION The class contains functions that give
        %low-level control over how the oscilloscope acquires
        %waveforms and waveform measurements.  The functions perform
        %the following operations:  - intiate an acquisition - send
        %a software trigger - return the status of acquisition  -
        %fetch a waveform or waveform measurement - abort an
        %acquisition     Read Only.
        LowlevelAcquisition
    end
    
    %% Property access methods
    methods
        %% LowlevelAcquisition property access methods
        function value = get.LowlevelAcquisition(obj)
            if isempty(obj.LowlevelAcquisition)
                obj.LowlevelAcquisition = instrument.ivic.IviScope.WaveformAcquisition.LowlevelAcquisition();
            end
            value = obj.LowlevelAcquisition;
        end
    end
    
    %% Public Methods
    methods
        function [WaveformArray,ActualPoints,InitialX,XIncrement] = ReadWaveform(obj,ChannelName,WaveformSize,MaximumTimems,WaveformArray)
            %READWAVEFORM This function initiates an acquisition on all
            %channels that you enable with the IviScope_ConfigureChannel
            %function.  If the channel you specify in the Channel Name
            %parameter is not enabled for the acquisition, this function
            %returns the IVISCOPE_ERROR_CHANNEL_NOT_ENABLED error.  It
            %then waits for the acquisition to complete and returns the
            %waveform for the channel you specify.  If the oscilloscope
            %did not complete the acquisition within the time period you
            %specify with the Maximum Time parameter, the function
            %returns the IVISCOPE_ERROR_MAX_TIME_EXCEEDED error.  You
            %call the IviScope_FetchWaveform function to obtain the
            %waveforms for each of the remaining enabled channels
            %without initiating another acquisition.  Notes:  (1) Use
            %this function to read waveforms when you set the
            %acquisition mode to IVISCOPE_VAL_NORMAL,
            %IVISCOPE_VAL_HI_RES, or IVISCOPE_VAL_AVERAGE.  If the
            %acquisition type is not one of the listed types, the
            %function returns the IVISCOPE_ERROR_INVALID_ACQ_TYPE error.
            % (2) After this function executes, each element in the
            %Waveform Array parameter is either a voltage or a value
            %indicating that the oscilloscope could not sample a
            %voltage.  (3) You configure the interpolation method the
            %oscilloscope uses with the IviScope_ConfigureInterpolation
            %function.  If you disable interpolation, the oscilloscope
            %does not interpolate points in the waveform.  If the
            %oscilloscope cannot sample a value for a point in the
            %waveform, the driver sets the corresponding element in the
            %Waveform Array to an IEEE defined NaN (Not a Number) value
            %and the function returns IVISCOPE_WARN_INVALID_WFM_ELEMENT.
            % (4) You can test a waveform value for an invalid value
            %condition by calling the IviScope_IsInvalidWfmElement
            %function.  (5) This function performs interchangeability
            %checking when the IVISCOPE_ATTR_INTERCHANGE_CHECK attribute
            %is set to True.  If the IVISCOPE_ATTR_SPY attribute is set
            %to True, you use the NI Spy utility to view
            %interchangeability warnings.  You use the
            %IviScope_GetNextInterchangeWarning function to retrieve
            %interchangeability warnings when the IVISCOPE_ATTR_SPY
            %attribute is set to False.  For more information about
            %interchangeability checking, refer to the help text for the
            %IVISCOPE_ATTR_INTERCHANGE_CHECK attribute.  (6) The class
            %driver returns a simulated waveform when this function is
            %called and the IVISCOPE_ATTR_SIMULATE attribute is set to
            %True and the IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION
            %attribute is set to False.  For information on how to
            %configure a simulated waveform, refer to the online help
            %manual.
            
            narginchk(5,5)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            WaveformSize = obj.checkScalarInt32Arg(WaveformSize);
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            WaveformArray = obj.checkVectorDoubleArg(WaveformArray);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                WaveformArray = libpointer('doublePtr', WaveformArray);
                ActualPoints = libpointer('int32Ptr', 0);
                InitialX = libpointer('doublePtr', 0);
                XIncrement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_ReadWaveform', session, ChannelName, WaveformSize, MaximumTimems, WaveformArray, ActualPoints, InitialX, XIncrement);
                
                WaveformArray = WaveformArray.Value;
                ActualPoints = ActualPoints.Value;
                InitialX = InitialX.Value;
                XIncrement = XIncrement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [MinWaveformArray,MaxWaveformArray,ActualPoints,InitialX,XIncrement] = ReadMinMaxWaveform(obj,ChannelName,WaveformSize,MaximumTimems,MinWaveformArray,MaxWaveformArray)
            %READMINMAXWAVEFORM This function initiates an acquisition
            %on all channels that you enable with the
            %IviScope_ConfigureChannel function.  If the channel you
            %specify in the Channel Name parameter is not enabled for
            %the acquisition, this function returns the
            %IVISCOPE_ERROR_CHANNEL_NOT_ENABLED error.  It then waits
            %for the acquisition to complete and returns the min/max
            %waveforms for the channel you specify.  If the oscilloscope
            %did not complete the acquisition within the time period you
            %specify with the Maximum Time parameter, the function
            %returns the IVISCOPE_ERROR_MAX_TIME_EXCEEDED error.  You
            %call the IviScope_FetchMinMaxWaveform function to obtain
            %the waveforms for each of the remaining enabled channels
            %without initiating another acquisition.  Notes:  (1) Use
            %this function to read waveforms when you set the
            %acquisition type to IVISCOPE_VAL_PEAK_DETECT or
            %IVISCOPE_VAL_ENVELOPE.  If the acquisition type is not one
            %of the listed types, the function returns the
            %IVISCOPE_ERROR_INVALID_ACQ_TYPE error.  (2) After this
            %function executes, each element in the Min Waveform Array
            %and Max Waveform Array parameters is either a voltage or a
            %value indicating that the oscilloscope could not sample a
            %voltage.  (3) You configure the interpolation method the
            %oscilloscope uses with the IviScope_ConfigureInterpolation
            %function.  If you disable interpolation, the oscilloscope
            %does not interpolate points in the waveform.  If the
            %oscilloscope cannot sample a value for a point in the
            %waveform, the driver sets the corresponding element in the
            %Waveform Array to an IEEE defined NaN (Not a Number) value
            %and the function returns IVISCOPE_WARN_INVALID_WFM_ELEMENT.
            %   (4) You can test a waveform value for an invalid value
            %condition by calling the IviScope_IsInvalidWfmElement
            %function.  (5) This function performs interchangeability
            %checking when the IVISCOPE_ATTR_INTERCHANGE_CHECK attribute
            %is set to True.  If the IVISCOPE_ATTR_SPY attribute is set
            %to True, you use the NI Spy utility to view
            %interchangeability warnings.  You use the
            %IviScope_GetNextInterchangeWarning function to retrieve
            %interchangeability warnings when the IVISCOPE_ATTR_SPY
            %attribute is set to False.  For more information about
            %interchangeability checking, refer to the help text for the
            %IVISCOPE_ATTR_INTERCHANGE_CHECK attribute.  (6) The class
            %driver returns simulated minimum and maximum waveforms when
            %this function is called and the IVISCOPE_ATTR_SIMULATE
            %attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %waveform, refer to the online help manual.  (7) This
            %function is part of the IviScopeMinMaxWaveform [MmW]
            %extension group.
            
            narginchk(6,6)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            WaveformSize = obj.checkScalarInt32Arg(WaveformSize);
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
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
                
                status = calllib( libname,'IviScope_ReadMinMaxWaveform', session, ChannelName, WaveformSize, MaximumTimems, MinWaveformArray, MaxWaveformArray, ActualPoints, InitialX, XIncrement);
                
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
        
        function Measurement = ReadWaveformMeasurement(obj,ChannelName,MeasurementFunction,MaximumTimems)
            %READWAVEFORMMEASUREMENT This function initiates an
            %acquisition on all channels that you enable with the
            %IviScope_ConfigureChannel function.  If the channel you
            %specify in the Channel Name parameter is not enabled for
            %the acquisition, this function returns the
            %IVISCOPE_ERROR_CHANNEL_NOT_ENABLED error.  It then waits
            %for the acquisition to complete and returns the waveform
            %measurement for the channel you specify.  If the
            %oscilloscope did not complete the acquisition within the
            %time period you specify with the Maximum Time parameter,
            %the function returns the IVISCOPE_ERROR_MAX_TIME_EXCEEDED
            %error.  You call the IviScope_FetchWaveformMeasurement
            %function to obtain any other waveform measurement on a
            %specific channel without initiating another acquisition.
            %Notes:  (1) You must configure the appropriate reference
            %levels before you call this function.  You configure the
            %low, mid, and high references either by calling the
            %IviScope_ConfigureRefLevels function or by setting the
            %following attributes:    IVISCOPE_ATTR_MEAS_HIGH_REF
            %IVISCOPE_ATTR_MEAS_LOW_REF   IVISCOPE_ATTR_MEAS_MID_REF
            %(2) This function performs interchangeability checking when
            %the IVISCOPE_ATTR_INTERCHANGE_CHECK attribute is set to
            %True.  If the IVISCOPE_ATTR_SPY attribute is set to True,
            %you use the NI Spy utility to view interchangeability
            %warnings.  You use the IviScope_GetNextInterchangeWarning
            %function to retrieve interchangeability warnings when the
            %IVISCOPE_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVISCOPE_ATTR_INTERCHANGE_CHECK
            %attribute.  (3) The class driver returns a simulated
            %measurement when this function is called and the
            %IVISCOPE_ATTR_SIMULATE attribute is set to True and the
            %IVISCOPE_ATTR_USE_SPECIFIC_SIMULATION attribute is set to
            %False.  For information on how to configure a simulated
            %measurement, refer to the online help manual.  (4) This
            %function is part of the IviScopeWaveformMeasurement [WM]
            %extension group.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            MeasurementFunction = obj.checkScalarInt32Arg(MeasurementFunction);
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                Measurement = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviScope_ReadWaveformMeasurement', session, ChannelName, MeasurementFunction, MaximumTimems, Measurement);
                
                Measurement = Measurement.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
