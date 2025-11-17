classdef ConfigurationFunctions < instrument.ivic.IviGroupBase
    %CONFIGURATIONFUNCTIONS This class contains functions and
    %sub-classes that configure the function generator.  The
    %class contains high-level functions that configure standard
    %waveform generation, arbitrary waveform generation,
    %arbitrary sequence generation, triggering, amplitude
    %modulation, and frequency modulation.  The class also
    %contains the low-level functions that set, get, and check
    %individual attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = ConfigurationFunctions()
            %% Initialize properties
            obj.StandardWaveform = instrument.ivic.IviFgen.ConfigurationFunctions.StandardWaveform();
            obj.ArbitraryWaveform = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitraryWaveform();
            obj.ArbitrarySequence = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitrarySequence();
            obj.Triggering = instrument.ivic.IviFgen.ConfigurationFunctions.Triggering();
            obj.Burst = instrument.ivic.IviFgen.ConfigurationFunctions.Burst();
            obj.AmplitudeModulation = instrument.ivic.IviFgen.ConfigurationFunctions.AmplitudeModulation();
            obj.FrequencyModulation = instrument.ivic.IviFgen.ConfigurationFunctions.FrequencyModulation();
            obj.SetGetCheckAttribute = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.FrequencyModulation = [];
            obj.AmplitudeModulation = [];
            obj.Burst = [];
            obj.Triggering = [];
            obj.ArbitrarySequence = [];
            obj.ArbitraryWaveform = [];
            obj.StandardWaveform = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.FrequencyModulation.setLibraryAndSession(libName, session);
            obj.AmplitudeModulation.setLibraryAndSession(libName, session);
            obj.Burst.setLibraryAndSession(libName, session);
            obj.Triggering.setLibraryAndSession(libName, session);
            obj.ArbitrarySequence.setLibraryAndSession(libName, session);
            obj.ArbitraryWaveform.setLibraryAndSession(libName, session);
            obj.StandardWaveform.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %STANDARDWAVEFORM This class contains functions that
        %configure the function generator to produce standard
        %waveform output.  These periodic signals are characterized
        %by their waveform, amplitude, DC offset, frequency, and
        %start phase.  Some waveforms may require additional
        %parameters to characterize their output.  For example, a
        %square wave requires a duty cycle parameter in addition to
        %those parameters listed above.  Read Only.
        StandardWaveform
        
        %ARBITRARYWAVEFORM This class contains functions that
        %configure the function generator to produce arbitrary
        %waveform output, create arbitrary waveforms, and clear
        %arbitrary waveforms.    An arbitrary waveform consists of a
        %user-specified array of normalized data that function
        %generator can produce. Read Only.
        ArbitraryWaveform
        
        %ARBITRARYSEQUENCE This class contains functions that
        %configure the function generator to produce arbitrary
        %sequence output, create arbitrary sequences, and clear
        %arbitrary sequences.    An arbitrary sequence consists of
        %multiple arbitrary waveforms.  For each waveform, you
        %specify the number of times the function generator produces
        %the waveform before proceeding to the next waveform.  The
        %number of times to repeat a specific waveform is called the
        %loop count.  Read Only.
        ArbitrarySequence
        
        %TRIGGERING This class contains functions that configure
        %the triggering source.  Read Only.
        Triggering
        
        %BURST This class contains functions that configure the
        %number of waveform cycles the function generator produces
        %when in the burst operation mode. Read Only.
        Burst
        
        %AMPLITUDEMODULATION This class contains functions that
        %configure the modulating signal and apply amplitude
        %modulation to a carrier signal.  Amplitude modulation
        %produces an output signal by varying the amplitude of a
        %carrier signal according to the amplitude of a modulating
        %signal.  You specify the carrier signal with the functions
        %in either the Standard Function Output class or the
        %Arbitrary Waveform Output class.  The modulating signal can
        %be an internally generated or an externally generated
        %signal.   Read Only.
        AmplitudeModulation
        
        %FREQUENCYMODULATION This class contains functions that
        %configure the modulating signal and apply frequency
        %modulation to a carrier signal.  Frequency modulation
        %produces an output signal by varying the frequency of a
        %carrier signal according to the frequency of a modulating
        %signal.  You specify the carrier signal with the functions
        %in either the Standard Function Output class or the
        %Arbitrary Waveform Output class.  The modulating signal can
        %be an internally generated or an externally generated
        %signal.   Read Only.
        FrequencyModulation
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% StandardWaveform property access methods
        function value = get.StandardWaveform(obj)
            if isempty(obj.StandardWaveform)
                obj.StandardWaveform = instrument.ivic.IviFgen.ConfigurationFunctions.StandardWaveform();
            end
            value = obj.StandardWaveform;
        end
        
        %% ArbitraryWaveform property access methods
        function value = get.ArbitraryWaveform(obj)
            if isempty(obj.ArbitraryWaveform)
                obj.ArbitraryWaveform = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitraryWaveform();
            end
            value = obj.ArbitraryWaveform;
        end
        
        %% ArbitrarySequence property access methods
        function value = get.ArbitrarySequence(obj)
            if isempty(obj.ArbitrarySequence)
                obj.ArbitrarySequence = instrument.ivic.IviFgen.ConfigurationFunctions.ArbitrarySequence();
            end
            value = obj.ArbitrarySequence;
        end
        
        %% Triggering property access methods
        function value = get.Triggering(obj)
            if isempty(obj.Triggering)
                obj.Triggering = instrument.ivic.IviFgen.ConfigurationFunctions.Triggering();
            end
            value = obj.Triggering;
        end
        
        %% Burst property access methods
        function value = get.Burst(obj)
            if isempty(obj.Burst)
                obj.Burst = instrument.ivic.IviFgen.ConfigurationFunctions.Burst();
            end
            value = obj.Burst;
        end
        
        %% AmplitudeModulation property access methods
        function value = get.AmplitudeModulation(obj)
            if isempty(obj.AmplitudeModulation)
                obj.AmplitudeModulation = instrument.ivic.IviFgen.ConfigurationFunctions.AmplitudeModulation();
            end
            value = obj.AmplitudeModulation;
        end
        
        %% FrequencyModulation property access methods
        function value = get.FrequencyModulation(obj)
            if isempty(obj.FrequencyModulation)
                obj.FrequencyModulation = instrument.ivic.IviFgen.ConfigurationFunctions.FrequencyModulation();
            end
            value = obj.FrequencyModulation;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureOutputMode(obj,OutputMode)
            %CONFIGUREOUTPUTMODE This function configures the output
            %mode of the function generator. The output mode determines
            %the kind of waveform the function generator produces. For
            %example, you can select to generate a standard waveform, an
            %arbitrary waveform, or a sequence of arbitrary waveforms.
            
            narginchk(2,2)
            OutputMode = obj.checkScalarInt32Arg(OutputMode);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureOutputMode', session, OutputMode);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOperationMode(obj,ChannelName,OperationMode)
            %CONFIGUREOPERATIONMODE This function configures the
            %operation mode of the function generator.  The operation
            %mode determines how the function generator produces output
            %on a channel.  For example, you can select to generate
            %output continuously or to generate a discrete number of
            %waveform cycles based on a trigger event.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            OperationMode = obj.checkScalarInt32Arg(OperationMode);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureOperationMode', session, ChannelName, OperationMode);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureRefClockSource(obj,ReferenceClockSource)
            %CONFIGUREREFCLOCKSOURCE This function configures the
            %function generator's reference clock source. The function
            %generator uses the reference clock to derive frequencies
            %and sample rates when generating output.
            
            narginchk(2,2)
            ReferenceClockSource = obj.checkScalarInt32Arg(ReferenceClockSource);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviFgen_ConfigureRefClockSource', session, ReferenceClockSource);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOutputImpedance(obj,ChannelName,Impedance)
            %CONFIGUREOUTPUTIMPEDANCE This function configures the
            %output impedance for the channel you specify.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            Impedance = obj.checkScalarDoubleArg(Impedance);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureOutputImpedance', session, ChannelName, Impedance);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureOutputEnabled(obj,ChannelName,OutputEnabled)
            %CONFIGUREOUTPUTENABLED This function configures whether
            %the signal the function generator produces appears at a
            %channel's output connector.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            OutputEnabled = obj.checkScalarBoolArg(OutputEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_ConfigureOutputEnabled', session, ChannelName, OutputEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
