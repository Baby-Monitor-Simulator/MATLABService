classdef PulseGenerator < instrument.ivic.IviGroupBase
    %PULSEGENERATOR This group contains attributes to support
    %the pulse generator within the
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = PulseGenerator()
            %% Initialize properties
            obj.DoublePulseGenerators = instrument.ivic.IviRFSigGen.PulseGenerator.DoublePulseGenerators();
            obj.PulseGeneratorOutput = instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput();
        end
        
        function delete(obj)
            obj.PulseGeneratorOutput = [];
            obj.DoublePulseGenerators = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.PulseGeneratorOutput.setLibraryAndSession(libName, session);
            obj.DoublePulseGenerators.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %PULSE_INTERNAL_TRIGGER_PERIOD_PG Specifies the period of
        %the pulse generators output signal (if Pulse Trigger Source
        %is set to Internal). The units are in seconds.
        Pulse_Internal_Trigger_Period_PG
        
        %PULSE_WIDTH_PG Specifies the width of the output pulse.
        %The units are in seconds.
        Pulse_Width_PG
        
        %PULSE_GATING_ENABLED_PG Specifies whether pulse gating is
        %enabled(VI_TRUE) or disabled(VI_FALSE).
        Pulse_Gating_Enabled_PG
        
        %PULSE_TRIGGER_SOURCE_PG Specifies the source of the signal
        %the pulse generator uses to generate one pulse.
        Pulse_Trigger_Source_PG
        
        %PULSE_EXTERNAL_TRIGGER_SLOPE_PG Specifies whether the
        %event occurs on the rising or falling edge of the input
        %signal.
        Pulse_External_Trigger_Slope_PG
        
        %PULSE_EXTERNAL_TRIGGER_DELAY_PG Specifies the delay for
        %starting the output pulse with respect to the trigger
        %input. The units are in seconds.
        Pulse_External_Trigger_Delay_PG
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %DOUBLEPULSEGENERATORS This group contains attributes to
        %support double pulse generation. It  Read Only.
        DoublePulseGenerators
        
        %PULSEGENERATOROUTPUT This group contains attributes to
        %support pulse generator output. It  Read Only.
        PulseGeneratorOutput
    end
    
    %% Property access methods
    methods
        %% Pulse_Internal_Trigger_Period_PG property access methods
        function value = get.Pulse_Internal_Trigger_Period_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250121);
        end
        function set.Pulse_Internal_Trigger_Period_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250121, newValue);
        end
        
        %% Pulse_Width_PG property access methods
        function value = get.Pulse_Width_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250122);
        end
        function set.Pulse_Width_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250122, newValue);
        end
        
        %% Pulse_Gating_Enabled_PG property access methods
        function value = get.Pulse_Gating_Enabled_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250123);
        end
        function set.Pulse_Gating_Enabled_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250123, newValue);
        end
        
        %% Pulse_Trigger_Source_PG property access methods
        function value = get.Pulse_Trigger_Source_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250124);
        end
        function set.Pulse_Trigger_Source_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.*;
            attrPulseTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250124, newValue);
        end
        
        %% Pulse_External_Trigger_Slope_PG property access methods
        function value = get.Pulse_External_Trigger_Slope_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250125);
        end
        function set.Pulse_External_Trigger_Slope_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.*;
            attrPulseExternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250125, newValue);
        end
        
        %% Pulse_External_Trigger_Delay_PG property access methods
        function value = get.Pulse_External_Trigger_Delay_PG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250126);
        end
        function set.Pulse_External_Trigger_Delay_PG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250126, newValue);
        end
        %% DoublePulseGenerators property access methods
        function value = get.DoublePulseGenerators(obj)
            if isempty(obj.DoublePulseGenerators)
                obj.DoublePulseGenerators = instrument.ivic.IviRFSigGen.PulseGenerator.DoublePulseGenerators();
            end
            value = obj.DoublePulseGenerators;
        end
        
        %% PulseGeneratorOutput property access methods
        function value = get.PulseGeneratorOutput(obj)
            if isempty(obj.PulseGeneratorOutput)
                obj.PulseGeneratorOutput = instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput();
            end
            value = obj.PulseGeneratorOutput;
        end
    end
end
