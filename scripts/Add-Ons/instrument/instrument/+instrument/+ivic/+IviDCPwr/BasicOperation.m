classdef BasicOperation < instrument.ivic.IviGroupBase
    %BASICOPERATION Attributes for controlling the basic
    %features of the DC power supply.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %OUTPUT_ENABLED This channel-based attribute specifies
        %whether the signal the power supply produces appears at the
        %output connector.
        Output_Enabled
        
        %OVP_ENABLED This channel-based attribute specifies whether
        %the power supply provides over-voltage protection.  If this
        %attribute is set to VI_TRUE, the power supply disables the
        %output when the output voltage is greater than or equal to
        %the value of the IVIDCPWR_ATTR_OVP_LIMIT attribute.
        OVP_Enabled
        
        %OVP_LIMIT This channel-based attribute specifies the
        %voltage the power supply allows. The units are Volts.  If
        %the IVIDCPWR_ATTR_OVP_ENABLED attribute is set to VI_TRUE,
        %the power supply disables the output when the output
        %voltage is greater than or equal to the value of this
        %attribute.  If the IVIDCPWR_ATTR_OVP_ENABLED attribute is
        %set to VI_FALSE, this attribute does not affect the
        %behavior of the instrument.
        OVP_Limit
        
        %CURRENT_LIMIT_BEHAVIOR This channel-based attribute
        %specifies the behavior of the power supply when the output
        %current is equal to or greater than the value of the
        %IVIDCPWR_ATTR_CURRENT_LIMIT attribute.
        Current_Limit_Behavior
        
        %CURRENT_LIMIT This channel-based attribute specifies the
        %output current limit. The units are Amperes.  The value of
        %the IVIDCPWR_ATTR_CURRENT_LIMIT_BEHAVIOR attribute
        %determines the behavior of the power supply when the output
        %current is equal to or greater than the value of this
        %attribute.
        Current_Limit
        
        %VOLTAGE_LEVEL This channel-based attribute specifies the
        %voltage level the DC power supply attempts to generate.
        %The units are Volts.
        Voltage_Level
    end
    
    %% Property access methods
    methods
        %% Output_Enabled property access methods
        function value = get.Output_Enabled(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250006);
        end
        function set.Output_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDCPwr.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250006, newValue);
        end
        
        %% OVP_Enabled property access methods
        function value = get.OVP_Enabled(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250002);
        end
        function set.OVP_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDCPwr.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% OVP_Limit property access methods
        function value = get.OVP_Limit(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250003);
        end
        function set.OVP_Limit(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250003, newValue);
        end
        
        %% Current_Limit_Behavior property access methods
        function value = get.Current_Limit_Behavior(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250004);
        end
        function set.Current_Limit_Behavior(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviDCPwr.BasicOperation.*;
            attrCurrentLimitBehaviorRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250004, newValue);
        end
        
        %% Current_Limit property access methods
        function value = get.Current_Limit(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250005);
        end
        function set.Current_Limit(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Voltage_Level property access methods
        function value = get.Voltage_Level(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250001);
        end
        function set.Voltage_Level(obj,newValue)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250001, newValue);
        end
    end
end
