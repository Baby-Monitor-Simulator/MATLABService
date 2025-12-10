classdef attrProbeAttenuationRangeTable < instrument.internal.DriverBaseClass
    %ATTRPROBEATTENUATIONRANGETABLE for instrument.ivic.IviScope.ChannelSubsystem class

    % Copyright 2010 The MathWorks, Inc.
    
    properties(Constant)
        % Enables the oscilloscope's automatic probe sense capability.
        IVISCOPE_VAL_PROBE_SENSE_ON = -1.0;
    end
    
    methods (Static = true)
        function  checkEnumValue(e)
            import instrument.ivic.IviScope.ChannelSubsystem.*
            found = ...
                ( e == attrProbeAttenuationRangeTable.IVISCOPE_VAL_PROBE_SENSE_ON);
            if ~found
                error(message('instrument:general:invalidMemberOfEnum'));
            end
        end
    end
end
