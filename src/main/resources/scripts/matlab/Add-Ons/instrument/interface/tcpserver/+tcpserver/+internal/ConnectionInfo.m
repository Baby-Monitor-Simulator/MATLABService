classdef ConnectionInfo < event.EventData & matlabshared.testmeas.internal.SetGet & ...
        matlabshared.testmeas.CustomDisplay
    %CONNECTIONINFO is the class used to store the TCP/IP client connection and
    % disconnection event information which users can query in callback functions.

    % Copyright 2020 The MathWorks, Inc.

    properties
        % The connection status of the server
        Connected (1,1) logical = false

        % The IP address of the client connected to the server
        ClientAddress (1,1) string

        % The port number of the client connected to the server
        ClientPort double = []

        % The absolute time of the connection/disconnection event
        AbsoluteTime datetime
    end

    properties (Hidden,Constant)
        DefaultPropertyDisplay = ["Connected","ClientAddress","ClientPort","AbsoluteTime"]
    end

    %% Lifetime
    methods
        function obj = ConnectionInfo(address,port,connectionStatus)
            obj.Connected = connectionStatus;
            obj.ClientAddress = address;
            obj.ClientPort = port;
            obj.AbsoluteTime = datetime;
            setCustomDisplay(obj);
        end
    end

    %% Helper Function
    methods (Access = private)
        function obj = setCustomDisplay(obj)
            % The list of properties to display under each corresponding
            % group name. The first group will be shown by default.
            obj.PropertyGroupList = {obj.DefaultPropertyDisplay};

            % The group names for the above PropertyGroupList.
            obj.PropertyGroupNames = "";

            % Do not show the "all properties" and "all methods" in the footer
            obj.ShowAllMethodsInFooter = false;
            obj.ShowAllPropertiesInFooter = false;
        end
    end
end