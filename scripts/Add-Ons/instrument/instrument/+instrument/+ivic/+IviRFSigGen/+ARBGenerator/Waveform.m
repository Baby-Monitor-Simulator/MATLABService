classdef Waveform < instrument.ivic.IviGroupBase
    %WAVEFORM The group contains attributes that return
    %Waveform parameters.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ARB_SELECTED_WAVEFORM_ARB Specifies the selected waveform
        %from the pool of available waveforms.
        ARB_Selected_Waveform_ARB
        
        %ARB_WAVEFORM_SIZE_MIN_ARB Returns the minimum size of the
        %waveform length in number of samples. The waveform length
        %must equal or greater than this minimum size. If the
        %minimum size is 1, there is no restriction on the waveform
        %length other than max size and quantum.
        ARB_Waveform_Size_Min_ARB
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %ARB_MAX_NUMBER_WAVEFORMS_ARB Returns the max number of
        %waveforms the instrument can hold in the memory. The number
        %may depend on the length of the waveform already in the
        %pool of waveforms saved in the instrument. Read Only.
        ARB_Max_Number_Waveforms_ARB
        
        %ARB_WAVEFORM_QUANTUM_ARB Returns the waveform quantum
        %where the waveform length is a multiple of this quantum. If
        %the waveform quantum is 1, there is no restriction on the
        %waveform length other than min and max size. Read Only.
        ARB_Waveform_Quantum_ARB
        
        %ARB_WAVEFORM_SIZE_MAX_ARB Returns the maximum waveform
        %length in the number of samples. The waveform length must
        %be equal or less than this maximum size. Read Only.
        ARB_Waveform_Size_Max_ARB
    end
    
    %% Property access methods
    methods
        %% ARB_Selected_Waveform_ARB property access methods
        function value = get.ARB_Selected_Waveform_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250451 ,4096);
        end
        function set.ARB_Selected_Waveform_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250451, newValue);
        end
        
        %% ARB_Waveform_Size_Min_ARB property access methods
        function value = get.ARB_Waveform_Size_Min_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250456);
        end
        function set.ARB_Waveform_Size_Min_ARB(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250456, newValue);
        end
        %% ARB_Max_Number_Waveforms_ARB property access methods
        function value = get.ARB_Max_Number_Waveforms_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250454);
        end
        
        %% ARB_Waveform_Quantum_ARB property access methods
        function value = get.ARB_Waveform_Quantum_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250455);
        end
        
        %% ARB_Waveform_Size_Max_ARB property access methods
        function value = get.ARB_Waveform_Size_Max_ARB(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250457);
        end
    end
end
