classdef DriverCapabilities < instrument.ivic.IviGroupBase
    %DRIVERCAPABILITIES Attributes that provide information
    %about the capabilities of this
    
    % Copyright 2010-2011 The MathWorks, Inc.
    
    %% Public Read Only Properties
    properties (SetAccess = private)
        %CHANNEL_COUNT Indicates the number of channels that the
        %specific instrument driver supports.       For each
        %attribute for which the IVI_VAL_MULTI_CHANNEL flag is set,
        %the IVI engine maintains a separate cache value for each
        %channel. Read Only.
        Channel_Count
        
        %SUPPORTED_INSTRUMENT_MODELS Contains a model code of the
        %instrument. For drivers that support more than one device,
        %this attribute contains a comma-separated list of supported
        %instrument models. Read Only.
        Supported_Instrument_Models
        
        %CLASS_GROUP_CAPABILITIES A string that contains a
        %comma-separated list of class-extension groups that this
        %driver implements. Read Only.
        Class_Group_Capabilities
    end
    
    %% Property access methods
    methods
        %% Channel_Count property access methods
        function value = get.Channel_Count(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViInt32( obj.RepCapIdentifier ,1050203);
        end
        
        %% Supported_Instrument_Models property access methods
        function value = get.Supported_Instrument_Models(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050327 ,4096);
        end
        
        %% Class_Group_Capabilities property access methods
        function value = get.Class_Group_Capabilities(obj)
            attributAccessors = instrument.ivic.IviRFSigGen.ConfigurationFunctions.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViString( obj.RepCapIdentifier ,1050401 ,4096);
        end
    end
end
