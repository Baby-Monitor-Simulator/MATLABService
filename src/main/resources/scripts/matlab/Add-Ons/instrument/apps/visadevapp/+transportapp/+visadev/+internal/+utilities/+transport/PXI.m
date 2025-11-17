classdef PXI < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %PXI  TransportProxy class for VISA-PXI interface. Defines properties
    %that are unique to the PXI interface.

    % Copyright 2022 The MathWorks, Inc.
    
    properties (Constant, Hidden)
        ID (1, 1) string = "PXI"
    end

    properties
        Bus
        DeviceIndex
        FunctionIndex
        ChassisIndex
        Slot
    end

    methods
        function setProxyPropertyGroups(obj)
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);

            % Create property group listing for PXI properties
            g = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), "");
            g.addProperties("Bus", "DeviceIndex", "FunctionIndex", ...
                "ChassisIndex", "Slot");
            g.Expanded = true;
        end
    end
end

