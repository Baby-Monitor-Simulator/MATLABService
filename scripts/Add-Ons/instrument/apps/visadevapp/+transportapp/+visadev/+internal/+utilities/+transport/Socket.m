classdef Socket < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %Socket  TransportProxy class for VISA TCPIP Socket interface. Defines
    %properties that are unique to the Socket interface.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant, Hidden)
        ID (1, 1) string = "Socket"
    end

    properties
        IPAddress internal.matlab.editorconverters.datatype.StringEnumeration
        Port
    end

    %Invoke the setPropertyGroups Hook method
    methods
        function setProxyPropertyGroups(obj)
            % Invoke superclass method
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);
            
            % Create property group listing for TCP/IP properties
            g = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), ""); 
            g.addProperties("IPAddress", "Port");
            g.Expanded = true;
        end
    end
end