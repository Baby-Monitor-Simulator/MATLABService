classdef EventHandler < matlabshared.transportlib.internal.client.IEventHandler
    %EVENTHANDLER class receives the TCP/IP client connection and disconnection
    % events from the tcpserver Device Plugin and forwards them to the
    % TCPServer class. It also contains the helper functions that are invoked
    % during an AsyncIO asynchronous event, like data being written to the
    % AsyncIO Channel and data being available to be read from the
    % channel. It also handles other custom events like custom error calls
    % from the AsyncIO Channel.

    % Copyright 2020 The MathWorks, Inc.

    properties (Dependent)
        Transport
    end

    properties (Access = private)
        % The EventHandler from the shared interface
        SharedEventHandler
    end

    events
        % The connection/disconnection event that TCPServerCustomClient
        % listens for.
        ConnectionInfo
    end

    %% Getters
    methods
        function value = get.Transport(obj)
            value = obj.SharedEventHandler.Transport;
        end
    end

    %% Lifetime
    methods
        function obj = EventHandler
            obj.SharedEventHandler = matlabshared.transportlib.internal.client.EventHandler;
        end
    end

    %% API
    methods
        function setTransport(obj,transport)
            % Set the Transport to the instance of GenericTransport.
            setTransport(obj.SharedEventHandler,transport);
        end
    end

    %% Callback Functions
    methods
        function onDataReceived(obj,~,~)
            % Callback function that gets fired when data is available to be
            % read on the AsyncIO Channel's input buffer.
            onDataReceived(obj.SharedEventHandler);
        end

        function onDataWritten(obj,~,~)
            % Callback function that gets fired when data is written to the
            % AsyncIO Channel
            onDataWritten(obj.SharedEventHandler);
        end

        function handleCustomEvent(obj,~,eventData)
            % Callback function that gets fired for TCP/IP client-server
            % connection/disconnection events and error events received
            % from the AsyncIO plug-in, such as a lost connection.

            switch string(eventData.Type)
                case "ConnectionRemoved"
                    % Event type that describes a client-server
                    % disconnection event.
                    notify(obj,'ConnectionInfo',tcpserver.internal.ConnectionInfo("",[],false));
                case "ConnectionAdded"
                    % Event type that describes a client-server
                    % connection event.
                    notify(obj,'ConnectionInfo',tcpserver.internal. ...
                           ConnectionInfo(eventData.Data.Address,eventData.Data.Port,true));
                otherwise
                    % Handles other event types such as asynchronous errors
                    % events thrown from the AsyncIO plug-in.
                    handleCustomEvent(obj.SharedEventHandler,[],eventData);
            end
        end
    end
end