classdef View < matlabshared.transportapp.internal.appspace.communicationlog.View
    % VIEW is the Appspace CommunicationLogSection View Class when
    % communicating in datagram mode. It provides a custom constants class
    % to add an additional column for address and port.

    % Copyright 2021 The MathWorks, Inc.

    %% Hook Methods
    methods
        function constants = getConstants(~)
            % Override the Shared-App getConstants to provide a custom
            % constants class.
            constants = transportapp.udpport.internal.datagram.appspace.communicationlog.Constants;
        end
    end
end
