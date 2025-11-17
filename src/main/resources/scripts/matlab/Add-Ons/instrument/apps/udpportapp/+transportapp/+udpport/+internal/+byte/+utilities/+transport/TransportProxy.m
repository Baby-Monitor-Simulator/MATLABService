classdef TransportProxy < transportapp.udpport.internal.common.utilities.transport.SharedTransportProxy
    % TRANSPORTPROXY is the transport proxy used when
    % byte communication is used with the UDP App.
    % Contains functionality for the following UDP Byte properties:
    %   -Terminator
    %   -NumBytesAvailable

    % Copyright 2021 The MathWorks, Inc.

    properties(Dependent, SetObservable)
        % Terminator is a TerminatorClass which holds the writeline and
        % readline values that terminate the written/read strings.
        Terminator
    end

    properties(Dependent, SetObservable, SetAccess = private)
        % NumBytesAvailable is the number of bytes available to
        % read by the UDP object.
        NumBytesAvailable
    end

    %% Getters amd Setters
    methods
        % Getters
        function val = get.NumBytesAvailable(obj)
            val = obj.TransportProxy.NumBytesAvailable;
        end

        function val = get.Terminator(obj)
            val = obj.TransportProxy.Terminator;
        end

        % Setters
        function set.Terminator(obj, inspectorValue)
            obj.TransportProxy.Terminator = inspectorValue;
        end
    end

    %% Abstract Method Implementation
    methods
        function setProxyPropertyGroups(obj)
            setProxyPropertyGroups@transportapp.udpport.internal.common.utilities.transport.SharedTransportProxy(obj);

            % Get the "communication" group
            groups = obj.getGroups();
            commGroup = groups(2);

            % Add the Terminator and NumBytesAvailable fields.
            commGroup.addEditorGroup("Terminator");
            commGroup.addProperties("NumBytesAvailable");
        end
    end
end