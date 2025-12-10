classdef DigitalModulation < instrument.ivic.IviGroupBase
    %DIGITALMODULATION With IviRFSigGenDigitalModulationBase
    %Extension Group the user can
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %DIGITALMODULATIONBASE_SELECTED_STANDARD_DMB Specifies the
        %actual standard used by the instrument. The coding,
        %mapping, symbol rate or bit clock frequency, filter
        %together with the according filter. parameters, FSK
        %deviation or ASK depth (in case of FSK or ASK modulation)
        %are set as defined in the selected standard.
        DigitalModulationBase_Selected_Standard_DMB
        
        %DIGITALMODULATIONBASE_DATA_SOURCE_DMB Specifies the source
        %of data. The data is used to modulate the RF signal
        %according to the standard selected with the
        %DigitalModulationBase Selected Standard attribute.
        DigitalModulationBase_Data_Source_DMB
        
        %DIGITALMODULATIONBASE_PRBS_TYPE_DMB Specifies the type of
        %the PRBS as defined in the CCITT-V.52 standard. The PRBS
        %(Pseudo Random Binary Sequence) is used only if
        %DigitalModulationBase Data Source is set to PRBS.
        DigitalModulationBase_PRBS_Type_DMB
        
        %DIGITALMODULATIONBASE_SELECTED_BIT_SEQUENCE_DMB Specifies
        %name of the bit sequence (stream) used as data for digital
        %modulation. The sequence is used only if
        %DigitalModulationBase Data Source is set to BitSequence.
        DigitalModulationBase_Selected_Bit_Sequence_DMB
        
        %DIGITALMODULATIONBASE_CLOCK_SOURCE_DMB Specifies the
        %source of the clock signal used to generate the digital
        %modulation according to the selected standard.
        DigitalModulationBase_Clock_Source_DMB
        
        %DIGITALMODULATIONBASE_EXTERNAL_CLOCK_TYPE_DMB Specifies
        %the type of the external clock signal used to generate the
        %digital modulation. This value is used only if the
        %DigitalModulationBase Clock Source attribute is set to
        %External.
        DigitalModulationBase_External_Clock_Type_DMB
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %DIGITALMODULATIONBASE_STANDARD_COUNT_DMB Specifies the
        %number of DigitalModulationBase standards available for a
        %particular instrument. Read Only.
        DigitalModulationBase_Standard_Count_DMB
    end
    
    %% Property access methods
    methods
        %% DigitalModulationBase_Selected_Standard_DMB property
        %access methods
        function value = get.DigitalModulationBase_Selected_Standard_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250502 ,4096);
        end
        function set.DigitalModulationBase_Selected_Standard_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250502, newValue);
        end
        
        %% DigitalModulationBase_Data_Source_DMB property access
        %methods
        function value = get.DigitalModulationBase_Data_Source_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250503);
        end
        function set.DigitalModulationBase_Data_Source_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.DigitalModulation.*;
            attrDigitalModulationBaseDataSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250503, newValue);
        end
        
        %% DigitalModulationBase_PRBS_Type_DMB property access
        %methods
        function value = get.DigitalModulationBase_PRBS_Type_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250504);
        end
        function set.DigitalModulationBase_PRBS_Type_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.DigitalModulation.*;
            attrDigitalModulationBasePRBSTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250504, newValue);
        end
        
        %% DigitalModulationBase_Selected_Bit_Sequence_DMB property
        %access methods
        function value = get.DigitalModulationBase_Selected_Bit_Sequence_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250505 ,4096);
        end
        function set.DigitalModulationBase_Selected_Bit_Sequence_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250505, newValue);
        end
        
        %% DigitalModulationBase_Clock_Source_DMB property access
        %methods
        function value = get.DigitalModulationBase_Clock_Source_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250506);
        end
        function set.DigitalModulationBase_Clock_Source_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.DigitalModulation.*;
            attrDigitalModulationBaseClockSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250506, newValue);
        end
        
        %% DigitalModulationBase_External_Clock_Type_DMB property
        %access methods
        function value = get.DigitalModulationBase_External_Clock_Type_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250507);
        end
        function set.DigitalModulationBase_External_Clock_Type_DMB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.DigitalModulation.*;
            attrDigitalModulationBaseExternalClockTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250507, newValue);
        end
        %% DigitalModulationBase_Standard_Count_DMB property access
        %methods
        function value = get.DigitalModulationBase_Standard_Count_DMB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250501);
        end
    end
end
