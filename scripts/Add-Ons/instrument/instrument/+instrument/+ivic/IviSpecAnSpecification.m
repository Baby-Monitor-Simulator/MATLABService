classdef (Hidden) IviSpecAnSpecification < instrument.ivic.IviDriverBase
    %IVISPECANSPECIFICATION IviSpecAnSpecification
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviSpecAnSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviSpecAn');
            
            %% Initialize properties
            obj.ConfigurationFunctions = instrument.ivic.IviSpecAn.ConfigurationFunctions();
            obj.Measurement = instrument.ivic.IviSpecAn.Measurement();
            obj.UtilityFunctions = instrument.ivic.IviSpecAn.UtilityFunctions();
            obj.InherentIVIAttributes = instrument.ivic.IviSpecAn.InherentIVIAttributes();
            obj.BasicOperation = instrument.ivic.IviSpecAn.BasicOperation();
            obj.Markers = instrument.ivic.IviSpecAn.Markers();
            obj.Trigger = instrument.ivic.IviSpecAn.Trigger();
            obj.DisplayControl = instrument.ivic.IviSpecAn.DisplayControl();
            obj.ExternalMixing = instrument.ivic.IviSpecAn.ExternalMixing();
        end
        
        function delete(obj)
            obj.ExternalMixing = [];
            obj.DisplayControl = [];
            obj.Trigger = [];
            obj.Markers = [];
            obj.BasicOperation = [];
            obj.InherentIVIAttributes = [];
            obj.UtilityFunctions = [];
            obj.Measurement = [];
            obj.ConfigurationFunctions = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATIONFUNCTIONS This class contains functions and
        %sub-classes that configure the instrument.  The class
        %includes high-level functions that configure multiple
        %instrument settings as well as low-level functions that
        %set, get, and check individual attribute values.  Read Only.
        ConfigurationFunctions
        
        %MEASUREMENT This class contains functions and sub-classes
        %that initiate and retrieve measurements using the current
        %configuration.  The class contains high-level read
        %functions that initiate a measurement and fetch the data in
        %one operation.  The class also contains low-level functions
        %that initiate the measurement process, send a software
        %trigger, and fetch measurement values in separate
        %operations.  Read Only.
        Measurement
        
        %UTILITYFUNCTIONS This class contains functions and
        %sub-classes that control common instrument operations.
        %These functions include many of functions that VXIplug&play
        %require, such as reset, self-test, revision query, error
        %query, and error message.  This class also contains
        %functions that access IVI error information, lock the
        %session, and perform instrument I/O.  Read Only.
        UtilityFunctions
        
        %INHERENTIVIATTRIBUTES Attributes common to all IVI
        %instrument drivers. Read Only.
        InherentIVIAttributes
        
        %BASICOPERATION Attributes that control and define basic
        %spectrum analyzer operation. Read Only.
        BasicOperation
        
        %MARKERS Attributes that define and control markers.
        %Markers are a common  Read Only.
        Markers
        
        %TRIGGER Attributes for trigger configuration and control.
        %Read Only.
        Trigger
        
        %DISPLAYCONTROL Attributes to configure and control the
        %instrument's front panel  Read Only.
        DisplayControl
        
        %EXTERNALMIXING Attributes to configure anc control the use
        %of an external mixer with the  Read Only.
        ExternalMixing
    end
    
    %% Property access methods
    methods
        %% ConfigurationFunctions property access methods
        function value = get.ConfigurationFunctions(obj)
            if isempty(obj.ConfigurationFunctions)
                obj.ConfigurationFunctions = instrument.ivic.IviSpecAn.ConfigurationFunctions();
            end
            value = obj.ConfigurationFunctions;
        end
        
        %% Measurement property access methods
        function value = get.Measurement(obj)
            if isempty(obj.Measurement)
                obj.Measurement = instrument.ivic.IviSpecAn.Measurement();
            end
            value = obj.Measurement;
        end
        
        %% UtilityFunctions property access methods
        function value = get.UtilityFunctions(obj)
            if isempty(obj.UtilityFunctions)
                obj.UtilityFunctions = instrument.ivic.IviSpecAn.UtilityFunctions();
            end
            value = obj.UtilityFunctions;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviSpecAn.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% BasicOperation property access methods
        function value = get.BasicOperation(obj)
            if isempty(obj.BasicOperation)
                obj.BasicOperation = instrument.ivic.IviSpecAn.BasicOperation();
            end
            value = obj.BasicOperation;
        end
        
        %% Markers property access methods
        function value = get.Markers(obj)
            if isempty(obj.Markers)
                obj.Markers = instrument.ivic.IviSpecAn.Markers();
            end
            value = obj.Markers;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviSpecAn.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% DisplayControl property access methods
        function value = get.DisplayControl(obj)
            if isempty(obj.DisplayControl)
                obj.DisplayControl = instrument.ivic.IviSpecAn.DisplayControl();
            end
            value = obj.DisplayControl;
        end
        
        %% ExternalMixing property access methods
        function value = get.ExternalMixing(obj)
            if isempty(obj.ExternalMixing)
                obj.ExternalMixing = instrument.ivic.IviSpecAn.ExternalMixing();
            end
            value = obj.ExternalMixing;
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
            %threads.  You can use the IviSpecAn_LockSession and
            %IviSpecAn_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviSpecAn_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
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
            %IVISPECAN_ATTR_RANGE_CHECK
            %IVISPECAN_ATTR_QUERY_INSTRUMENT_STATUS
            %IVISPECAN_ATTR_CACHE
            %IVISPECAN_ATTR_SIMULATE
            %IVISPECAN_ATTR_RECORD_COERCIONS     - Opens a session to
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
            %threads.  You can use the IviSpecAn_LockSession and
            %IviSpecAn_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviSpecAn_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviSpecAn_close.  (2) After calling IviSpecAn_close, you
            %cannot use the instrument driver again until you call
            %IviSpecAn_init or IviSpecAn_InitWithOptions.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviSpecAn_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
