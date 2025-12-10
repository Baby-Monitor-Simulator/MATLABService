classdef FrequencyModulation < instrument.ivic.IviGroupBase
    %FREQUENCYMODULATION Attributes for generating frequency
    %modulated signals.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FM_ENABLED_FM Specifies whether the function generator
        %applies frequency modulation to the output signal.  Note:
        %(1) This attribute is part of the IviFgenModulateFM FM
        %extension group.
        FM_Enabled_FM
        
        %FM_SOURCE_FM Specifies the signal the function generator
        %uses to modulate the output signal.  Note: (1) This
        %attribute is part of the IviFgenModulateFM FM extension
        %group.
        FM_Source_FM
        
        %FM_INTERNAL_DEVIATION_FM Specifies the maximum frequency
        %deviation the modulating waveform applies to the carrier
        %waveform.  This deviation corresponds to the maximum
        %amplitude level of the modulating signal.  The units are
        %Hertz (Hz).     This attribute affects function generator
        %behavior only when the IVIFGEN_ATTR_FM_SOURCE attribute is
        %set to IVIFGEN_VAL_FM_INTERNAL.  Note: (1) This attribute
        %is part of the IviFgenModulateFM FM extension group.
        FM_Internal_Deviation_FM
        
        %FM_INTERNAL_WAVEFORM_FM Specifies the standard waveform
        %type that the function generator uses to modulate the
        %output signal.     This attribute affects function
        %generator behavior only when the IVIFGEN_ATTR_FM_SOURCE
        %attribute is set to IVIFGEN_VAL_FM_INTERNAL.  Note: (1)
        %This attribute is part of the IviFgenModulateFM FM
        %extension group.
        FM_Internal_Waveform_FM
        
        %FM_INTERNAL_FREQUENCY_FM Specifies the frequency of the
        %standard waveform that the function generator uses to
        %modulate the output signal.  The units are Hertz (Hz).
        %This attribute affects function generator behavior only
        %when the IVIFGEN_ATTR_FM_SOURCE attribute is set to
        %IVIFGEN_VAL_FM_INTERNAL.  Note: (1) This attribute is part
        %of the IviFgenModulateFM FM extension group.
        FM_Internal_Frequency_FM
    end
    
    %% Property access methods
    methods
        %% FM_Enabled_FM property access methods
        function value = get.FM_Enabled_FM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250501);
        end
        function set.FM_Enabled_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.FrequencyModulation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250501, newValue);
        end
        
        %% FM_Source_FM property access methods
        function value = get.FM_Source_FM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250502);
        end
        function set.FM_Source_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.FrequencyModulation.*;
            attrFmSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250502, newValue);
        end
        
        %% FM_Internal_Deviation_FM property access methods
        function value = get.FM_Internal_Deviation_FM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250503);
        end
        function set.FM_Internal_Deviation_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250503, newValue);
        end
        
        %% FM_Internal_Waveform_FM property access methods
        function value = get.FM_Internal_Waveform_FM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250504);
        end
        function set.FM_Internal_Waveform_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.FrequencyModulation.*;
            attrFmInternalWaveformRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250504, newValue);
        end
        
        %% FM_Internal_Frequency_FM property access methods
        function value = get.FM_Internal_Frequency_FM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250505);
        end
        function set.FM_Internal_Frequency_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250505, newValue);
        end
    end
end
