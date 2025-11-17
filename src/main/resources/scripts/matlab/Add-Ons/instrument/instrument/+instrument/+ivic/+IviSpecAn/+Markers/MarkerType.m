classdef MarkerType < instrument.ivic.IviGroupBase
    %MARKERTYPE Attributes to control and configure the type of
    %marker used by the
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %MARKER_TYPE_MKT Returns the marker type of the active
        %marker. Read Only.
        Marker_Type_MKT
    end
    
    %% Property access methods
    methods
        %% Marker_Type_MKT property access methods
        function value = get.Marker_Type_MKT(obj)
            attributAccessors = instrument.ivic.IviSpecAn.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250701);
        end
    end
end
