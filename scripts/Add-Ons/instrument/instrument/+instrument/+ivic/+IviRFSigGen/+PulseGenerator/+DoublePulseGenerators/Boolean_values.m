classdef Boolean_values < instrument.internal.DriverBaseClass
    %BOOLEAN_VALUES for instrument.ivic.IviRFSigGen.PulseGenerator.DoublePulseGenerators class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % True
        VI_TRUE = 1;
        % False
        VI_FALSE = 0;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviRFSigGen.PulseGenerator.DoublePulseGenerators.*
            found = ...
                ( e == Boolean_values.VI_TRUE) || ...
                ( e == Boolean_values.VI_FALSE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
