classdef WarningUtility
    % WARNINGUTILITY class suppresses the warning IDs in WarningList when used.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Constant)
        WarningList (1, :) string = ["transportlib:legacy:DoesNotCloseConnection", "MATLAB:namelengthmaxexceeded"]
    end

    methods (Static)
        function warnState = cleanupStartMethod()
            warnState = warning;

            for warnString = instrument.icdevice.internal.utility.WarningUtility.WarningList
                warning("off", warnString);
            end
        end

        function cleanupEndMethod(warnState)
            warning(warnState);
        end
    end

    %% PRIVATE CONSTRUCTOR
    methods (Access = private)
        function obj = WarningUtility()
        end
    end
end
