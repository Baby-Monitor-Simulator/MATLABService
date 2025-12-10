classdef WaveformMeasurementWM < instrument.ivic.IviGroupBase
    %WAVEFORMMEASUREMENTWM Attributes that configure the
    %waveform measurement reference levels.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %MEASUREMENT_HIGH_REFERENCE_WM Specifies the high reference
        %the oscilloscope uses for waveform measurements.  The value
        %is a percentage of the difference between the Voltage High
        %and Voltage Low.  The oscilloscope calculates the Voltage
        %High and the Voltage Low using either the minmax or
        %histogram methods.  The minmax method uses the maximum and
        %minimum values found.  The histogram method uses the most
        %common values found above and below the middle of the
        %waveform.  Note: (1) This attribute is part of the
        %IviScopeWaveformMeas WM extension group.
        Measurement_High_Reference_WM
        
        %MEASUREMENT_LOW_REFERENCE_WM Specifies the low reference
        %the oscilloscope uses for waveform measurements.  The value
        %is a percentage of the difference between the Voltage High
        %and Voltage Low.  The oscilloscope calculates the Voltage
        %High and the Voltage Low using either the minmax or
        %histogram methods.  The minmax method uses the maximum and
        %minimum values found.  The histogram method uses the most
        %common values found above and below the middle of the
        %waveform.  Note: (1) This attribute is part of the
        %IviScopeWaveformMeas WM extension group.
        Measurement_Low_Reference_WM
        
        %MEASUREMENT_MID_REFERENCE_WM Specifies the mid reference
        %the oscilloscope uses for waveform measurements.  The value
        %is a percentage of the difference between the Voltage High
        %and Voltage Low.  The oscilloscope calculates the Voltage
        %High and the Voltage Low using either the minmax or
        %histogram methods.  The minmax method uses the maximum and
        %minimum values found.  The histogram method uses the most
        %common values found above and below the middle of the
        %waveform.  Note: (1) This attribute is part of the
        %IviScopeWaveformMeas WM extension group.
        Measurement_Mid_Reference_WM
    end
    
    %% Property access methods
    methods
        %% Measurement_High_Reference_WM property access methods
        function value = get.Measurement_High_Reference_WM(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250607);
        end
        function set.Measurement_High_Reference_WM(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250607, newValue);
        end
        
        %% Measurement_Low_Reference_WM property access methods
        function value = get.Measurement_Low_Reference_WM(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250608);
        end
        function set.Measurement_Low_Reference_WM(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250608, newValue);
        end
        
        %% Measurement_Mid_Reference_WM property access methods
        function value = get.Measurement_Mid_Reference_WM(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250609);
        end
        function set.Measurement_Mid_Reference_WM(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250609, newValue);
        end
    end
end
