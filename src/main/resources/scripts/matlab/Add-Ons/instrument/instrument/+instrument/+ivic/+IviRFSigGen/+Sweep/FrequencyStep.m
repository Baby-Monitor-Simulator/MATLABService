classdef FrequencyStep < instrument.ivic.IviGroupBase
    %FREQUENCYSTEP This group contains attributes to support
    %the instrument that can vary
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FREQUENCY_STEP_START_FST Specifies the start frequency of
        %the stepped sweep. If the stop frequency is less than the
        %start frequency, the frequency decreases during the sweep.
        %The units are in Hz.
        Frequency_Step_Start_FST
        
        %FREQUENCY_STEP_STOP_FST Specifies the stop frequency of
        %the stepped sweep. If the stop frequency is less than the
        %start frequency, the frequency decreases during the sweep.
        %The units are in Hz.
        Frequency_Step_Stop_FST
        
        %FREQUENCY_STEP_SCALING_FST Specifies the spacing of the
        %steps.
        Frequency_Step_Scaling_FST
        
        %FREQUENCY_STEP_SIZE_FST Specifies the step size. The units
        %are in Hz when the IVIRFSIGGEN_ATTR_FREQUENCY_STEP_SCALING
        %FST attribute is set to
        %IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LINEAR.  The value
        %is unitless (factor) when the
        %IVIRFSIGGEN_ATTR_FREQUENCY_STEP_SCALING FST attribute is
        %set to IVIRFSIGGEN_VAL_FREQUENCY_STEP_SCALING_LOGARITHMIC.
        Frequency_Step_Size_FST
        
        %FREQUENCY_STEP_SINGLE_STEP_ENABLED_FST Specifies whether
        %the trigger initiates the next step (VI_TRUE), or the next
        %step is taken after dwell time (VI_FALSE).
        Frequency_Step_Single_Step_Enabled_FST
        
        %FREQUENCY_STEP_DWELL_FST Specifies the duration time of
        %one step. The units are in seconds. Dwell time starts
        %immediate after tigger or next step; no settling time is
        %added. This attribute is ignored if Frequency Step Single
        %Step Enabled is set to VI_TRUE.
        Frequency_Step_Dwell_FST
    end
    
    %% Property access methods
    methods
        %% Frequency_Step_Start_FST property access methods
        function value = get.Frequency_Step_Start_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250241);
        end
        function set.Frequency_Step_Start_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250241, newValue);
        end
        
        %% Frequency_Step_Stop_FST property access methods
        function value = get.Frequency_Step_Stop_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250242);
        end
        function set.Frequency_Step_Stop_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250242, newValue);
        end
        
        %% Frequency_Step_Scaling_FST property access methods
        function value = get.Frequency_Step_Scaling_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250243);
        end
        function set.Frequency_Step_Scaling_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.FrequencyStep.*;
            attrFrequencyStepScalingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250243, newValue);
        end
        
        %% Frequency_Step_Size_FST property access methods
        function value = get.Frequency_Step_Size_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250244);
        end
        function set.Frequency_Step_Size_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250244, newValue);
        end
        
        %% Frequency_Step_Single_Step_Enabled_FST property access
        %methods
        function value = get.Frequency_Step_Single_Step_Enabled_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250245);
        end
        function set.Frequency_Step_Single_Step_Enabled_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.FrequencyStep.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250245, newValue);
        end
        
        %% Frequency_Step_Dwell_FST property access methods
        function value = get.Frequency_Step_Dwell_FST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250246);
        end
        function set.Frequency_Step_Dwell_FST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250246, newValue);
        end
    end
end
