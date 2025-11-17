classdef ChannelConfiguration < instrument.ivic.IviGroupBase
    %CHANNELCONFIGURATION Attributes you use to configure the
    %characteristics
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Properties
    properties
        %IS_SOURCE_CHANNEL This channel-based attribute specifies
        %whether you want to identify the channel as a source
        %channel.  Typically, you set this attribute to VI_TRUE when
        %you attach the channel to a power supply, a function
        %generator, or an active measurement point on the unit under
        %test, and you do not want to connect the channel to another
        %source.  The driver prevents source channels from
        %connecting to each other.  The IviSwtch_Connect function
        %returns the IVISWTCH_ERROR_ATTEMPT_TO_CONNECT_SOURCES when
        %you attempt to connect two channels that you identify as
        %source channels.
        Is_Source_Channel
        
        %IS_CONFIGURATION_CHANNEL This channel-based attribute
        %specifies whether to reserve the channel for internal path
        %creation.  A channel that is available for internal path
        %creation is called a configuration channel.  The driver may
        %use configuration channels to create paths between two
        %channels you specify in the IviSwtch_Connect function.
        %Configuration channels are not available for external
        %connections.     Set this attribute to VI_TRUE to mark the
        %channel as a configuration channel.  Set this attribute to
        %VI_FALSE to mark the channel as available for external
        %connections.     After you identify a channel as a
        %configuration channel, you cannot use that channel for
        %external connections.  The IviSwtch_Connect function
        %returns the IVISWTCH_ERROR_IS_CONFIGURATION_CHANNEL error
        %when you attempt to establish a connection between a
        %configuration channel and any other channel.
        Is_Configuration_Channel
    end
    
    %% Property access methods
    methods
        %% Is_Source_Channel property access methods
        function value = get.Is_Source_Channel(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250001);
        end
        function set.Is_Source_Channel(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ChannelConfiguration.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250001, newValue);
        end
        
        %% Is_Configuration_Channel property access methods
        function value = get.Is_Configuration_Channel(obj)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.GetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName,session);
            value = attributAccessors.GetAttributeViBoolean( obj.RepCapIdentifier ,1250003);
        end
        function set.Is_Configuration_Channel(obj,newValue)
            attributAccessors = instrument.ivic.IviSwtch.Configuration.SetGetCheckAttribute.SetAttribute();
            [libName, session] = obj.getLibraryAndSession();
            attributAccessors.setLibraryAndSession(libName, session);
            import instrument.ivic.IviSwtch.ChannelConfiguration.*;
            Boolean_values.checkEnumValue(newValue );
            attributAccessors.SetAttributeViBoolean( obj.RepCapIdentifier ,1250003, newValue);
        end
    end
end
