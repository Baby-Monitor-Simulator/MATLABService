classdef IviDmm
    %IVIDMM IVI DMM class-compliant interface stub

    % Copyright 2008-2015 The MathWorks, Inc.

    % Constructor
    methods
        function obj = IviDmm(id)
            error(message('instrument:ivicom:no64bitMATLABSupport'));
        end % constructor
    end % method block
end
