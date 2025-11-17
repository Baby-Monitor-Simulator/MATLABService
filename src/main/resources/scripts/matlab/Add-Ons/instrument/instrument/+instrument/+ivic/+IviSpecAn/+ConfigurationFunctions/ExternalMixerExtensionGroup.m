classdef ExternalMixerExtensionGroup < instrument.ivic.IviGroupBase
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
    %for the reference value marking the table limit.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureExternalMixerEnabled(obj,ExternalMixingEnabled)
            %CONFIGUREEXTERNALMIXERENABLED This function enables
            %external mixing.
            
            narginchk(2,2)
            ExternalMixingEnabled = obj.checkScalarBoolArg(ExternalMixingEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalMixerEnabled', session, ExternalMixingEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureExternalMixerNumberOfPorts(obj,NumberofPorts)
            %CONFIGUREEXTERNALMIXERNUMBEROFPORTS This function
            %specifies the number of external mixer ports.
            
            narginchk(2,2)
            NumberofPorts = obj.checkScalarInt32Arg(NumberofPorts);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalMixerNumberOfPorts', session, NumberofPorts);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureExternalMixer(obj,Harmonic,AverageConversionLoss)
            %CONFIGUREEXTERNALMIXER This function specifies the mixer
            %harmonic and average conversion loss.
            
            narginchk(3,3)
            Harmonic = obj.checkScalarInt32Arg(Harmonic);
            AverageConversionLoss = obj.checkScalarDoubleArg(AverageConversionLoss);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalMixer', session, Harmonic, AverageConversionLoss);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureExternalMixerBiasEnabled(obj,BiasEnabled)
            %CONFIGUREEXTERNALMIXERBIASENABLED This function enables
            %the external mixing bias.
            
            narginchk(2,2)
            BiasEnabled = obj.checkScalarBoolArg(BiasEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalMixerBiasEnabled', session, BiasEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureExternalMixerBias(obj,Bias,BiasLimit)
            %CONFIGUREEXTERNALMIXERBIAS This function configures the
            %external mixer bias and the external mixer bias limit.
            
            narginchk(3,3)
            Bias = obj.checkScalarDoubleArg(Bias);
            BiasLimit = obj.checkScalarDoubleArg(BiasLimit);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureExternalMixerBias', session, Bias, BiasLimit);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureConversionLossTableEnabled(obj,ConversionLossTableEnabled)
            %CONFIGURECONVERSIONLOSSTABLEENABLED This function enables
            %the conversion loss table.
            
            narginchk(2,2)
            ConversionLossTableEnabled = obj.checkScalarBoolArg(ConversionLossTableEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureConversionLossTableEnabled', session, ConversionLossTableEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureConversionLossTable(obj,Count,Frequency,ConversionLoss)
            %CONFIGURECONVERSIONLOSSTABLE This function configures the
            %conversion loss table by specifying a series of frequency
            %and a power loss pairs.
            
            narginchk(4,4)
            Count = obj.checkScalarInt32Arg(Count);
            Frequency = obj.checkVectorDoubleArg(Frequency);
            ConversionLoss = obj.checkVectorDoubleArg(ConversionLoss);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureConversionLossTable', session, Count, Frequency, ConversionLoss);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
