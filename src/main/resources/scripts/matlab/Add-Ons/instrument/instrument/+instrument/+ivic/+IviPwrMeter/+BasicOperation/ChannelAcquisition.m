classdef ChannelAcquisition < instrument.ivic.IviGroupBase
    %CHANNELACQUISITION Channel Acquisition
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %CHANNEL_ENABLED_CH This channel-based attribute specifies
        %if the power meter takes a measurement on the specified
        %input channel. The power meter will take a measurement on a
        %channel only if that channel is enabled. Channels are also
        %enabled when you call the Configure Measurement function.
        %See the function description for more details.
        Channel_Enabled_CH
    end
    
    %% Property access methods
    methods
        %% Channel_Enabled_CH property access methods
        function value = get.Channel_Enabled_CH(obj)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250051);
        end
        function set.Channel_Enabled_CH(obj,newValue)
            attributAccessors = instrument.ivic.IviPwrMeter.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviPwrMeter.BasicOperation.ChannelAcquisition.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250051, newValue);
        end
    end
end
