classdef ALC < instrument.ivic.IviGroupBase
    %ALC For generators with configurable Automatic Level
    %Control.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ALC_SOURCE_ALC Specifies the source of the controlling
        %voltage for the Automatic Level Control.
        ALC_Source_ALC
        
        %ALC_BANDWIDTH_ALC Specifies the bandwidth of Automatic
        %Level Control.
        ALC_Bandwidth_ALC
    end
    
    %% Property access methods
    methods
        %% ALC_Source_ALC property access methods
        function value = get.ALC_Source_ALC(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250301);
        end
        function set.ALC_Source_ALC(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.ALC.*;
            attrAlcSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250301, newValue);
        end
        
        %% ALC_Bandwidth_ALC property access methods
        function value = get.ALC_Bandwidth_ALC(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250302);
        end
        function set.ALC_Bandwidth_ALC(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250302, newValue);
        end
    end
end
