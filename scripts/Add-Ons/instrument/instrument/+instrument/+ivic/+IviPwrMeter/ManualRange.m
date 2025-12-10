classdef ManualRange < instrument.ivic.IviGroupBase
    %MANUALRANGE Manual Range
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %RANGE_LOWER_RNG This channel-based attribute specifies the
        %lower limit (minimum) of the expected value of the
        %measurement.  The specific driver coerces this value to the
        %appropriate range for the instrument. The value of this
        %attribute is specified in the same units as the value of
        %the IVIPWRMETER_ATTR_UNITS attribute. This attribute
        %affects the behavior of the instrument only when the
        %IVIPWRMETER_ATTR_RANGE_AUTO_ENABLED attribute is set to
        %FALSE.
        Range_Lower_RNG
        
        %RANGE_UPPER_RNG This channel-based attribute specifies the
        %upper limit (maximum) of the expected value of the
        %measurement.  The specific driver coerces this value to the
        %appropriate range for the instrument. The value of this
        %attribute is specified in the same units as the value of
        %the IVIPWRMETER_ATTR_UNITS. This attribute affects the
        %behavior of the instrument only when the
        %IVIPWRMETER_ATTR_RANGE_AUTO_ENABLED attribute is set to
        %FALSE.
        Range_Upper_RNG
    end
    
    %% Property access methods
    methods
        %% Range_Lower_RNG property access methods
        function value = get.Range_Lower_RNG(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250101);
        end
        function set.Range_Lower_RNG(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250101, newValue);
        end
        
        %% Range_Upper_RNG property access methods
        function value = get.Range_Upper_RNG(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250102);
        end
        function set.Range_Upper_RNG(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250102, newValue);
        end
    end
end
