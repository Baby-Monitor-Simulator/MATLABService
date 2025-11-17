classdef Acquisition < instrument.ivic.IviGroupBase
    %ACQUISITION Attributes that configure the various
    %acquisition modes
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %ACQUISITION_TYPE Specifies how the oscilloscope acquires
        %data and fills the waveform record.  When you set this
        %attribute to IVISCOPE_VAL_ENVELOPE or
        %IVISCOPE_VAL_PEAK_DETECT, the oscilloscope acquires minimum
        %and maximum waveforms.  To retrieve the minimum and maximum
        %waveforms, use the IviScope_ReadMinMaxWaveform and
        %IviScope_FetchMinMaxWaveform functions.
        Acquisition_Type
        
        %HORIZONTAL_TIME_PER_RECORD This attribute specifies the
        %time in seconds that corresponds to the record length.
        Horizontal_Time_Per_Record
        
        %HORIZONTAL_MINIMUM_NUMBER_OF_POINTS Specifies the minimum
        %number of points you require in the waveform record for
        %each channel.  This instrument driver uses the value you
        %specify to configure the record length that the
        %oscilloscope uses for waveform acquisition.  Use the
        %IVISCOPE_ATTR_HORZ_RECORD_LENGTH attribute to obtain the
        %actual record length.
        Horizontal_Minimum_Number_of_Points
        
        %ACQUISITION_START_TIME This attributes specifies the
        %length of time from the trigger event to the first point in
        %the waveform record.  The units are seconds.  If the value
        %is positive, the first point in the waveform record occurs
        %after the trigger event.  If the value is negative, the
        %first point in the waveform record occurs before the
        %trigger event.
        Acquisition_Start_Time
        
        %INTERPOLATION_I Specifies the interpolation method the
        %oscilloscope uses when it cannot sample a voltage for every
        %point in the waveform record.  Note: (1) This attribute is
        %part of the IviScopeInterpolation I extension group.
        Interpolation_I
        
        %NUMBER_OF_AVERAGES_AA Specifies the number of waveforms
        %the oscilloscope acquires and averages.  After the
        %oscilloscope acquires as many waveforms as this attribute
        %specifies, it returns to the idle state.  This attribute
        %affects instrument behavior only when the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute is set to
        %IVISCOPE_VAL_AVERAGE.  Note: (1) This attribute is part of
        %the IviScopeAverageAcquisition AA extension group.
        Number_of_Averages_AA
        
        %NUMBER_OF_ENVELOPES_MMW When you set the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute to
        %IVISCOPE_VAL_ENVELOPE, the oscilloscope acquires multiple
        %waveforms.  After each waveform acquisition, the
        %oscilloscope keeps the minimum and maximum values it finds
        %for each point in the waveform record.  This attribute
        %specifies the number of waveforms the oscilloscope acquires
        %and analyzes to create the minimum and maximum waveforms.
        %After the oscilloscope acquires as many waveforms as this
        %attribute specifies, it returns to the idle state.  This
        %attribute affects instrument operation only when the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute is set to
        %IVISCOPE_VAL_ENVELOPE.  Note: (1) This attribute is part of
        %the IviScopeMinMaxWaveform MmW extension group.
        Number_of_Envelopes_MmW
        
        %INITIATE_CONTINUOUS_CA Specifies whether the oscilloscope
        %continuously initiates waveform acquisition.  If you set
        %this attribute to VI_TRUE, the oscilloscope immediately
        %waits for another trigger after the previous waveform
        %acquisition is complete.  Setting this attribute to VI_TRUE
        %is useful when you require continuous updates of the
        %oscilloscope display.  Note: (1) This attribute is part of
        %the IviScopeContinuousAcquisition CA extension group.
        Initiate_Continuous_CA
    end
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %HORIZONTAL_RECORD_LENGTH Returns the actual number of
        %points the oscilloscope acquires for each channel.  The
        %value is equal to or greater than the minimum number of
        %points you specify with the IVISCOPE_ATTR_HORZ_MIN_NUM_PTS
        %attribute.  Allocate a ViReal64 array of this size or
        %greater to pass as the Waveform Array parameter of the
        %IviScope_ReadWaveform and IviScope_FetchWaveform functions.
        %      Note:  The oscilloscope may use different size
        %records depending on the value you specify for the
        %IVISCOPE_ATTR_ACQUISITION_TYPE attribute. Read Only.
        Horizontal_Record_Length
        
        %HORIZONTAL_SAMPLE_RATE Returns the effective digitizing
        %rate using the current configuration.  The units are
        %samples per second. Read Only.
        Horizontal_Sample_Rate
        
        %SAMPLE_MODE_SM Returns the sample mode the oscilloscope is
        %currently using.  IVISCOPE_VAL_REAL_TIME (0) - Indicates
        %that the oscilloscope  is using real-time sampling.
        %IVISCOPE_VAL_EQUIVALENT_TIME (1) - Indicates that the
        %oscilloscope  is using equivalent-time sampling.   Note:
        %(1) This attribute is part of the IviScopeSampleMode SM
        %extension group. Read Only.
        Sample_Mode_SM
    end
    
    %% Property access methods
    methods
        %% Acquisition_Type property access methods
        function value = get.Acquisition_Type(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250101);
        end
        function set.Acquisition_Type(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.Acquisition.*;
            attrAcquisitionTypeRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250101, newValue);
        end
        
        %% Horizontal_Time_Per_Record property access methods
        function value = get.Horizontal_Time_Per_Record(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250007);
        end
        function set.Horizontal_Time_Per_Record(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250007, newValue);
        end
        
        %% Horizontal_Minimum_Number_of_Points property access
        %methods
        function value = get.Horizontal_Minimum_Number_of_Points(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250009);
        end
        function set.Horizontal_Minimum_Number_of_Points(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250009, newValue);
        end
        
        %% Acquisition_Start_Time property access methods
        function value = get.Acquisition_Start_Time(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250109);
        end
        function set.Acquisition_Start_Time(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarDoubleArg(newValue);
            attributAccessors.SetAttributeViReal64( obj.RepCapIdentifier ,1250109, newValue);
        end
        
        %% Interpolation_I property access methods
        function value = get.Interpolation_I(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250019);
        end
        function set.Interpolation_I(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.Acquisition.*;
            attrInterpolationRangeTable.checkEnumValue(newValue );
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250019, newValue);
        end
        
        %% Number_of_Averages_AA property access methods
        function value = get.Number_of_Averages_AA(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250104);
        end
        function set.Number_of_Averages_AA(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250104, newValue);
        end
        
        %% Number_of_Envelopes_MmW property access methods
        function value = get.Number_of_Envelopes_MmW(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250105);
        end
        function set.Number_of_Envelopes_MmW(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            newValue = obj.checkScalarInt32Arg(newValue);
            attributAccessors.SetAttributeViInt32( obj.RepCapIdentifier ,1250105, newValue);
        end
        
        %% Initiate_Continuous_CA property access methods
        function value = get.Initiate_Continuous_CA(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250107);
        end
        function set.Initiate_Continuous_CA(obj,newValue)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviScope.Acquisition.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250107, newValue);
        end
        %% Horizontal_Record_Length property access methods
        function value = get.Horizontal_Record_Length(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250008);
        end
        
        %% Horizontal_Sample_Rate property access methods
        function value = get.Horizontal_Sample_Rate(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViReal64( obj.RepCapIdentifier ,1250010);
        end
        
        %% Sample_Mode_SM property access methods
        function value = get.Sample_Mode_SM(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1250106);
        end
    end
end
