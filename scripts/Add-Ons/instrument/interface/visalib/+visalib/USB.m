classdef USB < visalib.Resource & visalib.EOIModeSupport
    %USB Class representing a VISA USB instrument resource
    
    % Copyright 2020-2023 The MathWorks, Inc.
    
    properties (SetAccess = private)
        % Manufacturer identification number of the device (for USB, this
        % is the VID)
        VendorID (1, 1) string = "0x1234"
        
        % Model code of the device (for USB, this is the PID)
        ProductID (1, 1) string = "0x5678"
        
        % Board number for the interface        
        BoardIndex (1, 1) double = 0
        
        % The USB interface number of the instrument to which the session
        % is connected
        InterfaceIndex (1, 1) double = 0
    end
    
   
    methods (Hidden)
        function obj = USB(resourceInfo, synchronousRead)
            visalib.Resource.checkResourceType(resourceInfo.Type, visalib.InterfaceType.usb);
            obj@visalib.Resource(resourceInfo, synchronousRead);
        end
    end
    
    %% Overridden methods
    methods (Access = protected)
        function initResourceHook(obj)
            % Initialize properties prior to asking the client to connect.
            attrVendorID = visalib.internal.VISAAttribute.MANF_ID;
            attrProductID = visalib.internal.VISAAttribute.MODEL_CODE;
            attrBoardIndex = visalib.internal.VISAAttribute.INTF_NUM;
            attrInterfaceIndex = visalib.internal.VISAAttribute.USB_INTFC_NUM;
            
            obj.VendorID = compose("%#x", obj.getAttributeByType(attrVendorID));
            obj.ProductID = compose("%#x", obj.getAttributeByType(attrProductID));
            obj.BoardIndex = obj.getAttributeByType(attrBoardIndex);
            obj.InterfaceIndex = obj.getAttributeByType(attrInterfaceIndex);            
        end 

        function postConnectHook(obj)
            obj.EOIMode = matlab.lang.OnOffSwitchState.on;
            obj.configureTerminator("off", "LF");
        end

        function adjustGroupListHook(obj)
            obj.SupplementalIDProperties = ["Type", "PreferredVisa"];

            obj.SupplementalInterfaceProperties = ...
                [ "VendorID", "ProductID", "SerialNumber",...
                "BoardIndex", "InterfaceIndex"];

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
