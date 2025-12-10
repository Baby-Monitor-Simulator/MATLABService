classdef attrIqSourceRangeTable < instrument.internal.DriverBaseClass
    % ATTRIQSOURCERANGETABLE for instrument.ivic.IviRFSigGen.IQ class

    % Copyright 2016 The MathWorks, Inc.
    
    properties(Constant)
        % The signal generator uses the internally generated digital
        % modulation  signal to apply IQ modulation to the output RF
        % signal.
        IVIRFSIGGEN_VAL_IQ_SOURCE_DIGITAL_MODULATION_BASE = 0;
        % The signal generator uses the internally generated CDMA signal to
        % apply  IQ modulation to the output RF signal.
        IVIRFSIGGEN_VAL_IQ_SOURCE_CDMA_BASE = 1;
        % The signal generator uses the internally generated TDMA signal to
        % apply  IQ modulation to the output RF signal.
        IVIRFSIGGEN_VAL_IQ_SOURCE_TDMA_BASE = 2;
        % The signal generator uses the internally generated Arb signal to
        % apply IQ  modulation to the output RF signal.
        IVIRFSIGGEN_VAL_IQ_SOURCE_ARB_GENERATOR = 3;
        % The signal generator uses data from an external source for IQ
        % modulation.
        IVIRFSIGGEN_VAL_IQ_SOURCE_EXTERNAL = 4;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.IQ.*
            found = ...
                ( e == attrIqSourceRangeTable.IVIRFSIGGEN_VAL_IQ_SOURCE_DIGITAL_MODULATION_BASE) || ...
                ( e == attrIqSourceRangeTable.IVIRFSIGGEN_VAL_IQ_SOURCE_CDMA_BASE) || ...
                ( e == attrIqSourceRangeTable.IVIRFSIGGEN_VAL_IQ_SOURCE_TDMA_BASE) || ...
                ( e == attrIqSourceRangeTable.IVIRFSIGGEN_VAL_IQ_SOURCE_ARB_GENERATOR) || ...
                ( e == attrIqSourceRangeTable.IVIRFSIGGEN_VAL_IQ_SOURCE_EXTERNAL);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
