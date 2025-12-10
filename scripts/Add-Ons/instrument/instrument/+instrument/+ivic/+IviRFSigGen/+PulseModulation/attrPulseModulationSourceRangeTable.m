classdef attrPulseModulationSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRPULSEMODULATIONSOURCERANGETABLE for instrument.ivic.IviRFSigGen.PulseModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % An internal pulse generator IviRFSigGenPulseGenerator Extension Group  is used for modulation.
        IVIRFSIGGEN_VAL_PULSE_MODULATION_SOURCE_INTERNAL = 1;
        % An external generator is used for modulation.
        IVIRFSIGGEN_VAL_PULSE_MODULATION_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseModulation.*
            found = ...
                ( e == attrPulseModulationSourceRangeTable.IVIRFSIGGEN_VAL_PULSE_MODULATION_SOURCE_INTERNAL) || ...
                ( e == attrPulseModulationSourceRangeTable.IVIRFSIGGEN_VAL_PULSE_MODULATION_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
