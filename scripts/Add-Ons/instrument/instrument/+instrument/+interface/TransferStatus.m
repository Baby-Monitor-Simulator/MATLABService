classdef (Enumeration) TransferStatus 
    % TRANSFERSTATUS Represents the possible transfer states of an
    % interface object
    
    % Copyright 2013 The MathWorks, Inc.
    
    enumeration
        % Idle - This is the default state of the interface object
        Idle
        % Read - The interface object is performing a read from the device
        Read
        % Write - The interface object is performing a write to the device
        Write
        % ReadWrite - The interface object is performing a full duplex read
        % and write operation with the device
        ReadWrite
    end  
end
