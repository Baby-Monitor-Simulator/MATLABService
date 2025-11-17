classdef WaveformEnum < uint32
    %WaveformEnum represents available waveform setting for function
    %generator.
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        Sine (1)
        Square (2)
        Triangle(3)
        RampUp (4)
        RampDown (5)
        DC (6)
        Arb (7)
        None(8)
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
            elseif strcmpi (value, 'DC')
                enumValue = WaveformEnum.DC;
            elseif strcmpi (value, 'Arb')
                enumValue = WaveformEnum.Arb;
            else
                 error(message('instrument:fgen:notValidWaveform',value ));
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
            elseif value ==WaveformEnum.DC
                stringValue = 'DC';
            elseif value ==WaveformEnum.Arb
                stringValue = 'Arb';
            else
                error(message('instrument:fgen:unknownWaveform' ));
            end
        end
        
    end
end

