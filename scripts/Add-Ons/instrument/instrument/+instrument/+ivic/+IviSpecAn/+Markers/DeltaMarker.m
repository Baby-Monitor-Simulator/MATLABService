classdef DeltaMarker < instrument.ivic.IviGroupBase
    %DELTAMARKER Delta Marker attributes configuration
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %REFERENCE_MARKER_AMPLITUDE_DMK Returns the reference
        %marker amplitude when the active marker is a delta marker.
        %The units are specified by the
        %IVISPECAN_ATTR_AMPLITUDE_UNITS attribute. If the Marker
        %Type attribute is not Delta, this attribute returns the Not
        %Delta Marker error (0xBFFA2002). Read Only.
        Reference_Marker_Amplitude_DMK
        
        %REFERENCE_MARKER_POSITION_DMK Returns the position of the
        %reference marker, when the active marker is a delta marker.
        % The units are Hertz for frequency domain measurements, and
        %seconds for time domain measurements.  If the Marker Type
        %attribute is not Delta, this attribute returns the Not
        %Delta Marker error (0xBFFA2002). Read Only.
        Reference_Marker_Position_DMK
    end
    
    %% Property access methods
    methods
        %% Reference_Marker_Amplitude_DMK property access methods
        function value = get.Reference_Marker_Amplitude_DMK(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250801);
        end
        
        %% Reference_Marker_Position_DMK property access methods
        function value = get.Reference_Marker_Position_DMK(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250802);
        end
    end
end
