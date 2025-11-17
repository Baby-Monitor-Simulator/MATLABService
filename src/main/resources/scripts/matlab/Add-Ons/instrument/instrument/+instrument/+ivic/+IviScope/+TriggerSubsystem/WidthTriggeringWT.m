classdef WidthTriggeringWT < instrument.ivic.IviGroupBase
    %WIDTHTRIGGERINGWT Attributes that configure the
    %oscilloscope for width triggering.  You use
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %WIDTH_CONDITION_WT Specifies whether a pulse that is
        %within or outside the high and low thresholds triggers the
        %oscilloscope.  You specify the high and low thresholds with
        %the IVISCOPE_ATTR_WIDTH_HIGH_THRESHOLD and
        %IVISCOPE_ATTR_WIDTH_LOW_THRESHOLD attributes.  This
        %attribute affects instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_WIDTH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeWidthTrigger WT extension group.
        Width_Condition_WT
        
        %WIDTH_HIGH_THRESHOLD_WT Specifies the high width threshold
        %time.  The units are seconds.  This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_WIDTH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeWidthTrigger WT extension group.
        Width_High_Threshold_WT
        
        %WIDTH_LOW_THRESHOLD_WT Specifies the low width threshold
        %time.  The units are seconds.  This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_WIDTH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeWidthTrigger WT extension group.
        Width_Low_Threshold_WT
        
        %WIDTH_POLARITY_WT Specifies the polarity of the pulse that
        %triggers the oscilloscope.  This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_WIDTH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeWidthTrigger WT extension group.
        Width_Polarity_WT
    end
    
    %% Property access methods
    methods
        %% Width_Condition_WT property access methods
        function value = get.Width_Condition_WT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250504);
        end
        function set.Width_Condition_WT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT.*;
            attrWidthConditionRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250504, newValue);
        end
        
        %% Width_High_Threshold_WT property access methods
        function value = get.Width_High_Threshold_WT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250502);
        end
        function set.Width_High_Threshold_WT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250502, newValue);
        end
        
        %% Width_Low_Threshold_WT property access methods
        function value = get.Width_Low_Threshold_WT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250501);
        end
        function set.Width_Low_Threshold_WT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250501, newValue);
        end
        
        %% Width_Polarity_WT property access methods
        function value = get.Width_Polarity_WT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250503);
        end
        function set.Width_Polarity_WT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.WidthTriggeringWT.*;
            attrWidthPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250503, newValue);
        end
    end
end
