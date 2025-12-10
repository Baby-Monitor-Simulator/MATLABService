classdef View < matlabshared.transportapp.internal.toolstrip.read.View
    % VIEW is the Toolstrip Read Section View Class. It creates all the
    % toolstrip read section UI Elements, and contains events for user
    % interactions with these UI elements.

    % Copyright 2021 The MathWorks, Inc.

    methods (Access = protected)
        function consts = getConstants(~)
            consts = transportapp.udpport.internal.datagram.toolstrip.read.Constants;
        end
    end
end