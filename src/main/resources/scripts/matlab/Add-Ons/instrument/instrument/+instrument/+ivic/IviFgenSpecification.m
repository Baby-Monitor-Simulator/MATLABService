classdef (Hidden) IviFgenSpecification < instrument.ivic.IviDriverBase
    %IVIFGENSPECIFICATION IviFgenSpecification
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviFgenSpecification()
            
            %% construct superclass
            obj@instrument.ivic.IviDriverBase('IviFgen');
            
            %% Initialize properties
            obj.ConfigurationFunctions = instrument.ivic.IviFgen.ConfigurationFunctions();
            obj.ActionStatusFunctions = instrument.ivic.IviFgen.ActionStatusFunctions();
            obj.UtilityFunctions = instrument.ivic.IviFgen.UtilityFunctions();
            obj.InherentIVIAttributes = instrument.ivic.IviFgen.InherentIVIAttributes();
            obj.BasicOperation = instrument.ivic.IviFgen.BasicOperation();
            obj.StandardFunctionOutput = instrument.ivic.IviFgen.StandardFunctionOutput();
            obj.ArbitraryWaveformOutput = instrument.ivic.IviFgen.ArbitraryWaveformOutput();
            obj.ArbitrarySequenceOutput = instrument.ivic.IviFgen.ArbitrarySequenceOutput();
            obj.Triggering = instrument.ivic.IviFgen.Triggering();
            obj.Burst = instrument.ivic.IviFgen.Burst();
            obj.AmplitudeModulation = instrument.ivic.IviFgen.AmplitudeModulation();
            obj.FrequencyModulation = instrument.ivic.IviFgen.FrequencyModulation();
        end
        
        function delete(obj)
            obj.FrequencyModulation = [];
            obj.AmplitudeModulation = [];
            obj.Burst = [];
            obj.Triggering = [];
            obj.ArbitrarySequenceOutput = [];
            obj.ArbitraryWaveformOutput = [];
            obj.StandardFunctionOutput = [];
            obj.BasicOperation = [];
            obj.InherentIVIAttributes = [];
            obj.UtilityFunctions = [];
            obj.ActionStatusFunctions = [];
            obj.ConfigurationFunctions = [];
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CONFIGURATIONFUNCTIONS This class contains functions and
        %sub-classes that configure the function generator.  The
        %class contains high-level functions that configure standard
        %waveform generation, arbitrary waveform generation,
        %arbitrary sequence generation, triggering, amplitude
        %modulation, and frequency modulation.  The class also
        %contains the low-level functions that set, get, and check
        %individual attribute values.  Read Only.
        ConfigurationFunctions
        
        %ACTIONSTATUSFUNCTIONS This class contains functions and
        %classes that initiate instrument operations and report
        %their status.   Read Only.
        ActionStatusFunctions
        
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
        
        %BASICOPERATION Attributes that control the basic features
        %of the function generator. Read Only.
        BasicOperation
        
        %STANDARDFUNCTIONOUTPUT Attributes for generating standard
        %function waveform output.   Read Only.
        StandardFunctionOutput
        
        %ARBITRARYWAVEFORMOUTPUT Attributes for generating
        %arbitrary waveform output. Read Only.
        ArbitraryWaveformOutput
        
        %ARBITRARYSEQUENCEOUTPUT Attributes for generating
        %arbitrary sequence output. Read Only.
        ArbitrarySequenceOutput
        
        %TRIGGERING Attributes for setting triggering
        %characteristics. Read Only.
        Triggering
        
        %BURST Attributes for setting burst mode characteristics.
        %Read Only.
        Burst
        
        %AMPLITUDEMODULATION Attributes for applying amplitude
        %modulation to output signals.   Read Only.
        AmplitudeModulation
        
        %FREQUENCYMODULATION Attributes for generating frequency
        %modulated signals.   Read Only.
        FrequencyModulation
    end
    
    %% Property access methods
    methods
        %% ConfigurationFunctions property access methods
        function value = get.ConfigurationFunctions(obj)
            if isempty(obj.ConfigurationFunctions)
                obj.ConfigurationFunctions = instrument.ivic.IviFgen.ConfigurationFunctions();
            end
            value = obj.ConfigurationFunctions;
        end
        
        %% ActionStatusFunctions property access methods
        function value = get.ActionStatusFunctions(obj)
            if isempty(obj.ActionStatusFunctions)
                obj.ActionStatusFunctions = instrument.ivic.IviFgen.ActionStatusFunctions();
            end
            value = obj.ActionStatusFunctions;
        end
        
        %% UtilityFunctions property access methods
        function value = get.UtilityFunctions(obj)
            if isempty(obj.UtilityFunctions)
                obj.UtilityFunctions = instrument.ivic.IviFgen.UtilityFunctions();
            end
            value = obj.UtilityFunctions;
        end
        
        %% InherentIVIAttributes property access methods
        function value = get.InherentIVIAttributes(obj)
            if isempty(obj.InherentIVIAttributes)
                obj.InherentIVIAttributes = instrument.ivic.IviFgen.InherentIVIAttributes();
            end
            value = obj.InherentIVIAttributes;
        end
        
        %% BasicOperation property access methods
        function value = get.BasicOperation(obj)
            if isempty(obj.BasicOperation)
                obj.BasicOperation = instrument.ivic.IviFgen.BasicOperation();
            end
            value = obj.BasicOperation;
        end
        
        %% StandardFunctionOutput property access methods
        function value = get.StandardFunctionOutput(obj)
            if isempty(obj.StandardFunctionOutput)
                obj.StandardFunctionOutput = instrument.ivic.IviFgen.StandardFunctionOutput();
            end
            value = obj.StandardFunctionOutput;
        end
        
        %% ArbitraryWaveformOutput property access methods
        function value = get.ArbitraryWaveformOutput(obj)
            if isempty(obj.ArbitraryWaveformOutput)
                obj.ArbitraryWaveformOutput = instrument.ivic.IviFgen.ArbitraryWaveformOutput();
            end
            value = obj.ArbitraryWaveformOutput;
        end
        
        %% ArbitrarySequenceOutput property access methods
        function value = get.ArbitrarySequenceOutput(obj)
            if isempty(obj.ArbitrarySequenceOutput)
                obj.ArbitrarySequenceOutput = instrument.ivic.IviFgen.ArbitrarySequenceOutput();
            end
            value = obj.ArbitrarySequenceOutput;
        end
        
        %% Triggering property access methods
        function value = get.Triggering(obj)
            if isempty(obj.Triggering)
                obj.Triggering = instrument.ivic.IviFgen.Triggering();
            end
            value = obj.Triggering;
        end
        
        %% Burst property access methods
        function value = get.Burst(obj)
            if isempty(obj.Burst)
                obj.Burst = instrument.ivic.IviFgen.Burst();
            end
            value = obj.Burst;
        end
        
        %% AmplitudeModulation property access methods
        function value = get.AmplitudeModulation(obj)
            if isempty(obj.AmplitudeModulation)
                obj.AmplitudeModulation = instrument.ivic.IviFgen.AmplitudeModulation();
            end
            value = obj.AmplitudeModulation;
        end
        
        %% FrequencyModulation property access methods
        function value = get.FrequencyModulation(obj)
            if isempty(obj.FrequencyModulation)
                obj.FrequencyModulation = instrument.ivic.IviFgen.FrequencyModulation();
            end
            value = obj.FrequencyModulation;
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
            %threads.  You can use the IviFgen_LockSession and
            %IviFgen_UnlockSession functions to protect sections of code
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
            status = calllib(  libname,'IviFgen_init', LogicalName, IDQuery, ResetDevice, InstrumentHandle);
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
            %IviFgen_LockSession and IviFgen_UnlockSession functions to
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
            status = calllib(  libname,'IviFgen_InitWithOptions', LogicalName, IDQuery, ResetDevice, OptionString, InstrumentHandle);
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
            %(1) You must unlock the session when you call
            %IviFgen_close.  (2) After calling IviFgen_close, you cannot
            %use the instrument driver again until you call
            %IviFgen_init.
            
            if ~obj.initialized;
                return;
            end
            narginchk(1,1)
            
            libname = obj.libName;
            status = calllib(  libname,'IviFgen_close' ,obj.session);
            if status < 0
                obj.interpretError(status);
            end
            obj.session = [];
            obj.initialized = false;
        end
    end
end
