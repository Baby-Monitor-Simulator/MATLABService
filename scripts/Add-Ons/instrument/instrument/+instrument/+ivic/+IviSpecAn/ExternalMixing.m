classdef ExternalMixing < instrument.ivic.IviGroupBase
    %EXTERNALMIXING Attributes to configure anc control the use
    %of an external mixer with the
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %EXTERNAL_MIXER_ENABLED_EM Enables the external mixer.
        External_Mixer_Enabled_EM
        
        %EXTERNAL_MIXER_NUMBER_OF_PORTS_EM Selects the number of
        %ports used in external mixing.
        External_Mixer_Number_of_Ports_EM
        
        %EXTERNAL_MIXER_HARMONIC_EM Specifies the order n of the
        %harmonic used for conversion.
        External_Mixer_Harmonic_EM
        
        %EXTERNAL_MIXER_AVERAGE_CONVERSION_LOSS_EM Specifies the
        %average conversion loss.
        External_Mixer_Average_Conversion_Loss_EM
        
        %EXTERNAL_MIXER_CONVERSION_LOSS_TABLE_ENABLED_EM Enables or
        %disables the conversion loss table.
        External_Mixer_Conversion_Loss_Table_Enabled_EM
        
        %BIAS_ENABLED_EM Enables the external mixer's bias.
        Bias_Enabled_EM
        
        %BIAS_EM Specifies the external mixer bias current in Amps.
        Bias_EM
        
        %BIAS_LIMIT_EM Specifies the external mixer bias current
        %limit in Amps.
        Bias_Limit_EM
    end
    
    %% Property access methods
    methods
        %% External_Mixer_Enabled_EM property access methods
        function value = get.External_Mixer_Enabled_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250906);
        end
        function set.External_Mixer_Enabled_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.ExternalMixing.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250906, newValue);
        end
        
        %% External_Mixer_Number_of_Ports_EM property access methods
        function value = get.External_Mixer_Number_of_Ports_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250908);
        end
        function set.External_Mixer_Number_of_Ports_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250908, newValue);
        end
        
        %% External_Mixer_Harmonic_EM property access methods
        function value = get.External_Mixer_Harmonic_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250907);
        end
        function set.External_Mixer_Harmonic_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250907, newValue);
        end
        
        %% External_Mixer_Average_Conversion_Loss_EM property
        %access methods
        function value = get.External_Mixer_Average_Conversion_Loss_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250901);
        end
        function set.External_Mixer_Average_Conversion_Loss_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250901, newValue);
        end
        
        %% External_Mixer_Conversion_Loss_Table_Enabled_EM property
        %access methods
        function value = get.External_Mixer_Conversion_Loss_Table_Enabled_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250905);
        end
        function set.External_Mixer_Conversion_Loss_Table_Enabled_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.ExternalMixing.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250905, newValue);
        end
        
        %% Bias_Enabled_EM property access methods
        function value = get.Bias_Enabled_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250903);
        end
        function set.Bias_Enabled_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.ExternalMixing.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250903, newValue);
        end
        
        %% Bias_EM property access methods
        function value = get.Bias_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250902);
        end
        function set.Bias_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250902, newValue);
        end
        
        %% Bias_Limit_EM property access methods
        function value = get.Bias_Limit_EM(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250904);
        end
        function set.Bias_Limit_EM(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250904, newValue);
        end
    end
end
