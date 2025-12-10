classdef DisplayControl < instrument.ivic.IviGroupBase
    %DISPLAYCONTROL Attributes to configure and control the
    %instrument's front panel
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %UNITS_PER_DIVISION_DSP Specifies the number of vertical
        %units in one screen division. This is typically used in
        %conjunction with the IVISPECAN_ATTR_REFERENCE_LEVEL
        %attribute to set the vertical range of the spectrum
        %analyzer.
        Units_Per_Division_DSP
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %NUMBER_OF_DIVISIONS_DSP Specifies the number of divisions.
        %Read Only.
        Number_of_Divisions_DSP
    end
    
    %% Property access methods
    methods
        %% Units_Per_Division_DSP property access methods
        function value = get.Units_Per_Division_DSP(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250601);
        end
        function set.Units_Per_Division_DSP(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250601, newValue);
        end
        %% Number_of_Divisions_DSP property access methods
        function value = get.Number_of_Divisions_DSP(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250602);
        end
    end
end
