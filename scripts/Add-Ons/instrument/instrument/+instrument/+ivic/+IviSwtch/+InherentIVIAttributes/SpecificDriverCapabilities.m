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
        
        %GROUP_CAPABILITIES Indicates the IviSwtch capability
        %groups that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following group
        %names:  \IviSwtch\ - Supports fundamental switch
        %capabilities.  \IviSwtchScanner\ - Supports IviSwtch with
        %the capability to scan channels.  \IviSwtchSoftwareTrigger\
        %- Supports IviSwtchScanner with the capability to receive
        %software triggers. Read Only.
        Group_Capabilities
        
        %FUNCTION_CAPABILITIES Indicates the IviSwtch functions
        %that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following
        %functions:      \IviSwtch_init\     \IviSwtch_close\
        %\IviSwtch_reset\     \IviSwtch_self_test\
        %\IviSwtch_error_query\     \IviSwtch_error_message\
        %\IviSwtch_revision_query\     \IviSwtch_Connect\
        %\IviSwtch_Disconnect\     \IviSwtch_GetPath\
        %\IVISwtch_SetPath\     \IviSwtch_CanConnect\
        %\IviSwtch_DisconnectAll\     \IviSwtch_IsDebounced\
        %\IviSwtch_WaitForDebounce\     \IviSwtch_InitiateScan\
        %\IviSwtch_AbortScan\     \IviSwtch_IsScanning\
        %\IviSwtch_WaitForScanComplete\
        %\IviSwtch_ConfigureScanList\
        %\IviSwtch_ConfigureScanTrigger\
        %\IviSwtch_SendSoftwareTrigger\ Read Only.
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
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Group_Capabilities property access methods
        function value = get.Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
        
        %% Function_Capabilities property access methods
        function value = get.Function_Capabilities(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050402 ,4096);
        end
        
        %% Channel_Count property access methods
        function value = get.Channel_Count(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050203);
        end
    end
end
