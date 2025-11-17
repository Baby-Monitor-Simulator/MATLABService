classdef (Hidden) IviSwtchSpecification < instrument.ivic.IviDriverBase
    %IVISWTCHSPECIFICATION IviSwtchSpecification
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviSwtchSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviSwtch');
            
            %% Initialize properties
            obj.Configuration = instrument.ivic.IviSwtch.Configuration();
            obj.Route = instrument.ivic.IviSwtch.Route();
            obj.Scan = instrument.ivic.IviSwtch.Scan();
            obj.Utility = instrument.ivic.IviSwtch.Utility();
            obj.InherentIVIAttributes = instrument.ivic.IviSwtch.InherentIVIAttributes();
            obj.ChannelConfiguration = instrument.ivic.IviSwtch.ChannelConfiguration();
            obj.ModuleCharacteristics = instrument.ivic.IviSwtch.ModuleCharacteristics();
            obj.ScanningConfiguration = instrument.ivic.IviSwtch.ScanningConfiguration();
            obj.MatrixConfiguration = instrument.ivic.IviSwtch.MatrixConfiguration();
        end
        
        function delete(obj)
            obj.MatrixConfiguration = [];
            obj.ScanningConfiguration = [];
            obj.ModuleCharacteristics = [];
            obj.ChannelConfiguration = [];
            obj.InherentIVIAttributes = [];
            obj.Utility = [];
            obj.Scan = [];
            obj.Route = [];
            obj.Configuration = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATION This class provides functions and classes
        %that configure the switch.  The class includes high-level
        %functions that configure the scan list and scan trigger.
        %The class also contains the low-level functions that set,
        %get, and check individual attribute values.  Read Only.
        Configuration
        
        %ROUTE This class contains functions and classes that
        %initiate instrument operations and report their status.
        %Functions/SubClasses:   Read Only.
        Route
        
        %SCAN This class contains functions for configuring
        %scanning switches. Read Only.
        Scan
        
        %UTILITY This class contains functions and sub-classes that
        %control common instrument operations.  These functions
        %include many of functions that VXIplug&play require, such
        %as reset, self-test, revision query, error query, and error
        %message.  This class also contains functions that access
        %IVI error information, lock the session, and perform
        %instrument I/O.  Read Only.
        Utility
        
        %INHERENTIVIATTRIBUTES Attributes common to all IVI
        %instrument drivers. Read Only.
        InherentIVIAttributes
        
        %CHANNELCONFIGURATION Attributes you use to configure the
        %characteristics  Read Only.
        ChannelConfiguration
        
        %MODULECHARACTERISTICS Attributes you use to obtain the
        %characteristics of the switch module.\n Read Only.
        ModuleCharacteristics
        
        %SCANNINGCONFIGURATION Attributes you use to configure a
        %switch module using a scan list string.\n Read Only.
        ScanningConfiguration
        
        %MATRIXCONFIGURATION Attributes you use to configure a
        %matrix switch module.\n Read Only.
        MatrixConfiguration
    end
    
    %% Property access methods
    methods
        %% Configuration property access methods
        function value = get.Configuration(obj)
            if isempty(obj.Configuration)
                obj.Configuration = instrument.ivic.IviSwtch.Configuration();
            end
            value = obj.Configuration;
        end
        
        %% Route property access methods
        function value = get.Route(obj)
            if isempty(obj.Route)
                obj.Route = instrument.ivic.IviSwtch.Route();
            end
            value = obj.Route;
        end
        
        %% Scan property access methods
        function value = get.Scan(obj)
            if isempty(obj.Scan)
                obj.Scan = instrument.ivic.IviSwtch.Scan();
            end
            value = obj.Scan;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = instrument.ivic.IviSwtch.Utility();
            end
            value = obj.Utility;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviSwtch.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% ChannelConfiguration property access methods
        function value = get.ChannelConfiguration(obj)
            if isempty(obj.ChannelConfiguration)
                obj.ChannelConfiguration = instrument.ivic.IviSwtch.ChannelConfiguration();
            end
            value = obj.ChannelConfiguration;
        end
        
        %% ModuleCharacteristics property access methods
        function value = get.ModuleCharacteristics(obj)
            if isempty(obj.ModuleCharacteristics)
                obj.ModuleCharacteristics = instrument.ivic.IviSwtch.ModuleCharacteristics();
            end
            value = obj.ModuleCharacteristics;
        end
        
        %% ScanningConfiguration property access methods
        function value = get.ScanningConfiguration(obj)
            if isempty(obj.ScanningConfiguration)
                obj.ScanningConfiguration = instrument.ivic.IviSwtch.ScanningConfiguration();
            end
            value = obj.ScanningConfiguration;
        end
        
        %% MatrixConfiguration property access methods
        function value = get.MatrixConfiguration(obj)
            if isempty(obj.MatrixConfiguration)
                obj.MatrixConfiguration = instrument.ivic.IviSwtch.MatrixConfiguration();
            end
            value = obj.MatrixConfiguration;
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
            %threads.  You can use the IviSwtch_LockSession and
            %IviSwtch_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviSwtch_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
            if status < 0
                error(message('instrument:ivic:ErrorInvokinginit'));
            end
            obj.session = InstrumentHandle.Value;
            obj.initialized = true;
        end
        
        function InstrumentHandle = InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            %INITWITHOPTIONS This function performs the following
            %initialization actions:  - Creates a new IVI instrument
            %driver session.  - Opens a session to the specified device
            %using the interface and address you specify for the
            %Resource Name parameter.  - If the ID Query parameter is
            %set to True, this function queries the instrument ID and
            %checks that it is valid for this instrument driver.  - If
            %the Reset parameter is set to True, this function resets
            %the instrument to a known state.  - Sends initialization
            %commands to set the instrument to the state necessary for
            %the operation of the instrument driver.  - Returns a
            %session handle that you use to identify the instrument in
            %all subsequent instrument driver function calls.  Note:
            %This function creates a new session each time you invoke
            %it. Although you can open more than one IVI session for the
            %same resource, it is best not to do so.  You can use the
            %same session in multiple program threads.  You can use the
            %IviSwtch_LockSession and IviSwtch_UnlockSession functions
            %to protect sections of code that require exclusive access
            %to the resource.
            
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
            status = calllib(  libname,'IviSwtch_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviSwtch_close.  (2) After calling IviSwtch_close, you
            %cannot use the instrument driver again until you call
            %IviSwtch_init.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviSwtch_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
