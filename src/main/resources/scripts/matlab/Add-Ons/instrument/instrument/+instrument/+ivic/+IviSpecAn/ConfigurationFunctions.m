classdef ConfigurationFunctions < instrument.ivic.IviGroupBase
    %CONFIGURATIONFUNCTIONS This class contains functions and
    %sub-classes that configure the instrument.  The class
    %includes high-level functions that configure multiple
    %instrument settings as well as low-level functions that
    %set, get, and check individual attribute values.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = ConfigurationFunctions()
            %% Initialize properties
            obj.Multitrace = instrument.ivic.IviSpecAn.ConfigurationFunctions.Multitrace();
            obj.Marker = instrument.ivic.IviSpecAn.ConfigurationFunctions.Marker();
            obj.TriggerExtensionGroup = instrument.ivic.IviSpecAn.ConfigurationFunctions.TriggerExtensionGroup();
            obj.ExternalMixerExtensionGroup = instrument.ivic.IviSpecAn.ConfigurationFunctions.ExternalMixerExtensionGroup();
            obj.SetGetCheckAttribute = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.ExternalMixerExtensionGroup = [];
            obj.TriggerExtensionGroup = [];
            obj.Marker = [];
            obj.Multitrace = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.ExternalMixerExtensionGroup.setLibraryAndSession(libName, session);
            obj.TriggerExtensionGroup.setLibraryAndSession(libName, session);
            obj.Marker.setLibraryAndSession(libName, session);
            obj.Multitrace.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MULTITRACE The IviSpecAnMultitrace extension group defines
        %extensions for analyzers capable of performing simple
        %mathematical functions on one or more traces. Read Only.
        Multitrace
        
        %MARKER Most analyzers utilize markers.  The marker
        %extension group defines extensions for analyzers capable of
        %performing various functions on one or more traces that
        %involve using markers.  Markers can be used for things as
        %simple as getting amplitude value at a specific point to
        %complex functions such as signal tracking.  The marker
        %extension group defines additional attributes such Active
        %Marker and Marker Amplitude. Read Only.
        Marker
        
        %TRIGGEREXTENSIONGROUP This extension group specifies the
        %source of the trigger signal that causes the analyzer to
        %leave the Wait-For-Trigger state. Read Only.
        TriggerExtensionGroup
        
        %EXTERNALMIXEREXTENSIONGROUP Many spectrum analyzers have
        %outputs and inputs that allow external equipment to use the
        %IF or mixer signal that the spectrum analyzer uses.  In
        %this case, external equipment can be used to mix signals to
        %convert them to measurable frequencies.  This allows the
        %use of an analyzer to measure values that are outside of
        %the normal frequency range of the equipment.  When using an
        %external mixer, many of the settings of the analyzer have
        %to be carefully converted to allow the user to know what is
        %meant by the values read.  Specifically, the frequency, the
        %harmonic number, mixer configuration, and conversion loss
        %must be configured carefully to be able to use the external
        %mixing successfully.  The frequency of the input signal can
        %be expressed as a function of the Local Oscillator (LO)
        %frequency and the selected harmonic of the 1st LO is as
        %follows:          fin = n * fLO +/- fIF         where:  fin
        %  frequency of input signal             n     order of
        %harmonic used for conversion             fLO    frequency
        %of 1st LO             fIF      intermediate frequency  The
        %Harmonic number defines the order n of the harmonic used
        %for conversion. Both even and odd harmonics can be used.
        %The selected harmonic, together with the setting range of
        %the 1st LO, determines the limits of the settable frequency
        %range.  The following applies:  Lower frequency limit:
        %fmin. = n * fLO,min. - fIF Upper frequency limit:  fmax. =
        %n * fLO,max. + fIF         Where:             fLO,min
        %lower frequency limit of LO             fLO,max  upper
        %frequency limit of LO           The following sections
        %describe the mixer configuration and the conversion loss
        %table configuration.  13.1.1  Mixer Configuration  The
        %external mixers are configured either as two-port or three
        %port mixers.  Single-diode mixers generally require a DC
        %voltage which is applied via the LO line. This DC voltage
        %is to be tuned to the minimum conversion loss versus
        %frequency.  Some instruments can define a limit for the
        %BIAS current. The two-port mixer connects the 'LO OUT / IF
        %IN' output of the analyzer to the LO/IF port of the
        %external mixer.  The diplexer is contained in the analyzer
        %and the IF signal can be tapped from the line which is used
        %to feed the LO signal to the mixer.  The signal to be
        %measured is fed to the RF input of the external mixer.  On
        %the other hand, the three-port mixer connects the 'LO OUT /
        %IF IN' output of the analyzer to the LO port of the
        %external mixer.  The 'IF IN' input of the analyzer is
        %connected to the IF port of the external mixer.  The signal
        %to be measured is fed to the RF input of the external
        %mixer.  13.1.2  Conversion Loss  The maximum settable
        %reference level depends on the external mixer's conversion
        %loss which is defined by average conversion loss or by
        %using the conversion loss table.  For example, if an IF
        %signal with a level of -20 dBm is applied to the LO OUT /
        %IF IN or IF IN input of the spectrum analyzer, full screen
        %level is attained. Consequently, the maximum settable
        %reference level is -20 dBm at a set conversion loss of 0
        %dB.  If a conversion loss > 0 dB is entered, the maximum
        %settable reference level increases in the same proportion.
        %If the maximum possible reference level is set on the
        %analyzer, this level is reduced if a smaller conversion
        %loss is entered.    In addition to the dynamic range of the
        %spectrum analyzer the 1 dB compression point of the mixer
        %has to be taken into account. The levels of the input
        %signals lie well below this value to avoid generation of
        %harmonics of these signals in the mixer. These are
        %converted by the LO signals harmonics of higher order and
        %appear in the displayed spectrum.  Some instruments allow
        %to define conversion loss tables. The Conversion loss table
        %allows the conversion loss of the mixer in the selected
        %band to be taken into account as a function of frequency.
        %Correction values for frequencies between the individual
        %reference values are obtained by interpolation (Linear
        %interpolation). Outside the frequency range covered by the
        %table the conversion loss is assumed to be the same as that
        %for the reference value marking the table limit.   Read
        %Only.
        ExternalMixerExtensionGroup
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% Multitrace property access methods
        function value = get.Multitrace(obj)
            if isempty(obj.Multitrace)
                obj.Multitrace = instrument.ivic.IviSpecAn.ConfigurationFunctions.Multitrace();
            end
            value = obj.Multitrace;
        end
        
        %% Marker property access methods
        function value = get.Marker(obj)
            if isempty(obj.Marker)
                obj.Marker = instrument.ivic.IviSpecAn.ConfigurationFunctions.Marker();
            end
            value = obj.Marker;
        end
        
        %% TriggerExtensionGroup property access methods
        function value = get.TriggerExtensionGroup(obj)
            if isempty(obj.TriggerExtensionGroup)
                obj.TriggerExtensionGroup = instrument.ivic.IviSpecAn.ConfigurationFunctions.TriggerExtensionGroup();
            end
            value = obj.TriggerExtensionGroup;
        end
        
        %% ExternalMixerExtensionGroup property access methods
        function value = get.ExternalMixerExtensionGroup(obj)
            if isempty(obj.ExternalMixerExtensionGroup)
                obj.ExternalMixerExtensionGroup = instrument.ivic.IviSpecAn.ConfigurationFunctions.ExternalMixerExtensionGroup();
            end
            value = obj.ExternalMixerExtensionGroup;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
    
    %% Public Methods
    methods
        function ConfigureFrequencyStartStop(obj,StartFrequency,StopFrequency)
            %CONFIGUREFREQUENCYSTARTSTOP This function configures the
            %frequency range defining its start frequency and its stop
            %frequency.  If the start frequency is equal to the stop
            %frequency, then the spectrum analyzer operates in the
            %time-domain mode.  Otherwise, the spectrum analyzer
            %operates in frequency-domain mode.  Notes:  (1) In
            %auto-coupled mode, resolution bandwidth (RBW), video
            %bandwidth (VBW), and sweep time may be affected by this
            %function.
            
            narginchk(3,3)
            StartFrequency = obj.checkScalarDoubleArg(StartFrequency);
            StopFrequency = obj.checkScalarDoubleArg(StopFrequency);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureFrequencyStartStop', session, StartFrequency, StopFrequency);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencyCenterSpan(obj,CenterFrequency,Span)
            %CONFIGUREFREQUENCYCENTERSPAN This function configures the
            %frequency range of the spectrum analyzer using the center
            %frequency and the frequency span.  If span corresponds to
            %zero Hertz, then the spectrum analyzer operates in
            %time-domain mode.  Otherwise, spectrum analyzer operates in
            %frequency-domain mode.  This function modifies the
            %IVISPECAN_ATTR_FREQUENCY_START and
            %IVISPECAN_ATTR_FREQUENCY_STOP attributes as follows:
            %Frequency Start = Center Frequency - Span/2     Frequency
            %Stop  = Center Frequency + Span/2  Note:  In auto-coupled
            %mode, resolution bandwidth (RBW), video bandwidth (VBW),
            %and sweep time may be affected by this function.
            
            narginchk(3,3)
            CenterFrequency = obj.checkScalarDoubleArg(CenterFrequency);
            Span = obj.checkScalarDoubleArg(Span);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureFrequencyCenterSpan', session, CenterFrequency, Span);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureFrequencyOffset(obj,FrequencyOffset)
            %CONFIGUREFREQUENCYOFFSET This function configures the
            %frequency offset of the spectrum analyzer. This affects the
            %setting of the spectrum analyzer's absolute frequencies,
            %such as start, stop, center, and marker.  This function
            %does not modify the settings for differences of
            %frequencies, such as span and delta marker.
            
            narginchk(2,2)
            FrequencyOffset = obj.checkScalarDoubleArg(FrequencyOffset);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureFrequencyOffset', session, FrequencyOffset);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureSweepCoupling(obj,ResolutionBandwidthAuto,ResolutionBandwidth,VideoBandwidthAuto,VideoBandwidth,SweepTimeAuto,SweepTime)
            %CONFIGURESWEEPCOUPLING This function configures the
            %coupling and sweeping attributes of the spectrum analyzer.
            
            narginchk(7,7)
            ResolutionBandwidthAuto = obj.checkScalarBoolArg(ResolutionBandwidthAuto);
            ResolutionBandwidth = obj.checkScalarDoubleArg(ResolutionBandwidth);
            VideoBandwidthAuto = obj.checkScalarBoolArg(VideoBandwidthAuto);
            VideoBandwidth = obj.checkScalarDoubleArg(VideoBandwidth);
            SweepTimeAuto = obj.checkScalarBoolArg(SweepTimeAuto);
            SweepTime = obj.checkScalarDoubleArg(SweepTime);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureSweepCoupling', session, ResolutionBandwidthAuto, ResolutionBandwidth, VideoBandwidthAuto, VideoBandwidth, SweepTimeAuto, SweepTime);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureAcquisition(obj,SweepModeContinuous,NumberOfSweeps,DetectorTypeAuto,DetectorType,VerticalScale)
            %CONFIGUREACQUISITION This function configures the
            %acquisition attributes of the spectrum analyzer.
            
            narginchk(6,6)
            SweepModeContinuous = obj.checkScalarBoolArg(SweepModeContinuous);
            NumberOfSweeps = obj.checkScalarInt32Arg(NumberOfSweeps);
            DetectorTypeAuto = obj.checkScalarBoolArg(DetectorTypeAuto);
            DetectorType = obj.checkScalarInt32Arg(DetectorType);
            VerticalScale = obj.checkScalarInt32Arg(VerticalScale);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureAcquisition', session, SweepModeContinuous, NumberOfSweeps, DetectorTypeAuto, DetectorType, VerticalScale);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureLevel(obj,AmplitudeUnits,InputImpedance,ReferenceLevel,ReferenceLevelOffset,AttenuationAuto,Attenuation)
            %CONFIGURELEVEL This function configures the vertical
            %settings of the spectrum analyzer.  This corresponds to
            %settings like amplitude units, input attenuation, input
            %impedance, reference level, and reference level offset.
            
            narginchk(7,7)
            AmplitudeUnits = obj.checkScalarInt32Arg(AmplitudeUnits);
            InputImpedance = obj.checkScalarDoubleArg(InputImpedance);
            ReferenceLevel = obj.checkScalarDoubleArg(ReferenceLevel);
            ReferenceLevelOffset = obj.checkScalarDoubleArg(ReferenceLevelOffset);
            AttenuationAuto = obj.checkScalarBoolArg(AttenuationAuto);
            Attenuation = obj.checkScalarDoubleArg(Attenuation);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureLevel', session, AmplitudeUnits, InputImpedance, ReferenceLevel, ReferenceLevelOffset, AttenuationAuto, Attenuation);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureTraceType(obj,TraceName,TraceType)
            %CONFIGURETRACETYPE This function configures the type of
            %trace to acquire.
            
            narginchk(3,3)
            TraceName = obj.checkScalarStringArg(TraceName);
            TraceType = obj.checkScalarInt32Arg(TraceType);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TraceName = [double(TraceName) 0];
                
                status = calllib( libname,'IviSpecAn_ConfigureTraceType', session, TraceName, TraceType);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetTraceName(obj,Index,NameBufferSize)
            %GETTRACENAME This function returns the specific driver
            %defined trace name that corresponds to the one-based index
            %specified by the Index parameter.  If you pass in a value
            %for the Index parameter that is less than one or greater
            %than the value of the IVISPECAN_ATTR_TRACE_COUNT attribute,
            %the function returns an empty string in the Name parameter
            %and returns the Invalid Value error (0xBFFA1010).  Note:
            %For an instrument with only one Trace, i.e. the
            %IVISPECAN_ATTR_TRACE_COUNT attribute is one, the driver may
            %return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_GetTraceName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function TraceSize = QueryTraceSize(obj,TraceName)
            %QUERYTRACESIZE This function queries the read-only
            %IVISPECAN_ATTR_TRACE_SIZE attribute.
            
            narginchk(2,2)
            TraceName = obj.checkScalarStringArg(TraceName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                TraceName = [double(TraceName) 0];
                TraceSize = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviSpecAn_QueryTraceSize', session, TraceName, TraceSize);
                
                TraceSize = TraceSize.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function PeakPreselector(obj)
            %PEAKPRESELECTOR This function adjusts the preselector to
            %obtain the maximum readings for the current start and stop
            %frequency. This function may affect the marker
            %configuration.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_PeakPreselector', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
