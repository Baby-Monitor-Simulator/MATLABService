classdef IviSwtch < instrument.ivicom.IviSwtchSpecification
    %IVISWITCH IVI Switch class-compliant interface stub

    % Copyright 2015 The MathWorks, Inc.

    % Constructor
    methods
        function obj = IviSwtch(id)
            error(message('instrument:ivicom:no64bitMATLABSupport'));   
        end % constructor
    end % method block
end
