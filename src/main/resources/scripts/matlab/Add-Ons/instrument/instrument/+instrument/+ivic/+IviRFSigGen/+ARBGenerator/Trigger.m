classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This group contains attributes for configuring Arb
    %waveform trigger.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ARB_TRIGGER_SOURCE_ARB Specifies how the Arb waveform is
        %started (triggered).
        ARB_Trigger_Source_ARB
        
        %ARB_EXTERNAL_TRIGGER_SLOPE_ARB Specifies whether the
        %trigger event occurs on the rising or falling edge of the
        %input signal.
        ARB_External_Trigger_Slope_ARB
    end
    
    %% Property access methods
    methods
        %% ARB_Trigger_Source_ARB property access methods
        function value = get.ARB_Trigger_Source_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250458);
        end
        function set.ARB_Trigger_Source_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.ARBGenerator.Trigger.*;
            attrArbTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250458, newValue);
        end
        
        %% ARB_External_Trigger_Slope_ARB property access methods
        function value = get.ARB_External_Trigger_Slope_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250459);
        end
        function set.ARB_External_Trigger_Slope_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.ARBGenerator.Trigger.*;
            attrArbExternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250459, newValue);
        end
    end
end
