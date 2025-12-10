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
        
        %GROUP_CAPABILITIES Indicates the IviDCPwr capability
        %groups that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following group
        %names:  \IviDCPwrBase\ - Supports fundamental DC power
        %supply capabilities.  \IviDCPwrTrigger\ - Supports
        %IviDCPwrBase with the capability to change the output on
        %trigger events.  \IviDCPwrSoftwareTrigger\ - Supports
        %IviDCPwrTrigger with the capability to send a software
        %trigger. Read Only.
        Group_Capabilities
        
        %FUNCTION_CAPABILITIES Indicates the IviDCPwr functions
        %that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following
        %functions:      \IviDCPwr_init\     \IviDCPwr_close\
        %\IviDCPwr_reset\     \IviDCPwr_self_test\
        %\IviDCPwr_error_query\     \IviDCPwr_error_message\
        %\IviDCPwr_revision_query\     \IviDCPwr_InitWithOptions\
        % \IviDCPwr_ConfigureOutputEnabled\
        %\IviDCPwr_ConfigureOutputRange\
        %\IviDCPwr_ConfigureCurrentLimit\
        %\IviDCPwr_ConfigureOVP\
        %\IviDCPwr_ConfigureVoltageLevel\
        %\IviDCPwr_QueryOutputState\
        %\IviDCPwr_QueryMaxCurrentLimit\
        %\IviDCPwr_QueryMaxVoltageLevel\
        %\IviDCPwr_ResetOutputProtection\
        %\IviDCPwr_ConfigureTriggerSource\
        %\IviDCPwr_ConfigureTriggeredVoltageLevel\
        %\IviDCPwr_ConfigureTriggeredCurrentLimit\
        %\IviDCPwr_Abort\     \IviDCPwr_Initiate\
        %\IviDCPwr_SendSoftwareTrigger\     \IviDCPwr_Measure\ Read
        %Only.
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
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Group_Capabilities property access methods
        function value = get.Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
        
        %% Function_Capabilities property access methods
        function value = get.Function_Capabilities(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050402 ,4096);
        end
        
        %% Channel_Count property access methods
        function value = get.Channel_Count(obj)
            attributAccessors = instrument.ivic.IviDCPwr.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050203);
        end
    end
end
