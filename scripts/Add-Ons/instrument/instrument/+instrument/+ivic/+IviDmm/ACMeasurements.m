classdef ACMeasurements < instrument.ivic.IviGroupBase
    %ACMEASUREMENTS Attributes that configure additional
    %parameters for AC
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AC_MINIMUM_FREQUENCY_AC Specifies the minimum frequency
        %component of the input signal for AC measurements. The
        %value of this attribute affects instrument behavior only
        %when you set the IVIDMM_ATTR_FUNCTION attribute to an AC
        %measurement.  Note: (1) This attribute is part of the
        %IviDmmAcMeasurement AC extension group.
        AC_Minimum_Frequency_AC
        
        %AC_MAXIMUM_FREQUENCY_AC Specifies the maximum frequency
        %component of the input signal for AC measurements. The
        %value of this attribute affects instrument behavior only
        %when you set the IVIDMM_ATTR_FUNCTION attribute to an AC
        %measurement.  Note: (1) This attribute is part of the
        %IviDmmAcMeasurement AC extension group.
        AC_Maximum_Frequency_AC
    end
    
    %% Property access methods
    methods
        %% AC_Minimum_Frequency_AC property access methods
        function value = get.AC_Minimum_Frequency_AC(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250006);
        end
        function set.AC_Minimum_Frequency_AC(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250006, newValue);
        end
        
        %% AC_Maximum_Frequency_AC property access methods
        function value = get.AC_Maximum_Frequency_AC(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250007);
        end
        function set.AC_Maximum_Frequency_AC(obj,newValue)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250007, newValue);
        end
    end
end
