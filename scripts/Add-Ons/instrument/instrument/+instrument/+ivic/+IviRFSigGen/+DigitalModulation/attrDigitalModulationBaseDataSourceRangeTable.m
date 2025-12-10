classdef attrDigitalModulationBaseDataSourceRangeTable < instrument.internal.DriverBaseClass
    %ATTRDIGITALMODULATIONBASEDATASOURCERANGETABLE for instrument.ivic.IviRFSigGen.DigitalModulation class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % The data from an external device connected to the instrument is used.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATA_SOURCE_EXTERNAL = 1;
        % The internal PRBS Pseudo Random Binary Sequence generator is used as  data source.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATA_SOURCE_PRBS = 2;
        % A constant bit sequence is used as data source and repeated  continuously.
        IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATASOURCE_BIT_SEQUENCE = 3;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.DigitalModulation.*
            found = ...
                ( e == attrDigitalModulationBaseDataSourceRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATA_SOURCE_EXTERNAL) || ...
                ( e == attrDigitalModulationBaseDataSourceRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATA_SOURCE_PRBS) || ...
                ( e == attrDigitalModulationBaseDataSourceRangeTable.IVIRFSIGGEN_VAL_DIGITAL_MODULATION_BASE_DATA_SOURCE_BIT_SEQ);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
