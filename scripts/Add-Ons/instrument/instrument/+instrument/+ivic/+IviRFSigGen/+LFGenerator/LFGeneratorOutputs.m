classdef LFGeneratorOutputs < instrument.ivic.IviGroupBase
    %LFGENERATOROUTPUTS This group contains attributes for
    %using the LF Generator as a source for
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %LF_GENERATOR_OUTPUT_AMPLITUDE_LFO Specifies the output
        %voltage of the LF generator. The unit is V.
        LF_Generator_Output_Amplitude_LFO
        
        %LF_GENERATOR_OUTPUT_ENABLED_LFO Specifies whether the LF
        %generator applies an output signal (VI_TRUE) or not
        %(VI_FALSE).
        LF_Generator_Output_Enabled_LFO
    end
    
    %% Property access methods
    methods
        %% LF_Generator_Output_Amplitude_LFO property access methods
        function value = get.LF_Generator_Output_Amplitude_LFO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250111);
        end
        function set.LF_Generator_Output_Amplitude_LFO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250111, newValue);
        end
        
        %% LF_Generator_Output_Enabled_LFO property access methods
        function value = get.LF_Generator_Output_Enabled_LFO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250112);
        end
        function set.LF_Generator_Output_Enabled_LFO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.LFGenerator.LFGeneratorOutputs.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250112, newValue);
        end
    end
end
