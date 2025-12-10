classdef Burst < instrument.ivic.IviGroupBase
    %BURST Attributes for setting burst mode characteristics.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %BURST_COUNT_BST This channel-based attribute specifies the
        %number of waveform cycles that the function generator
        %produces after it receives a trigger. This attribute
        %affects function generator behavior only when the
        %IVIFGEN_ATTR_OPERATION_MODE attribute is set to
        %IVIFGEN_VAL_OPERATE_BURST.  Note: (1) This attribute is
        %part of the IviFgenBurst BST extension group.
        Burst_Count_BST
    end
    
    %% Property access methods
    methods
        %% Burst_Count_BST property access methods
        function value = get.Burst_Count_BST(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250350);
        end
        function set.Burst_Count_BST(obj,newValue)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250350, newValue);
        end
    end
end
