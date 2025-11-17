classdef (Hidden) Utility
    % UTILITY Supporting functionality for toolbox operations.
    %
    %   This class implements internal functionality required for toolbox
    %   operation. These methods are not intended for external use.
        
    % Copyright 2013 The MathWorks, Inc.
    
    
    methods (Static, Abstract)
        % FINDDEVICES Finds all the vendor devices connected.
        findDevices();
        % OPEN Opens a connection to the vendor board and returns the
        % deviceHandle to the vendor board which is guaranteed to be
        % greater than zero if valid.
        open(port);
        % CLOSE Closes the connection to the vendor board specified
        % by the deviceHandle.
        close(deviceHandle);
    end
end