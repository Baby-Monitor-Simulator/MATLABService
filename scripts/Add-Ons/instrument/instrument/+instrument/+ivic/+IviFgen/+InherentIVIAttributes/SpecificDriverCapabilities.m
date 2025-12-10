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
        
        %GROUP_CAPABILITIES Indicates the IviFgen capability groups
        %that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following group
        %names:  \IviFgenBase\ - Supports fundamental function
        %generator capabilities.  \IviFgenStdFunc\ - Supports
        %IviFgenBase with the capability to generate standard
        %periodic waveforms.  \IviFgenArbWfm\ - Supports IviFgenBase
        %with the capability to create and generate user-defined
        %arbitrary waveforms.  \IviFgenArbFrequency\ - Supports
        %IviFgenArbWfm with the capability to set the rate at which
        %an entire waveform buffer is generated.  \IviFgenArbSeq\ -
        %Supports IviFgenArbWfm  with the capability to create and
        %generate sequences of user-defined arbitrary waveforms.
        %\IviFgenTrigger\ - Supports IviFgen with the capability to
        %trigger signal generation.  \IviFgenInternalTrigger\ -
        %Supports IviFgenTrigger with the capability to generate
        %triggers internally.  \IviFgenSoftwareTrigger\ - Supports
        %IviFgenTrigger with the capability to receive software
        %triggers.  \IviFgenBurst\ - Supports IviFgenBase with the
        %capability to generate discrete numbers of waveform cycles
        %based on a trigger event.  \IviFgenModulateAM\ - Supports
        %IviFgenBase with the capability to apply amplitude
        %modulation to an output signal.  \IviFgenModulateFM\ -
        %Supports IviFgenBase with the capability to apply frequency
        %modulation to an output signal. Read Only.
        Group_Capabilities
        
        %FUNCTION_CAPABILITIES Indicates the IviFgen functions that
        %the specific instrument driver supports.  This attribute is
        %a comma-delimited list of the following functions:
        %\IviFgen_init\     \IviFgen_close\     \IviFgen_reset\
        %\IviFgen_self_test\     \IviFgen_error_query\
        %\IviFgen_error_message\     \IviFgen_revision_query\
        %\IviFgen_ConfigureOutputMode\
        %\IviFgen_ConfigureOperationMode\
        %\IviFgen_ConfigureRefClockSource\
        %\IviFgen_ConfigureOutputImpedance\
        %\IviFgen_ConfigureOutputEnabled\
        %\IviFgen_InitiateGeneration\     \IviFgen_AbortGeneration\
        %   \IviFgen_ConfigureStandardWaveform\
        %\IviFgen_QueryArbWfmCapabilities\
        %\IviFgen_CreateArbWaveform\
        %\IviFgen_ConfigureSampleRate\
        %\IviFgen_ConfigureArbFrequency\
        %\IviFgen_ConfigureArbWaveform\
        %\IviFgen_ClearArbWaveform\
        %\IviFgen_QueryArbSeqCapabilities\
        %\IviFgen_CreateArbSequence\
        %\IviFgen_ConfigureArbSequence\
        %\IviFgen_ClearArbSequence\     \IviFgen_ClearArbMemory\
        %\IviFgen_ConfigureTriggerSource\
        %\IviFgen_ConfigureInternalTriggerRate\
        %\IviFgen_SendSoftWareTrigger\
        %\IviFgen_ConfigureBurstCount\
        %\IviFgen_ConfigureAMEnabled\
        %\IviFgen_ConfigureAMSource\
        %\IviFgen_ConfigureAMInternal\
        %\IviFgen_ConfigureFMEnabled\
        %\IviFgen_ConfigureFMSource\
        %\IviFgen_ConfigureFMInternal\ Read Only.
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
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Group_Capabilities property access methods
        function value = get.Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
        
        %% Function_Capabilities property access methods
        function value = get.Function_Capabilities(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050402 ,4096);
        end
        
        %% Channel_Count property access methods
        function value = get.Channel_Count(obj)
            attributAccessors = instrument.ivic.IviFgen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050203);
        end
    end
end
