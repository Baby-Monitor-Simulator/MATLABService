classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This group contains attributes for configuring
    %CDMA trigger.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %CDMA_TRIGGER_SOURCE_CDMA Specifies the source of the
        %trigger signal that starts the channel coding generation.
        CDMA_Trigger_Source_CDMA
        
        %CDMA_EXTERNAL_TRIGGER_SLOPE_CDMA Specifies whether the
        %trigger event occurs on the rising or falling edge of the
        %input signal.
        CDMA_External_Trigger_Slope_CDMA
    end
    
    %% Property access methods
    methods
        %% CDMA_Trigger_Source_CDMA property access methods
        function value = get.CDMA_Trigger_Source_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250603);
        end
        function set.CDMA_Trigger_Source_CDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.CDMA.Trigger.*;
            attrCdmaTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250603, newValue);
        end
        
        %% CDMA_External_Trigger_Slope_CDMA property access methods
        function value = get.CDMA_External_Trigger_Slope_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250604);
        end
        function set.CDMA_External_Trigger_Slope_CDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.CDMA.Trigger.*;
            attrCdmaExternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250604, newValue);
        end
    end
end
