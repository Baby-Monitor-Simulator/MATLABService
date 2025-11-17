classdef attrOutputModeRangeTable < instrument.internal.DriverBaseClass
    %ATTROUTPUTMODERANGETABLE for instrument.ivic.IviFgen.BasicOperation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Configures the function generator to produce standard waveforms.
        IVIFGEN_VAL_OUTPUT_FUNC = 0;
        % Configures the function generator to produce arbitrary waveforms.
        IVIFGEN_VAL_OUTPUT_ARB = 1;
        % Configures the function generator to produce sequences of arbitrary  waveforms.
        IVIFGEN_VAL_OUTPUT_SEQ = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.BasicOperation.*
            found = ...
                ( e == attrOutputModeRangeTable.IVIFGEN_VAL_OUTPUT_FUNC) || ...
                ( e == attrOutputModeRangeTable.IVIFGEN_VAL_OUTPUT_ARB) || ...
                ( e == attrOutputModeRangeTable.IVIFGEN_VAL_OUTPUT_SEQ);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
