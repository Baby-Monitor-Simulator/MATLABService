classdef PulseGeneratorOutput < instrument.ivic.IviGroupBase
    %PULSEGENERATOROUTPUT This group contains attributes to
    %support pulse generator output. It
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %PULSE_OUTPUT_ENABLED_PGO Specifies whether the output of
        %the pulse generator is on  (VI_TRUE) or off (VI_FALSE).
        Pulse_Output_Enabled_PGO
        
        %PULSE_OUTPUT_POLARITY_PGO Specifies the polarity of the
        %output signal.
        Pulse_Output_Polarity_PGO
    end
    
    %% Property access methods
    methods
        %% Pulse_Output_Enabled_PGO property access methods
        function value = get.Pulse_Output_Enabled_PGO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250142);
        end
        function set.Pulse_Output_Enabled_PGO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250142, newValue);
        end
        
        %% Pulse_Output_Polarity_PGO property access methods
        function value = get.Pulse_Output_Polarity_PGO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250141);
        end
        function set.Pulse_Output_Polarity_PGO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.PulseGeneratorOutput.*;
            attrPulseOutputPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250141, newValue);
        end
    end
end
