classdef RohdeSchwarzbase < instrument.ieee4882.DriverGroupBase
    % ROHDESCHWARZBASE class implements the error checking mechanism for Rohde-Schwarz RFSigGen
    
    % Copyright 2017 The MathWorks, Inc.
    
    methods (Hidden,  Access = protected)
        % Rohde-Schwarz specific error checking
        function checkErrorImpl(obj)
            % error checking
            msg = obj.queryInstrument('*ESR?');
            value = str2double(msg);
            % error conditions
            if ~isnan(value) && ~isequal(value,0)
                error(message('instrument:ieee4882Driver:instrumentError'));
            end
        end
    end
end