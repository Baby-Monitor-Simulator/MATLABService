classdef ArbTriggerSourceEnum < uint32
    % ARBTRIGGERSOURCEENUM Represents possible ARB Generator Trigger Source
    % for RF signal generator.
    
    % Copyright 2016-2017 The MathWorks, Inc.
    
    enumeration
        Immediate (0)
        External  (1)
        Software  (2)
    end
    
    
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.rfsiggen.*
            if strcmpi (value, 'Immediate')
                enumValue = ArbTriggerSourceEnum.Immediate;
            elseif strcmpi (value, 'External')
                enumValue = ArbTriggerSourceEnum.External;
            elseif strcmpi (value, 'Software')
                enumValue = ArbTriggerSourceEnum.Software;
            else
                error(message('instrument:rfsiggen:notValidArbTriggerSource'));
            end
        end
        
        
        
        function stringValue = getString (enumValue)
            import instrument.internal.udm.rfsiggen.*
            if  enumValue == ArbTriggerSourceEnum.Immediate
                stringValue = 'Immediate';
            elseif enumValue ==ArbTriggerSourceEnum.External
                stringValue = 'External';
            elseif enumValue ==ArbTriggerSourceEnum.Software
                stringValue = 'Software';
            else
                error(message('instrument:rfsiggen:notValidArbTriggerSource' ));
            end
        end
        
        
    end
end