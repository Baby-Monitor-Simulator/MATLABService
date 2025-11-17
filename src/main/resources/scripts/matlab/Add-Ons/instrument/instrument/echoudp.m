function echoudp(varargin)
%ECHOUDP start or stop a UDP echo server.
%
%     echoudp('STATE', PORT) starts a UDP server with port number,
%     PORT. STATE can only be 'on'.
%
%     echoudp('STATE') stops the echo server. STATE can only be 'off'.
%
%     Example:
%         echoudp("on", 4000);
%         u = udpport();
%         write(u, 1:5, "uint8", "127.0.0.1", 4000);
%         data = read(u, u.NumBytesAvailable, "uint8");
%         echoudp("off");
%
%     See also echotcpip udpport

% Copyright 2020 The MathWorks, Inc.
% 
if nargin == 0
    throwAsCaller(MException('instrument:echoudp:invalidSyntaxState', ...
        message('network:echoudp:invalidSyntaxState').getString));
elseif nargin > 2
    throwAsCaller(MException('instrument:echoudp:invalidSyntaxArgv', ...
        message('network:echoudp:invalidSyntaxArgv').getString));
end

% Convert the string input argument to char
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
state = varargin{1};
try
    state = validatestring(state, {'off', 'on'});
catch
    throwAsCaller(MException('instrument:echoudp:invalidSyntaxBool', ...
        message('network:echoudp:invalidSyntaxBool').getString));
end

switch nargin

    case 1
        % The state can only be "off". Error otherwise.
        if strcmpi(state, 'on')
            throwAsCaller(MException('instrument:echoudp:invalidSyntaxPort', ...
                message('network:echoudp:invalidSyntaxPort').getString));
        end

        % State is "off"
        try
            % Destroy the UDP Echo Server
            matlabshared.network.internal.EchoServer. ...
                manageTransportLifetime("UDP", "destroy");
        catch ex
            throwAsCaller(ex);
        end
    case 2
        % If nargin is 2, state can only be "on". Error otherwise
        if strcmpi(state, 'off')
            throw(MException('instrument:echoudp:invalidSyntax', ...
                message('network:echoudp:invalidSyntax').getString));
        end
        portNumber = varargin{2};
        try
            % Create the UDP Echo Server
            matlabshared.network.internal.EchoServer. ...
                manageTransportLifetime("UDP", "create", portNumber);
        catch ex
            throwAsCaller(ex);
        end
end