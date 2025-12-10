classdef BasicOperation < instrument.ivic.IviGroupBase
    %BASICOPERATION Basic Operation
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = BasicOperation()
            %% Initialize properties
            obj.ChannelAcquisition = instrument.ivic.IviPwrMeter.BasicOperation.ChannelAcquisition();
        end
        
        function delete(obj)
            obj.ChannelAcquisition = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.ChannelAcquisition.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %AVERAGING_AUTO_ENABLED This channel-based attribute
        %specifies the auto-averaging mode used by the instrument
        %for the specified input channel. If auto averaging is
        %enabled, the instrument determines the best value for the
        %averaging count automatically. The averaging count
        %specifies the number of samples that the instrument takes
        %before the measurement is complete. If auto averaging is
        %disabled, specify the averaging count explicitly by setting
        %the IVIPWRMETER_ATTR_AVERAGING_COUNT AVG attribute.
        Averaging_Auto_Enabled
        
        %CORRECTION_FREQUENCY This channel-based attribute
        %specifies the frequency of the input signal in Hertz.  The
        %instrument uses this value to determine the appropriate
        %correction factor for the sensor. To obtain the most
        %accurate measurement, specify the correction frequency as
        %close as possible to the actual frequency of the input
        %signal.
        Correction_Frequency
        
        %OFFSET This channel-based attribute specifies an offset to
        %be added to the measured value on a channel in units of dB.
        % This attribute can be used to compensate for system losses
        %or gains between the unit under test and the sensor of the
        %power meter.   A positive value is used for loss
        %compensation.  A negative value is used for gain
        %compensation. For example, a cable loss of 2 dB could be
        %compensated for by setting this attribute to +2.
        %Similarly, a gain stage of 10 dB could be accounted for by
        %setting the value of this attribute to -10.  In both cases,
        %the reading from the power meter will indicate the power at
        %the unit under test rather than power at the power meter's
        %sensor.
        Offset
        
        %RANGE_AUTO_ENABLED This channel-based attribute specifies
        %if the power meter should automatically determine the best
        %range for the measurement. If this attribute is set to
        %TRUE, the instrument automatically determines the best
        %range for the measurement. If this attribute is set to
        %FALSE, specify the lower and upper limits of the
        %measurement range by explicitly setting the
        %IVIPWRMETER_ATTR_RANGE_LOWER RNG and
        %IVIPWRMETER_ATTR_RANGE_UPPER RNG attributes.
        Range_Auto_Enabled
        
        %UNITS Specifies the unit to which the RF power is
        %converted after measurement.  The actual RF power of the
        %signal on a channel is always measured in Watts. The value
        %of this attribute is used to determine the units in which
        %the IVIPWRMETER_ATTR_RANGE_LOWER RNG and
        %IVIPWRMETER_ATTR_RANGE_UPPER RNG attributes are specified.
        %The unit of the measurement result returned by the Read and
        %Fetch functions also depends on the value of this attribute.
        Units
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CHANNELACQUISITION Channel Acquisition Read Only.
        ChannelAcquisition
    end
    
    %% Property access methods
    methods
        %% Averaging_Auto_Enabled property access methods
        function value = get.Averaging_Auto_Enabled(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250003);
        end
        function set.Averaging_Auto_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250003, newValue);
        end
        
        %% Correction_Frequency property access methods
        function value = get.Correction_Frequency(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250004);
        end
        function set.Correction_Frequency(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250004, newValue);
        end
        
        %% Offset property access methods
        function value = get.Offset(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250005);
        end
        function set.Offset(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Range_Auto_Enabled property access methods
        function value = get.Range_Auto_Enabled(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250002);
        end
        function set.Range_Auto_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% Units property access methods
        function value = get.Units(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250001);
        end
        function set.Units(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.BasicOperation.*;
            attrUnitsRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250001, newValue);
        end
        %% ChannelAcquisition property access methods
        function value = get.ChannelAcquisition(obj)
            if isempty(obj.ChannelAcquisition)
                obj.ChannelAcquisition = instrument.ivic.IviPwrMeter.BasicOperation.ChannelAcquisition();
            end
            value = obj.ChannelAcquisition;
        end
    end
end
