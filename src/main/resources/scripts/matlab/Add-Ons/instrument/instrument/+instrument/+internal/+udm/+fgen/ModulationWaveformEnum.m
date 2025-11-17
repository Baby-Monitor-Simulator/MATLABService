classdef ModulationWaveformEnum < uint32
    %ModulationWaveformEnum Represents possible modulation waveform setting
    %for function generator.
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        Sine (1)
        Square (2)
        Triangle(3)
        RampUp (4)
        RampDown (5)
    end
    
    
 
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.fgen.*
            if strcmpi (value, 'Sine')
                enumValue = WaveformEnum.Sine;
            elseif strcmpi (value, 'Square')
                enumValue = WaveformEnum.Square;
            elseif strcmpi (value, 'Triangle')
                enumValue = WaveformEnum.Triangle;
            elseif strcmpi (value, 'RampUp')
                enumValue = WaveformEnum.RampUp;
            elseif strcmpi (value, 'RampDown')
                enumValue = WaveformEnum.RampDown;
            else
                 error(message('instrument:fgen:notValidModulationWaveform',value ));
            end
        end
        
        function stringValue = getString (value)
             import instrument.internal.udm.fgen.*
            if  value == WaveformEnum.Sine
                stringValue = 'Sine';
            elseif value ==WaveformEnum.Square  
                stringValue = 'Square';
            elseif value ==WaveformEnum.Triangle  
                 stringValue = 'Triangle';
            elseif value ==WaveformEnum.RampUp  
                stringValue = 'RampUp';
            elseif value ==WaveformEnum.RampDown  
                 stringValue = 'RampDown';
            else
                 error(message('instrument:fgen:unknownModulationWaveform' ));
            end
        end
        

    end
end

