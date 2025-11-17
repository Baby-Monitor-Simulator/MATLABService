classdef Configuration < instrument.ivic.IviGroupBase
    %CONFIGURATION This class provides functions and classes
    %that configure the switch.  The class includes high-level
    %functions that configure the scan list and scan trigger.
    %The class also contains the low-level functions that set,
    %get, and check individual attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Configuration()
            %% Initialize properties
            obj.SetGetCheckAttribute = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureScanList(obj,ScanList,ScanMode)
            %CONFIGURESCANLIST This function configures the switch
            %module for scanning.  Use the IviSwtch_ConfigureScanTrigger
            %function to configure the scan trigger. Use the
            %IviSwtch_InitiateScan function to start the scan.  Notes:
            %(1) This function is part of the IviSwtchScanner [SCN]
            %extension group.
            
            narginchk(3,3)
            ScanList = obj.checkScalarStringArg(ScanList);
            ScanMode = obj.checkScalarInt32Arg(ScanMode);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ScanList = [double(ScanList) 0];
                
                status = calllib( libname,'IviSwtch_ConfigureScanList', session, ScanList, ScanMode);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureScanTrigger(obj,ScanDelay,TriggerInput,ScanAdvancedOutput)
            %CONFIGURESCANTRIGGER This function configures the scan
            %triggers for the scan list you establish with
            %IviSwtch_ConfigureScanList function.  Notes:  (1) This
            %function is part of the IviSwtchScanner [SCN] extension
            %group.
            
            narginchk(4,4)
            ScanDelay = obj.checkScalarDoubleArg(ScanDelay);
            TriggerInput = obj.checkScalarInt32Arg(TriggerInput);
            ScanAdvancedOutput = obj.checkScalarInt32Arg(ScanAdvancedOutput);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_ConfigureScanTrigger', session, ScanDelay, TriggerInput, ScanAdvancedOutput);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetContinuousScan(obj,ContinuousScanState)
            %SETCONTINUOUSSCAN This function sets the continuous scan
            %mode on the instrument.  Notes:  (1) This function is part
            %of the IviSwtchScanner [SCN] extension group.
            
            narginchk(2,2)
            ContinuousScanState = obj.checkScalarBoolArg(ContinuousScanState);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSwtch_SetContinuousScan', session, ContinuousScanState);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
