classdef Thermistor < instrument.ivic.IviGroupBase
    %THERMISTOR Attributes that configure the thermistor
    %transducer type.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %THERMISTOR_RESISTANCE_THM Specifies the resistance of the
        %thermistor in Ohms.  The value of this attribute affects
        %instrument behavior only when the
        %IVIDMM_ATTR_TEMP_TRANSDUCER_TYPE attribute is set to
        %IVIDMM_VAL_THERMISTOR.  Note: (1) This attribute is part of
        %the IviDmmThermistor THM extension group.
        Thermistor_Resistance_THM
    end
    
    %% Property access methods
    methods
        %% Thermistor_Resistance_THM property access methods
        function value = get.Thermistor_Resistance_THM(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250251);
        end
        function set.Thermistor_Resistance_THM(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250251, newValue);
        end
    end
end
