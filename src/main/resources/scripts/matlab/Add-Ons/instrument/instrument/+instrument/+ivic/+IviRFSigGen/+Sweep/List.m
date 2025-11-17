classdef List < instrument.ivic.IviGroupBase
    %LIST This group contains attributes to support the
    %instrument that can set the
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %LIST_SELECTED_NAME_LST Specifies the name of the selected
        %list to become active. The name must be one of the lists
        %created .
        List_Selected_Name_LST
        
        %LIST_SINGLE_STEP_ENABLED_LST Enables or disables single
        %step mode. VI_TRUE: The list will advance when the next
        %trigger event occurs. VI_FALSE: The list will advance
        %immediately after the dwell time ends.
        List_Single_Step_Enabled_LST
        
        %LIST_DWELL_LST Specifies the duration time of one step.
        %The units are in seconds. This attribute is ignored if List
        %Single Step Enabled is set to VI_TRUE.
        List_Dwell_LST
    end
    
    %% Property access methods
    methods
        %% List_Selected_Name_LST property access methods
        function value = get.List_Selected_Name_LST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250281 ,4096);
        end
        function set.List_Selected_Name_LST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250281, newValue);
        end
        
        %% List_Single_Step_Enabled_LST property access methods
        function value = get.List_Single_Step_Enabled_LST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250282);
        end
        function set.List_Single_Step_Enabled_LST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviRFSigGen.Sweep.List.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250282, newValue);
        end
        
        %% List_Dwell_LST property access methods
        function value = get.List_Dwell_LST(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250283);
        end
        function set.List_Dwell_LST(obj,newValue)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250283, newValue);
        end
    end
end
