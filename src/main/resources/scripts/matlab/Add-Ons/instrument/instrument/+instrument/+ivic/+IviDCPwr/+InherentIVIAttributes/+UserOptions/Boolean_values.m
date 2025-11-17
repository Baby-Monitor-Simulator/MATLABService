classdef Boolean_values < instrument.internal.DriverBaseClass
    %BOOLEAN_VALUES for instrument.ivic.IviDCPwr.InherentIVIAttributes.UserOptions class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % True
        VI_TRUE = 1;
        % False
        VI_FALSE = 0;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviDCPwr.InherentIVIAttributes.UserOptions.*
            found = ...
                ( e == Boolean_values.VI_TRUE) || ...
                ( e == Boolean_values.VI_FALSE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
