classdef IQSourceEnum < uint32
    % IQSOURCEENUM Represents possible trigger sources for RF signal
    % generator.
    
    % Copyright 2016-2017 The MathWorks, Inc.
    
    enumeration
        DigitalModulation (0)
        CDMA              (1)
        TDMA              (2)
        ArbGenerator      (3)
        External          (4)
    end
    
    
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.rfsiggen.*
            if strcmpi (value, 'DigitalModulation')
                enumValue = IQSourceEnum.DigitalModulation;
            elseif strcmpi (value, 'CDMA')
                enumValue = IQSourceEnum.CDMA;
            elseif strcmpi (value, 'TDMA')
                enumValue = IQSourceEnum.TDMA;
            elseif strcmpi (value, 'ArbGenerator')
                enumValue = IQSourceEnum.ArbGenerator;
            elseif strcmpi (value, 'External')
                enumValue = IQSourceEnum.External;
            else
                error(message('instrument:rfsiggen:notValidIQSource'));
            end
        end
        
        
        
        function stringValue = getString (enumValue)
            import instrument.internal.udm.rfsiggen.*
            if  enumValue == IQSourceEnum.DigitalModulation
                stringValue = 'DigitalModulation';
            elseif enumValue ==IQSourceEnum.CDMA
                stringValue = 'CDMA';
            elseif enumValue ==IQSourceEnum.TDMA
                stringValue = 'TDMA';
            elseif enumValue == IQSourceEnum.ArbGenerator
                stringValue = 'ArbGenerator';
            elseif  enumValue == IQSourceEnum.External
                stringValue = 'External';
            else
                error(message('instrument:rfsiggen:notValidIQSource'));
            end
        end
        
        
    end
end

