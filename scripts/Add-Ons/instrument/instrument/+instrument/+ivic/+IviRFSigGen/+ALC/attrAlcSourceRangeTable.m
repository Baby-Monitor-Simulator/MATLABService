classdef attrAlcSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRALCSOURCERANGETABLE for instrument.ivic.IviRFSigGen.ALC class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The ALC is controlled by an internal measurement source.
        IVIRFSIGGEN_VAL_ALC_SOURCE_INTERNAL = 1;
        % The ALC is controlled by an external voltage.
        IVIRFSIGGEN_VAL_ALC_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.ALC.*
            found = ...
                ( e == attrAlcSourceRangeTable.IVIRFSIGGEN_VAL_ALC_SOURCE_INTERNAL) || ...
                ( e == attrAlcSourceRangeTable.IVIRFSIGGEN_VAL_ALC_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
