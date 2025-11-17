classdef IQ < instrument.ivic.IviGroupBase
    %IQ This group supports RFSigGens that can apply IQ
    %(vector) modulation to
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = IQ()
            %% Initialize properties
            obj.IQImpairment = instrument.ivic.IviRFSigGen.IQ.IQImpairment();
        end
        
        function delete(obj)
            obj.IQImpairment = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.IQImpairment.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %IQ_ENABLED_MIQ Specifies whether the signal generator
        %applies IQ (vector) modulation to the output RF signal
        %(VI_TRUE) or not (VI_FALSE).
        IQ_Enabled_MIQ
        
        %IQ_SOURCE_MIQ Specifies the source of the signal that the
        %signal generator uses for IQ modulation.
        IQ_Source_MIQ
        
        %IQSWAP_ENABLED_MIQ Enables or disables the inverse phase
        %rotation of the IQ signal by swapping the I and Q inputs.
        %If VI_TRUE, the RF signal generator applies non-inverse
        %phase rotation of the IQ signal.  If VI_FALSE, the RF
        %signal generator applies inverse phase rotation of the IQ
        %signal.
        IQSwap_Enabled_MIQ
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %IQ_NOMINAL_VOLTAGE_MIQ This is the voltage at which the
        %instrument achieves full modulation. The value is
        %calculated by SQRT(I^2+Q^2). Read Only.
        IQ_Nominal_Voltage_MIQ
        
        %IQIMPAIRMENT This group allows the user to simulate or
        %correct impairment on IQ  Read Only.
        IQImpairment
    end
    
    %% Property access methods
    methods
        %% IQ_Enabled_MIQ property access methods
        function value = get.IQ_Enabled_MIQ(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250401);
        end
        function set.IQ_Enabled_MIQ(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.IQ.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250401, newValue);
        end
        
        %% IQ_Source_MIQ property access methods
        function value = get.IQ_Source_MIQ(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250403);
        end
        function set.IQ_Source_MIQ(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.IQ.*;
            attrIqSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250403, newValue);
        end
        
        %% IQSwap_Enabled_MIQ property access methods
        function value = get.IQSwap_Enabled_MIQ(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250404);
        end
        function set.IQSwap_Enabled_MIQ(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.IQ.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250404, newValue);
        end
        %% IQ_Nominal_Voltage_MIQ property access methods
        function value = get.IQ_Nominal_Voltage_MIQ(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250402);
        end
        
        %% IQImpairment property access methods
        function value = get.IQImpairment(obj)
            if isempty(obj.IQImpairment)
                obj.IQImpairment = instrument.ivic.IviRFSigGen.IQ.IQImpairment();
            end
            value = obj.IQImpairment;
        end
    end
end
