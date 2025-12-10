classdef FrequencyMeasurements < instrument.ivic.IviGroupBase
    %FREQUENCYMEASUREMENTS Attributes that configure additional
    %parameters for
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %FREQUENCY_VOLTAGE_RANGE_FRQ Specifies the expected maximum
        %value of the input signal for frequency and period
        %measurements.  The value of this attribute affects
        %instrument behavior only when the IVIDMM_ATTR_FUNCTION
        %attribute is set to IVIDMM_VAL_FREQ or IVIDMM_VAL_PERIOD.
        %Note: (1) This attribute is part of the
        %IviDmmFrequencyMeasurement FRQ extension group.
        Frequency_Voltage_Range_FRQ
    end
    
    %% Property access methods
    methods
        %% Frequency_Voltage_Range_FRQ property access methods
        function value = get.Frequency_Voltage_Range_FRQ(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250101);
        end
        function set.Frequency_Voltage_Range_FRQ(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250101, newValue);
        end
    end
end
