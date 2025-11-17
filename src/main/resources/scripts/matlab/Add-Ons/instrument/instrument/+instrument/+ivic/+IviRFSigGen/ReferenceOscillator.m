classdef ReferenceOscillator < instrument.ivic.IviGroupBase
    %REFERENCEOSCILLATOR This group supports signal generators
    %with a configurable frequency
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %REFERENCE_OSCILLATOR_SOURCE_RO Specifies the reference
        %frequency source used to generate the exact RF output
        %frequency.
        Reference_Oscillator_Source_RO
        
        %REFERENCE_OSCILLATOR_EXTERNAL_FREQUENCY_RO Specifies the
        %frequency of the external signal, which is used as
        %reference for internal RF frequency generation. This value
        %is used only if the
        %IVIRFSIGGEN_ATTR_REFERENCE_OSCILLATOR_SOURCE RO attribute
        %is set to External.
        Reference_Oscillator_External_Frequency_RO
    end
    
    %% Property access methods
    methods
        %% Reference_Oscillator_Source_RO property access methods
        function value = get.Reference_Oscillator_Source_RO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250321);
        end
        function set.Reference_Oscillator_Source_RO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.ReferenceOscillator.*;
            attrReferenceOscillatorSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250321, newValue);
        end
        
        %% Reference_Oscillator_External_Frequency_RO property
        %access methods
        function value = get.Reference_Oscillator_External_Frequency_RO(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250322);
        end
        function set.Reference_Oscillator_External_Frequency_RO(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250322, newValue);
        end
    end
end
