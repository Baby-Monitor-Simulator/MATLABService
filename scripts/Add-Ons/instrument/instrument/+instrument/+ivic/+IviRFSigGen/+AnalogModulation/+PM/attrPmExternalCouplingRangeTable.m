classdef attrPmExternalCouplingRangeTable < instrument.internal.DriverBaseClass
    %ATTRPMEXTERNALCOUPLINGRANGETABLE for instrument.ivic.IviRFSigGen.AnalogModulation.PM class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The external source is coupled for AC only.
        IVIRFSIGGEN_VAL_PM_EXTERNAL_COUPLING_AC = 1;
        % The external source is coupled for both DC and AC.
        IVIRFSIGGEN_VAL_PM_EXTERNAL_COUPLING_DC = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.AnalogModulation.PM.*
            found = ...
                ( e == attrPmExternalCouplingRangeTable.IVIRFSIGGEN_VAL_PM_EXTERNAL_COUPLING_AC) || ...
                ( e == attrPmExternalCouplingRangeTable.IVIRFSIGGEN_VAL_PM_EXTERNAL_COUPLING_DC);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
