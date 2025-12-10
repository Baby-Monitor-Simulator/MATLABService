classdef Scan < instrument.ivic.IviGroupBase
    %SCAN This class contains functions for configuring
    %scanning switches.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function InitiateScan(obj)
            %INITIATESCAN This function initiates a scan using the scan
            %list and triggers you configure with the
            %IviSwtch_ConfigureScanList and
            %IviSwtch_ConfigureScanTrigger functions. This function
            %returns immediately.  Once you start the scanning
            %operation, you cannot perform any other operation other
            %than GetAttribute, AbortScan, or SendSoftwareTrigger. All
            %other functions return IVISWTCH_ERROR_SCAN_IN_PROGRESS.  To
            %stop the scanning operation, call the IviSwtch_AbortScan
            %function.  This function applies default values to
            %attributes that have not been set by the user under the
            %following conditions:  (1) If the user has not set the
            %value of any attribute in the IviSwtchScanner extension,
            %the following default values are used:
            %IVISWTCH_ATTR_SCAN_LIST            - "" (Empty string)
            %IVISWTCH_ATTR_TRIGGER_INPUT        - IVISWTCH_VAL_EXTERNAL
            %IVISWTCH_ATTR_SCAN_ADVANCED_OUTPUT - IVISWTCH_VAL_EXTERNAL
            %IVISWTCH_ATTR_SCAN_DELAY           - 0  Notes:  (1) This
            %function performs interchangeability checking when the
            %IVISWTCH_ATTR_INTERCHANGE_CHECK attribute is set to True.
            %If the IVISWTCH_ATTR_SPY attribute is set to True, you use
            %the NI Spy utility to view interchangeability warnings.
            %You use the IviSwtch_GetNextInterchangeWarning function to
            %retrieve interchangeability warnings when the
            %IVISWTCH_ATTR_SPY attribute is set to False.  For more
            %information about interchangeability checking, refer to the
            %help text for the IVISWTCH_ATTR_INTERCHANGE_CHECK
            %attribute.  (2) This function is part of the
            %IviSwtchScanner [SCN] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_InitiateScan', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function AbortScan(obj)
            %ABORTSCAN This function aborts a previously initiated
            %scan. You initiate a scan with the IviSwtch_InitiateScan
            %function.  If the instrument is not currently scanning,
            %this function returns the
            %IVISWTCH_ERROR_NO_SCAN_IN_PROGRESS error.  Notes:  (1) This
            %function is part of the IviSwtchScanner [SCN] extension
            %group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_AbortScan', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function IsScanning = IsScanning(obj)
            %ISSCANNING This function returns the state of the switch
            %module. It indicates if the instrument is currently
            %scanning or is idle.  Notes:  (1) This function is part of
            %the IviSwtchScanner [SCN] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                IsScanning = libpointer('uint16Ptr', 0);
                
                status = calllib( libname,'IviSwtch_IsScanning', session, IsScanning);
                
                IsScanning = IsScanning.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function WaitForScanComplete(obj,MaximumTimems)
            %WAITFORSCANCOMPLETE This function waits until the
            %instrument stops scanning.  Notes:  (1) This function is
            %part of the IviSwtchScanner [SCN] extension group.
            
            narginchk(2,2)
            MaximumTimems = obj.checkScalarInt32Arg(MaximumTimems);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_WaitForScanComplete', session, MaximumTimems);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SendSoftwareTrigger(obj)
            %SENDSOFTWARETRIGGER This function sends a command to
            %trigger the switch.  Call this function if you pass
            %IVISWTCH_VAL_SOFTWARE_TRIG for the Trigger Input parameter
            %of the IviSwtch_ConfigureScanTrigger function.  Notes:  (1)
            %This function does not check the instrument status.
            %Typically, you call this function only in a sequence of
            %calls to other low-level driver functions.  The sequence
            %performs one operation.  You use the low-level functions to
            %optimize one or more aspects of interaction with the
            %instrument.  If you want to check the instrument status,
            %call the IviSwtch_error_query function at the conclusion of
            %the sequence.  (2) This function is part of the
            %IviSwtchSoftwareTrigger [SWT] extension group.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_SendSoftwareTrigger', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
