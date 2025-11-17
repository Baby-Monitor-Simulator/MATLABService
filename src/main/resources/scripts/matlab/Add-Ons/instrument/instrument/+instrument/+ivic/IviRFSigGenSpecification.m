classdef (Hidden) IviRFSigGenSpecification < instrument.ivic.IviDriverBase
    %IVIRFSIGGENSPECIFICATION IviRFSigGenSpecification
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviRFSigGenSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviRFSigGen');
            
            %% Initialize properties
            obj.ConfigurationFunctions = instrument.ivic.IviRFSigGen.ConfigurationFunctions();
            obj.ActionFunctions = instrument.ivic.IviRFSigGen.ActionFunctions();
            obj.UtilityFunctions = instrument.ivic.IviRFSigGen.UtilityFunctions();
            obj.InherentIVIProperties = instrument.ivic.IviRFSigGen.InherentIVIProperties();
            obj.RF = instrument.ivic.IviRFSigGen.RF();
            obj.AnalogModulation = instrument.ivic.IviRFSigGen.AnalogModulation();
            obj.PulseModulation = instrument.ivic.IviRFSigGen.PulseModulation();
            obj.LFGenerator = instrument.ivic.IviRFSigGen.LFGenerator();
            obj.PulseGenerator = instrument.ivic.IviRFSigGen.PulseGenerator();
            obj.Sweep = instrument.ivic.IviRFSigGen.Sweep();
            obj.ALC = instrument.ivic.IviRFSigGen.ALC();
            obj.ReferenceOscillator = instrument.ivic.IviRFSigGen.ReferenceOscillator();
            obj.IQ = instrument.ivic.IviRFSigGen.IQ();
            obj.ARBGenerator = instrument.ivic.IviRFSigGen.ARBGenerator();
            obj.DigitalModulation = instrument.ivic.IviRFSigGen.DigitalModulation();
            obj.CDMA = instrument.ivic.IviRFSigGen.CDMA();
            obj.TDMA = instrument.ivic.IviRFSigGen.TDMA();
        end
        
        function delete(obj)
            obj.TDMA = [];
            obj.CDMA = [];
            obj.DigitalModulation = [];
            obj.ARBGenerator = [];
            obj.IQ = [];
            obj.ReferenceOscillator = [];
            obj.ALC = [];
            obj.Sweep = [];
            obj.PulseGenerator = [];
            obj.LFGenerator = [];
            obj.PulseModulation = [];
            obj.AnalogModulation = [];
            obj.RF = [];
            obj.InherentIVIProperties = [];
            obj.UtilityFunctions = [];
            obj.ActionFunctions = [];
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
        
        %ACTIONFUNCTIONS This class contains functions and
        %sub-classes that initiate instrument operations and report
        %their status.  Read Only.
        ActionFunctions
        
        %UTILITYFUNCTIONS This class contains functions and
        %sub-classes that control common instrument operations.
        %These functions include many of functions that VXIplug&play
        %require, such as reset, self-test, revision query, error
        %query, and error message.  This class also contains
        %functions that access IVI error infomation, lock the
        %session, and perform instrument I/O.  Read Only.
        UtilityFunctions
        
        %INHERENTIVIPROPERTIES Attributes common to all IVI
        %instrument drivers. Read Only.
        InherentIVIProperties
        
        %RF This group contains all of the fundamental attributes
        %for the IviRFSigGen  Read Only.
        RF
        
        %ANALOGMODULATION This group contains all of the Analog
        %Modulation attributes. Read Only.
        AnalogModulation
        
        %PULSEMODULATION This group contains attributes for RF
        %Signal Generators that can apply  Read Only.
        PulseModulation
        
        %LFGENERATOR This group contains all of the attributes to
        %use a LF Generator (within  Read Only.
        LFGenerator
        
        %PULSEGENERATOR This group contains attributes to support
        %the pulse generator within the  Read Only.
        PulseGenerator
        
        %SWEEP This group contains attributes to support signal
        %generators with the  Read Only.
        Sweep
        
        %ALC For generators with configurable Automatic Level
        %Control. Read Only.
        ALC
        
        %REFERENCEOSCILLATOR This group supports signal generators
        %with a configurable frequency  Read Only.
        ReferenceOscillator
        
        %IQ This group supports RFSigGens that can apply IQ
        %(vector) modulation to  Read Only.
        IQ
        
        %ARBGENERATOR This group contains the attributes to control
        %the internal arbitrary  Read Only.
        ARBGenerator
        
        %DIGITALMODULATION With IviRFSigGenDigitalModulationBase
        %Extension Group the user can  Read Only.
        DigitalModulation
        
        %CDMA With IviRFSigGenCDMABaseFunctionality Extension Group
        %the user can  Read Only.
        CDMA
        
        %TDMA With IviRFSigGenTDMABaseFunctionality Extension Group
        %the user can  Read Only.
        TDMA
    end
    
    %% Property access methods
    methods
        %% ConfigurationFunctions property access methods
        function value = get.ConfigurationFunctions(obj)
            if isempty(obj.ConfigurationFunctions)
                obj.ConfigurationFunctions = instrument.ivic.IviRFSigGen.ConfigurationFunctions();
            end
            value = obj.ConfigurationFunctions;
        end
        
        %% ActionFunctions property access methods
        function value = get.ActionFunctions(obj)
            if isempty(obj.ActionFunctions)
                obj.ActionFunctions = instrument.ivic.IviRFSigGen.ActionFunctions();
            end
            value = obj.ActionFunctions;
        end
        
        %% UtilityFunctions property access methods
        function value = get.UtilityFunctions(obj)
            if isempty(obj.UtilityFunctions)
                obj.UtilityFunctions = instrument.ivic.IviRFSigGen.UtilityFunctions();
            end
            value = obj.UtilityFunctions;
        end
        
        %% InherentIVIProperties property access methods
        function value = get.InherentIVIProperties(obj)
            if isempty(obj.InherentIVIProperties)
                obj.InherentIVIProperties = instrument.ivic.IviRFSigGen.InherentIVIProperties();
            end
            value = obj.InherentIVIProperties;
        end
        
        %% RF property access methods
        function value = get.RF(obj)
            if isempty(obj.RF)
                obj.RF = instrument.ivic.IviRFSigGen.RF();
            end
            value = obj.RF;
        end
        
        %% AnalogModulation property access methods
        function value = get.AnalogModulation(obj)
            if isempty(obj.AnalogModulation)
                obj.AnalogModulation = instrument.ivic.IviRFSigGen.AnalogModulation();
            end
            value = obj.AnalogModulation;
        end
        
        %% PulseModulation property access methods
        function value = get.PulseModulation(obj)
            if isempty(obj.PulseModulation)
                obj.PulseModulation = instrument.ivic.IviRFSigGen.PulseModulation();
            end
            value = obj.PulseModulation;
        end
        
        %% LFGenerator property access methods
        function value = get.LFGenerator(obj)
            if isempty(obj.LFGenerator)
                obj.LFGenerator = instrument.ivic.IviRFSigGen.LFGenerator();
            end
            value = obj.LFGenerator;
        end
        
        %% PulseGenerator property access methods
        function value = get.PulseGenerator(obj)
            if isempty(obj.PulseGenerator)
                obj.PulseGenerator = instrument.ivic.IviRFSigGen.PulseGenerator();
            end
            value = obj.PulseGenerator;
        end
        
        %% Sweep property access methods
        function value = get.Sweep(obj)
            if isempty(obj.Sweep)
                obj.Sweep = instrument.ivic.IviRFSigGen.Sweep();
            end
            value = obj.Sweep;
        end
        
        %% ALC property access methods
        function value = get.ALC(obj)
            if isempty(obj.ALC)
                obj.ALC = instrument.ivic.IviRFSigGen.ALC();
            end
            value = obj.ALC;
        end
        
        %% ReferenceOscillator property access methods
        function value = get.ReferenceOscillator(obj)
            if isempty(obj.ReferenceOscillator)
                obj.ReferenceOscillator = instrument.ivic.IviRFSigGen.ReferenceOscillator();
            end
            value = obj.ReferenceOscillator;
        end
        
        %% IQ property access methods
        function value = get.IQ(obj)
            if isempty(obj.IQ)
                obj.IQ = instrument.ivic.IviRFSigGen.IQ();
            end
            value = obj.IQ;
        end
        
        %% ARBGenerator property access methods
        function value = get.ARBGenerator(obj)
            if isempty(obj.ARBGenerator)
                obj.ARBGenerator = instrument.ivic.IviRFSigGen.ARBGenerator();
            end
            value = obj.ARBGenerator;
        end
        
        %% DigitalModulation property access methods
        function value = get.DigitalModulation(obj)
            if isempty(obj.DigitalModulation)
                obj.DigitalModulation = instrument.ivic.IviRFSigGen.DigitalModulation();
            end
            value = obj.DigitalModulation;
        end
        
        %% CDMA property access methods
        function value = get.CDMA(obj)
            if isempty(obj.CDMA)
                obj.CDMA = instrument.ivic.IviRFSigGen.CDMA();
            end
            value = obj.CDMA;
        end
        
        %% TDMA property access methods
        function value = get.TDMA(obj)
            if isempty(obj.TDMA)
                obj.TDMA = instrument.ivic.IviRFSigGen.TDMA();
            end
            value = obj.TDMA;
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
            %threads.  You can use the IviRFSigGen_LockSession and
            %IviRFSigGen_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviRFSigGen_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
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
            %IVIRFSIGGEN_ATTR_RANGE_CHECK
            %IVIRFSIGGEN_ATTR_QUERY_INSTRUMENT_STATUS
            %IVIRFSIGGEN_ATTR_CACHE
            %IVIRFSIGGEN_ATTR_SIMULATE
            %IVIRFSIGGEN_ATTR_RECORD_COERCIONS      - Opens a session to
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
            %threads.  You can use the IviRFSigGen_LockSession and
            %IviRFSigGen_UnlockSession functions to protect sections of
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
            status = calllib(  libname,'IviRFSigGen_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %IviRFSigGen_close.  (2) After calling IviRFSigGen_close,
            %you cannot use the instrument driver again until you call
            %IviRFSigGen_init or IviRFSigGen_InitWithOptions.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviRFSigGen_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
