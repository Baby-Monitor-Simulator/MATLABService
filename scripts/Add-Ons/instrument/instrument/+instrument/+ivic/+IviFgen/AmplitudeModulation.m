classdef AmplitudeModulation < instrument.ivic.IviGroupBase
    %AMPLITUDEMODULATION Attributes for applying amplitude
    %modulation to output signals.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AM_ENABLED_AM This channel-based attribute specifies
        %whether the function generator applies amplitude modulation
        %to the output signal.  Note: (1) This attribute is part of
        %the IviFgenModulateAM AM extension group.
        AM_Enabled_AM
        
        %AM_SOURCE_AM This channel-based attribute specifies the
        %signal that the function generator uses to modulate the
        %output signal.  Note: (1) This attribute is part of the
        %IviFgenModulateAM AM extension group.
        AM_Source_AM
        
        %AM_INTERNAL_DEPTH_AM Specifies the extent of modulation
        %the function generator applies to the carrier signal.  The
        %units are a percentage of full modulation.  At 0% depth,
        %the output amplitude equals the carrier signal's amplitude.
        % At 100% depth, the output amplitude equals twice the the
        %carrier signal's amplitude.     This attribute affects
        %function generator behavior only when the
        %IVIFGEN_ATTR_AM_SOURCE attribute is set to
        %IVIFGEN_VAL_AM_INTERNAL.  Note: (1) This attribute is part
        %of the IviFgenModulateAM AM extension group.
        AM_Internal_Depth_AM
        
        %AM_INTERNAL_WAVEFORM_AM Specifies the standard waveform
        %type that the function generator uses to modulate the
        %output signal.     This attribute affects function
        %generator behavior only when the IVIFGEN_ATTR_AM_SOURCE
        %attribute is set to IVIFGEN_VAL_AM_INTERNAL.  Note: (1)
        %This attribute is part of the IviFgenModulateAM AM
        %extension group.
        AM_Internal_Waveform_AM
        
        %AM_INTERNAL_FREQUENCY_AM Specifies the frequency of the
        %standard waveform that the function generator uses to
        %modulate the output signal.  The units are Hertz (Hz).
        %This attribute affects function generator behavior only
        %when the IVIFGEN_ATTR_AM_SOURCE attribute is set to
        %IVIFGEN_VAL_AM_INTERNAL.  Note: (1) This attribute is part
        %of the IviFgenModulateAM AM extension group.
        AM_Internal_Frequency_AM
    end
    
    %% Property access methods
    methods
        %% AM_Enabled_AM property access methods
        function value = get.AM_Enabled_AM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250401);
        end
        function set.AM_Enabled_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.AmplitudeModulation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250401, newValue);
        end
        
        %% AM_Source_AM property access methods
        function value = get.AM_Source_AM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250402);
        end
        function set.AM_Source_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.AmplitudeModulation.*;
            attrAmSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250402, newValue);
        end
        
        %% AM_Internal_Depth_AM property access methods
        function value = get.AM_Internal_Depth_AM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250403);
        end
        function set.AM_Internal_Depth_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250403, newValue);
        end
        
        %% AM_Internal_Waveform_AM property access methods
        function value = get.AM_Internal_Waveform_AM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250404);
        end
        function set.AM_Internal_Waveform_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.AmplitudeModulation.*;
            attrAmInternalWaveformRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250404, newValue);
        end
        
        %% AM_Internal_Frequency_AM property access methods
        function value = get.AM_Internal_Frequency_AM(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250405);
        end
        function set.AM_Internal_Frequency_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250405, newValue);
        end
    end
end
