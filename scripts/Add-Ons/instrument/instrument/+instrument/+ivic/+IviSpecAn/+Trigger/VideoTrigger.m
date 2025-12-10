classdef VideoTrigger < instrument.ivic.IviGroupBase
    %VIDEOTRIGGER Attributes to configure and control video
    %triggers
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %VIDEO_TRIGGER_LEVEL_VT Specifies the level of the video
        %signal to trigger an acquisition.  The units are specified
        %by the IVISPECAN_ATTR_AMPLITUDE_UNITS attribute.
        Video_Trigger_Level_VT
        
        %VIDEO_TRIGGER_SLOPE_VT Specifies the slope of the video
        %signal to trigger an acquisition.
        Video_Trigger_Slope_VT
    end
    
    %% Property access methods
    methods
        %% Video_Trigger_Level_VT property access methods
        function value = get.Video_Trigger_Level_VT(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250501);
        end
        function set.Video_Trigger_Level_VT(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250501, newValue);
        end
        
        %% Video_Trigger_Slope_VT property access methods
        function value = get.Video_Trigger_Slope_VT(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250502);
        end
        function set.Video_Trigger_Slope_VT(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Trigger.VideoTrigger.*;
            attrVideoTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250502, newValue);
        end
    end
end
