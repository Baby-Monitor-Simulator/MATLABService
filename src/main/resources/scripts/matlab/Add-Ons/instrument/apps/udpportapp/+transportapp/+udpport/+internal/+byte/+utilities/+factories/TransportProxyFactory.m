classdef TransportProxyFactory < transportapp.udpport.internal.common.utilities.factories.ITransportProxyFactory
    % TRANSPORTPROXYFACTORY is a factory implementing the
    % ITransportProxyFactory interface. It creates the transport proxy used
    % with byte communication.

    % Copyright 2021 The MathWorks, Inc.

    methods(Access=private)
        function obj = TransportProxyFactory()
        end
    end

    %% Abstract Method Implementation
    methods(Static)
        function transportProxy = createTransportProxy(mediator, transportProperties, transportParams)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                transportProperties
                transportParams cell
            end

            % Create the transport object used within the app. Parameters
            % are derived from the original transportProperties struct.
            udpTransportObj = udpport(transportParams{:});

            % Provides the byte TransportProxy with Shared-App properties
            % (e.g. timeout, byteOrder, terminator).
            baseTransportProxy = matlabshared.transportapp.internal.utilities.transport.BaseTransportProxy( ...
                udpTransportObj, mediator);

            % Pass in the destination address and port specified by the user in the Modal Tab.
            % If they are non-empty their respective fields will be populated by the Property Inspector.
            transportProxy = transportapp.udpport.internal.byte.utilities.transport.TransportProxy( ...
                mediator, baseTransportProxy, ...
                transportProperties.DestinationAddress, ...
                transportProperties.DestinationPort);
        end
    end
end
