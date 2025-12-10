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
        
        %GROUP_CAPABILITIES Indicates the IviDmm capability groups
        %that the specific instrument driver supports.  This
        %attribute is a comma-delimited list of the following group
        %names:  \IviDmmBase\ - Supports fundamental dmm
        %capabilities.  \IviDmmACMeasurement\ - Supports IviDmmBase
        %with the capability to take AC measurements.
        %\IviDmmFrequencyMeasurement\ - Supports IviDmmBase with the
        %capability to take frequency measurements.
        %\IviDmmTemperatureMeasurement\ - Supports IviDmmBase with
        %the capability to take temperature measurements.
        %\IviDmmThermocouple\ - Supports IviDmmBase with the
        %capability to take temperature measurements with a
        %thermocouple.  \IviDmmResistanceTemperatureDevice\ -
        %Supports IviDmmBase with the capability to take temperature
        %measurements with a resistance temperature device.
        %\IviDmmThermistor\ - Supports IviDmmBase with the
        %capability to take temperature measurements with a
        %thermistor.  \IviDmmMultiPoint\ - Supports IviDmm with the
        %capability to accept multiple triggers and acquire multiple
        %samples per trigger.  \IviDmmTriggerSlope\ - Supports
        %IviDmmBase with the capability to specify trigger slope.
        %\IviDmmSoftwareTrigger\ - Supports IviDmmBase with the
        %capability to send a software trigger.  \IviDmmDeviceInfo\
        %- Supports IviDmmBase with the capability to return
        %attributes that give extra information concerning the
        %instrument's state such as aperture time.
        %\IviDmmAutoRangeValue\ - Supports IviDmmBase with the
        %capability to return the actual range when auto ranging.
        %\IviDmmAutoZero\ - Supports IviDmmBase with the capability
        %to take an auto-zero reading.  \IviDmmPowerLineFrequency\ -
        %Supports IviDmmBase with the capability to specify the
        %power line frequency. Read Only.
        Group_Capabilities
        
        %FUNCTION_CAPABILITIES Indicates the IviDmm functions that
        %the specific instrument driver supports.  This attribute is
        %a comma-delimited list of the following functions:
        %\IviDmm_init\     \IviDmm_close\     \IviDmm_reset\
        %\IviDmm_self_test\     \IviDmm_error_query\
        %\IviDmm_error_message\     \IviDmm_revision_query\
        %\IviDmm_ConfigureMeasurement\     \IviDmm_ConfigureTrigger\
        %    \IviDmm_Read\     \IviDmm_Fetch\     \IviDmm_Abort\
        %\IviDmm_Initiate\     \IviDmm_IsOverRange\
        %\IviDmm_ConfigureACBandwidth\
        %\IviDmm_ConfigureFrequencyVoltageRange\
        %\IviDmm_ConfigureTransducerType\
        %\IviDmm_ConfigureFixedRefJunction\
        %\IviDmm_ConfigureThermocouple\     \IviDmm_ConfigureRTD\
        % \IviDmm_ConfigureThermistor\
        %\IviDmm_ConfigureMeasCompleteDest\
        %\IviDmm_ConfigureMultiPoint\     \IviDmm_ReadMultiPoint\
        % \IviDmm_FetchMultiPoint\
        %\IviDmm_ConfigureTriggerSlope\
        %\IviDmm_SendSoftwareTrigger\
        %\IviDmm_GetApertureTimeInfo\     \IviDmm_GetAutoRangeValue\
        %    \IviDmm_ConfigureAutoZeroMode\
        %\IviDmm_ConfigurePowerLineFrequency\ Read Only.
        Function_Capabilities
    end
    
    %% Property access methods
    methods
        %% Supported_Instrument_Models property access methods
        function value = get.Supported_Instrument_Models(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Group_Capabilities property access methods
        function value = get.Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
        
        %% Function_Capabilities property access methods
        function value = get.Function_Capabilities(obj)
            attributAccessors = instrument.ivic.IviDmm.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050402 ,4096);
        end
    end
end
