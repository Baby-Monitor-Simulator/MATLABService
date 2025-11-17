classdef (Hidden) IviScopeSpecification < instrument.ivic.IviDriverBase
    %IVISCOPESPECIFICATION IviScopeSpecification
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviScopeSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviScope');
            
            %% Initialize properties
            obj.Configuration = instrument.ivic.IviScope.Configuration();
            obj.WaveformAcquisition = instrument.ivic.IviScope.WaveformAcquisition();
            obj.Utility = instrument.ivic.IviScope.Utility();
            obj.InherentIVIAttributes = instrument.ivic.IviScope.InherentIVIAttributes();
            obj.Acquisition = instrument.ivic.IviScope.Acquisition();
            obj.ChannelSubsystem = instrument.ivic.IviScope.ChannelSubsystem();
            obj.TriggerSubsystem = instrument.ivic.IviScope.TriggerSubsystem();
            obj.WaveformMeasurementWM = instrument.ivic.IviScope.WaveformMeasurementWM();
        end
        
        function delete(obj)
            obj.WaveformMeasurementWM = [];
            obj.TriggerSubsystem = [];
            obj.ChannelSubsystem = [];
            obj.Acquisition = [];
            obj.InherentIVIAttributes = [];
            obj.Utility = [];
            obj.WaveformAcquisition = [];
            obj.Configuration = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATION This class contains functions and
        %sub-classes that configure the oscilloscope.  The class
        %includes high-level functions that configure the
        %acquisition, channel, and trigger subsystems.  The class
        %also contains the low-level functions that set, get, and
        %check individual attribute values.  Read Only.
        Configuration
        
        %WAVEFORMACQUISITION This class contains functions and
        %sub-classes that initiate and retrieve waveforms and
        %waveform measurements using the current configuration.  The
        %class contains high-level read functions that intiate an
        %acquisition and fetch the data in one operation.  The class
        %also contains low-level functions that intiate an
        %acquisition, and fetch a waveform or wavefrom measurement
        %in separate operations.  Read Only.
        WaveformAcquisition
        
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
        
        %ACQUISITION Attributes that configure the various
        %acquisition modes Read Only.
        Acquisition
        
        %CHANNELSUBSYSTEM Channel-based attributes that you use to
        %configure the oscilloscope. Read Only.
        ChannelSubsystem
        
        %TRIGGERSUBSYSTEM Attributes that control how the
        %oscilloscope triggers an acquisition. Read Only.
        TriggerSubsystem
        
        %WAVEFORMMEASUREMENTWM Attributes that configure the
        %waveform measurement reference levels. Read Only.
        WaveformMeasurementWM
    end
    
    %% Property access methods
    methods
        %% Configuration property access methods
        function value = get.Configuration(obj)
            if isempty(obj.Configuration)
                obj.Configuration = instrument.ivic.IviScope.Configuration();
            end
            value = obj.Configuration;
        end
        
        %% WaveformAcquisition property access methods
        function value = get.WaveformAcquisition(obj)
            if isempty(obj.WaveformAcquisition)
                obj.WaveformAcquisition = instrument.ivic.IviScope.WaveformAcquisition();
            end
            value = obj.WaveformAcquisition;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = instrument.ivic.IviScope.Utility();
            end
            value = obj.Utility;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviScope.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% Acquisition property access methods
        function value = get.Acquisition(obj)
            if isempty(obj.Acquisition)
                obj.Acquisition = instrument.ivic.IviScope.Acquisition();
            end
            value = obj.Acquisition;
        end
        
        %% ChannelSubsystem property access methods
        function value = get.ChannelSubsystem(obj)
            if isempty(obj.ChannelSubsystem)
                obj.ChannelSubsystem = instrument.ivic.IviScope.ChannelSubsystem();
            end
            value = obj.ChannelSubsystem;
        end
        
        %% TriggerSubsystem property access methods
        function value = get.TriggerSubsystem(obj)
            if isempty(obj.TriggerSubsystem)
                obj.TriggerSubsystem = instrument.ivic.IviScope.TriggerSubsystem();
            end
            value = obj.TriggerSubsystem;
        end
        
        %% WaveformMeasurementWM property access methods
        function value = get.WaveformMeasurementWM(obj)
            if isempty(obj.WaveformMeasurementWM)
                obj.WaveformMeasurementWM = instrument.ivic.IviScope.WaveformMeasurementWM();
            end
            value = obj.WaveformMeasurementWM;
        end
    end
    
    %% Public Methods
    methods
        function InstrumentHandle = init(obj,LogicalName,IDQuery,ResetDevice)
            %INIT This function performs the following initialization
            %actions:  - Creates a new IVI instrument driver session.  -
            %Opens a session to the specific driver using the logical
            %name of the IVI driver session.  - If the ID Query
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
            %threads.  You can use the IviScope_LockSession and
            %IviScope_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviScope_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
            if status < 0
                error(message('instrument:ivic:ErrorInvokinginit'));
            end
            obj.session = InstrumentHandle.Value;
            obj.initialized = true;
        end
        
        function InstrumentHandle = InitWithOptions(obj,LogicalName,IDQuery,ResetDevice,OptionString)
            %INITWITHOPTIONS This function performs the following
            %initialization actions:  - Creates a new IVI instrument
            %driver session.  - Opens a session to the specific driver
            %using the logical name of the IVI driver session.  - If the
            %ID Query parameter is set to True, this function queries
            %the instrument ID and checks that it is valid for this
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
            %threads.  You can use the IviScope_LockSession and
            %IviScope_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviScope_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviScope_close.  (2) After calling IviScope_close, you
            %cannot use the instrument driver again until you call
            %IviScope_init.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviScope_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
