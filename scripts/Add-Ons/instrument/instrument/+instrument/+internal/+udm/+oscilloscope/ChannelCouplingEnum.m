classdef (Enumeration) ChannelCouplingEnum < handle
    %ChannelCouplingEnum Represents possible channel coupling setting for oscilloscope
    
    % Copyright 2011-2013 The MathWorks, Inc.
    
    enumeration
        AC
        DC
        GND
    end
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.oscilloscope.*;
            if strcmpi (value, 'AC')
                enumValue = ChannelCouplingEnum.AC;
            elseif strcmpi (value, 'DC')
                enumValue = ChannelCouplingEnum.DC;
            else 
                enumValue = ChannelCouplingEnum.GND;
            end
        end
        
        function validateChannelCouplingValue(value)
            if  ~strcmpi (value, 'AC') && ~strcmpi (value, 'DC') && ~strcmpi (value, 'GND')
                error(message('instrument:oscilloscope:notValidVerticalCoupling',value ));
            end
        end
        
    end
end

% LocalWords:  GND
