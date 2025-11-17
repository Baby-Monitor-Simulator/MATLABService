classdef VXI < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %VXI  TransportProxy class for VISA-VXI interface. Defines properties
    %that are unique to the VXI interface.

    % Copyright 2022 The MathWorks, Inc.
    
    properties (Constant, Hidden)
        ID (1, 1) string = "VXI"
    end

    properties
        LogicalAddress
        ChassisIndex
        Slot
    end

    methods
        function setProxyPropertyGroups(obj)
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);

            % Create property group listing for VXI properties
            g = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), "");
            g.addProperties("LogicalAddress", "ChassisIndex", "Slot");
            g.Expanded = true;
        end
    end
end