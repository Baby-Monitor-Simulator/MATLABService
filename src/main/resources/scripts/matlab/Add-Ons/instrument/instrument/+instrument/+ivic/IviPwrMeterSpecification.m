classdef (Hidden) IviPwrMeterSpecification < instrument.ivic.IviDriverBase
    %IVIPWRMETERSPECIFICATION IviPwrMeterSpecification
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviPwrMeterSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviPwrMeter');
            
            %% Initialize properties
            obj.Configuration = instrument.ivic.IviPwrMeter.Configuration();
            obj.Zeroing = instrument.ivic.IviPwrMeter.Zeroing();
            obj.Calibration = instrument.ivic.IviPwrMeter.Calibration();
            obj.Measurement = instrument.ivic.IviPwrMeter.Measurement();
            obj.Utility = instrument.ivic.IviPwrMeter.Utility();
            obj.InherentIVIAttributes = instrument.ivic.IviPwrMeter.InherentIVIAttributes();
            obj.BasicOperation = instrument.ivic.IviPwrMeter.BasicOperation();
            obj.ManualRange = instrument.ivic.IviPwrMeter.ManualRange();
            obj.Trigger = instrument.ivic.IviPwrMeter.Trigger();
            obj.DutyCycle = instrument.ivic.IviPwrMeter.DutyCycle();
            obj.AveragingCount = instrument.ivic.IviPwrMeter.AveragingCount();
            obj.ReferenceOscillator = instrument.ivic.IviPwrMeter.ReferenceOscillator();
        end
        
        function delete(obj)
            obj.ReferenceOscillator = [];
            obj.AveragingCount = [];
            obj.DutyCycle = [];
            obj.Trigger = [];
            obj.ManualRange = [];
            obj.BasicOperation = [];
            obj.InherentIVIAttributes = [];
            obj.Utility = [];
            obj.Measurement = [];
            obj.Calibration = [];
            obj.Zeroing = [];
            obj.Configuration = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATION This class contains functions and
        %sub-classes that configure the DMM.  The class includes
        %high-level functions that configure the basic measurement
        %operation and subclasses that configure the trigger and the
        %multi-point measurement capability.  It also contains
        %sub-classes that configure additional parameters for some
        %measurement types and that return information about the
        %current state of the instrument. The class also contains
        %the low-level functions that set, get, and check individual
        %attribute values.  Read Only.
        Configuration
        
        %ZEROING This class contains functions to perform the zero
        %correction. Read Only.
        Zeroing
        
        %CALIBRATION This class contains functions to perform the
        %calibration. Read Only.
        Calibration
        
        %MEASUREMENT This class contains functions and sub-classes
        %that initiate and retrieve measurements using the current
        %configuration.  The class contains high-level read
        %functions that initiate a measurement and fetch the data in
        %one operation.  The class also contains low-level functions
        %that initiate the measurement process, send a software
        %trigger, and fetch measurement values in separate
        %operations.  Read Only.
        Measurement
        
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
        
        %BASICOPERATION Basic Operation Read Only.
        BasicOperation
        
        %MANUALRANGE Manual Range Read Only.
        ManualRange
        
        %TRIGGER Trigger Read Only.
        Trigger
        
        %DUTYCYCLE Duty Cycle Read Only.
        DutyCycle
        
        %AVERAGINGCOUNT Averaging Count Read Only.
        AveragingCount
        
        %REFERENCEOSCILLATOR Reference Oscillator Read Only.
        ReferenceOscillator
    end
    
    %% Property access methods
    methods
        %% Configuration property access methods
        function value = get.Configuration(obj)
            if isempty(obj.Configuration)
                obj.Configuration = instrument.ivic.IviPwrMeter.Configuration();
            end
            value = obj.Configuration;
        end
        
        %% Zeroing property access methods
        function value = get.Zeroing(obj)
            if isempty(obj.Zeroing)
                obj.Zeroing = instrument.ivic.IviPwrMeter.Zeroing();
            end
            value = obj.Zeroing;
        end
        
        %% Calibration property access methods
        function value = get.Calibration(obj)
            if isempty(obj.Calibration)
                obj.Calibration = instrument.ivic.IviPwrMeter.Calibration();
            end
            value = obj.Calibration;
        end
        
        %% Measurement property access methods
        function value = get.Measurement(obj)
            if isempty(obj.Measurement)
                obj.Measurement = instrument.ivic.IviPwrMeter.Measurement();
            end
            value = obj.Measurement;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = instrument.ivic.IviPwrMeter.Utility();
            end
            value = obj.Utility;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviPwrMeter.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% BasicOperation property access methods
        function value = get.BasicOperation(obj)
            if isempty(obj.BasicOperation)
                obj.BasicOperation = instrument.ivic.IviPwrMeter.BasicOperation();
            end
            value = obj.BasicOperation;
        end
        
        %% ManualRange property access methods
        function value = get.ManualRange(obj)
            if isempty(obj.ManualRange)
                obj.ManualRange = instrument.ivic.IviPwrMeter.ManualRange();
            end
            value = obj.ManualRange;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviPwrMeter.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% DutyCycle property access methods
        function value = get.DutyCycle(obj)
            if isempty(obj.DutyCycle)
                obj.DutyCycle = instrument.ivic.IviPwrMeter.DutyCycle();
            end
            value = obj.DutyCycle;
        end
        
        %% AveragingCount property access methods
        function value = get.AveragingCount(obj)
            if isempty(obj.AveragingCount)
                obj.AveragingCount = instrument.ivic.IviPwrMeter.AveragingCount();
            end
            value = obj.AveragingCount;
        end
        
        %% ReferenceOscillator property access methods
        function value = get.ReferenceOscillator(obj)
            if isempty(obj.ReferenceOscillator)
                obj.ReferenceOscillator = instrument.ivic.IviPwrMeter.ReferenceOscillator();
            end
            value = obj.ReferenceOscillator;
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
            %threads.  You can use the IviPwrMeter_LockSession and
            %IviPwrMeter_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviPwrMeter_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
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
            %IviPwrMeter_LockSession and IviPwrMeter_UnlockSession
            %functions to protect sections of code that require
            %exclusive access to the resource.
            
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
            status = calllib(  libname,'IviPwrMeter_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviPwrMeter_close.  (2) After calling IviPwrMeter_close,
            %you cannot use the instrument driver again until you call
            %IviPwrMeter_init or IviPwrMeter_InitWithOptions.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviPwrMeter_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
