classdef BasicOperation < instrument.ivic.IviGroupBase
    %BASICOPERATION Attributes that control and define basic
    %spectrum analyzer operation.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %AMPLITUDE_UNITS Specifies the amplitude units for input,
        %output, and display amplitude.
        Amplitude_Units
        
        %ATTENUATION Specifies the input attenuation (in positive
        %dB).  This means that if 10dB is selected, the result is a
        %reduction in the signal level of 10 dB.
        Attenuation
        
        %ATTENUATION_AUTO Enables or disables auto attenuation.
        Attenuation_Auto
        
        %DETECTOR_TYPE Specifies the detection method used to
        %capture and process the signal. This governs the data
        %acquisition for a particular sweep, but does not have any
        %control over how multiple sweeps are processed.
        Detector_Type
        
        %DETECTOR_TYPE_AUTO Enables the auto detector. Note: When
        %the IVISPECAN_ATTR_DETECTOR_TYPE_AUTO attribute is set to
        %True, the relationship between the
        %IVISPECAN_ATTR_TRACE_TYPE attribute and the
        %IVISPECAN_ATTR_DETECTOR_TYPE attribute is not defined.
        Detector_Type_Auto
        
        %FREQUENCY_START Specifies the left edge of the frequency
        %domain in Hertz. This is used in conjunction with the
        %IVISPECAN_ATTR_FREQUENCY_STOP attribute to define the
        %frequency domain. If the IVISPECAN_ATTR_FREQUENCY_START
        %attribute value is equal to the
        %IVISPECAN_ATTR_FREQUENCY_STOP attribute value then the
        %spectrum analyzer's horizontal attributes are in
        %time-domain.
        Frequency_Start
        
        %FREQUENCY_STOP Specifies the right edge of the frequency
        %domain in Hertz. This is used in conjunction with the
        %IVISPECAN_ATTR_FREQUENCY_START attribute to define the
        %frequency domain. If the IVISPECAN_ATTR_FREQUENCY_START
        %attribute value is equal to the
        %IVISPECAN_ATTR_FREQUENCY_STOP attribute value then the
        %spectrum analyzer's horizontal attributes are in
        %time-domain.
        Frequency_Stop
        
        %FREQUENCY_OFFSET Specifies an offset value, in Hertz, that
        %is added to the frequency readout.  The offset is used to
        %compensate for external frequency conversion. Setting this
        %attribute changes the IVISPECAN_ATTR_FREQUENCY_START and
        %IVISPECAN_ATTR_FREQUENCY_STOP attributes. The following
        %equations define the relationship of these settings:
        %Frequency Start = Actual Start Frequency + Frequency Offset
        %      Frequency Stop = Actual Stop Frequency + Frequency
        %Offset       Marker Position = Actual Marker Frequency +
        %Frequency Offset
        Frequency_Offset
        
        %INPUT_IMPEDANCE Specifies the value of input impedance, in
        %ohms, expected at the active input port. This is typically
        %50 ohms or 75 ohms.
        Input_Impedance
        
        %NUMBER_OF_SWEEPS This attribute defines the number of
        %sweeps. This attribute value has no effect if the
        %IVISPECAN_ATTR_TRACE_TYPE attribute is set to the value
        %Clear Write.
        Number_of_Sweeps
        
        %REFERENCE_LEVEL The calibrated vertical position of the
        %captured data used as a reference for amplitude
        %measurements. This is typically set to a value slightly
        %higher than the highest expected signal level. The units
        %are determined by the IVISPECAN_ATTR_AMPLITUDE_UNITS
        %attribute.
        Reference_Level
        
        %REFERENCE_LEVEL_OFFSET Specifies an offset for the
        %IVISPECAN_ATTR_REFERENCE_LEVEL attribute in dB. This
        %attribute adjusts the reference level for external signal
        %gain or loss.  A positive value corresponds to a gain while
        %a negative number corresponds to a loss.
        Reference_Level_Offset
        
        %RESOLUTION_BANDWIDTH This specifies the width of the IF
        %filter in Hertz.
        Resolution_Bandwidth
        
        %RESOLUTION_BANDWIDTH_AUTO Enables resolution bandwidth
        %auto coupling.
        Resolution_Bandwidth_Auto
        
        %SWEEP_MODE_CONTINUOUS Enables continuous sweep mode.
        Sweep_Mode_Continuous
        
        %SWEEP_TIME Specifies the length of time (in seconds) to
        %sweep from the left edge to the right edge of the current
        %domain.
        Sweep_Time
        
        %SWEEP_TIME_AUTO Enables sweep time auto.
        Sweep_Time_Auto
        
        %TRACE_TYPE This trace-based attribute specifies the
        %representation of the acquired data.
        Trace_Type
        
        %VERTICAL_SCALE Specifies the vertical scale of the
        %measurement hardware (use of log amplifiers versus linear
        %amplifiers).
        Vertical_Scale
        
        %VIDEO_BANDWIDTH Specifies the video bandwidth of the
        %post-detection filter in Hertz.
        Video_Bandwidth
        
        %VIDEO_BANDWIDTH_AUTO Enables video bandwidth auto coupling.
        Video_Bandwidth_Auto
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %TRACE_COUNT Returns the number of traces. Note: For an
        %instrument with only one Trace the driver may return an
        %empty string. Read Only.
        Trace_Count
        
        %TRACE_SIZE This trace-based attribute returns the number
        %of points in the trace array. Read Only.
        Trace_Size
    end
    
    %% Property access methods
    methods
        %% Amplitude_Units property access methods
        function value = get.Amplitude_Units(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250001);
        end
        function set.Amplitude_Units(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            attrAmplitudeUnitsRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250001, newValue);
        end
        
        %% Attenuation property access methods
        function value = get.Attenuation(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250002);
        end
        function set.Attenuation(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250002, newValue);
        end
        
        %% Attenuation_Auto property access methods
        function value = get.Attenuation_Auto(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250003);
        end
        function set.Attenuation_Auto(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250003, newValue);
        end
        
        %% Detector_Type property access methods
        function value = get.Detector_Type(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250004);
        end
        function set.Detector_Type(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            attrDetectorTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250004, newValue);
        end
        
        %% Detector_Type_Auto property access methods
        function value = get.Detector_Type_Auto(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250005);
        end
        function set.Detector_Type_Auto(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250005, newValue);
        end
        
        %% Frequency_Start property access methods
        function value = get.Frequency_Start(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250006);
        end
        function set.Frequency_Start(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250006, newValue);
        end
        
        %% Frequency_Stop property access methods
        function value = get.Frequency_Stop(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250007);
        end
        function set.Frequency_Stop(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250007, newValue);
        end
        
        %% Frequency_Offset property access methods
        function value = get.Frequency_Offset(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250008);
        end
        function set.Frequency_Offset(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250008, newValue);
        end
        
        %% Input_Impedance property access methods
        function value = get.Input_Impedance(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250009);
        end
        function set.Input_Impedance(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250009, newValue);
        end
        
        %% Number_of_Sweeps property access methods
        function value = get.Number_of_Sweeps(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250010);
        end
        function set.Number_of_Sweeps(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250010, newValue);
        end
        
        %% Reference_Level property access methods
        function value = get.Reference_Level(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250011);
        end
        function set.Reference_Level(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250011, newValue);
        end
        
        %% Reference_Level_Offset property access methods
        function value = get.Reference_Level_Offset(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250012);
        end
        function set.Reference_Level_Offset(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250012, newValue);
        end
        
        %% Resolution_Bandwidth property access methods
        function value = get.Resolution_Bandwidth(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250013);
        end
        function set.Resolution_Bandwidth(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250013, newValue);
        end
        
        %% Resolution_Bandwidth_Auto property access methods
        function value = get.Resolution_Bandwidth_Auto(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250014);
        end
        function set.Resolution_Bandwidth_Auto(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250014, newValue);
        end
        
        %% Sweep_Mode_Continuous property access methods
        function value = get.Sweep_Mode_Continuous(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250015);
        end
        function set.Sweep_Mode_Continuous(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250015, newValue);
        end
        
        %% Sweep_Time property access methods
        function value = get.Sweep_Time(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250016);
        end
        function set.Sweep_Time(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250016, newValue);
        end
        
        %% Sweep_Time_Auto property access methods
        function value = get.Sweep_Time_Auto(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250017);
        end
        function set.Sweep_Time_Auto(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250017, newValue);
        end
        
        %% Trace_Type property access methods
        function value = get.Trace_Type(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250020);
        end
        function set.Trace_Type(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            attrTraceTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250020, newValue);
        end
        
        %% Vertical_Scale property access methods
        function value = get.Vertical_Scale(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250021);
        end
        function set.Vertical_Scale(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            attrVerticalScaleRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250021, newValue);
        end
        
        %% Video_Bandwidth property access methods
        function value = get.Video_Bandwidth(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250022);
        end
        function set.Video_Bandwidth(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250022, newValue);
        end
        
        %% Video_Bandwidth_Auto property access methods
        function value = get.Video_Bandwidth_Auto(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250023);
        end
        function set.Video_Bandwidth_Auto(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.BasicOperation.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250023, newValue);
        end
        %% Trace_Count property access methods
        function value = get.Trace_Count(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250018);
        end
        
        %% Trace_Size property access methods
        function value = get.Trace_Size(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250019);
        end
    end
end
