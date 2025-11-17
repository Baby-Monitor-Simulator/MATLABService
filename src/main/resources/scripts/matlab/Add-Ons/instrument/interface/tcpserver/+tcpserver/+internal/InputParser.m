classdef InputParser
    %INPUTPARSER parses the tcpserver constructor input arguments and returns the
    % TCPServer ServerAddress and ServerPort. The parsing of first input
    % argument ServerAddress as an optional input argument could not be
    % done by MATLAB's inputParser as ServerPort, the second input
    % argument, is a required input argument.

    % Copyright 2020 The MathWorks, Inc.

    methods (Static)
        function [address,port,nvPairs] = parse(varargin)
            % Parses the tcpserver constructor input arguments to get the
            % address and port values.

            address = "";
            port = [];
            nvPairs = {};

            if nargin == 0
                % For nargin = 0, an error is thrown to indicate that
                % ServerPort or ServerAddress and ServerPort have to
                % be specified.

                validSyntax = message('instrument:interface:tcpserver:ValidSyntax').getString;
                error(message('instrument:interface:tcpserver:ZeroArgError',validSyntax));
            elseif nargin == 1
                % For nargin = 1, only ServerPort can be specified as
                % the input argument.
                % eg. t = tcpserver(port)

                address = [];
                port = varargin{1};
                tcpserver.internal.InputParser.validateServerPort(port);
            elseif nargin == 2
                % For nargin = 2, only ServerAddress and ServerPort can
                % be specified as the two input arguments.
                % eg. t = tcpserver(address,port)

                % If ServerPort is specified as the first argument then
                % the next argument will trigger the unmatched PV pair
                % error condition.
                if isnumeric(varargin{1}) && ischar(varargin{2})
                    error(message('instrument:interface:tcpserver:UnmatchedPVPairs'));
                end

                address = varargin{1};
                port = varargin{2};
                tcpserver.internal.InputParser.validateServerAddress(address);
                tcpserver.internal.InputParser.validateServerPort(port);
            elseif nargin > 2
                % Parses input arguments when name-value pairs are provided.
                % eg. t = tcpserver(port,nvPair)
                % eg. t = tcpserver(address,port,nvPair)

                [address,port,nvPairs] = tcpserver.internal.InputParser.parseNVPair(varargin{:});
            end
        end

        function [address,port,nvPairs] = parseNVPair(varargin)
            % Parses the input arguments when optional name-value pair
            % arguments are specified.

            % Checks if the first input argument is ServerPort or
            % ServerAddress.
            if isnumeric(varargin{1})
                address = [];
                port = varargin{1};
                tcpserver.internal.InputParser.validateServerPort(port);
                nvPairs = varargin(2:end);
            else
                address = varargin{1};
                port = varargin{2};
                tcpserver.internal.InputParser.validateServerAddress(address);
                tcpserver.internal.InputParser.validateServerPort(port);
                nvPairs = varargin(3:end);
            end

            % Validates the name-value pairs
            if mod(numel(nvPairs),2)
                error(message('instrument:interface:tcpserver:UnmatchedPVPairs'));
            end
        end
    end

    %% Argument validation methods
    methods(Static, Access = private)
        function validateServerAddress(address)
            validateattributes(address, {'char','string'}, {'nonempty'}, 'tcpserver', 'SERVERADDRESS', 1);
        end

        function validateServerPort(port)
            validateattributes(port, {'numeric'}, {'>=', 1, '<=', 65535, 'nonempty', 'scalar', 'integer'}, 'tcpserver', 'SERVERPORT');
        end
    end
end