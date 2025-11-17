classdef Marker < instrument.ivic.IviGroupBase
    %MARKER Most analyzers utilize markers.  The marker
    %extension group defines extensions for analyzers capable of
    %performing various functions on one or more traces that
    %involve using markers.  Markers can be used for things as
    %simple as getting amplitude value at a specific point to
    %complex functions such as signal tracking.  The marker
    %extension group defines additional attributes such Active
    %Marker and Marker Amplitude.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function ConfigureMarkerEnabled(obj,MarkerEnabled,MarkerTraceName)
            %CONFIGUREMARKERENABLED This function enables the active
            %marker on the specified trace.
            
            narginchk(3,3)
            MarkerEnabled = obj.checkScalarBoolArg(MarkerEnabled);
            MarkerTraceName = obj.checkScalarStringArg(MarkerTraceName);
            try
                [libname, session ] = obj.getLibraryAndSession();
                MarkerTraceName = [double(MarkerTraceName) 0];
                
                status = calllib( libname,'IviSpecAn_ConfigureMarkerEnabled', session, MarkerEnabled, MarkerTraceName);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureMarkerFrequencyCounter(obj,MarkerFrequencyCounter,FrequencyCounterResolution)
            %CONFIGUREMARKERFREQUENCYCOUNTER This function sets the
            %marker frequency counter resolution and turns the marker
            %frequency counter on/off.
            
            narginchk(3,3)
            MarkerFrequencyCounter = obj.checkScalarBoolArg(MarkerFrequencyCounter);
            FrequencyCounterResolution = obj.checkScalarDoubleArg(FrequencyCounterResolution);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureMarkerFrequencyCounter', session, MarkerFrequencyCounter, FrequencyCounterResolution);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureMarkerSearch(obj,PeakExcursion,MarkerThreshold)
            %CONFIGUREMARKERSEARCH This function configures the marker
            %peak excursion and marker threshold values.  The marker
            %peak excursion specifies the minimum amplitude variation
            %that can be recognized as a peak or minimum by the marker.
            %The marker threshold specifies a lower bound for ALL marker
            %search functions.
            
            narginchk(3,3)
            PeakExcursion = obj.checkScalarDoubleArg(PeakExcursion);
            MarkerThreshold = obj.checkScalarDoubleArg(MarkerThreshold);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureMarkerSearch', session, PeakExcursion, MarkerThreshold);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function ConfigureSignalTrackEnabled(obj,SignalTrackEnabled)
            %CONFIGURESIGNALTRACKENABLED This function enables
            %signal-tracking. When signal tracking is turned on, the
            %spectrum analyzer centers the signal on which the active
            %marker resides after each sweep.  There are two prevalent
            %methods of signal tracking in the industry.   1.  A search
            %for the largest signal on screen is made, and the spectrum
            %analyzer center frequency is tuned to this signal.  2.  The
            %marker is placed on a signal (anywhere on screen) and when
            %marker track is enabled, the frequency of the peak of the
            %selected signal is used for tuning the spectrum analyzer.
            %This does not need to be the largest signal on screen, and
            %this method tracks the specified signal in the presence of
            %a larger signal.  This function implements the first method
            %of signal tracking.  This INVALIDATES the
            %IVISPECAN_ATTR_FREQUENCY_START and
            %IVISPECAN_ATTR_FREQUENCY_STOP attribute values.   Note:
            %Signal track can only be enabled on one marker at a time.
            %The driver shall check all other markers to see if this
            %function is already enabled on any marker other than the
            %active and turn this off on the other marker before
            %enabling this on the active marker.
            
            narginchk(2,2)
            SignalTrackEnabled = obj.checkScalarBoolArg(SignalTrackEnabled);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_ConfigureSignalTrackEnabled', session, SignalTrackEnabled);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function DisableAllMarkers(obj)
            %DISABLEALLMARKERS This function disables all of markers.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_DisableAllMarkers', session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MarkerSearch(obj,MarkerSearch)
            %MARKERSEARCH This function specifies the type of marker
            %search and performs the search.   This function returns the
            %Marker Not Enabled error (0x0xBFFA2001) if the
            %IVISPECAN_ATTR_MARKER_ENABLED attribute is set to False.
            
            narginchk(2,2)
            MarkerSearch = obj.checkScalarInt32Arg(MarkerSearch);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_MarkerSearch', session, MarkerSearch);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MoveMarker(obj,MarkerPosition)
            %MOVEMARKER This function moves the active marker to the
            %specified horizontal position.
            
            narginchk(2,2)
            MarkerPosition = obj.checkScalarDoubleArg(MarkerPosition);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_MoveMarker', session, MarkerPosition);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [MarkerPosition,MarkerAmplitude] = QueryMarker(obj)
            %QUERYMARKER This function returns the horizontal position
            %and the marker amplitude level of the active marker.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MarkerPosition = libpointer('doublePtr', 0);
                MarkerAmplitude = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviSpecAn_QueryMarker', session, MarkerPosition, MarkerAmplitude);
                
                MarkerPosition = MarkerPosition.Value;
                MarkerAmplitude = MarkerAmplitude.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetActiveMarker(obj,ActiveMarker)
            %SETACTIVEMARKER This function selects one of the available
            %markers, and makes it the active marker. The active marker
            %must be enabled using the IviSpecAn_ConfigureMarkerEnabled
            %function before it can be used for most marker operations.
            
            narginchk(2,2)
            ActiveMarker = obj.checkScalarStringArg(ActiveMarker);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ActiveMarker = [double(ActiveMarker) 0];
                
                status = calllib( libname,'IviSpecAn_SetActiveMarker', session, ActiveMarker);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetInstrumentFromMarker(obj,InstrumentSetting)
            %SETINSTRUMENTFROMMARKER This function uses the
            %IVISPECAN_ATTR_MARKER_POSITION or
            %IVISPECAN_ATTR_MARKER_AMPLITUDE attribute to configure the
            %spectrum analyzer according to value of the
            %InstrumentSetting parameter.  For example, setting the
            %Instrument Setting parameter to Frequency Center sets the
            %center frequency to the value of the
            %IVISPECAN_ATTR_MARKER_POSITION attribute.    This function
            %may set the IVISPECAN_ATTR_FREQUENCY_START,
            %IVISPECAN_ATTR_FREQUENCY_STOP, or
            %IVISPECAN_ATTR_REFERENCE_LEVEL attributes.  If the
            %IVISPECAN_ATTR_MARKER_ENABLED attribute is set to False,
            %this function returns the Marker Not Enabled error
            %(0xBFFA2001).  If the IVISPECAN_ATTR_MARKER_TYPE attribute
            %is not Delta and the InstrumentSetting parameter is
            %Frequency Span, the function returns the Not Delta Marker
            %error (0xBFFA2002).
            
            narginchk(2,2)
            InstrumentSetting = obj.checkScalarInt32Arg(InstrumentSetting);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_SetInstrumentFromMarker', session, InstrumentSetting);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MarkerType = QueryMarkerType(obj)
            %QUERYMARKERTYPE This function queries the read-only
            %IVISPECAN_ATTR_MARKER_TYPE attribute.
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                MarkerType = libpointer('int32Ptr', 0);
                
                status = calllib( libname,'IviSpecAn_QueryMarkerType', session, MarkerType);
                
                MarkerType = MarkerType.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function MakeMarkerDelta(obj,DeltaMarker)
            %MAKEMARKERDELTA This function specifies whether the active
            %marker is a delta marker.   When this function is called
            %with DeltaMarker true, the current active marker is changed
            %to a delta marker and the associated reference marker is
            %moved to the current position of the active marker. The
            %current position becomes the reference point for marker
            %values. The marker readout indicates the relative frequency
            %(or time) separation and amplitude difference between the
            %reference and active marker.  When this Delta Marker is set
            %to false, the current marker is changed to a normal marker.
            %The reference marker is determined by calling the
            %IviSpecAn_QueryReferenceMarker function.  Notes:  (1) If
            %the current active marker is not enabled then this function
            %enables the active marker.
            
            narginchk(2,2)
            DeltaMarker = obj.checkScalarBoolArg(DeltaMarker);
            try
                [libname, session ] = obj.getLibraryAndSession();
                
                status = calllib( libname,'IviSpecAn_MakeMarkerDelta', session, DeltaMarker);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function [ReferenceMarkerAmplitude,ReferenceMarkerPosition] = QueryReferenceMarker(obj)
            %QUERYREFERENCEMARKER This function returns the amplitude
            %and position of the reference marker.  If the
            %IVISPECAN_ATTR_MARKER_TYPE attribute is not Delta, this
            %function returns the Not Delta Marker error (0xBFFA2002).
            
            narginchk(1,1)
            try
                [libname, session ] = obj.getLibraryAndSession();
                ReferenceMarkerAmplitude = libpointer('doublePtr', 0);
                ReferenceMarkerPosition = libpointer('doublePtr', 0);
                
                status = calllib( libname,'IviSpecAn_QueryReferenceMarker', session, ReferenceMarkerAmplitude, ReferenceMarkerPosition);
                
                ReferenceMarkerAmplitude = ReferenceMarkerAmplitude.Value;
                ReferenceMarkerPosition = ReferenceMarkerPosition.Value;
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function Name = GetMarkerName(obj,Index,NameBufferSize)
            %GETMARKERNAME This function returns the specific driver
            %defined trace name that corresponds to the one-based index
            %specified by the Index parameter.  If you pass in a value
            %for the Index parameter that is less than one or greater
            %than the value of the IVISPECAN_ATTR_MARKER_COUNT
            %attribute, the function returns an empty string in the Name
            %parameter and returns the Invalid Value error.  Note:  For
            %an instrument with only one Marker, i.e. the
            %IVISPECAN_ATTR_MARKER_COUNT attribute is one, the driver
            %may return an empty string.
            
            narginchk(3,3)
            Index = obj.checkScalarInt32Arg(Index);
            NameBufferSize = obj.checkScalarInt32Arg(NameBufferSize);
            try
                [libname, session ] = obj.getLibraryAndSession();
                Name = libpointer('int8Ptr', repmat(10, 1, 4096 ));
                
                status = calllib( libname,'IviSpecAn_GetMarkerName', session, Index, NameBufferSize, Name);
                
                Name = strtrim(char(Name.Value));
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
