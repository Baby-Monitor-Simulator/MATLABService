classdef (Hidden) ErrorProxy < handle
    %ErrorProxy ErrorProxy is a utility class used to wrap error
    % messages that are issued by the visalib library. 
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    %%% Helper methods (wrappers)
    methods (Static)
        function e = getVisaException(messageID, varargin)
            %GETVISAERROR Create an MException for a specified messageID.
            %The messageID is assumed to be available within
            %instrument:interface:visa. 
            
            id = sprintf("instrument:interface:visa:%s", messageID);
            e = localGetException(id, varargin{:});           
        end

        function ex = translateVisaException(ex)
            % Wrap errors, as needed, issued by the VISA driver/adaptor.
            switch ex.identifier
                case 'instrument:interface:visa:standardAdaptorCommandFailed'
                    % An error code of -500 means that a generic read error
                    % occurred.
                    if contains(ex.message, "-500")
                        ex = visalib.internal.ErrorProxy.getVisaException("unableToReadDataVISADriver");
                    end
            end
        end
    end
    
    methods (Static)
        function e = getException(id, varargin)
            % Create an exception using the provided ID and slot
            % parameters.           
            e = MException(id, getString(message(id, varargin{:})));
        end     
        
        function getError(id, varargin)
            throwAsCaller(localGetException(id, varargin{:}));
        end
        
        function sendWarning(id, varargin)
            % Temporarily turn off the backtrace
            warningState = warning('off','backtrace');
            oc = onCleanup(@() warning(warningState));
            try
                warning(message(id,varargin{:}));
            catch e
                warning(warningState);
                rethrow(e);
            end            
        end
    end
end

% Short-hand for calling Static method (for internal use)
function e = localGetException(id, varargin)
    e = visalib.internal.ErrorProxy.getException(id, varargin{:});
end