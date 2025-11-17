classdef ResistanceTemperatureDevice < instrument.ivic.IviGroupBase
    %RESISTANCETEMPERATUREDEVICE Attributes that configure the
    %RTD transducer type.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %RTD_ALPHA_RTD Specifies the alpha parameter for a
        %resistance temperature device.  The value of this attribute
        %affects instrument behavior only when the
        %IVIDMM_VAL_TEMP_TRANSDUCER_TYPE attribute is set to
        %IVIDMM_VAL_2_WIRE_RTD or IVIDMM_VAL_4_WIRE_RTD.  Note: (1)
        %This attribute is part of the
        %IviDmmResistanceTemperatureDevice RTD extension group.
        RTD_Alpha_RTD
        
        %RTD_RESISTANCE_RTD Specifies the R0 parameter (resistance)
        %for a resistance temperature device (RTD).  The RTD
        %resistance is also known as the RTD reference value.  The
        %value of this attribute affects instrument behavior only
        %when the IVIDMM_VAL_TEMP_TRANSDUCER_TYPE attribute is set
        %to IVIDMM_VAL_2_WIRE_RTD or IVIDMM_VAL_4_WIRE_RTD.  Note:
        %(1) This attribute is part of the
        %IviDmmResistanceTemperatureDevice RTD extension group.
        RTD_Resistance_RTD
    end
    
    %% Property access methods
    methods
        %% RTD_Alpha_RTD property access methods
        function value = get.RTD_Alpha_RTD(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250241);
        end
        function set.RTD_Alpha_RTD(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250241, newValue);
        end
        
        %% RTD_Resistance_RTD property access methods
        function value = get.RTD_Resistance_RTD(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250242);
        end
        function set.RTD_Resistance_RTD(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250242, newValue);
        end
    end
end
