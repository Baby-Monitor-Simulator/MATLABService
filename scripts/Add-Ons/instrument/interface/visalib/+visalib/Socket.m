classdef Socket < visalib.Resource & visalib.EOIModeSupport
    %Socket Class representing a VISA TCPIP socket resource
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % TCP/IP Address of the socket to which the session is connected in
        % dot-format
        IPAddress (1, 1) string = "1.2.3.4"
        
        % Port number for the given TCP/IP address
        Port (1, 1) double = "999"
    end
    
    properties (Hidden)
        % Request that a TCP/IP provider enable the use of "keep-alive"
        % packets on the connection
        KeepAlive (1, 1) matlab.lang.OnOffSwitchState = "off"

        % When disabled ("off"), enable buffering data (until a full-size
        % packet can be sent); by default, this attribute is enabled in
        % VISA (so as to ensure that immediate writes)
        NoDelay (1, 1) matlab.lang.OnOffSwitchState = "on"
    end    
   
    methods (Hidden)
        function obj = Socket(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.socket);
            obj@visalib.Resource(resourceInfo, synchronousRead);
            obj.ResourceClass = "SOCKET";
        end
    end
    
    %% Getters and Setters
    methods
        function set.KeepAlive(obj, value)
            attribute = visalib.internal.VISAUnclassifiedAttribute.VI_ATTR_TCPIP_KEEPALIVE;
            obj.setUnclassifiedAttributeByType(attribute, value);

            obj.KeepAlive = obj.getUnclassifiedAttributeByType(attribute);
        end

        function set.NoDelay(obj, value)
            attribute = visalib.internal.VISAUnclassifiedAttribute.VI_ATTR_TCPIP_NODELAY;
            obj.setUnclassifiedAttributeByType(attribute, value);

            obj.NoDelay = obj.getUnclassifiedAttributeByType(attribute);
        end        
    end

    %% VISA methods 
    
    %% Overridden methods
    methods (Access = protected)
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.
            attrAddress = visalib.internal.VISAAttribute.TCPIP_ADDR;
            attrPort = visalib.internal.VISAAttribute.TCPIP_PORT;

            obj.IPAddress = obj.getAttributeByType(attrAddress);
            obj.Port = obj.getAttributeByType(attrPort);
        end

        function postConnectHook(obj)
            obj.setSuppressEndEnabled(false);
            obj.setTermCharEnabled(true);
        end

        function adjustGroupListHook(obj)
            obj.InterfaceSpecificProperties = ["IPAddress", "Port"];
            obj.SharedProperties(end+1) = "EOIMode";
        end
    end

    %%% EOIMode
    methods (Access = protected)
        function valueOut = setAndReturnAttribute(obj, attribute, valueIn)
            valueOut = obj.setAndVerifyAttributeValue(attribute, valueIn);
        end
    end
end