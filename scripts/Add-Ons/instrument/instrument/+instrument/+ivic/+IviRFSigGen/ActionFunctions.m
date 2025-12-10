classdef ActionFunctions < instrument.ivic.IviGroupBase
    %ACTIONFUNCTIONS This class contains functions and
    %sub-classes that initiate instrument operations and report
    %their status.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function DisableAllModulation(obj)
            %DISABLEALLMODULATION This function disables all currently
            %enabled modulations (e.g. analog, pulse, IQ, and digital
            %modulation).
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_DisableAllModulation', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WaitUntilSettled(obj,MaxTime)
            %WAITUNTILSETTLED This function waits until the state of
            %the RF output signal has settled.
            
            narginchk(2,2)
            MaxTime = obj.checkScalarInt32Arg(MaxTime);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_WaitUntilSettled', session, MaxTime);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Settled = IsSettled(obj)
            %ISSETTLED This function queries if the RF output signal is
            %currently settled.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                Settled = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviRFSigGen_IsSettled', session, Settled);
                
                Settled = Settled.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the RF signal generator.  Call this function if you
            %set a trigger source to a software trigger value.  Below is
            %a list of attributes and functions which can set the
            %trigger source to a software trigger.  Functions:
            %IviRFSigGen_ConfigureArbTriggerSource
            %IviRFSigGen_ConfigureSweep
            %IviRFSigGen_ConfigureCDMATriggerSource
            %IviRFSigGen_ConfigureTDMATriggerSource   Attributes:
            %IVIRFSIGGEN_ATTR_ARB_TRIGGER_SOURCE
            %IVIRFSIGGEN_ATTR_SWEEP_TRIGGER_SOURCE
            %IVIRFSIGGEN_ATTR_CDMA_TRIGGER_SOURCE
            %IVIRFSIGGEN_ATTR_TDMA_TRIGGER_SOURCE  Notes:  This function
            %does not check the instrument status.   Typically, you call
            %this function only in a sequence of calls to other
            %low-level driver functions.  The sequence performs one
            %operation.  You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument.  If you
            %want to check the instrument status, call the
            %IviRFSigGen_error_query function at the conclusion of the
            %sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviRFSigGen_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
