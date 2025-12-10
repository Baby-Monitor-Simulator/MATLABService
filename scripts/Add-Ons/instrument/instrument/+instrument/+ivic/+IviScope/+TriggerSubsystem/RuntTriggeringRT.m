classdef RuntTriggeringRT < instrument.ivic.IviGroupBase
    %RUNTTRIGGERINGRT Attributes that configure the
    %oscilloscope for runt triggering.  You use
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %RUNT_HIGH_THRESHOLD_RT Specifies the high threshold the
        %oscilloscope uses for runt triggering.  The units are
        %volts.  This attribute affects instrument operation only
        %when the IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_RUNT_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeRuntTrigger RT extension group.
        Runt_High_Threshold_RT
        
        %RUNT_LOW_THRESHOLD_RT Specifies the low threshold the
        %oscilloscope uses for runt triggering.  The units are
        %volts. This attribute affects instrument operation only
        %when the IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_RUNT_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeRuntTrigger RT extension group.
        Runt_Low_Threshold_RT
        
        %RUNT_POLARITY_RT Specifies the polarity of the runt that
        %triggers the oscilloscope. This attribute affects
        %instrument operation only when the
        %IVISCOPE_ATTR_TRIGGER_TYPE attribute is set to
        %IVISCOPE_VAL_RUNT_TRIGGER.  Note: (1) This attribute is
        %part of the IviScopeRuntTrigger RT extension group.
        Runt_Polarity_RT
    end
    
    %% Property access methods
    methods
        %% Runt_High_Threshold_RT property access methods
        function value = get.Runt_High_Threshold_RT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250301);
        end
        function set.Runt_High_Threshold_RT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250301, newValue);
        end
        
        %% Runt_Low_Threshold_RT property access methods
        function value = get.Runt_Low_Threshold_RT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250302);
        end
        function set.Runt_Low_Threshold_RT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250302, newValue);
        end
        
        %% Runt_Polarity_RT property access methods
        function value = get.Runt_Polarity_RT(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250303);
        end
        function set.Runt_Polarity_RT(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.TriggerSubsystem.RuntTriggeringRT.*;
            attrRuntPolarityRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250303, newValue);
        end
    end
end
