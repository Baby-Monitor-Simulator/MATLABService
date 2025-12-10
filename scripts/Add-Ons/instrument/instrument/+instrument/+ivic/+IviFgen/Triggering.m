classdef Triggering < instrument.ivic.IviGroupBase
    %TRIGGERING Attributes for setting triggering
    %characteristics.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %TRIGGER_SOURCE_TRG This channel-based attribute specifies
        %the trigger source. After the function generator receives a
        %trigger, it generates an output signal based on the
        %operation mode.  Note: (1) This attribute is part of the
        %IviFgenTrigger TRG extension group.
        Trigger_Source_TRG
        
        %INTERNAL_TRIGGER_RATE_IT This attribute specifies the rate
        %at which the function generator's internal trigger source
        %produces a trigger, in triggers per second. This attribute
        %affects function generator behavior only when the
        %IVIFGEN_ATTR_TRIGGER_SOURCE attribute is set to
        %IVIFGEN_VAL_INTERNAL_TRIGGER on a channel.  Note: (1) This
        %attribute is part of the IviFgenInternalTrigger IT
        %extension group.
        Internal_Trigger_Rate_IT
    end
    
    %% Property access methods
    methods
        %% Trigger_Source_TRG property access methods
        function value = get.Trigger_Source_TRG(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250302);
        end
        function set.Trigger_Source_TRG(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviFgen.Triggering.*;
            attrTriggerSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250302, newValue);
        end
        
        %% Internal_Trigger_Rate_IT property access methods
        function value = get.Internal_Trigger_Rate_IT(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250310);
        end
        function set.Internal_Trigger_Rate_IT(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250310, newValue);
        end
    end
end
