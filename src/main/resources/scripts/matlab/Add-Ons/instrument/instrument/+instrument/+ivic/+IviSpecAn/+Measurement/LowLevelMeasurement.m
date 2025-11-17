classdef LowLevelMeasurement < instrument.ivic.IviGroupBase
    %LOWLEVELMEASUREMENT This class contains functions that
    %transfer data to and from the instrument.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Initiate(obj)
            %INITIATE This function initiates an acquisition. After
            %calling this function, the spectrum analyzer leaves the
            %idle state and waits for a trigger.  Notes:  (1) This
            %function does not check the instrument status.   Typically,
            %you call this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviSpecAn_error_query function at the conclusion of the
            %sequence.  (2) Call IviSpecAn_AcquisitionStatus to
            %determine when the acquisition is complete.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_Initiate', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Abort(obj)
            %ABORT This function aborts a previously initiated
            %measurement and returns the spectrum analyzer to the idle
            %state.  Note:  This function does not check the instrument
            %status.   Typically, you call this function only in a
            %sequence of calls to other low-level driver functions.  The
            %sequence performs one operation.  Use the low-level
            %functions to optimize one or more aspects of interaction
            %with the instrument.  If you want to check the instrument
            %status, call the IviSpecAn_error_query function at the
            %conclusion of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_Abort', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AcquisitionStatus = AcquisitionStatus(obj)
            %ACQUISITIONSTATUS This function determines if an
            %acquisition is in progress or complete.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                AcquisitionStatus = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviSpecAn_AcquisitionStatus', session, AcquisitionStatus);
                
                AcquisitionStatus = AcquisitionStatus.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the spectrum analyzer.  Call this function if you
            %pass IVISPECAN_VAL_TRIGGER_SOURCE_SOFTWARE for the
            %IVISPECAN_ATTR_TRIGGER_SOURCE attribute or the Trigger
            %Source parameter of the IviSpecAn_ConfigureTriggerSource
            %function.  Notes:  (1) If the IVISPECAN_ATTR_TRIGGER_SOURCE
            %is not set to the IVISPECAN_VAL_TRIGGER_SOURCE_SOFTWARE
            %value, this function returns the Trigger Not Software error
            %(0xBFFA1001).  (2) This function does not check the
            %instrument status.   Typically, you call this function only
            %in a sequence of calls to other low-level driver functions.
            % The sequence performs one operation.  You use the
            %low-level functions to optimize one or more aspects of
            %interaction with the instrument.  If you want to check the
            %instrument status, call the IviSpecAn_error_query function
            %at the conclusion of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
