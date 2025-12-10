classdef (Hidden) IviDmmSpecification < instrument.ivic.IviDriverBase
    %IVIDMMSPECIFICATION IviDmmSpecification
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviDmmSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviDmm');
            
            %% Initialize properties
            obj.Configuration = instrument.ivic.IviDmm.Configuration();
            obj.Measurement = instrument.ivic.IviDmm.Measurement();
            obj.Utility = instrument.ivic.IviDmm.Utility();
            obj.InherentIVIAttributes = instrument.ivic.IviDmm.InherentIVIAttributes();
            obj.BasicOperation = instrument.ivic.IviDmm.BasicOperation();
            obj.Trigger = instrument.ivic.IviDmm.Trigger();
            obj.ACMeasurements = instrument.ivic.IviDmm.ACMeasurements();
            obj.FrequencyMeasurements = instrument.ivic.IviDmm.FrequencyMeasurements();
            obj.TemperatureMeasurements = instrument.ivic.IviDmm.TemperatureMeasurements();
            obj.MultiPointAcquisition = instrument.ivic.IviDmm.MultiPointAcquisition();
            obj.ConfigurationInformation = instrument.ivic.IviDmm.ConfigurationInformation();
            obj.MeasurementOperationOptions = instrument.ivic.IviDmm.MeasurementOperationOptions();
        end
        
        function delete(obj)
            obj.MeasurementOperationOptions = [];
            obj.ConfigurationInformation = [];
            obj.MultiPointAcquisition = [];
            obj.TemperatureMeasurements = [];
            obj.FrequencyMeasurements = [];
            obj.ACMeasurements = [];
            obj.Trigger = [];
            obj.BasicOperation = [];
            obj.InherentIVIAttributes = [];
            obj.Utility = [];
            obj.Measurement = [];
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
        
        %BASICOPERATION Attributes that control the basic features
        %of the DMM. Read Only.
        BasicOperation
        
        %TRIGGER Attributes that configure the triggering
        %capabilities of the DMM.\n Read Only.
        Trigger
        
        %ACMEASUREMENTS Attributes that configure additional
        %parameters for AC  Read Only.
        ACMeasurements
        
        %FREQUENCYMEASUREMENTS Attributes that configure additional
        %parameters for  Read Only.
        FrequencyMeasurements
        
        %TEMPERATUREMEASUREMENTS Attribues that configure
        %additional parameters for temperature  Read Only.
        TemperatureMeasurements
        
        %MULTIPOINTACQUISITION Attributes for acquiring data on
        %multiple triggers and acquiring multiple  Read Only.
        MultiPointAcquisition
        
        %CONFIGURATIONINFORMATION Attributes that return
        %information about the current configuration of the DMM.
        %Read Only.
        ConfigurationInformation
        
        %MEASUREMENTOPERATIONOPTIONS Attributes that configure
        %different measurement operations.\n Read Only.
        MeasurementOperationOptions
    end
    
    %% Property access methods
    methods
        %% Configuration property access methods
        function value = get.Configuration(obj)
            if isempty(obj.Configuration)
                obj.Configuration = instrument.ivic.IviDmm.Configuration();
            end
            value = obj.Configuration;
        end
        
        %% Measurement property access methods
        function value = get.Measurement(obj)
            if isempty(obj.Measurement)
                obj.Measurement = instrument.ivic.IviDmm.Measurement();
            end
            value = obj.Measurement;
        end
        
        %% Utility property access methods
        function value = get.Utility(obj)
            if isempty(obj.Utility)
                obj.Utility = instrument.ivic.IviDmm.Utility();
            end
            value = obj.Utility;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviDmm.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% BasicOperation property access methods
        function value = get.BasicOperation(obj)
            if isempty(obj.BasicOperation)
                obj.BasicOperation = instrument.ivic.IviDmm.BasicOperation();
            end
            value = obj.BasicOperation;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviDmm.Trigger();
            end
            value = obj.Trigger;
        end
        
        %% ACMeasurements property access methods
        function value = get.ACMeasurements(obj)
            if isempty(obj.ACMeasurements)
                obj.ACMeasurements = instrument.ivic.IviDmm.ACMeasurements();
            end
            value = obj.ACMeasurements;
        end
        
        %% FrequencyMeasurements property access methods
        function value = get.FrequencyMeasurements(obj)
            if isempty(obj.FrequencyMeasurements)
                obj.FrequencyMeasurements = instrument.ivic.IviDmm.FrequencyMeasurements();
            end
            value = obj.FrequencyMeasurements;
        end
        
        %% TemperatureMeasurements property access methods
        function value = get.TemperatureMeasurements(obj)
            if isempty(obj.TemperatureMeasurements)
                obj.TemperatureMeasurements = instrument.ivic.IviDmm.TemperatureMeasurements();
            end
            value = obj.TemperatureMeasurements;
        end
        
        %% MultiPointAcquisition property access methods
        function value = get.MultiPointAcquisition(obj)
            if isempty(obj.MultiPointAcquisition)
                obj.MultiPointAcquisition = instrument.ivic.IviDmm.MultiPointAcquisition();
            end
            value = obj.MultiPointAcquisition;
        end
        
        %% ConfigurationInformation property access methods
        function value = get.ConfigurationInformation(obj)
            if isempty(obj.ConfigurationInformation)
                obj.ConfigurationInformation = instrument.ivic.IviDmm.ConfigurationInformation();
            end
            value = obj.ConfigurationInformation;
        end
        
        %% MeasurementOperationOptions property access methods
        function value = get.MeasurementOperationOptions(obj)
            if isempty(obj.MeasurementOperationOptions)
                obj.MeasurementOperationOptions = instrument.ivic.IviDmm.MeasurementOperationOptions();
            end
            value = obj.MeasurementOperationOptions;
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
            %threads.  You can use the IviDmm_LockSession and
            %IviDmm_UnlockSession functions to protect sections of code
            %that require exclusive access to the resource.
            
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
            status = calllib(  libname,'IviDmm_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
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
            %IviDmm_LockSession and IviDmm_UnlockSession functions to
            %protect sections of code that require exclusive access to
            %the resource.
            
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
            status = calllib(  libname,'IviDmm_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviDmm_close.  (2) After calling IviDmm_close, you cannot
            %use the instrument driver again until you call IviDmm_init.
            %
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviDmm_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
