classdef ARBGenerator < instrument.ivic.IviGroupBase
    %ARBGENERATOR This group contains the attributes to control
    %the internal arbitrary
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = ARBGenerator()
            %% Initialize properties
            obj.Waveform = instrument.ivic.IviRFSigGen.ARBGenerator.Waveform();
            obj.Trigger = instrument.ivic.IviRFSigGen.ARBGenerator.Trigger();
        end
        
        function delete(obj)
            obj.Trigger = [];
            obj.Waveform = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Trigger.setLibraryAndSession(libName, session);
            obj.Waveform.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %ARB_CLOCK_FREQUENCY_ARB Specifies the sample frequency.
        %The waveform is generated with this clock frequency.
        ARB_Clock_Frequency_ARB
        
        %ARB_FILTER_FREQUENCY_ARB Specifies the cut-off frequency
        %of the low pass filter. The waveform is filtered before
        %output with this filter for anti aliasing. The filter
        %frequency normally is lower than the clock frequency. The
        %units are Hertz.
        ARB_Filter_Frequency_ARB
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %WAVEFORM The group contains attributes that return
        %Waveform parameters. Read Only.
        Waveform
        
        %TRIGGER This group contains attributes for configuring Arb
        %waveform trigger. Read Only.
        Trigger
    end
    
    %% Property access methods
    methods
        %% ARB_Clock_Frequency_ARB property access methods
        function value = get.ARB_Clock_Frequency_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250452);
        end
        function set.ARB_Clock_Frequency_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250452, newValue);
        end
        
        %% ARB_Filter_Frequency_ARB property access methods
        function value = get.ARB_Filter_Frequency_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250453);
        end
        function set.ARB_Filter_Frequency_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250453, newValue);
        end
        %% Waveform property access methods
        function value = get.Waveform(obj)
            if isempty(obj.Waveform)
                obj.Waveform = instrument.ivic.IviRFSigGen.ARBGenerator.Waveform();
            end
            value = obj.Waveform;
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviRFSigGen.ARBGenerator.Trigger();
            end
            value = obj.Trigger;
        end
    end
end
