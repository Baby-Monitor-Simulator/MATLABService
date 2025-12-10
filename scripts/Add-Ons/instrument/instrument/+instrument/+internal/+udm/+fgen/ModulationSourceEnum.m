classdef ModulationSourceEnum < uint32
    %ModulationSourceEnum represents possible modulation source setting for function
    %generator.
    
    % Copyright 2011 The MathWorks, Inc.
    
    enumeration
        Internal (0)
        External (1)
        
    end
    
    methods (Static)
        
        function enumValue = getEnum(value)
            import instrument.internal.udm.fgen.*
            if strcmpi (value, 'Internal')
                enumValue = ModulationSourceEnum.Internal;
            elseif strcmpi (value, 'External')
                enumValue = ModulationSourceEnum.External;
            else
                error(message('instrument:fgen:notValidModulationSource',value ));
            end
        end
        
        
        function stringValue = getString (value)
            import instrument.internal.udm.fgen.*
            if  value == ModulationSourceEnum.Internal
                stringValue = 'Internal';
            elseif value == ModulationSourceEnum.External
                stringValue = 'External';
            else
                error(message('instrument:fgen:unknownModulationSource' ));
            end
        end
        
    end
end

