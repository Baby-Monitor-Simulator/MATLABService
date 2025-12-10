classdef TDMA < instrument.ivic.IviGroupBase
    %TDMA With IviRFSigGenTDMABaseFunctionality Extension Group
    %the user can
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = TDMA()
            %% Initialize properties
            obj.Trigger = instrument.ivic.IviRFSigGen.TDMA.Trigger();
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
        %TDMA_SELECTED_STANDARD_TDMA Specifies the actual standard
        %used by the instrument. The coding, mapping, symbol rate or
        %bit clock frequency, filter together with the according
        %filter parameters, FSK deviation or ASK depth (in case of
        %FSK or ASK modulation) are set as defined in the selected
        %standard.
        TDMA_Selected_Standard_TDMA
        
        %TDMA_SELECTED_FRAME_TDMA Specifies the actual frame used
        %by the instrument. It is selected from the list queried
        %with the Get TDMA Frame Names function.
        TDMA_Selected_Frame_TDMA
        
        %TDMA_CLOCK_SOURCE_TDMA Specifies the source of the clock
        %signal used to generate the digital modulation according to
        %the selected standard.
        TDMA_Clock_Source_TDMA
        
        %TDMA_EXTERNAL_CLOCK_TYPE_TDMA Specifies the type of the
        %external clock signal used to generate the digital
        %modulation. This value is used only if the
        %IVIRFSIGGEN_ATTR_TDMA_CLOCK_SOURCE TDMA attribute is set to
        %External.
        TDMA_External_Clock_Type_TDMA
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %TDMA_STANDARD_COUNT_TDMA Specifies the number of TDMA
        %standards available for a particular instrument. Read Only.
        TDMA_Standard_Count_TDMA
        
        %TDMA_FRAME_COUNT_TDMA Specifies the number of TDMA frames
        %available for a particular instrument. Read Only.
        TDMA_Frame_Count_TDMA
        
        %TRIGGER This group contains attributes for configuring
        %TDMA trigger. Read Only.
        Trigger
    end
    
    %% Property access methods
    methods
        %% TDMA_Selected_Standard_TDMA property access methods
        function value = get.TDMA_Selected_Standard_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250702 ,4096);
        end
        function set.TDMA_Selected_Standard_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250702, newValue);
        end
        
        %% TDMA_Selected_Frame_TDMA property access methods
        function value = get.TDMA_Selected_Frame_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250706 ,4096);
        end
        function set.TDMA_Selected_Frame_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250706, newValue);
        end
        
        %% TDMA_Clock_Source_TDMA property access methods
        function value = get.TDMA_Clock_Source_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250707);
        end
        function set.TDMA_Clock_Source_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.TDMA.*;
            attrTdmaClockSourceRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250707, newValue);
        end
        
        %% TDMA_External_Clock_Type_TDMA property access methods
        function value = get.TDMA_External_Clock_Type_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250708);
        end
        function set.TDMA_External_Clock_Type_TDMA(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.TDMA.*;
            attrTdmaClockTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250708, newValue);
        end
        %% TDMA_Standard_Count_TDMA property access methods
        function value = get.TDMA_Standard_Count_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250701 );
        end
        
        %% TDMA_Frame_Count_TDMA property access methods
        function value = get.TDMA_Frame_Count_TDMA(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250705);
        end
        
        %% Trigger property access methods
        function value = get.Trigger(obj)
            if isempty(obj.Trigger)
                obj.Trigger = instrument.ivic.IviRFSigGen.TDMA.Trigger();
            end
            value = obj.Trigger;
        end
    end
end
