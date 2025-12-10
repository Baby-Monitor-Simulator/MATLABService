classdef IviDriver
    %IVIDRIVER IVI Driver interface stub

    % Copyright 2008-2015 The MathWorks, Inc.
    
    % Constructor
    methods
        function obj = IviDriver(varargin)
            error(message('instrument:ivicom:no64bitMATLABSupport'));
        end % constructor
    end % method block
end
