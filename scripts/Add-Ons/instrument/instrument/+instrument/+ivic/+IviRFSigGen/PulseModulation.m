classdef PulseModulation < instrument.ivic.IviGroupBase
    %PULSEMODULATION This group contains attributes for RF
    %Signal Generators that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %PULSE_MODULATION_ENABLED_PULM Specifies whether the signal
        %generator applies pulse modulation to the RF output signal
        %(VI_TRUE) or not (VI_FALSE).
        Pulse_Modulation_Enabled_PULM
        
        %PULSE_MODULATION_SOURCE_PULM Specifies the source of the
        %signal that is used as the modulating signal.
        Pulse_Modulation_Source_PULM
        
        %PULSE_MODULATION_EXTERNAL_POLARITY_PULM Specifies the
        %polarity of the external source signal.
        Pulse_Modulation_External_Polarity_PULM
    end
    
    %% Property access methods
    methods
        %% Pulse_Modulation_Enabled_PULM property access methods
        function value = get.Pulse_Modulation_Enabled_PULM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250051);
        end
        function set.Pulse_Modulation_Enabled_PULM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseModulation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250051, newValue);
        end
        
        %% Pulse_Modulation_Source_PULM property access methods
        function value = get.Pulse_Modulation_Source_PULM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250052);
        end
        function set.Pulse_Modulation_Source_PULM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseModulation.*;
            attrPulseModulationSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250052, newValue);
        end
        
        %% Pulse_Modulation_External_Polarity_PULM property access
        %methods
        function value = get.Pulse_Modulation_External_Polarity_PULM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250053);
        end
        function set.Pulse_Modulation_External_Polarity_PULM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseModulation.*;
            attrPulseModulationExternalPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250053, newValue);
        end
    end
end
