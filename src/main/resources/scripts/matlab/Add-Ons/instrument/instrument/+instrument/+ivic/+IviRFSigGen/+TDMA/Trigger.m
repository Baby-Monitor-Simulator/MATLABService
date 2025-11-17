classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER This group contains attributes for configuring
    %TDMA trigger.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TDMA_TRIGGER_SOURCE_TDMA Specifies the source of the
        %trigger signal that starts the frameslots generation.
        TDMA_Trigger_Source_TDMA
        
        %TDMA_EXTERNAL_TRIGGER_SLOPE_TDMA Specifies whether the
        %trigger event occurs on the rising or falling edge of the
        %input signal.
        TDMA_External_Trigger_Slope_TDMA
    end
    
    %% Property access methods
    methods
        %% TDMA_Trigger_Source_TDMA property access methods
        function value = get.TDMA_Trigger_Source_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250703);
        end
        function set.TDMA_Trigger_Source_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.TDMA.Trigger.*;
            attrTdmaTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250703, newValue);
        end
        
        %% TDMA_External_Trigger_Slope_TDMA property access methods
        function value = get.TDMA_External_Trigger_Slope_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250704);
        end
        function set.TDMA_External_Trigger_Slope_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.TDMA.Trigger.*;
            attrTdmaExternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250704, newValue);
        end
    end
end
