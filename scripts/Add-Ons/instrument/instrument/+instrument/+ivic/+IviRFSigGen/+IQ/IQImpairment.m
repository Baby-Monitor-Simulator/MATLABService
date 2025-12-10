classdef IQImpairment < instrument.ivic.IviGroupBase
    %IQIMPAIRMENT This group allows the user to simulate or
    %correct impairment on IQ
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %IQ_IMPAIRMENT_ENABLED_IQI Enables IQ impairment. When set
        %to VI_TRUE, the following impairment attributes are
        %applied.   IVIRFSIGGEN_ATTR_IQ_I_OFFSET IQI
        %IVIRFSIGGEN_ATTR_IQ_Q_OFFSET IQI IVIRFSIGGEN_ATTR_IQ_RATIO
        %IQI IVIRFSIGGEN_ATTR_IQ_SKEW IQI
        IQ_Impairment_Enabled_IQI
        
        %IQ_I_OFFSET_IQI Specifies an origin offset voltage to the
        %I signal. The range of values allowed is -100% to +100%.
        %The value is expressed as percentage (%).
        IQ_I_Offset_IQI
        
        %IQ_Q_OFFSET_IQI Specifies an origin offset voltage to the
        %Q signal. The range of values allowed is -100% to +100%.
        %The value is expressed as percentage (%).
        IQ_Q_Offset_IQI
        
        %IQ_RATIO_IQI Specifies the gain imbalance between the I
        %and Q channels. For no imbalance this value is set to 0 %.
        %The value is expressed as percentage (%).
        IQ_Ratio_IQI
        
        %IQ_SKEW_IQI Specifies the adjustment of the phase angle
        %between the I and Q vectors. If this skew is zero, the
        %phase angle is 90 degrees. The units are degrees.
        IQ_Skew_IQI
    end
    
    %% Property access methods
    methods
        %% IQ_Impairment_Enabled_IQI property access methods
        function value = get.IQ_Impairment_Enabled_IQI(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250421);
        end
        function set.IQ_Impairment_Enabled_IQI(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.IQ.IQImpairment.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250421, newValue);
        end
        
        %% IQ_I_Offset_IQI property access methods
        function value = get.IQ_I_Offset_IQI(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250422);
        end
        function set.IQ_I_Offset_IQI(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250422, newValue);
        end
        
        %% IQ_Q_Offset_IQI property access methods
        function value = get.IQ_Q_Offset_IQI(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250423);
        end
        function set.IQ_Q_Offset_IQI(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250423, newValue);
        end
        
        %% IQ_Ratio_IQI property access methods
        function value = get.IQ_Ratio_IQI(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250424);
        end
        function set.IQ_Ratio_IQI(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250424, newValue);
        end
        
        %% IQ_Skew_IQI property access methods
        function value = get.IQ_Skew_IQI(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250425);
        end
        function set.IQ_Skew_IQI(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250425, newValue);
        end
    end
end
