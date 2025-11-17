classdef Source < instrument.ivic.IviGroupBase
    %SOURCE This group contains the repeated attributes for RF
    %Signal Generators that can
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %ANALOG_MODULATION_SOURCE_COUNT_MS Specifies how many
        %analog modulation sources are available. Read Only.
        Analog_Modulation_Source_Count_MS
    end
    
    %% Property access methods
    methods
        %% Analog_Modulation_Source_Count_MS property access methods
        function value = get.Analog_Modulation_Source_Count_MS(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250041);
        end
    end
end
