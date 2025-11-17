classdef TriggerSubsystem < instrument.ivic.IviGroupBase
    %TRIGGERSUBSYSTEM Attributes for triggered output changes.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TRIGGER_SOURCE_TRG This channel-based attribute specifies
        %the trigger source.  After you call IviDCPwr_Initiate, the
        %power supply waits for a trigger event from the source you
        %specify with this attribute.  After a trigger event occurs,
        %the power supply changes the voltage level to the value of
        %the IVIDCPWR_ATTR_TRIGGERED_VOLTAGE_LEVEL and the current
        %limit to the value of the
        %IVIDCPWR_ATTR_TRIGGERED_CURRENT_LIMIT attributes.
        Trigger_Source_TRG
        
        %TRIGGERED_VOLTAGE_LEVEL_TRG This channel-based attribute
        %specifies the value to  which the power supply sets the
        %voltage level after a trigger event occurs. The units are
        %Volts.  After you call IviDCPwr_Initiate, the power supply
        %waits for a trigger event from the source you specify with
        %the IVIDCPWR_ATTR_TRIGGER_SOURCE attribute.  After a
        %trigger event occurs, the power supply sets the voltage
        %level to the value of this attribute.  After a trigger
        %occurs, the value of the IVIDCPWR_ATTR_VOLTAGE_LEVEL
        %attribute reflects the new value to which the voltage level
        %has been set.
        Triggered_Voltage_Level_TRG
        
        %TRIGGERED_CURRENT_LIMIT_TRG This channel-based attribute
        %specifies the value to  which the power supply sets the
        %current limit after a trigger event occurs. The units are
        %amps.  After you call IviDCPwr_Initiate, the power supply
        %waits for a trigger event from the source you specify with
        %the IVIDCPWR_ATTR_TRIGGER_SOURCE attribute.  After a
        %trigger event occurs, the power supply sets the current
        %limit to the value of this attribute.  After a trigger
        %occurs, the value of the IVIDCPWR_ATTR_CURRENT_LIMIT
        %attribute reflects the new value to which the current limit
        %has been set.
        Triggered_Current_Limit_TRG
    end
    
    %% Property access methods
    methods
        %% Trigger_Source_TRG property access methods
        function value = get.Trigger_Source_TRG(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250101);
        end
        function set.Trigger_Source_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDCPwr.TriggerSubsystem.*;
            attrTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250101, newValue);
        end
        
        %% Triggered_Voltage_Level_TRG property access methods
        function value = get.Triggered_Voltage_Level_TRG(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250103);
        end
        function set.Triggered_Voltage_Level_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250103, newValue);
        end
        
        %% Triggered_Current_Limit_TRG property access methods
        function value = get.Triggered_Current_Limit_TRG(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250102);
        end
        function set.Triggered_Current_Limit_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250102, newValue);
        end
    end
end
