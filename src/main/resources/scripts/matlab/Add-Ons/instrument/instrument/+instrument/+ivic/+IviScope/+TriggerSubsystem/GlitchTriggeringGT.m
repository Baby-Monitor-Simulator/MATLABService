classdef GlitchTriggeringGT < instrument.ivic.IviGroupBase
    %GLITCHTRIGGERINGGT Attributes that configure the
    %oscilloscope for glitch triggering.  You use
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %GLITCH_WIDTH_GT Specifies the glitch width.  The units are
        %seconds.  The oscilloscope triggers when it detects a pulse
        %with a width that is less than the value you specify. This
        %attribute affects instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_GLITCH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeGlitchTrigger GT extension group.
        Glitch_Width_GT
        
        %GLITCH_POLARITY_GT Specifies the polarity of the glitch
        %that triggers the oscilloscope. This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_GLITCH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeGlitchTrigger GT extension group.
        Glitch_Polarity_GT
        
        %GLITCH_CONDITION_GT Specifies the glitch condition that
        %triggers the oscilloscope.  The glitch trigger occurs when
        %the oscilloscope detects a pulse with a width less than or
        %greater than the width value you specify  with the
        %IVISCOPE_ATTR_GLITCH_WIDTH attribute.  This attribute
        %affects instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_GLITCH_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeGlitchTrigger GT extension group.
        Glitch_Condition_GT
    end
    
    %% Property access methods
    methods
        %% Glitch_Width_GT property access methods
        function value = get.Glitch_Width_GT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250401);
        end
        function set.Glitch_Width_GT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250401, newValue);
        end
        
        %% Glitch_Polarity_GT property access methods
        function value = get.Glitch_Polarity_GT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250402);
        end
        function set.Glitch_Polarity_GT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT.*;
            attrGlitchPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250402, newValue);
        end
        
        %% Glitch_Condition_GT property access methods
        function value = get.Glitch_Condition_GT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250403);
        end
        function set.Glitch_Condition_GT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.GlitchTriggeringGT.*;
            attrGlitchConditionRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250403, newValue);
        end
    end
end
