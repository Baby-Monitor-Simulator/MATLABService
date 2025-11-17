classdef (Abstract) ITransportProxyFactory
    % ITRANSPORTPROXYFACTORY is the interface that all TransportProxyFactory
    % classes need to implement. A class implementing
    % ITransportProxyFactory provides a factory method for creating
    % TransportProxies.

    % Copyright 2021 The MathWorks, Inc.

    methods(Abstract, Static)
        transportProxy = createTransportProxy(mediator, transportProperties, transportParameters)
    end
end
