classdef DoublePulseGenerators < instrument.ivic.IviGroupBase
    %DOUBLEPULSEGENERATORS This group contains attributes to
    %support double pulse generation. It
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %PULSE_DOUBLE_ENABLED_DPG Specifies whether double pulse
        %mode is used (VI_TRUE) or not (VI_FALSE).
        Pulse_Double_Enabled_DPG
        
        %PULSE_DOUBLE_DELAY_DPG Specifies the delay of the second
        %pulse. The units are in seconds.
        Pulse_Double_Delay_DPG
    end
    
    %% Property access methods
    methods
        %% Pulse_Double_Enabled_DPG property access methods
        function value = get.Pulse_Double_Enabled_DPG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250131);
        end
        function set.Pulse_Double_Enabled_DPG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.PulseGenerator.DoublePulseGenerators.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250131, newValue);
        end
        
        %% Pulse_Double_Delay_DPG property access methods
        function value = get.Pulse_Double_Delay_DPG(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250132);
        end
        function set.Pulse_Double_Delay_DPG(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250132, newValue);
        end
    end
end
