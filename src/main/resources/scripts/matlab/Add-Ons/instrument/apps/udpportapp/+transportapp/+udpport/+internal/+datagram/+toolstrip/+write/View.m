classdef View < matlabshared.transportapp.internal.toolstrip.write.View
    % VIEW is the Toolstrip Write Section View Class for datagram communication.
    % It creates all the toolstrip write section UI Elements, and contains
    % events for user interactions with these UI elements.
    % NOTE: This for the UDP App is nearly identical to the
    % Shared-App infrastructure. Any changes come from a
    % custom constants class.

    % Copyright 2021 The MathWorks, Inc.

    %% Hook Methods
    methods
        function consts = getConstants(~)
            consts = transportapp.udpport.internal.datagram.toolstrip.write.Constants;
        end
    end
end
