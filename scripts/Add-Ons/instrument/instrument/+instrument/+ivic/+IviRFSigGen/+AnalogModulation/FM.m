classdef FM < instrument.ivic.IviGroupBase
    %FM This group contains attributes for RF Signal Generators
    %that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FM_ENABLED_FM Specifies whether the signal generator
        %applies frequency modulation to the RF output signal
        %(VI_TRUE) or not (VI_FALSE).
        FM_Enabled_FM
        
        %FM_SOURCE_FM Specifies the source of the signal that is
        %used as the modulating signal. If more than one source is
        %specified, the voltages of all sources (internal and
        %external) are summed.  Multiple source names are separated
        %by commas.
        FM_Source_FM
        
        %FM_EXTERNAL_COUPLING_FM Specifies the coupling of the
        %external source of the modulating signal.
        FM_External_Coupling_FM
        
        %FM_DEVIATION_FM Specifies the extent of modulation (peak
        %frequency deviation) the signal generator applies to the
        %RF-signal (carrier waveform) with the modulating signal as
        %a result of summing all sources,internal and external.  The
        %units are Hz.
        FM_Deviation_FM
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %FM_NOMINAL_VOLTAGE_FM This is the voltage at which the
        %instrument achieves the amount of modulation specified by
        %the IVIRFSIGGEN_ATTR_FM_DEVIATION FM attribute.  Note: This
        %attribute is read only. Read Only.
        FM_Nominal_Voltage_FM
    end
    
    %% Property access methods
    methods
        %% FM_Enabled_FM property access methods
        function value = get.FM_Enabled_FM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250021);
        end
        function set.FM_Enabled_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.FM.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250021, newValue);
        end
        
        %% FM_Source_FM property access methods
        function value = get.FM_Source_FM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250022 ,4096);
        end
        function set.FM_Source_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250022, newValue);
        end
        
        %% FM_External_Coupling_FM property access methods
        function value = get.FM_External_Coupling_FM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250023);
        end
        function set.FM_External_Coupling_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.FM.*;
            attrFmExternalCouplingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250023, newValue);
        end
        
        %% FM_Deviation_FM property access methods
        function value = get.FM_Deviation_FM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250025);
        end
        function set.FM_Deviation_FM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250025, newValue);
        end
        %% FM_Nominal_Voltage_FM property access methods
        function value = get.FM_Nominal_Voltage_FM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250024);
        end
    end
end
