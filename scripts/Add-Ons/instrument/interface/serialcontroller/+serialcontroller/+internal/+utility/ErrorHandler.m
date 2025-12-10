classdef ErrorHandler
    % ERRORHANDLER throws the appropriate error message based on the error
    % recieved.

    % Copyright 2022 The MathWorks, Inc.

    properties (Constant,Access = private)
        % Dictionary keys and values
        ErrorIDKeys = ["asyncio:Channel:couldNotLoadDevice","instrument:interface:serialcontroller:FindControllers"]
        ErrorIDValues = ["instrument:interface:serialcontroller:NI845xDriverNotInstalled","instrument:interface:serialcontroller:AardvarkDriverNotInstalled"]
        
        % Dictionary that holds on to expected error IDs as keys and
        % corresponding user error IDs as values.
        ErrorDictionary = dictionary(serialcontroller.internal.utility.ErrorHandler.ErrorIDKeys,serialcontroller.internal.utility.ErrorHandler.ErrorIDValues)
    end

    %% Utility API
    methods (Static)
        function LookUpAndThrowError(ex)
            % Looks for the error received in keys and throws appropriate
            % error based on that.

            if isKey(serialcontroller.internal.utility.ErrorHandler.ErrorDictionary,ex.identifier)
                % Get appropriate error ID based on error ID received.
                id = serialcontroller.internal.utility.ErrorHandler.ErrorDictionary(ex.identifier);
                ex = MException(message(id));
            end

            % Throw error about driver not being installed if error happens
            % when looking for controllers or when creating asyncIO channel.
            % If received error ID is not a key then throw as usual.
            throw(ex);
        end
    end

    %% Lifetime
    methods (Access = private)
        function obj = ErrorHandler()
            % Private constructor as utility class should not be
            % instantiated.
        end
    end
end