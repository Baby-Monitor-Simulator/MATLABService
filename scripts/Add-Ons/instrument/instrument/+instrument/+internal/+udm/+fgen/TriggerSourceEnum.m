classdef TriggerSourceEnum < uint32
    %TriggerSourceEnum Represents possible Trigger Source for function
    %generator.
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        External (1)
        Software (2)
        Internal (3)
        TTL0 (111)
        TTL1 (112)
        TTL2 (113)
        TTL3(114 )
        TTL4(115 )
        TTL5(116 )
        TTL6(117 )
        TTL7(118 )
        ecl0(119 )
        ecl1(120 )
        pxistar (131 )
        rtsi0(141 )
        rtsi1(142 )
        rtsi2(143 )
        rtsi3(144 )
        rtsi4(145 )
        rtsi5(146 )
        rtsi6(147 )
        
    end
    
    
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.fgen.*
            if strcmpi (value, 'External')
                enumValue = TriggerSourceEnum.External;
            elseif strcmpi (value, 'Software')
                enumValue = TriggerSourceEnum.Software;
            elseif strcmpi (value, 'Internal')
                enumValue = TriggerSourceEnum.Internal;
            elseif strcmpi (value, 'TTL0')
                enumValue = TriggerSourceEnum.TTL0;
            elseif strcmpi (value, 'TTL1')
                enumValue = TriggerSourceEnum.TTL1;
            elseif strcmpi (value, 'TTL2')
                enumValue = TriggerSourceEnum.TTL2;
            elseif strcmpi (value, 'TTL3')
                enumValue = TriggerSourceEnum.TTL3;
            elseif strcmpi (value, 'TTL4')
                enumValue = TriggerSourceEnum.TTL4;
            elseif strcmpi (value, 'TTL5')
                enumValue = TriggerSourceEnum.TTL5;
            elseif strcmpi (value, 'TTL6')
                enumValue = TriggerSourceEnum.TTL6;
            elseif strcmpi (value, 'TTL7')
                enumValue = TriggerSourceEnum.TTL7;
            elseif strcmpi (value, 'ecl0')
                enumValue = TriggerSourceEnum.ecl0;
            elseif strcmpi (value, 'ecl1')
                enumValue = TriggerSourceEnum.ecl1;
            elseif strcmpi (value, 'pxistar')
                enumValue = TriggerSourceEnum.pxistar;
            elseif strcmpi (value, 'rtsi0')
                enumValue = TriggerSourceEnum.rtsi0;
            elseif strcmpi (value, 'rtsi1')
                enumValue = TriggerSourceEnum.rtsi1;
            elseif strcmpi (value, 'rtsi2')
                enumValue = TriggerSourceEnum.rtsi2;
            elseif strcmpi (value, 'rtsi3')
                enumValue = TriggerSourceEnum.rtsi3;
            elseif strcmpi (value, 'rtsi4')
                enumValue = TriggerSourceEnum.rtsi4;
            elseif strcmpi (value, 'rtsi5')
                enumValue = TriggerSourceEnum.rtsi5;
            elseif strcmpi (value, 'rtsi6')
                enumValue = TriggerSourceEnum.rtsi6;
            else
                error(message('instrument:fgen:notValidTriggerSource',value ));
            end
        end
        
        
        
        function stringValue = getString (enumValue)
            import instrument.internal.udm.fgen.*
            if  enumValue == TriggerSourceEnum.External
                stringValue = 'External';
            elseif enumValue ==TriggerSourceEnum.Software
                stringValue = 'Software';
            elseif enumValue ==TriggerSourceEnum.Internal
                stringValue = 'Internal';
            elseif enumValue == TriggerSourceEnum.TTL0
                stringValue = 'TTL0';
            elseif  enumValue == TriggerSourceEnum.TTL1
                stringValue = 'TTL1';
            elseif  enumValue == TriggerSourceEnum.TTL2
                stringValue = 'TTL2';
            elseif enumValue == TriggerSourceEnum.TTL3
                stringValue = 'TTL3';
            elseif  enumValue == TriggerSourceEnum.TTL4
                stringValue = 'TTL4';
            elseif  enumValue == TriggerSourceEnum.TTL5
                stringValue = 'TTL5';
            elseif  enumValue == TriggerSourceEnum.TTL6
                stringValue = 'TTL6';
            elseif  enumValue == TriggerSourceEnum.TTL7
                stringValue = 'TTL7';
            elseif  enumValue == TriggerSourceEnum.ecl0
                stringValue = 'ecl0';
            elseif enumValue == TriggerSourceEnum.ecl1
                stringValue = 'ecl1';
            elseif enumValue == TriggerSourceEnum.pxistar
                stringValue = 'pxistar';
            elseif enumValue == TriggerSourceEnum.rtsi0
                stringValue = 'rtsi0';
            elseif enumValue == TriggerSourceEnum.rtsi1
                stringValue = 'rtsi1';
            elseif  enumValue == TriggerSourceEnum.rtsi2
                stringValue = 'rtsi2';
            elseif enumValue == TriggerSourceEnum.rtsi3
                stringValue = 'rtsi3';
            elseif  enumValue == TriggerSourceEnum.rtsi4
                stringValue = 'rtsi4';
            elseif enumValue == TriggerSourceEnum.rtsi5
                stringValue = 'rtsi5';
            elseif enumValue == TriggerSourceEnum.rtsi6
                stringValue = 'rtsi6';
            else
                error(message('instrument:fgen:unknownTriggerSource' ));
            end
        end
        
        
    end
end

