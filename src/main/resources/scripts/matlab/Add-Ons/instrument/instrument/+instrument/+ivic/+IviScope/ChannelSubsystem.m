classdef ChannelSubsystem < instrument.ivic.IviGroupBase
    %CHANNELSUBSYSTEM Channel-based attributes that you use to
    %configure the oscilloscope.
    
    % Copyright 2010-2019 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %CHANNEL_ENABLED This channel-based attribute specifies
        %whether the oscilloscope acquires a waveform for a channel
        %when you call the  IviScope_InitiateAcquisition,
        %IviScope_ReadWaveform, IviScope_ReadMinMaxWaveform, or
        %IviScope_ReadWaveformMeasurement function.
        Channel_Enabled
        
        %PROBE_ATTENUATION This channel-based attribute specifies
        %the scaling factor by which the probe you attach to the
        %channel attenuates the input.  For example, when you use a
        %10:1 probe, set this attribute to 10.0.     This driver
        %reserves negative values to control the oscilloscope's
        %automatic probe sense capability.  Setting this attribute
        %to IVISCOPE_VAL_PROBE_SENSE_ON configures the oscilloscope
        %to sense the attenuation of the probe automatically.  After
        %you enable the automatic probe sense, subsequent queries of
        %this attribute return the value
        %IVISCOPE_VAL_PROBE_SENSE_ON.  Use the
        %IVISCOPE_ATTR_PROBE_SENSE_VALUE attribute to obtain the
        %actual probe attenuation.     If you set the oscilloscope
        %to sense the probe attenuation automatically, the probe
        %attenuation value can change at any time.  When the
        %oscilloscope detects a new probe attenuation value, other
        %settings in the oscilloscope might also change.  The driver
        %has no way of knowing when these changes occur.  Therefore,
        %when you enable the automatic probe sense capability, this
        %driver disables caching for attributes that depend on the
        %probe attenuation.  These attributes include
        %IVISCOPE_ATTR_VERTICAL_RANGE,
        %IVISCOPE_ATTR_VERTICAL_OFFSET, and all the attributes that
        %configure trigger levels.  To maximize performance, set
        %this attribute to a manual probe attenuation setting.
        %If the oscilloscope is set to sense the probe attenuation
        %automatically, setting this attribute to a positive value
        %disables the automatic probe sense and configures the
        %oscilloscope to use the manual probe attenuation you
        %specify.     If you use a manual probe attenuation, you
        %must set this attribute to reflect the new probe
        %attenuation each time you attach a different probe.
        Probe_Attenuation
        
        %VERTICAL_RANGE This channel-based attribute specifies the
        %absolute value of the input range the oscilloscope can
        %acquire for the channel.  The units are volts.  For
        %example, to acquire a sine wave which spans between -5.0
        %and 5.0 volts, you set this attribute to 10.0 volts.
        Vertical_Range
        
        %VERTICAL_OFFSET This channel-based attribute specifies the
        %location of the center of the range that you specify with
        %the IVISCOPE_ATTR_VERTICAL_RANGE attribute.  Express the
        %value in volts and with respect to ground.  For example, to
        %acquire a sine wave that spans between 0.0 and 10.0 volts,
        %set this attribute to 5.0 volts.
        Vertical_Offset
        
        %VERTICAL_COUPLING This channel-based attribute specifies
        %how the oscilloscope couples the input signal for the
        %channel.
        Vertical_Coupling
        
        %MAXIMUM_INPUT_FREQUENCY This channel-based attribute
        %specifies the maximum input frequency of the channel.
        %Express this value as the frequency at which the input
        %circuitry attenuates the input signal by 3 dB.  The units
        %for this attribute are hertz.
        Maximum_Input_Frequency
        
        %INPUT_IMPEDANCE This channel-based attribute specifies the
        %input impedance for the channel.  The units are ohms.
        Input_Impedance
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %PROBE_SENSE_VALUE_PAS This channel-based attribute returns
        %the probe attenuation value the oscilloscope automatically
        %senses.  If you disable the automatic probe sense
        %capability, this attribute returns the manual probe
        %attenuation setting.  Note: (1) This attribute is part of
        %the IviScopeProbeAutoSense PAS extension group. Read Only.
        Probe_Sense_Value_PAS
    end
    
    %% Property access methods
    methods
        %% Channel_Enabled property access methods
        function value = get.Channel_Enabled(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250005);
        end
        function set.Channel_Enabled(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.ChannelSubsystem.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Probe_Attenuation property access methods
        function value = get.Probe_Attenuation(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250004);
        end
        function set.Probe_Attenuation(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.ChannelSubsystem.*;
            %%% checkEnumValue commented to support both positive and -1
            %%% values. newValue attribute validation is done within
            %%% IviScopeAdaptor.m
            % attrProbeAttenuationRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250004, newValue);
        end
        
        %% Vertical_Range property access methods
        function value = get.Vertical_Range(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250001);
        end
        function set.Vertical_Range(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250001, newValue);
        end
        
        %% Vertical_Offset property access methods
        function value = get.Vertical_Offset(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250002);
        end
        function set.Vertical_Offset(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% Vertical_Coupling property access methods
        function value = get.Vertical_Coupling(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250003);
        end
        function set.Vertical_Coupling(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.ChannelSubsystem.*;
            attrVerticalCouplingRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250003, newValue);
        end
        
        %% Maximum_Input_Frequency property access methods
        function value = get.Maximum_Input_Frequency(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250006);
        end
        function set.Maximum_Input_Frequency(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250006, newValue);
        end
        
        %% Input_Impedance property access methods
        function value = get.Input_Impedance(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250103);
        end
        function set.Input_Impedance(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250103, newValue);
        end
        %% Probe_Sense_Value_PAS property access methods
        function value = get.Probe_Sense_Value_PAS(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250108);
        end
    end
end
