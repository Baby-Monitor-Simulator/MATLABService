classdef TCPIP < transportapp.visadev.internal.utilities.transport.VisadevBaseTransport ...
        & transportapp.visadev.internal.utilities.transport.EOIModeMixin
    %TCPIP  TransportProxy class for VISA-TCPIP interface. Defines properties
    %that are unique to TCP/IP VXI-11 and HiSLIP interfaces.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant, Hidden)
        ID (1, 1) string = "TCPIP"
    end

    properties
        LANName internal.matlab.editorconverters.datatype.StringEnumeration
        InstrumentAddress internal.matlab.editorconverters.datatype.StringEnumeration
        BoardIndex
    end

    %Invoke the setPropertyGroups Hook method
    methods
        function setProxyPropertyGroups(obj)
            % Invoke superclass method
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.VisadevBaseTransport(obj);
            setProxyPropertyGroups@transportapp.visadev.internal.utilities.transport.EOIModeMixin(obj);
            
            % Create property group listing for TCP/IP properties
            g = obj.createGroup(obj.getGroupID(obj.ID), obj.getGroupName(obj.ID), "");
            g.addProperties("LANName", "InstrumentAddress", "BoardIndex");
            g.Expanded = true;
        end
    end
end