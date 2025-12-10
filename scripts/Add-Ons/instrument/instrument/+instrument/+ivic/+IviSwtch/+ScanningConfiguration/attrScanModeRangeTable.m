classdef attrScanModeRangeTable < instrument.internal.DriverBaseClass
    %ATTRSCANMODERANGETABLE for instrument.ivic.IviSwtch.ScanningConfiguration class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % No implicit action on connections when scanning
        IVISWTCH_VAL_NONE = 0;
        % When scanning, the switch module breaks existing connections before  making new connections.
        IVISWTCH_VAL_BREAK_BEFORE_MAKE = 1;
        % When scanning, the switch module breaks existing connections after  making new connections.
        IVISWTCH_VAL_BREAK_AFTER_MAKE = 2;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviSwtch.ScanningConfiguration.*
            found = ...
                ( e == attrScanModeRangeTable.IVISWTCH_VAL_NONE) || ...
                ( e == attrScanModeRangeTable.IVISWTCH_VAL_BREAK_BEFORE_MAKE) || ...
                ( e == attrScanModeRangeTable.IVISWTCH_VAL_BREAK_AFTER_MAKE);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
