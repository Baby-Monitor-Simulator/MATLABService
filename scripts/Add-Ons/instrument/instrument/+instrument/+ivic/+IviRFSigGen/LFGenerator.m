classdef LFGenerator < instrument.ivic.IviGroupBase
    %LFGENERATOR This group contains all of the attributes to
    %use a LF Generator (within
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = LFGenerator()
            %% Initialize properties
            obj.LFGeneratorOutputs = instrument.ivic.IviRFSigGen.LFGenerator.LFGeneratorOutputs();
        end
        
        function delete(obj)
            obj.LFGeneratorOutputs = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.LFGeneratorOutputs.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %ACTIVE_LF_GENERATOR_LF Specifies the LF generator which is
        %currently active. The values for this attribute correspond
        %to the LFGenerator repeated capability.
        Active_LF_Generator_LF
        
        %LF_GENERATOR_FREQUENCY_LF Specifies the frequency of the
        %active LF generator. The unit is Hz.
        LF_Generator_Frequency_LF
        
        %LF_GENERATOR_WAVEFORM_LF Specifies the waveform of the
        %active LF generator.
        LF_Generator_Waveform_LF
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %LF_GENERATOR_COUNT_LF Specifies the number of LF generator
        %sources available for a particular instrument. Read Only.
        LF_Generator_Count_LF
        
        %LFGENERATOROUTPUTS This group contains attributes for
        %using the LF Generator as a source for  Read Only.
        LFGeneratorOutputs
    end
    
    %% Property access methods
    methods
        %% Active_LF_Generator_LF property access methods
        function value = get.Active_LF_Generator_LF(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250101 ,4096);
        end
        function set.Active_LF_Generator_LF(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250101, newValue);
        end
        
        %% LF_Generator_Frequency_LF property access methods
        function value = get.LF_Generator_Frequency_LF(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250102);
        end
        function set.LF_Generator_Frequency_LF(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250102, newValue);
        end
        
        %% LF_Generator_Waveform_LF property access methods
        function value = get.LF_Generator_Waveform_LF(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250103);
        end
        function set.LF_Generator_Waveform_LF(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.LFGenerator.*;
            attrLfGeneratorWaveformRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250103, newValue);
        end
        %% LF_Generator_Count_LF property access methods
        function value = get.LF_Generator_Count_LF(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250104);
        end
        
        %% LFGeneratorOutputs property access methods
        function value = get.LFGeneratorOutputs(obj)
            if isempty(obj.LFGeneratorOutputs)
                obj.LFGeneratorOutputs = instrument.ivic.IviRFSigGen.LFGenerator.LFGeneratorOutputs();
            end
            value = obj.LFGeneratorOutputs;
        end
    end
end
