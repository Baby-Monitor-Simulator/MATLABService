classdef IviCounter
    %IVICOUNTER IVI Counter class-compliant interface stub

    % Copyright 2015 The MathWorks, Inc.

    % Constructor
    methods
        function obj = IviCounter(id)
            error(message('instrument:ivicom:no64bitMATLABSupport'));
        end % constructor
    end % method block
end
