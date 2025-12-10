classdef TransportProxy < transportapp.udpport.internal.common.utilities.transport.SharedTransportProxy
    % TRANSPORTPROXY is the transport proxy used when
    % datagram communication is used with the UDP App.
    % Contains functionality for the following UDP Datagram properties:
    %   -NumDatagramsAvailable

    % Copyright 2021 The MathWorks, Inc.

    properties(Dependent, SetObservable, SetAccess = private)
        % NumDatagramsAvailable is the number of datagrams available to
        % read by the UDP object.
        NumDatagramsAvailable
    end

    %% Getters and Setters
    methods
        function val = get.NumDatagramsAvailable(obj)
            val = obj.TransportProxy.NumDatagramsAvailable;
        end
    end

    %% Abstract Method Implementation
    methods
        function setProxyPropertyGroups(obj)
            setProxyPropertyGroups@transportapp.udpport.internal.common.utilities.transport.SharedTransportProxy(obj);

            % Get the "communication" group
            groups = obj.getGroups();
            commGroup = groups(2);

            % Add NumDatagramsAvailable field to the property inspector.
            commGroup.addProperties("NumDatagramsAvailable");
        end
    end
end