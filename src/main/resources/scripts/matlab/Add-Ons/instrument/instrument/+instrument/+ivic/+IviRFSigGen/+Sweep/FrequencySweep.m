classdef FrequencySweep < instrument.ivic.IviGroupBase
    %FREQUENCYSWEEP This group contains attributes to support
    %the instrument that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FREQUENCY_SWEEP_START_FSW Specifies the start frequency of
        %the sweep. If the stop frequency is less than the start
        %frequency, the frequency decreases during the sweep. The
        %units are in Hz.
        Frequency_Sweep_Start_FSW
        
        %FREQUENCY_SWEEP_STOP_FSW Specifies the stop frequency of
        %the sweep. If the stop frequency is less than the start
        %frequency, the frequency decreases during the sweep. The
        %units are in Hz.
        Frequency_Sweep_Stop_FSW
        
        %FREQUENCY_SWEEP_TIME_FSW Specifies the duration of one
        %sweep from start to stop frequency. The units are in
        %seconds.
        Frequency_Sweep_Time_FSW
    end
    
    %% Property access methods
    methods
        %% Frequency_Sweep_Start_FSW property access methods
        function value = get.Frequency_Sweep_Start_FSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250211);
        end
        function set.Frequency_Sweep_Start_FSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250211, newValue);
        end
        
        %% Frequency_Sweep_Stop_FSW property access methods
        function value = get.Frequency_Sweep_Stop_FSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250212);
        end
        function set.Frequency_Sweep_Stop_FSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250212, newValue);
        end
        
        %% Frequency_Sweep_Time_FSW property access methods
        function value = get.Frequency_Sweep_Time_FSW(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250213);
        end
        function set.Frequency_Sweep_Time_FSW(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250213, newValue);
        end
    end
end
