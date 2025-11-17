classdef (Hidden) IviDriverBase
    %IVIDRIVERBASE IVI Driver root interface stub
    
    % Copyright 2008-2015 The MathWorks, Inc.
    
    %% Construction/Clean up
    methods
        function obj = IviDriverBase(identifier,interfaceName)
            error(message('instrument:ivicom:no64bitMATLABSupport'));            
        end
    end
end
