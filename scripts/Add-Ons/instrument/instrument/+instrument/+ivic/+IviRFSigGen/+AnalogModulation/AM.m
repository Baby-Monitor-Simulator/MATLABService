classdef AM < instrument.ivic.IviGroupBase
    %AM This group contains attributes for RF Signal Generators
    %that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AM_ENABLED_AM Specifies whether the signal generator
        %applies amplitude modulation to the RF output signal
        %(VI_TRUE) or not (VI_FALSE).
        AM_Enabled_AM
        
        %AM_SOURCE_AM Specifies the source of the signal that is
        %used as the modulating signal. If more than one source is
        %specified, the voltages of all sources (internal and
        %external) are summed.  Multiple source names are separated
        %by commas.
        AM_Source_AM
        
        %AM_SCALING_AM Specifies linear or logarithmic attenuation
        %for amplitude modulation. The unit of the
        %IVIRFSIGGEN_ATTR_AM_DEPTH AM attribute is changed with this
        %setting.
        AM_Scaling_AM
        
        %AM_EXTERNAL_COUPLING_AM Specifies the coupling of the
        %external source of the modulating signal.
        AM_External_Coupling_AM
        
        %AM_DEPTH_AM Specifies the extend of modulation the signal
        %generator applies to the RF-signal (carrier waveform) with
        %the modulating signal as a result of summing all sources,
        %internal and external. If the IVIRFSIGGEN_ATTR_AM_SCALING
        %AM attribute is set to Linear, then the units are percent
        %(%). If the IVIRFSIGGEN_ATTR_AM_SCALING AM attribute is set
        %to logarithmic, then the units are dBm.
        AM_Depth_AM
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %AM_NOMINAL_VOLTAGE_AM This is the voltage at which the
        %instrument achieves the amount of modulation specified by
        %the IVIRFSIGGEN_ATTR_AM_DEPTH AM attribute.  Note: This
        %attribute is read only. Read Only.
        AM_Nominal_Voltage_AM
    end
    
    %% Property access methods
    methods
        %% AM_Enabled_AM property access methods
        function value = get.AM_Enabled_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250011);
        end
        function set.AM_Enabled_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.AM.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250011, newValue);
        end
        
        %% AM_Source_AM property access methods
        function value = get.AM_Source_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250012 ,4096);
        end
        function set.AM_Source_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250012, newValue);
        end
        
        %% AM_Scaling_AM property access methods
        function value = get.AM_Scaling_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250013);
        end
        function set.AM_Scaling_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.AM.*;
            attrAmScalingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250013, newValue);
        end
        
        %% AM_External_Coupling_AM property access methods
        function value = get.AM_External_Coupling_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250014);
        end
        function set.AM_External_Coupling_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.AM.*;
            attrAmExternalCouplingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250014, newValue);
        end
        
        %% AM_Depth_AM property access methods
        function value = get.AM_Depth_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250016);
        end
        function set.AM_Depth_AM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250016, newValue);
        end
        %% AM_Nominal_Voltage_AM property access methods
        function value = get.AM_Nominal_Voltage_AM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250015);
        end
    end
end
