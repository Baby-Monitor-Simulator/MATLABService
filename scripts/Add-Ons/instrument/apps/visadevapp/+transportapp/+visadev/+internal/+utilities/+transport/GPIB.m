classdef GPIB < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %GPIB TransportProxy class for VISA-GPIB interface. Defines properties
    %that are unique to the GPIB interface.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant, Hidden)
        ID (1, 1) string = "GPIB"
    end

    properties
        BoardIndex
        PrimaryAddress
        SecondaryAddress
    end
    
    methods
        function setProxyPropertyGroups(obj)
            % Invoke superclass method
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);

            % Create property group listing for GPIB properties

            gpibGroup = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), "");
            gpibGroup.addProperties("BoardIndex", "PrimaryAddress", "SecondaryAddress");
            gpibGroup.Expanded = true;
        end
    end
end