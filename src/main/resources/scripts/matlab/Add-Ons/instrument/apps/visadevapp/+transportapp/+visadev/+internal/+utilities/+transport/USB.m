classdef USB < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %USB  TransportProxy class for VISA-USB interface. Defines properties
    %that are unique to the USB interface.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant, Hidden)
        ID (1, 1) string = "USB"
    end

    properties
        VendorID internal.matlab.editorconverters.datatype.StringEnumeration
        ProductID internal.matlab.editorconverters.datatype.StringEnumeration
        BoardIndex
        InterfaceIndex
    end

    %Invoke the setPropertyGroups Hook method
    methods
        function setProxyPropertyGroups(obj)
            % Invoke superclass method
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);
            
            % Create property group listing for USB properties
            g = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), ""); 
            g.addProperties("VendorID", "ProductID", "BoardIndex", "InterfaceIndex");
            g.Expanded = true;
        end
    end
end