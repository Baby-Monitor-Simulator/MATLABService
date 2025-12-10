classdef PowerSweep < instrument.ivic.IviGroupBase
    %POWERSWEEP This group contains attributes to support the
    %instrument that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %POWER_SWEEP_START_PSW Specifies the start power of the
        %sweep. If the stop power is less than the start power, the
        %power decreases in value during the sweep. The units are in
        %dBm.
        Power_Sweep_Start_PSW
        
        %POWER_SWEEP_STOP_PSW Specifies the stop power of the
        %sweep. If the stop power is less than the start power, the
        %power decreases in value during the sweep. The units are in
        %dBm.
        Power_Sweep_Stop_PSW
        
        %POWER_SWEEP_TIME_PSW Specifies the duration of one sweep
        %from start to stop power. The units are in seconds.
        Power_Sweep_Time_PSW
    end
    
    %% Property access methods
    methods
        %% Power_Sweep_Start_PSW property access methods
        function value = get.Power_Sweep_Start_PSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250221);
        end
        function set.Power_Sweep_Start_PSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250221, newValue);
        end
        
        %% Power_Sweep_Stop_PSW property access methods
        function value = get.Power_Sweep_Stop_PSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250222);
        end
        function set.Power_Sweep_Stop_PSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250222, newValue);
        end
        
        %% Power_Sweep_Time_PSW property access methods
        function value = get.Power_Sweep_Time_PSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250223);
        end
        function set.Power_Sweep_Time_PSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250223, newValue);
        end
    end
end
