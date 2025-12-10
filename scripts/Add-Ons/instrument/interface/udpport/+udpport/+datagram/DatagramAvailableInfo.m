classdef DatagramAvailableInfo < handle
    % 'DATAGRAMAVAILABLEINFO' is used for passing custom event information
    % from the respective callback handlers to the user specified callback
    % functions.

    %   Copyright 2020 The MathWorks, Inc.
    properties (SetAccess = private)
        DatagramsAvailableFcnCount
        AbsoluteTime
    end

    methods
        function data = DatagramAvailableInfo(count, absolutetime)
            data.DatagramsAvailableFcnCount = count;
            data.AbsoluteTime = absolutetime;
        end
    end
end