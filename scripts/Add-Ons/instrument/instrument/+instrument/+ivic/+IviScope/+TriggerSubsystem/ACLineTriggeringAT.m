classdef ACLineTriggeringAT < instrument.ivic.IviGroupBase
    %ACLINETRIGGERINGAT Attributes for synchronizing the
    %trigger with the AC Line.  You
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AC_LINE_TRIGGER_SLOPE_AT Specifies the slope of the zero
        %crossing upon which the scope triggers.  This attribute
        %affects instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_AC_LINE_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeTVTrigger AT extension group.
        AC_Line_Trigger_Slope_AT
    end
    
    %% Property access methods
    methods
        %% AC_Line_Trigger_Slope_AT property access methods
        function value = get.AC_Line_Trigger_Slope_AT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250701);
        end
        function set.AC_Line_Trigger_Slope_AT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.ACLineTriggeringAT.*;
            attrAcLineTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250701, newValue);
        end
    end
end
