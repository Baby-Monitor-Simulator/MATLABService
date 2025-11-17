classdef RepeatedCapability
    %REPEATEDCAPABILITY base class for all IVI-COM repeated capabilities stub

    % Copyright 2008-2015 The MathWorks, Inc.

    % Constructor
    methods
        function obj = RepeatedCapability(varargin)
            error(message('instrument:ivicom:no64bitMATLABSupport'));
        end % constructor
    end % method block
end
