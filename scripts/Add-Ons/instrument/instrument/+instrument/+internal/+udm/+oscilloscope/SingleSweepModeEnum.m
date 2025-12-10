classdef (Enumeration) SingleSweepModeEnum < handle
    %SingleSweepModeEnum Represents possible Single Sweep mode setting for oscilloscope
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        On
        Off
    end
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.oscilloscope.*
            if strcmpi (value, 'on')
                enumValue = SingleSweepModeEnum.On;
            elseif strcmpi (value, 'off')
                enumValue = SingleSweepModeEnum.Off;
            else
                error(message('instrument:oscilloscope:notValidSingleSweepMode',value ));
            end
        end
        
        function validateSingleSweepModeValue(value)
            if  ~strcmpi (value, 'on') && ~strcmpi (value, 'off')
                error(message('instrument:oscilloscope:notValidSingleSweepMode',value ));
            end
        end
        
    end
end

