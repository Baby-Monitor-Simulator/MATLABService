classdef InternalTrigger < instrument.ivic.IviGroupBase
    %INTERNALTRIGGER Internal Trigger
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %INTERNAL_TRIGGER_EVENT_SOURCE_IT Specifies the channel
        %that the power meter uses to monitor the internal trigger
        %event. The power meter leaves the Idle state when the
        %measurement signal on this channel meets the conditions set
        %by the IVIPWRMETER_ATTR_INTERNAL_TRIGGER_LEVEL IT and the
        %IVIPWRMETER_ATTR_INTERNAL_TRIGGER_SLOPE IT attributes. This
        %attribute affects the behavior of the instrument only if
        %the IVIPWRMETER_ATTR_TRIGGER_SOURCE TRG attribute is set to
        %Internal.
        Internal_Trigger_Event_Source_IT
        
        %INTERNAL_TRIGGER_LEVEL_IT Specifies the trigger level for
        %the measurement signal. The power meter leaves the Idle
        %state when the measurement signal on the channel specified
        %by the IVIPWRMETER_ATTR_INTERNAL_TRIGGER_EVENT_SOURCE IT
        %attribute crosses the value specified by this attribute.
        %The value of this attribute is specified in the same unit
        %as the value of the IVIPWRMETER_ATTR_UNITS. This attribute
        %affects the behavior of the instrument only if the
        %IVIPWRMETER_ATTR_TRIGGER_SOURCE TRG attribute is set to
        %Internal.
        Internal_Trigger_Level_IT
        
        %INTERNAL_TRIGGER_SLOPE_IT Specifies the polarity of the
        %internal trigger slope. The power meter triggers on the
        %rising or falling edge of the internal trigger source
        %depending on the value of this attribute. This attribute
        %affects the behavior of the instrument only if the
        %IVIPWRMETER_ATTR_TRIGGER_SOURCE TRG attribute is set to
        %Internal.
        Internal_Trigger_Slope_IT
    end
    
    %% Property access methods
    methods
        %% Internal_Trigger_Event_Source_IT property access methods
        function value = get.Internal_Trigger_Event_Source_IT(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250251 ,4096);
        end
        function set.Internal_Trigger_Event_Source_IT(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250251, newValue);
        end
        
        %% Internal_Trigger_Level_IT property access methods
        function value = get.Internal_Trigger_Level_IT(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250252);
        end
        function set.Internal_Trigger_Level_IT(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250252, newValue);
        end
        
        %% Internal_Trigger_Slope_IT property access methods
        function value = get.Internal_Trigger_Slope_IT(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250253);
        end
        function set.Internal_Trigger_Slope_IT(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.Trigger.InternalTrigger.*;
            attrInternalTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250253, newValue);
        end
    end
end
