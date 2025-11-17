classdef TransportProxyFactory < transportapp.udpport.internal.common.utilities.factories.ITransportProxyFactory
    % TRANSPORTPROXYFACTORY is a factory implementing the
    % ITransportProxyFactory interface. It creates the transport proxy used
    % with datagram communication.

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

            % DatagramTransportProxy is a specialization of
            % BaseTransportProxy that provides similar functionality for
            % the underlying udp datagram transport object.
            baseTransportProxy = transportapp.udpport.internal.datagram.utilities.transport.SpecializedBaseTransportProxy( ...
                udpTransportObj, mediator);

            % Pass in the destination address and port specificed by the user in the Modal Tab.
            % If they are non-empty the respective fields will be populated in the Property Inspector.
            transportProxy = transportapp.udpport.internal.datagram.utilities.transport.TransportProxy( ...
                mediator, baseTransportProxy, ...
                transportProperties.DestinationAddress, ...
                transportProperties.DestinationPort);
        end
    end
end