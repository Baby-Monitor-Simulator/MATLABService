function isConnectFailed = connectFailedMATLABTarget(err)
    % Given an exception 'err', check if the UDPByte connect failed
    % during MATLAB execution.
    %#codegen 
    
    % Copyright 2023 The MathWorks, Inc.

    isConnectFailed = err.identifier == "network:udp:connectFailed" && contains(err.message, "Only UDP object with initAccess (first instance) can control underlying socking options (Multicast/Broadcast/PortSharing)");
end