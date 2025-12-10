classdef Agilentbase < instrument.ieee4882.DriverGroupBase
    % AGILENTBASE class implements the error checking mechanism for Agilent RFSigGen's
    
    % Copyright 2017 The MathWorks, Inc.
    
    methods (Hidden,  Access = protected)
        % CHECKERRORIMPL Specific error checking
        function checkErrorImpl(obj)
            % error checking
            msg = obj.queryInstrument('*ESR?');
            value = str2double(msg);
            % error conditions
            if ~isnan(value) && ~isequal(value,0)
                msg = obj.queryInstrument('SYSTEM:ERR?');
                % Agilent spectrum analyzer report error messages in many
                % cases of coupled property values conflicting with each
                % other, but adjust other dependent properties such that
                % the commanded state is reached. In such cases, we report
                % the instrument message to the user as a warning. An error
                % is generated only if the instrument returns an error
                % message that is not a settings conflict.
                if ~strncmpi(msg, '-221,"Settings conflict;',24)
                    error(message('instrument:ieee4882Driver:instrumentError'));
                else
                    % Turn off backtrace momentarily and warn user
                    stateWarningBacktrace = warning('off','backtrace');
                    warning(message('instrument:rfsiggen:AgilentRFSigGenSettingsConflict',msg));
                    warning(stateWarningBacktrace);
                end
            end
        end
    end
end