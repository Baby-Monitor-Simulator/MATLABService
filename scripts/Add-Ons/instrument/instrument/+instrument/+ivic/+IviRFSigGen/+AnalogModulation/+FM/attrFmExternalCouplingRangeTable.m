classdef attrFmExternalCouplingRangeTable < instrument.internal.DriverBaseClass
    %ATTRFMEXTERNALCOUPLINGRANGETABLE for instrument.ivic.IviRFSigGen.AnalogModulation.FM class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The external source is coupled for AC only.
        IVIRFSIGGEN_VAL_FM_EXTERNAL_COUPLING_AC = 1;
        % The external source is coupled for both DC and AC.
        IVIRFSIGGEN_VAL_FM_EXTERNAL_COUPLING_DC = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.AnalogModulation.FM.*
            found = ...
                ( e == attrFmExternalCouplingRangeTable.IVIRFSIGGEN_VAL_FM_EXTERNAL_COUPLING_AC) || ...
                ( e == attrFmExternalCouplingRangeTable.IVIRFSIGGEN_VAL_FM_EXTERNAL_COUPLING_DC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
