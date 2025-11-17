classdef Trigger < instrument.ivic.IviGroupBase
    %TRIGGER Attributes that configure the triggering
    %capabilities of the DMM.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TRIGGER_SOURCE Specifies the trigger source.  After you
        %call either the IviDmm_Read or IviDmm_Initiate functions,
        %the DMM waits for the trigger you specify with this
        %attribute.  After it receives the trigger, the DMM waits
        %the length of time you specify with the
        %IVIDMM_ATTR_TRIGGER_DELAY attribute.  The DMM then takes a
        %measurement.
        Trigger_Source
        
        %TRIGGER_DELAY Specifies the length of time the DMM waits
        %after it receives the trigger and before it takes a
        %measurement.  Use positive values to set the trigger delay
        %in seconds.  Negative values are reserved for configuring
        %the DMM to calculate the trigger delay automatically.
        %Setting this attribute to IVIDMM_VAL_AUTO_DELAY_ON
        %configures the DMM to calculate the trigger delay before
        %each measurement.  Setting this attribute to
        %IVIDMM_VAL_AUTO_DELAY_OFF stops the DMM from calculating
        %the trigger delay and sets the trigger delay to the last
        %automatically calculated value.
        Trigger_Delay
        
        %TRIGGER_SLOPE_TS Specifies if the trigger occurs on the
        %rising edge (IVIDMM_VAL_POSITIVE) or on the falling edge
        %(IVIDMM_VAL_NEGATIVE) of the external trigger source.
        %Note: (1) This attribute is part of the IviDmmTriggerSlope
        %TS extension group.
        Trigger_Slope_TS
    end
    
    %% Property access methods
    methods
        %% Trigger_Source property access methods
        function value = get.Trigger_Source(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250004);
        end
        function set.Trigger_Source(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.Trigger.*;
            attrTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250004, newValue);
        end
        
        %% Trigger_Delay property access methods
        function value = get.Trigger_Delay(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250005);
        end
        function set.Trigger_Delay(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Trigger_Slope_TS property access methods
        function value = get.Trigger_Slope_TS(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250334);
        end
        function set.Trigger_Slope_TS(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDmm.Trigger.*;
            attrTriggerSlopeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250334, newValue);
        end
    end
end
