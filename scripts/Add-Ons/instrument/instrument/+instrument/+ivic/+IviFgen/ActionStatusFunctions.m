classdef ActionStatusFunctions < instrument.ivic.IviGroupBase
    %ACTIONSTATUSFUNCTIONS This class contains functions and
    %classes that initiate instrument operations and report
    %their status.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function InitiateGeneration(obj)
            %INITIATEGENERATION This function initiates signal
            %generation. If the function generator is in the
            %Configuration State, this function moves the function
            %generator to the Output Generation State.  If the function
            %generator is already in the Output Generation State, this
            %function does nothing and returns VI_SUCCESS.  The
            %instrument is in the Generation State after you call the
            %IviFgen_init, IviFgen_InitWithOptions, or IviFgen_reset
            %functions.  You can configure the output of the function
            %generator regardless of whether function generator is in
            %the Configuration State or the Generation State.  This
            %means that you are required to call the
            %IviFgen_InitiateGeneration function only if you abort
            %signal generation by calling the IviFgen_AbortGeneration
            %function.    Many function generators constantly generate
            %an output signal, and do not require you to initiate signal
            %generation.  If a function generator is always outputting
            %the currently configured signal, this function does nothing
            %and returns VI_SUCCESS.  You are not required to call the
            %IviFgen_InitiateGeneration and IviFgen_AbortGeneration
            %functions.  Whether you choose to call these functions in
            %an application program has no impact on interchangeability.
            % You can choose to use these functions if you want to
            %optimize your application for instruments that exhibit
            %increased performance when output configuration is
            %performed while the instrument is not generating a signal.
            %This function disables extensions that have not been set by
            %the user under the following conditions:  (1) If you have
            %not set the value of any attribute in the IviFgenModulateAM
            %extension on a channel, this function sets the
            %IVIFGEN_ATTR_AM_ENABLED attribute to False for that
            %channel.  (2) If you have not set the value of any
            %attribute in the IviFgenModulateFM extension on a channel,
            %this function sets the IVIFGEN_ATTR_FM_ENABLED attribute to
            %False for that channel.  Notes:  (1) This function does not
            %normally check the instrument status.   Typically, you call
            %this function only in a sequence of calls to other
            %low-level driver functions. The sequence performs one
            %operation. You use the low-level functions to optimize one
            %or more aspects of interaction with the instrument. If you
            %want to check the instrument status, call the
            %IviFgen_error_query function at the conclusion of the
            %sequence.  (2) This function performs interchangeability
            %checking when the IVIFGEN_ATTR_INTERCHANGE_CHECK attribute
            %is set to True. If the IVIFGEN_ATTR_SPY attribute is set to
            %True, you use the NI Spy utility to view interchangeability
            %warnings. You use the IviFgen_GetNextInterchangeWarning
            %function to retrieve interchangeability warnings when the
            %IVIFGEN_ATTR_SPY attribute is set to False. For more
            %information about interchangeability checking, refer to the
            %help text for the IVIFGEN_ATTR_INTERCHANGE_CHECK attribute.
            %
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_InitiateGeneration', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AbortGeneration(obj)
            %ABORTGENERATION This function aborts a previously
            %initiated signal generation. If the function generator is
            %in the Output Generation State, this function moves the
            %function generator to the Configuration State.  If the
            %function generator is already in the Configuration State,
            %the function does nothing and returns VI_SUCCESS.  You can
            %configure the output of the function generator regardless
            %of whether the function generator is in the Configuration
            %State or the Generation State.  This means that you are not
            %required to call the IviFgen_AbortGeneration function prior
            %to configuring the output of the function generator.
            %Many function generators constantly generate an output
            %signal, and do not require you to abort signal generation
            %prior to configuring the instrument.  If a function
            %generator's output cannot be aborted (i.e., the function
            %generator cannot stop generating a signal) this function
            %does nothing and returns VI_SUCCESS.  You are not required
            %to call the IviFgen_InitiateGeneration and
            %IviFgen_AbortGeneration functions.  Whether you choose to
            %call these functions in an application program has no
            %impact on interchangeability.  You can choose to use these
            %functions if you want to optimize your application for
            %instruments that exhibit increased performance when output
            %configuration is performed while the instrument is not
            %generating a signal.  Note: This function does not normally
            %check the instrument status.  Typically, you call this
            %function only in a sequence of calls to other low-level
            %driver functions. The sequence performs one operation. You
            %use the low-level functions to optimize one or more aspects
            %of interaction with the instrument. If you want to check
            %the instrument status, call the IviFgen_error_query
            %function at the conclusion of the sequence.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_AbortGeneration', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the function generator.  Call this function if you
            %pass IVIFGEN_VAL_SOFTWARE_TRIG for the Trigger Source
            %parameter of the IviFgen_ConfigureTriggerSource function.
            %If the IVIFGEN_ATTR_TRIGGER_SOURCE attribute is not set to
            %IVIFGEN_VAL_SOFTWARE_TRIG, this function returns the error
            %IVIFGEN_ERROR_TRIGGER_NOT_SOFTWARE.  Notes:  (1) This
            %function does not normally check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions. The sequence
            %performs one operation. You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument. If you want to check the instrument status,
            %call the IviFgen_error_query function at the conclusion of
            %the sequence.  (2) This function is part of the
            %IviFgenTrigger [SWT] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
