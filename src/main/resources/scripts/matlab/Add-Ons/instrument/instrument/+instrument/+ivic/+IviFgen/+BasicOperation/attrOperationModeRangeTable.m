classdef attrOperationModeRangeTable < instrument.internal.DriverBaseClass
    %ATTROPERATIONMODERANGETABLE for instrument.ivic.IviFgen.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the function generator to generate output continuously.
        IVIFGEN_VAL_OPERATE_CONTINUOUS = 0;
        % Configures the function generator to generate a burst of waveform cycles.
        IVIFGEN_VAL_OPERATE_BURST = 1;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.BasicOperation.*
            found = ...
                ( e == attrOperationModeRangeTable.IVIFGEN_VAL_OPERATE_CONTINUOUS) || ...
                ( e == attrOperationModeRangeTable.IVIFGEN_VAL_OPERATE_BURST);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
