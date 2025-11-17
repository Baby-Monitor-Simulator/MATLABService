classdef SpecificDriverCapabilities < instrument.ivic.IviGroupBase
    %SPECIFICDRIVERCAPABILITIES Attributes that provide
    %information about the capabilities of the specific driver.\n
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %SUPPORTED_INSTRUMENT_MODELS Contains a model code of the
        %instrument. For specific drivers that support more than one
        %device, this attribute contains a comma-separated list of
        %supported instrument models. Read Only.
        Supported_Instrument_Models
        
        %GROUP_CAPABILITIES Indicates the IviScope capability
        %groups that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following group
        %names:  \IviScopeBase\ - Supports fundamental oscilloscope
        %capabilities.  \IviScopeInterpolation\ - Supports
        %IviScopeBase with the ability to configure the oscilloscope
        %to interpolate missing points in a waveform.
        %\IviScopeTVTrigger\ - Supports IviScopeBase with the
        %ability to trigger on standard television signals.
        %\IviScopeRuntTrigger\ - Supports IviScopeBase with the
        %ability to trigger on runts.  \IviScopeGlitchTrigger\ -
        %Supports IviScopeBase with the ability to trigger on
        %glitches.  \IviScopeWidthTrigger\ - Supports IviScopeBase
        %with the ability to trigger on a variety of conditions
        %regarding pulse widths.  \IviScopeAcLineTrigger\ - Supports
        %IviScopeBase with the ability to trigger on zero crossings
        %of a network supply voltage.  \IviScopeWaveformMeas\ -
        %Supports IviScopeBase with the ability to calculate
        %waveform measurements.  \IviScopeMinMaxWaveform\ - Supports
        %IviScopeBase with the ability to acquire minimum and
        %maximum waveforms that correspond to the same time range.
        %\IviScopeProbeAutoSense\ - Supports IviScopeBase with the
        %ability to automatically sense the probe attenuation of an
        %attached probe.  \IviScopeContinuousAcquisition\ - Supports
        %IviScopeBase with the ability to continuously acquire data
        %from the input.  \IviScopeAverageAcquisition\ - Supports
        %IviScopeBase with the ability to create a waveform that is
        %the average of multiple waveform acquisitions.
        %\IviScopeSampleMode\ - Supports IviScopeBase with the
        %ability to return the actual sample mode.
        %\IviScopeTriggerModifier\ - Supports IviScopeBase with the
        %ability to modify the behavior of the triggering subsystem
        %in the absence of an expected trigger.  \IviScopeAutoSetup\
        %- Supports IviScopeBase with the ability to perform an
        %auto-setup operation.  \IviScopeSoftwareTrigger\ - Supports
        %IviScopeBase with the ability to use the software trigger
        %as the exclusive trigger type. Read Only.
        Group_Capabilities
        
        %FUNCTION_CAPABILITIES Indicates the IviScope functions
        %that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following
        %functions:      \IviScope_init\     \IviScope_close\
        %\IviScope_reset\     \IviScope_self_test\
        %\IviScope_error_query\     \IviScope_error_message\
        %\IviScope_revision_query\     \IviScope_Abort\
        %\IviScope_AcquisitionStatus\
        %\IviScope_ActualRecordLength\
        %\IviScope_ConfigureAcquisitionRecord\
        %\IviScope_ConfigureAcquisitionType\
        %\IviScope_ConfigureChannel\
        %\IviScope_ConfigureChanCharacteristics\
        %\IviScope_ConfigureEdgeTriggerSource\
        %\IviScope_ConfigureTrigger\
        %\IviScope_ConfigureTriggerCoupling\
        %\IviScope_FetchWaveform\     \IviScope_InitiateAcquisition\
        %    \IviScope_IsInvalidWfmElement\
        %\IviScope_ReadWaveform\     \IviScope_SampleRate\
        %\IviScope_ConfigureInterpolation\
        %\IviScope_ConfigureTVTriggerSource\
        %\IviScope_ConfigureTVTriggerLineNumber\
        %\IviScope_ConfigureRuntTriggerSource\
        %\IviScope_ConfigureGlitchTriggerSource\
        %\IviScope_ConfigureWidthTriggerSource\
        %\IviScope_ConfigureAcLineTriggerSlope\
        %\IviScope_ConfigureRefLevels\
        %\IviScope_FetchWaveformMeasurement\
        %\IviScope_ReadWaveformMeasurement\
        %\IviScope_ConfigureNumEnvelopes\
        %\IviScope_FetchMinMaxWaveform\
        %\IviScope_ReadMinMaxWaveform\
        %\IviScope_AutoProbeSenseValue\
        %\IviScope_ConfigureInitiateContinuous\
        %\IviScope_ConfigureNumAverages\     \IviScope_SampleMode\
        %  \IviScope_ConfigureTriggerModifier\
        %\IviScope_AutoSetup\ Read Only.
        Function_Capabilities
        
        %CHANNEL_COUNT Indicates the number of channels that the
        %specific driver supports.       For each attribute for
        %which the IVI_VAL_MULTI_CHANNEL flag attribute is set, the
        %instrument driver maintains a separate cache value for each
        %channel. Read Only.
        Channel_Count
    end
    
    %% Property access methods
    methods
        %% Supported_Instrument_Models property access methods
        function value = get.Supported_Instrument_Models(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Group_Capabilities property access methods
        function value = get.Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
        
        %% Function_Capabilities property access methods
        function value = get.Function_Capabilities(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050402 ,4096);
        end
        
        %% Channel_Count property access methods
        function value = get.Channel_Count(obj)
            attributAccessors = instrument.ivic.IviScope.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050203);
        end
    end
end
