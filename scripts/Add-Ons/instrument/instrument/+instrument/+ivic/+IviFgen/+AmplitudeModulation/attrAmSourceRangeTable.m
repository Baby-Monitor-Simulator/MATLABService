classdef attrAmSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRAMSOURCERANGETABLE for instrument.ivic.IviFgen.AmplitudeModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Internal AM Modulating Source.
        IVIFGEN_VAL_AM_INTERNAL = 0;
        % External AM Modulating Source.
        IVIFGEN_VAL_AM_EXTERNAL = 1;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviFgen.AmplitudeModulation.*
            found = ...
                ( e == attrAmSourceRangeTable.IVIFGEN_VAL_AM_INTERNAL) || ...
                ( e == attrAmSourceRangeTable.IVIFGEN_VAL_AM_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
