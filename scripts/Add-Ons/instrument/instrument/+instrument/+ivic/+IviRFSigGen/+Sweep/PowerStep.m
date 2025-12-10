classdef PowerStep < instrument.ivic.IviGroupBase
    %POWERSTEP This group contains attributes to support the
    %instrument that can vary
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %POWER_STEP_START_PST Specifies the start power of the
        %stepped sweep. If the stop power is less than the start
        %power, the power decreases in value during the sweep. The
        %units are in dBm.
        Power_Step_Start_PST
        
        %POWER_STEP_STOP_PST Specifies the stop power of the
        %stepped sweep. If the stop power is less than the start
        %power, the power decreases in value during the sweep. The
        %units are in dBm.
        Power_Step_Stop_PST
        
        %POWER_STEP_SIZE_PST Specifies the step size. The units are
        %in dBm.
        Power_Step_Size_PST
        
        %SINGLE_STEP_ENABLED_PST Specifies whether the trigger
        %initiates the next step (VI_TRUE), or the next step is
        %taken after dwell time (VI_FALSE).
        Single_Step_Enabled_PST
        
        %POWER_STEP_DWELL_PST Specifies the duration time of one
        %step. The units are in seconds. This attribute is ignored
        %if Frequency Step Single Step Enabled is set to VI_TRUE.
        Power_Step_Dwell_PST
    end
    
    %% Property access methods
    methods
        %% Power_Step_Start_PST property access methods
        function value = get.Power_Step_Start_PST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250261);
        end
        function set.Power_Step_Start_PST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250261, newValue);
        end
        
        %% Power_Step_Stop_PST property access methods
        function value = get.Power_Step_Stop_PST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250262);
        end
        function set.Power_Step_Stop_PST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250262, newValue);
        end
        
        %% Power_Step_Size_PST property access methods
        function value = get.Power_Step_Size_PST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250263);
        end
        function set.Power_Step_Size_PST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250263, newValue);
        end
        
        %% Single_Step_Enabled_PST property access methods
        function value = get.Single_Step_Enabled_PST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250264);
        end
        function set.Single_Step_Enabled_PST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.PowerStep.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250264, newValue);
        end
        
        %% Power_Step_Dwell_PST property access methods
        function value = get.Power_Step_Dwell_PST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250265);
        end
        function set.Power_Step_Dwell_PST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250265, newValue);
        end
    end
end
