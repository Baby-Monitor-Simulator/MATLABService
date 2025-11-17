classdef WarningUtility
    % This is a utility class that suppresses warnings which are listed in the
    % WarningList property.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant)
        WarningList (1, :) string = ["transportlib:legacy:DoesNotCloseConnection", ...
            "instrument:IviScope:ClassToBeRemoved", "instrument:IviFgen:ClassToBeRemoved", "instrument:IviRFSigGen:ClassToBeRemoved"]
    end

    methods (Static)
        function warnState = disableWarnings()
            % Suppresses warning IDs that are listed in the WarningList
            % property.
            warnState = warning;
            for warnString = instrument.internal.udm.WarningUtility.WarningList
                warning("off", warnString);
            end
        end

        function restoreWarnState(warnState)
            % Restores warning state before any warning was suppressed.
            warning(warnState);
        end
    end

    %% Lifetime
    methods (Access = private)
        function obj = WarningUtility()
            % Private constructor as utility class should not be
            % instantiated.
        end
    end
end