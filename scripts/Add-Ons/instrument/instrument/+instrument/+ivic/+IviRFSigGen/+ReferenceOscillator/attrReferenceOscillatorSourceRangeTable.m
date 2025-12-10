classdef attrReferenceOscillatorSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRREFERENCEOSCILLATORSOURCERANGETABLE for instrument.ivic.IviRFSigGen.ReferenceOscillator class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % An internal reference oscillator is used.
        IVIRFSIGGEN_VAL_REFERENCE_OSCILLATOR_SOURCE_INTERNAL = 1;
        % An external reference oscillator is used.
        IVIRFSIGGEN_VAL_REFERENCE_OSCILLATOR_SOURCE_EXTERNAL = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.ReferenceOscillator.*
            found = ...
                ( e == attrReferenceOscillatorSourceRangeTable.IVIRFSIGGEN_VAL_REFERENCE_OSCILLATOR_SOURCE_INTERNAL) || ...
                ( e == attrReferenceOscillatorSourceRangeTable.IVIRFSIGGEN_VAL_REFERENCE_OSCILLATOR_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
