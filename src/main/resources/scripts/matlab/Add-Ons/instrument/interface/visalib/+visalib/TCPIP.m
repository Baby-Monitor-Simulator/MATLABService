classdef TCPIP < visalib.Resource & visalib.EOIModeSupport
    %TCPIP Class representing a VISA TCPIP instrument resource
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % Board number for the interface
        BoardIndex (1, 1) double = 0
        
        % The LAN device name used by the VXI-11 or HiSLIP protocol during
        % connection
        LANName (1, 1) string = "inst0"
        
        % TCP/IP Address of the instrument (formatted in dot-notation).
        InstrumentAddress (1, 1) string = "169.254.2.20"
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

    properties (Access = private)
        IsHiSLIP (1, 1) logical
    end
   
    methods (Hidden)
        function obj = TCPIP(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.tcpip);
            obj@visalib.Resource(resourceInfo, synchronousRead);
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
            attrBoardIndex = visalib.internal.VISAAttribute.INTF_NUM;
            attrDeviceName = visalib.internal.VISAAttribute.TCPIP_DEVICE_NAME;
            attrAddress = visalib.internal.VISAAttribute.TCPIP_ADDR;

            attrIsHiSLIP = visalib.internal.VISAAttribute.TCPIP_IS_HISLIP;

            obj.BoardIndex = obj.getAttributeByType(attrBoardIndex);
            obj.LANName = obj.getAttributeByType(attrDeviceName);
            obj.InstrumentAddress = obj.getAttributeByType(attrAddress);
            obj.IsHiSLIP = obj.getAttributeByType(attrIsHiSLIP);

            % HiSLIP does not support setting VI_ATTR_SUPPRESS_END_EN
            obj.CheckSuppressEndIndicator = ~obj.IsHiSLIP;
        end

        function postConnectHook(obj)
             obj.EOIMode = matlab.lang.OnOffSwitchState.on;
             obj.configureTerminator("off", "LF");
        end

        function adjustGroupListHook(obj)
            obj.InterfaceSpecificProperties = ["LANName", "InstrumentAddress"];
            obj.SupplementalInterfaceProperties = "BoardIndex";
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