classdef PM < instrument.ivic.IviGroupBase
    %PM This group contains attributes for RF Signal Generators
    %that can apply
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %PM_ENABLED_PM Specifies whether the signal generator
        %applies phase modulation to the RF output signal (VI_TRUE)
        %or not (VI_FALSE).
        PM_Enabled_PM
        
        %PM_SOURCE_PM Specifies the source of the signal that is
        %used as the modulating signal. If more than one source is
        %specified, the voltages of all sources (internal and
        %external) are summed.  Multiple source names are separated
        %by commas.
        PM_Source_PM
        
        %PM_EXTERNAL_COUPLING_PM Specifies the coupling of the
        %external source of the modulating signal.
        PM_External_Coupling_PM
        
        %PM_DEVIATION_PM Specifies the extent of modulation (peak
        %phase deviation) the signal generator applies to the
        %RF-signal (carrier waveform) with the modulating signal.
        %The units are radians.
        PM_Deviation_PM
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %PM_NOMINAL_VOLTAGE_PM This is the voltage at which the
        %instrument achieves the amount of modulation specified by
        %the IVIRFSIGGEN_ATTR_PM_DEVIATION PM attribute.   Note:
        %This attribute is read only. Read Only.
        PM_Nominal_Voltage_PM
    end
    
    %% Property access methods
    methods
        %% PM_Enabled_PM property access methods
        function value = get.PM_Enabled_PM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250031);
        end
        function set.PM_Enabled_PM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.PM.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250031, newValue);
        end
        
        %% PM_Source_PM property access methods
        function value = get.PM_Source_PM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250032 ,4096);
        end
        function set.PM_Source_PM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250032, newValue);
        end
        
        %% PM_External_Coupling_PM property access methods
        function value = get.PM_External_Coupling_PM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250033);
        end
        function set.PM_External_Coupling_PM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.AnalogModulation.PM.*;
            attrPmExternalCouplingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250033, newValue);
        end
        
        %% PM_Deviation_PM property access methods
        function value = get.PM_Deviation_PM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250035);
        end
        function set.PM_Deviation_PM(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250035, newValue);
        end
        %% PM_Nominal_Voltage_PM property access methods
        function value = get.PM_Nominal_Voltage_PM(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250034);
        end
    end
end
