classdef TestModeManager
    % TESTMODEMANAGER sets the flag to determine whether the Aardvark and
    % Ni845x API's should operate in Mock mode or Production Mode.

    % Copyright 2023 The MathWorks, Inc.

    methods (Static)
        function flag = enableMockMode(flag)
            % SET THE FLAG: Store the flag passed to the function in
            % persistent var pFlag. This will later be used to check
            % whether the class is configured to run in mock mode or
            % production mode. GET THE FLAG: If no flag is passed, it
            % returns the flag stored in persistent var pFlag which
            % configures the utility to run in mock mode or production
            % mode. If persistent var pFlag is empty (which means that
            % function has not been used for set operation yet), then store
            % pFlag as false by default and return false.
            arguments
                flag = []
            end
            persistent pFlag

            if ~isempty(flag)
                pFlag = flag;
                return
            end
            if isempty(pFlag)
                pFlag = false;
            end
            flag = pFlag;
        end
    end
end