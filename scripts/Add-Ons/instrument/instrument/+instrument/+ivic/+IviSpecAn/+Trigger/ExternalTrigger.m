classdef ExternalTrigger < instrument.ivic.IviGroupBase
    %EXTERNALTRIGGER Attributes to configure and control
    %external triggers
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %EXTERNAL_TRIGGER_LEVEL_EXT Specifies the level, in Volts,
        %of the external trigger signal to trigger an acquisition.
        External_Trigger_Level_EXT
        
        %EXTERNAL_TRIGGER_SLOPE_EXT Specifies the slope of the
        %external trigger signal to trigger an acquisition.
        External_Trigger_Slope_EXT
    end
    
    %% Property access methods
    methods
        %% External_Trigger_Level_EXT property access methods
        function value = get.External_Trigger_Level_EXT(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250401);
        end
        function set.External_Trigger_Level_EXT(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250401, newValue);
        end
        
        %% External_Trigger_Slope_EXT property access methods
        function value = get.External_Trigger_Slope_EXT(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250402);
        end
        function set.External_Trigger_Slope_EXT(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Trigger.ExternalTrigger.*;
            attrExternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250402, newValue);
        end
    end
end
