classdef (Enumeration) ConnectionStatus 
    % CONNECTIONSTATUS Represents the possible connection states of an
    % interface object
    
    % Copyright 2013 The MathWorks, Inc.
    
    enumeration
        % Connected - In this state the interface object is connected to the
        % device
        Connected
        % Disconnected - In this state the interface object is disconnected
        % from the device
        Disconnected
    end  
end

