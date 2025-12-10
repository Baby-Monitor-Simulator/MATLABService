classdef Zeroing < instrument.ivic.IviGroupBase
    %ZEROING This class contains functions to perform the zero
    %correction.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function Zero(obj,ChannelName)
            %ZERO This function performs a zero correction on the
            %specified channel. You may use the
            %IviPwrMeter_IsZeroComplete function to determine when the
            %zero correction is complete.
            
            narginchk(2,2)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviPwrMeter_Zero', session, ChannelName);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ZeroAllChannels(obj)
            %ZEROALLCHANNELS This function performs a zero correction
            %on all enabled channels. You may use the
            %IviPwrMeter_IsZeroComplete function to determine when the
            %zero correction is complete.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviPwrMeter_ZeroAllChannels', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ZeroCorrectionStatus = IsZeroComplete(obj)
            %ISZEROCOMPLETE This function queries the instrument to
            %determine the status of all zero correction operations
            %initiated by the IviPwrMeter_Zero or
            %IviPwrMeter_ZeroAllChannels functions. This function
            %returns the IVIPWRMETER_VAL_ZERO_COMPLETE (1) value in the
            %Status parameter only when zero corrections are complete on
            %all enabled channels.  If some zero correction operations
            %are still in progress on one or more channels, this
            %function returns the IVIPWRMETER_VAL_ZERO_IN_PROGRESS (0)
            %value. If the driver cannot query the instrument to
            %determine its state, the driver returns the
            %IVIPWRMETER_VAL_ZERO_STATUS_UNKNOWN (-1) value.  Note:
            %This function does not check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviPwrMeter_error_query function at the conclusion
            %of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ZeroCorrectionStatus = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviPwrMeter_IsZeroComplete', session, ZeroCorrectionStatus);
                
                ZeroCorrectionStatus = ZeroCorrectionStatus.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
