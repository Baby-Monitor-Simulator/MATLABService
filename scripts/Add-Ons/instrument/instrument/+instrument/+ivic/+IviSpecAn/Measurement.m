classdef Measurement < instrument.ivic.IviGroupBase
    %MEASUREMENT This class contains functions and sub-classes
    %that initiate and retrieve measurements using the current
    %configuration.  The class contains high-level read
    %functions that initiate a measurement and fetch the data in
    %one operation.  The class also contains low-level functions
    %that initiate the measurement process, send a software
    %trigger, and fetch measurement values in separate
    %operations.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Measurement()
            %% Initialize properties
            obj.LowLevelMeasurement = instrument.ivic.IviSpecAn.Measurement.LowLevelMeasurement();
        end
        
        function delete(obj)
            obj.LowLevelMeasurement = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.LowLevelMeasurement.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %LOWLEVELMEASUREMENT This class contains functions that
        %transfer data to and from the instrument.  Read Only.
        LowLevelMeasurement
    end
    
    %% Property access methods
    methods
        %% LowLevelMeasurement property access methods
        function value = get.LowLevelMeasurement(obj)
            if isempty(obj.LowLevelMeasurement)
                obj.LowLevelMeasurement = instrument.ivic.IviSpecAn.Measurement.LowLevelMeasurement();
            end
            value = obj.LowLevelMeasurement;
        end
    end
    
    %% Public Methods
    methods
        function [ActualPoints,Amplitude] = ReadYTrace(obj,TraceName,MaximumTimems,ArrayLength,Amplitude)
            %READYTRACE This function initiates a signal acquisition
            %based on the present instrument configuration.  It then
            %waits for the acquisition to complete, and returns the
            %trace as an array of amplitude values. The amplitude array
            %returns data that represent the amplitude of the signals of
            %the sweep from the start frequency to the stop frequency
            %(in frequency domain, in time domain the amplitude array is
            %ordered from beginning of sweep to end). This function
            %resets the sweep count.  Notes:  (1) If the spectrum
            %analyzer did not complete the acquisition within the time
            %specified in the Maximum Time parameter, this function
            %returns the Max Time Exceeded (0xBFFA2003) error.  (2) If
            %the data was captured in an uncalibrated spectrum analyzer
            %mode, this function returns a Measure Uncalibrated
            %(0x3FFA2001) warning.
            
            narginchk(5,5)
            TraceName = obj.checkScalarStringArg(TraceName);
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            ArrayLength = obj.checkScalarInt32Arg(ArrayLength);
            Amplitude = obj.checkVectorDoubleArg(Amplitude);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TraceName = [double(TraceName) 0];
                ActualPoints = libpointer('int32Ptr', 0);
                Amplitude = libpointer('doublePtr', Amplitude);
                
                status = calllib( libname,'IviSpecAn_ReadYTrace', session, TraceName, MaximumTimems, ArrayLength, ActualPoints, Amplitude);
                
                ActualPoints = ActualPoints.Value;
                Amplitude = Amplitude.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ActualPoints,Amplitude] = FetchYTrace(obj,TraceName,ArrayLength,Amplitude)
            %FETCHYTRACE This function returns the trace the spectrum
            %analyzer acquires. The trace is from a previously initiated
            %acquisition.  Call the IviSpecAn_Initiate function to start
            %an acquisition.  Call the IviSpecAn_AcquisitionStatus
            %function to determine when the acquisition is complete.
            %Once the acquisition is complete, call the Fetch Y Trace
            %function to return the trace.  You may call the
            %IviSpecAn_ReadYTrace function instead of the
            %IviSpecAn_Initiate function. The IviSpecAn_ReadYTrace
            %function starts an acquisition, waits for the acquisition
            %to complete, and returns the trace in one function call.
            %Use the IviSpecAn_FetchYTrace function when acquiring
            %multiple traces.  Use a different trace name for each
            %IviSpecAn_FetchYTrace call.  You may also call
            %IviSpecAn_FetchYTrace after calling IviSpecAn_ReadYTrace to
            %acquire subsequent traces.  The array returns data that
            %represents the amplitude of the signals of the sweep from
            %the start frequency to the stop frequency (in frequency
            %domain, in time domain the amplitude array is ordered from
            %beginning of sweep to end).  The
            %IVISPECAN_ATTR_AMPLITUDE_UNITS attribute determines the
            %units of the points in the amplitude array.  Note:  This
            %function does not check the instrument status.   Typically,
            %you call this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviSpecAn_error_query function at the conclusion of the
            %sequence.
            
            narginchk(4,4)
            TraceName = obj.checkScalarStringArg(TraceName);
            ArrayLength = obj.checkScalarInt32Arg(ArrayLength);
            Amplitude = obj.checkVectorDoubleArg(Amplitude);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TraceName = [double(TraceName) 0];
                ActualPoints = libpointer('int32Ptr', 0);
                Amplitude = libpointer('doublePtr', Amplitude);
                
                status = calllib( libname,'IviSpecAn_FetchYTrace', session, TraceName, ArrayLength, ActualPoints, Amplitude);
                
                ActualPoints = ActualPoints.Value;
                Amplitude = Amplitude.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
