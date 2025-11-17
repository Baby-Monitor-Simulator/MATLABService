classdef CDMA < instrument.ivic.IviGroupBase
    %CDMA With IviRFSigGenCDMABaseFunctionality Extension Group
    %the user can
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = CDMA()
            %% Initialize properties
            obj.Trigger = instrument.ivic.IviRFSigGen.CDMA.Trigger();
        end
        
        function delete(obj)
            obj.Trigger = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.Trigger.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %CDMA_SELECTED_STANDARD_CDMA Specifies the actual standard
        %used by the instrument. The modulation type, bit clock
        %frequency and filter together with the according filter
        %parameters are set as defined in the selected standard.
        CDMA_Selected_Standard_CDMA
        
        %CDMA_SELECTED_TEST_MODEL_CDMA Specifies the actual CDMA
        %test model used by the instrument.
        CDMA_Selected_Test_Model_CDMA
        
        %CDMA_CLOCK_SOURCE_CDMA Specifies the source of the clock
        %signal used to generate the digital modulation according to
        %the selected standard.
        CDMA_Clock_Source_CDMA
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CDMA_STANDARD_COUNT_CDMA Returns the number of CDMA
        %standards available for a particular instrument. Read Only.
        CDMA_Standard_Count_CDMA
        
        %CDMA_TEST_MODEL_COUNT_CDMA Returns the number of CDMA test
        %models available for a particular instrument. Read Only.
        CDMA_Test_Model_Count_CDMA
        
        %TRIGGER This group contains attributes for configuring
        %CDMA trigger. Read Only.
        Trigger
    end
    
    %% Property access methods
    methods
        %% CDMA_Selected_Standard_CDMA property access methods
        function value = get.CDMA_Selected_Standard_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250602 ,4096);
        end
        function set.CDMA_Selected_Standard_CDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250602, newValue);
        end
        
        %% CDMA_Selected_Test_Model_CDMA property access methods
        function value = get.CDMA_Selected_Test_Model_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250606 ,4096);
        end
        function set.CDMA_Selected_Test_Model_CDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250606, newValue);
        end
        
        %% CDMA_Clock_Source_CDMA property access methods
        function value = get.CDMA_Clock_Source_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250607);
        end
        function set.CDMA_Clock_Source_CDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.CDMA.*;
            attrCdmaClockSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250607, newValue);
        end
        %% CDMA_Standard_Count_CDMA property access methods
        function value = get.CDMA_Standard_Count_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250601);
        end
        
        %% CDMA_Test_Model_Count_CDMA property access methods
        function value = get.CDMA_Test_Model_Count_CDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250605);
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviRFSigGen.CDMA.Trigger();
            end
            value = obj.Trigger;
        end
    end
end
