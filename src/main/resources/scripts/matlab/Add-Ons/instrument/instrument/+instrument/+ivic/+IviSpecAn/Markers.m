classdef Markers < instrument.ivic.IviGroupBase
    %MARKERS Attributes that define and control markers.
    %Markers are a common
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods (Hidden=true)
        function obj = Markers()
            %% Initialize properties
            obj.MarkerType = instrument.ivic.IviSpecAn.Markers.MarkerType();
            obj.DeltaMarker = instrument.ivic.IviSpecAn.Markers.DeltaMarker();
        end
        
        function delete(obj)
            obj.DeltaMarker = [];
            obj.MarkerType = [];
        end
        function setLibraryAndSession(obj, libName, session)
            obj.setLibraryAndSession@instrument.ivic.IviGroupBase(libName, session);
            obj.DeltaMarker.setLibraryAndSession(libName, session);
            obj.MarkerType.setLibraryAndSession(libName, session);
        end
    end
    
    %% Public Properties
    properties
        %ACTIVE_MARKER_MKR Specifies the marker which is currently
        %active.  The values for this attribute correspond to the
        %Marker repeated capability.
        Active_Marker_MKR
        
        %MARKER_ENABLED_MKR Enables the active marker.
        Marker_Enabled_MKR
        
        %MARKER_FREQUENCY_COUNTER_ENABLED_MKR Enables the marker
        %frequency counter for better marker measurement accuracy.
        %This attribute returns the Marker Not Enabled error
        %(0xBFFA2001) if the IVISPECAN_ATTR_MARKER_ENABLED MKR
        %attribute is set to False.
        Marker_Frequency_Counter_Enabled_MKR
        
        %MARKER_FREQUENCY_COUNTER_RESOLUTION_MKR Specifies the
        %resolution of the frequency counter in Hertz.  The
        %measurement gate time is the reciprocal of the specified
        %resolution.
        Marker_Frequency_Counter_Resolution_MKR
        
        %MARKER_POSITION_MKR Specifies the frequency or time
        %position of the active marker (depending on the mode in
        %which the analyzer is operating, frequency or time-domain).
        %This attribute returns the Marker Not Enabled error
        %(0xBFFA2001) if the active marker is not enabled.
        Marker_Position_MKR
        
        %MARKER_THRESHOLD_MKR Specifies the lower limit of the
        %search domain vertical range for the IviSpecAn_MarkerSearch
        %MKR function.
        Marker_Threshold_MKR
        
        %MARKER_TRACE_MKR Specifies the trace for the active marker.
        Marker_Trace_MKR
        
        %PEAK_EXCURSION_MKR Specifies the minimum amplitude
        %variation of the signal in dB that the
        %IviSpecAn_MarkerSearch MKR function identifies as a peak.
        Peak_Excursion_MKR
        
        %SIGNAL_TRACK_ENABLED_MKR Enables or disables signal
        %tracking.  When signal tracking is turned on, the spectrum
        %analyzer centers the signal after each sweep.  This process
        %invalidates the IVISPECAN_ATTR_FREQUENCY_START and
        %IVISPECAN_ATTR_FREQUENCY_STOP attributes.If the active
        %marker is not enabled, operations on this attribute return
        %the Marker Not Enabled (0xBFFA2001) error.   Note: Signal
        %tracking can only be enabled on one marker at any given
        %time.
        Signal_Track_Enabled_MKR
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MARKER_AMPLITUDE_MKR Returns the amplitude of the active
        %marker. The units are specified by the
        %IVISPECAN_ATTR_AMPLITUDE_UNITS attribute, except when the
        %IVISPECAN_ATTR_MARKER_TYPE MKR attribute is set to Delta.
        %When the IVISPECAN_ATTR_MARKER_TYPE MKR attribute is set to
        %Delta the units are dB.  If the
        %IVISPECAN_ATTR_MARKER_ENABLED MKRattribute is set to False,
        %any attempt to read this attribute returns the Marker Not
        %Enabled error(0xBFFA2001). Read Only.
        Marker_Amplitude_MKR
        
        %NUMBER_OF_MARKERS_MKR Returns the number of markers
        %available for the instrument. Read Only.
        Number_of_Markers_MKR
        
        %MARKERTYPE Attributes to control and configure the type of
        %marker used by the  Read Only.
        MarkerType
        
        %DELTAMARKER Delta Marker attributes configuration Read
        %Only.
        DeltaMarker
    end
    
    %% Property access methods
    methods
        %% Active_Marker_MKR property access methods
        function value = get.Active_Marker_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250201 ,4096);
        end
        function set.Active_Marker_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250201, newValue);
        end
        
        %% Marker_Enabled_MKR property access methods
        function value = get.Marker_Enabled_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250204);
        end
        function set.Marker_Enabled_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Markers.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250204, newValue);
        end
        
        %% Marker_Frequency_Counter_Enabled_MKR property access
        %methods
        function value = get.Marker_Frequency_Counter_Enabled_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250205);
        end
        function set.Marker_Frequency_Counter_Enabled_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Markers.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250205, newValue);
        end
        
        %% Marker_Frequency_Counter_Resolution_MKR property access
        %methods
        function value = get.Marker_Frequency_Counter_Resolution_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250206);
        end
        function set.Marker_Frequency_Counter_Resolution_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250206, newValue);
        end
        
        %% Marker_Position_MKR property access methods
        function value = get.Marker_Position_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250207);
        end
        function set.Marker_Position_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250207, newValue);
        end
        
        %% Marker_Threshold_MKR property access methods
        function value = get.Marker_Threshold_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250208);
        end
        function set.Marker_Threshold_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250208, newValue);
        end
        
        %% Marker_Trace_MKR property access methods
        function value = get.Marker_Trace_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1250209 ,4096);
        end
        function set.Marker_Trace_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarStringArg(newValue);
            attributAccessors.SetAttributeViString( obj.RepCapIdentifier ,1250209, newValue);
        end
        
        %% Peak_Excursion_MKR property access methods
        function value = get.Peak_Excursion_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250210);
        end
        function set.Peak_Excursion_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250210, newValue);
        end
        
        %% Signal_Track_Enabled_MKR property access methods
        function value = get.Signal_Track_Enabled_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250211);
        end
        function set.Signal_Track_Enabled_MKR(obj,newValue)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSpecAn.Markers.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250211, newValue);
        end
        %% Marker_Amplitude_MKR property access methods
        function value = get.Marker_Amplitude_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250202);
        end
        
        %% Number_of_Markers_MKR property access methods
        function value = get.Number_of_Markers_MKR(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250203);
        end
        
        %% MarkerType property access methods
        function value = get.MarkerType(obj)
            if isempty(obj.MarkerType)
                obj.MarkerType = instrument.ivic.IviSpecAn.Markers.MarkerType();
            end
            value = obj.MarkerType;
        end
        
        %% DeltaMarker property access methods
        function value = get.DeltaMarker(obj)
            if isempty(obj.DeltaMarker)
                obj.DeltaMarker = instrument.ivic.IviSpecAn.Markers.DeltaMarker();
            end
            value = obj.DeltaMarker;
        end
    end
end
