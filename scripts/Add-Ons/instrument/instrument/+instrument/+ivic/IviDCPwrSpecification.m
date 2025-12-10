classdef (Hidden) IviDCPwrSpecification < instrument.ivic.IviDriverBase
    %IVIDCPWRSPECIFICATION IviDCPwrSpecification
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviDCPwrSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviDCPwr');
            
            %% Initialize properties
            obj.Configuration = instrument.ivic.IviDCPwr.Configuration();
            obj.ActionStatus = instrument.ivic.IviDCPwr.ActionStatus();
            obj.Utility = instrument.ivic.IviDCPwr.Utility();
            obj.InherentIVIAttributes = instrument.ivic.IviDCPwr.InherentIVIAttributes();
            obj.BasicOperation = instrument.ivic.IviDCPwr.BasicOperation();
            obj.TriggerSubsystem = instrument.ivic.IviDCPwr.TriggerSubsystem();
        end
        
        function delete(obj)
            obj.TriggerSubsystem = [];
            obj.BasicOperation = [];
            obj.InherentIVIAttributes = [];
            obj.Utility = [];
            obj.ActionStatus = [];
            obj.Configuration = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATION This class contains functions that configure
        %the instrument.  The class includes high-level functions
        %that configure multiple instrument settings as well as
        %low-level functions that set, get, and check individual
        %attribute values.  Read Only.
        Configuration
        
        %ACTIONSTATUS This class contains functions that initiate
        %instrument operations and report their status.  Read Only.
        ActionStatus
        
        %UTILITY This class contains functions and sub-classes that
        %control common instrument operations.  These functions
        %include many of functions that VXIplug&play require, such
        %as reset, self-test, revision query, error query, and error
        %message.  This class also contains functions that access
        %IVI error information and lock the session.  Read Only.
        Utility
        
        %INHERENTIVIATTRIBUTES Attributes common to all IVI
        %instrument drivers. Read Only.
        InherentIVIAttributes
        
        %BASICOPERATION Attributes for controlling the basic
        %features of the DC power supply. Read Only.
        BasicOperation
        
        %TRIGGERSUBSYSTEM Attributes for triggered output changes.
        %Read Only.
        TriggerSubsystem
    end
    
    %% Property access methods
    methods
        %% Configuration property access methods
        function value = get.Configuration(obj)
            if isempty(obj.Configuration)
                obj.Configuration = instrument.ivic.IviDCPwr.Configuration();
            end
            value = obj.Configuration;
        end
        
        %% ActionStatus property access methods
        function value = get.ActionStatus(obj)
            if isempty(obj.ActionStatus)
                obj.ActionStatus = instrument.ivic.IviDCPwr.ActionStatus();
            end
            value = obj.ActionStatus;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = instrument.ivic.IviDCPwr.Utility();
            end
            value = obj.Utility;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviDCPwr.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% BasicOperation property access methods
        function value = get.BasicOperation(obj)
            if isempty(obj.BasicOperation)
                obj.BasicOperation = instrument.ivic.IviDCPwr.BasicOperation();
            end
            value = obj.BasicOperation;
        end
        
        %% TriggerSubsystem property access methods
        function value = get.TriggerSubsystem(obj)
            if isempty(obj.TriggerSubsystem)
                obj.TriggerSubsystem = instrument.ivic.IviDCPwr.TriggerSubsystem();
            end
            value = obj.TriggerSubsystem;
        end
    end
    
    %% Public Methods
    methods
        function InstrumentHandle = init(obj,LogicalName,IDQuery,ResetDevice)
            %INIT This function performs the following initialization
            %actions:  - Creates a new IVI instrument driver session.  -
            %Opens a session to the specified device using the interface
            %and address you specify for the Resource Name parameter.  -
            %If the ID Query parameter is set to True, this function
            %queries the instrument ID and checks that it is valid for
            %this instrument driver.  - If the Reset parameter is set to
            %True, this function resets the instrument to a known state.
            % - Sends initialization commands to set the instrument to
            %the state necessary for the operation of the instrument
            %driver.  - Returns a session handle that you use to
            %identify the instrument in all subsequent instrument driver
            %function calls.  Note:  This function creates a new session
            %each time you invoke it. Although you can open more than
            %one IVI session for the same resource, it is best not to do
            %so.  You can use the same session in multiple program
            %threads.  You can use the IviDCPwr_LockSession and
            %IviDCPwr_UnlockSession functions to protect sections of
            %code that require exclusive access to the resource.
            
            if obj.initialized;
                error(message('instrument:ivic:DriverInitialized'));
            end
            narginchk(4,4)
            LogicalName = obj.checkScalarStringArg(LogicalName);
            LogicalName = [double( LogicalName ) 0];
            IDQuery = obj.checkScalarBoolArg(IDQuery);
            ResetDevice = obj.checkScalarBoolArg(ResetDevice);
            
            libname = obj.libName;
            InstrumentHandle = libpointer('uint32Ptr', 1);
            status = calllib(  libname,'IviDCPwr_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
            if status < 0
                error(message('instrument:ivic:ErrorInvokinginit'));
            end
            obj.session = InstrumentHandle.Value;
            obj.initialized = true;
        end
        
        function InstrumentHandle = InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            %INITWITHOPTIONS This function performs the following
            %initialization actions:  - Creates a new IVI instrument
            %driver and optionally sets the initial state of the
            %following session attributes:
            %IVIDCPWR_ATTR_RANGE_CHECK
            %IVIDCPWR_ATTR_QUERY_INSTRUMENT_STATUS
            %IVIDCPWR_ATTR_CACHE
            %IVIDCPWR_ATTR_SIMULATE
            %IVIDCPWR_ATTR_RECORD_COERCIONS      - Opens a session to
            %the specified device using the interface and address you
            %specify for the Resource Name parameter.  - If the ID Query
            %parameter is set to True, this function queries the
            %instrument ID and checks that it is valid for this
            %instrument driver.  - If the Reset parameter is set to
            %True, this function resets the instrument to a known state.
            % - Sends initialization commands to set the instrument to
            %the state necessary for the operation of the instrument
            %driver.  - Returns a session handle that you use to
            %identify the instrument in all subsequent instrument driver
            %function calls.  Note:  This function creates a new session
            %each time you invoke it. Although you can open more than
            %one IVI session for the same resource, it is best not to do
            %so.  You can use the same session in multiple program
            %threads.  You can use the IviDCPwr_LockSession and
            %IviDCPwr_UnlockSession functions to protect sections of
            %code that require exclusive access to the resource.
            
            if obj.initialized;
                error(message('instrument:ivic:DriverInitialized'));
            end
            narginchk(5,5)
            LogicalName = obj.checkScalarStringArg(LogicalName);
            LogicalName = [double( LogicalName ) 0];
            ResetDevice = obj.checkScalarBoolArg(ResetDevice);
            OptionString = obj.checkScalarStringArg(OptionString);
            OptionString = [double(OptionString) 0];
            
            libname = obj.libName;
            InstrumentHandle = libpointer('uint32Ptr', 1);
            status = calllib(  libname,'IviDCPwr_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
            if status < 0
                error(message('instrument:ivic:ErrorInvokingInitWithOptions'));
            end
            obj.session = InstrumentHandle.Value;
            obj.initialized = true;
        end
        
        function close(obj)
            %CLOSE This function performs the following operations:  -
            %Closes the instrument I/O session.  - Destroys the
            %instrument driver session and all of its attributes.  -
            %Deallocates any memory resources the driver uses.  Notes:
            %(1) You must unlock the session before calling
            %IviDCPwr_close.  (2) After calling IviDCPwr_close, you
            %cannot use the instrument driver again until you call
            %IviDCPwr_init or IviDCPwr_InitWithOptions.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviDCPwr_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
