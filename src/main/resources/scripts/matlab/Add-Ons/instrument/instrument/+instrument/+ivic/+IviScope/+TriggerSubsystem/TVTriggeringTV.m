classdef TVTriggeringTV < instrument.ivic.IviGroupBase
    %TVTRIGGERINGTV Attributes that configure the oscilloscope
    %to trigger on TV signals.  You
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TV_TRIGGER_SIGNAL_FORMAT_TV Specifies the format of the TV
        %signal on which the oscilloscope triggers.  This attribute
        %affects instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_TV_TRIGGER.  Note: (1) This attribute is part
        %of the IviScopeTVTrigger TV extension group.
        TV_Trigger_Signal_Format_TV
        
        %TV_TRIGGER_EVENT_TV Specifies the event on which the
        %oscilloscope triggers.  This attribute affects instrument
        %operation only when the IVISCOPE_ATTR_TRIGGER_TYPE
        %attribute is set to IVISCOPE_VAL_TV_TRIGGER.  Note: (1)
        %This attribute is part of the IviScopeTVTrigger TV
        %extension group.
        TV_Trigger_Event_TV
        
        %TV_TRIGGER_LINE_NUMBER_TV Specifies the line on which the
        %oscilloscope triggers.  This attribute affects instrument
        %operation only when the IVISCOPE_ATTR_TRIGGER_TYPE
        %attribute is set to IVISCOPE_VAL_TV_TRIGGER and when the
        %IVISCOPE_ATTR_TV_TRIGGER_EVENT attribute is set to
        %IVISCOPE_VAL_LINE_NUMBER.  The line number setting is
        %independent of the field.  This means that to trigger on
        %the first line of the second field, you must set this
        %attribute to the value of 263 (if we presume that field one
        %had 262 lines).  Note: (1) This attribute is part of the
        %IviScopeTVTrigger TV extension group.
        TV_Trigger_Line_Number_TV
        
        %TV_TRIGGER_POLARITY_TV Specifies the polarity of the TV
        %signal.  This attribute affects instrument operation only
        %when the IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_TV_TRIGGER.  Note: (1) This attribute is part
        %of the IviScopeTVTrigger TV extension group.
        TV_Trigger_Polarity_TV
    end
    
    %% Property access methods
    methods
        %% TV_Trigger_Signal_Format_TV property access methods
        function value = get.TV_Trigger_Signal_Format_TV(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250201);
        end
        function set.TV_Trigger_Signal_Format_TV(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*;
            attrTvTriggerSignalFormatRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250201, newValue);
        end
        
        %% TV_Trigger_Event_TV property access methods
        function value = get.TV_Trigger_Event_TV(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250205);
        end
        function set.TV_Trigger_Event_TV(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*;
            attrTvTriggerEventRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250205, newValue);
        end
        
        %% TV_Trigger_Line_Number_TV property access methods
        function value = get.TV_Trigger_Line_Number_TV(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250206);
        end
        function set.TV_Trigger_Line_Number_TV(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250206, newValue);
        end
        
        %% TV_Trigger_Polarity_TV property access methods
        function value = get.TV_Trigger_Polarity_TV(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250204);
        end
        function set.TV_Trigger_Polarity_TV(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.TVTriggeringTV.*;
            attrTvTriggerPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250204, newValue);
        end
    end
end
