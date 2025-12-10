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
            obj.RF = instrument.ivic.IviRFSigGen.ConfigurationFunctions.RF();
            obj.AnalogModulation = instrument.ivic.IviRFSigGen.ConfigurationFunctions.AnalogModulation();
            obj.PulseModulation = instrument.ivic.IviRFSigGen.ConfigurationFunctions.PulseModulation();
            obj.LFGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.LFGenerator();
            obj.PulseGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.PulseGenerator();
            obj.Sweep = instrument.ivic.IviRFSigGen.ConfigurationFunctions.Sweep();
            obj.List = instrument.ivic.IviRFSigGen.ConfigurationFunctions.List();
            obj.ALC = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ALC();
            obj.ReferenceOscillator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ReferenceOscillator();
            obj.IQ = instrument.ivic.IviRFSigGen.ConfigurationFunctions.IQ();
            obj.ARBGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ARBGenerator();
            obj.DigitalModulationBase = instrument.ivic.IviRFSigGen.ConfigurationFunctions.DigitalModulationBase();
            obj.CDMA = instrument.ivic.IviRFSigGen.ConfigurationFunctions.CDMA();
            obj.TDMA = instrument.ivic.IviRFSigGen.ConfigurationFunctions.TDMA();
            obj.SetGetCheckAttribute = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute();
        end
        
        function delete(obj)
            obj.SetGetCheckAttribute = [];
            obj.TDMA = [];
            obj.CDMA = [];
            obj.DigitalModulationBase = [];
            obj.ARBGenerator = [];
            obj.IQ = [];
            obj.ReferenceOscillator = [];
            obj.ALC = [];
            obj.List = [];
            obj.Sweep = [];
            obj.PulseGenerator = [];
            obj.LFGenerator = [];
            obj.PulseModulation = [];
            obj.AnalogModulation = [];
            obj.RF = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.SetGetCheckAttribute.setLibraryAndSession(libName, session);
            obj.TDMA.setLibraryAndSession(libName, session);
            obj.CDMA.setLibraryAndSession(libName, session);
            obj.DigitalModulationBase.setLibraryAndSession(libName, session);
            obj.ARBGenerator.setLibraryAndSession(libName, session);
            obj.IQ.setLibraryAndSession(libName, session);
            obj.ReferenceOscillator.setLibraryAndSession(libName, session);
            obj.ALC.setLibraryAndSession(libName, session);
            obj.List.setLibraryAndSession(libName, session);
            obj.Sweep.setLibraryAndSession(libName, session);
            obj.PulseGenerator.setLibraryAndSession(libName, session);
            obj.LFGenerator.setLibraryAndSession(libName, session);
            obj.PulseModulation.setLibraryAndSession(libName, session);
            obj.AnalogModulation.setLibraryAndSession(libName, session);
            obj.RF.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %RF This class contains functions to configure the base
        %capabilities of the RFSigGen. Read Only.
        RF
        
        %ANALOGMODULATION The IviRFSigGenModulateAM Extension Group
        %supports signal generators that can apply amplitude
        %modulation to the RF output signal. The user can enable or
        %disable amplitude modulation, specify the source and
        %coupling of the modulating signal and the modulation depth
        %with lin/log attenuation. Read Only.
        AnalogModulation
        
        %PULSEMODULATION The IviRFSigGenModulatePulse Extension
        %Group supports signal generators that can apply pulse
        %modulation to the RF output signal. The user can enable or
        %disable pulse modulation, and specify the source and the
        %polarity of the modulating signal. Read Only.
        PulseModulation
        
        %LFGENERATOR This class contains functions to configure the
        %low frequency (LF) functionality of RFSigGens. Read Only.
        LFGenerator
        
        %PULSEGENERATOR This class contains sub-classes to
        %configure the pulse generator functionality of RFSigGens.
        %Read Only.
        PulseGenerator
        
        %SWEEP This class contains functions and sub-classes to
        %configure the different sweep functionalities of the
        %RFSigGen.  The IviRFSigGenSweep extension group supports
        %signal generators with the ability to sweep (or step) the
        %frequency or the power of the RF output signal. Read Only.
        Sweep
        
        %LIST The IviRFSigGenList Extension Group supports signal
        %generators that can set the frequency and power of the RF
        %output signal to values given as a list of values. The user
        %can enable or disable stepping the frequency and power
        %list, specify the name of the list and set it's values. The
        %active list can be selected usingd the list name. Setting
        %single step and dwell time are also included.  This
        %extension group requires the Sweep extension group. List
        %stepping is enabled by setting the sweep mode to
        %IVIRFSIGGEN_VAL_SWEEP_MODE_LIST in the sweep extension
        %group. Read Only.
        List
        
        %ALC For generators with configurable Automatic Level
        %Control(ALC). Read Only.
        ALC
        
        %REFERENCEOSCILLATOR The IviRFSigGenReferenceOscillator
        %extension group supports signal generators with a
        %configurable frequency reference. Read Only.
        ReferenceOscillator
        
        %IQ The IviRFSigGenModulateIQ Extension Group supports
        %signal generators that can apply IQ (vector) modulation to
        %the RF output signal. The user can enable or disable IQ
        %modulation and specify the source of the modulating signal.
        %A calibration is executed with an event function. Read Only.
        IQ
        
        %ARBGENERATOR This class contains functions and sub-classes
        %to configure the arbitrary waveform functionality of the
        %RFSigGen. Read Only.
        ARBGenerator
        
        %DIGITALMODULATIONBASE With
        %IviRFSigGenDigitalModulationBase Extension Group the user
        %can generate signals conforming to wireless communication
        %standards (e.g. mobile cellular standards). The generated
        %signals do not have TDMA framing nor CDMA channel coding.
        %The functionality covers basic modulation properties such
        %as IQ constellation, symbol mapping, etc. within a
        %specified communication standard. Read Only.
        DigitalModulationBase
        
        %CDMA This class includes all of the configuration
        %functions for the Code Division Multiple Access(CDMA)
        %functionality extension group. Read Only.
        CDMA
        
        %TDMA This class includes all of the configuration
        %functions for the Time Division Multiple Access(TDMA)
        %functionality extension group. Read Only.
        TDMA
        
        %SETGETCHECKATTRIBUTE This class contains sub-classes for
        %the set, get, and check attribute functions.   Read Only.
        SetGetCheckAttribute
    end
    
    %% Property access methods
    methods
        %% RF property access methods
        function value = get.RF(obj)
            if isempty(obj.RF)
                obj.RF = instrument.ivic.IviRFSigGen.ConfigurationFunctions.RF();
            end
            value = obj.RF;
        end
        
        %% AnalogModulation property access methods
        function value = get.AnalogModulation(obj)
            if isempty(obj.AnalogModulation)
                obj.AnalogModulation = instrument.ivic.IviRFSigGen.ConfigurationFunctions.AnalogModulation();
            end
            value = obj.AnalogModulation;
        end
        
        %% PulseModulation property access methods
        function value = get.PulseModulation(obj)
            if isempty(obj.PulseModulation)
                obj.PulseModulation = instrument.ivic.IviRFSigGen.ConfigurationFunctions.PulseModulation();
            end
            value = obj.PulseModulation;
        end
        
        %% LFGenerator property access methods
        function value = get.LFGenerator(obj)
            if isempty(obj.LFGenerator)
                obj.LFGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.LFGenerator();
            end
            value = obj.LFGenerator;
        end
        
        %% PulseGenerator property access methods
        function value = get.PulseGenerator(obj)
            if isempty(obj.PulseGenerator)
                obj.PulseGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.PulseGenerator();
            end
            value = obj.PulseGenerator;
        end
        
        %% Sweep property access methods
        function value = get.Sweep(obj)
            if isempty(obj.Sweep)
                obj.Sweep = instrument.ivic.IviRFSigGen.ConfigurationFunctions.Sweep();
            end
            value = obj.Sweep;
        end
        
        %% List property access methods
        function value = get.List(obj)
            if isempty(obj.List)
                obj.List = instrument.ivic.IviRFSigGen.ConfigurationFunctions.List();
            end
            value = obj.List;
        end
        
        %% ALC property access methods
        function value = get.ALC(obj)
            if isempty(obj.ALC)
                obj.ALC = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ALC();
            end
            value = obj.ALC;
        end
        
        %% ReferenceOscillator property access methods
        function value = get.ReferenceOscillator(obj)
            if isempty(obj.ReferenceOscillator)
                obj.ReferenceOscillator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ReferenceOscillator();
            end
            value = obj.ReferenceOscillator;
        end
        
        %% IQ property access methods
        function value = get.IQ(obj)
            if isempty(obj.IQ)
                obj.IQ = instrument.ivic.IviRFSigGen.ConfigurationFunctions.IQ();
            end
            value = obj.IQ;
        end
        
        %% ARBGenerator property access methods
        function value = get.ARBGenerator(obj)
            if isempty(obj.ARBGenerator)
                obj.ARBGenerator = instrument.ivic.IviRFSigGen.ConfigurationFunctions.ARBGenerator();
            end
            value = obj.ARBGenerator;
        end
        
        %% DigitalModulationBase property access methods
        function value = get.DigitalModulationBase(obj)
            if isempty(obj.DigitalModulationBase)
                obj.DigitalModulationBase = instrument.ivic.IviRFSigGen.ConfigurationFunctions.DigitalModulationBase();
            end
            value = obj.DigitalModulationBase;
        end
        
        %% CDMA property access methods
        function value = get.CDMA(obj)
            if isempty(obj.CDMA)
                obj.CDMA = instrument.ivic.IviRFSigGen.ConfigurationFunctions.CDMA();
            end
            value = obj.CDMA;
        end
        
        %% TDMA property access methods
        function value = get.TDMA(obj)
            if isempty(obj.TDMA)
                obj.TDMA = instrument.ivic.IviRFSigGen.ConfigurationFunctions.TDMA();
            end
            value = obj.TDMA;
        end
        
        %% SetGetCheckAttribute property access methods
        function value = get.SetGetCheckAttribute(obj)
            if isempty(obj.SetGetCheckAttribute)
                obj.SetGetCheckAttribute = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute();
            end
            value = obj.SetGetCheckAttribute;
        end
    end
end
