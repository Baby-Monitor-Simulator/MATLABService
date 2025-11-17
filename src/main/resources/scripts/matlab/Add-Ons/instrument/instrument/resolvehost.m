function varargout = resolvehost(varargin)
%RESOLVEHOST Return the name and address of the host.
%
%   NAME = RESOLVEHOST('HOST') returns the name of host, HOST.
%
%   [NAME, ADDRESS] = RESOLVEHOST('HOST') returns the address of host, HOST,
%   in addition to the HOST'S name. HOST can be either the network name or
%   address of the host. If HOST is not a valid network host, NAME and ADDRESS
%   return as empty strings.
%
%   For example, 'www.mathworks.com' is a network name and '144.212.100.10'
%   is a network address.
%
%   OUT = RESOLVEHOST('HOST','RETURNTYPE') returns the host name if RETURNTYPE
%   is 'name' and returns the host address if RETURNTYPE is 'address'. By default,
%   RETURNTYPE is 'name'.
%
%   Example:
%       [name,address] = resolvehost('144.212.100.10')
%       name = resolvehost('144.212.100.10','name')
%       address = resolvehost('www.mathworks.com','address')
%
%   See also TCPCLIENT, TCPSERVER, UDPPORT.

%   Copyright 1999-2020 The MathWorks, Inc.

try
    nargoutchk(0,2);
catch ex
    throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxRetv')));
end

% Error nargin cases
if nargin == 0
    throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxHost')));
elseif nargin > 2
    throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxArgv')));
end

% Valid nargin cases
try
    host = validateHost(varargin{1});
    if host == ""
        varargout = {'', ''};
        return
    end
    returnType = "both";
    
    if nargin > 1
        returnType = validateReturnType(varargin{2});
    end
    
catch ex
    throwAsCaller(ex);
end

if ~localVerifyIPAddress(host)
    varargout = {'', ''};
    return
end

% Create the output structure.
try
    % Call the cpp mex function for resolving the hostname or ip.
    out = matlabshared.network.internal.mex.resolve(host);

    % Create the cell output to assign to varargout.
    varargout = prepareOutput(out, returnType);
catch ex
    throwAsCaller(MException('instrument:resolvehost:opfailed', ex.message));
end
end
%--------------------------------------------------------------------------
% Display warning if host is bad IP address. Valid IPs are x.x.x.x where x=0-255
% This is only a check for ipv4 addresses. ipv6 addresses will still go
% through the cpp mex function and get resolved for any errors.
function flag = localVerifyIPAddress(host)

flag = false;

% Return if it's empty string
if isempty(strtrim(host))
    return
end

% Parse the string x.x.x.x into four numbers.
out = double(split(host, "."));

% Non-numerical IP address
if any(isnan(out))
    flag = true;
    return
end

if length(out) ~= 4
    return
end

if any(out < 0) || any(out > 255)
    warnState = warning('backtrace', 'off');
    warning(message('instrument:resolvehost:invalidIPaddress'));
    warning(warnState);
    return
end
flag = true;
end

%% Processing MEX Function Output

function val = prepareOutput(out, returnType)
% Create the output cell array from the output of the cpp mex resolve
% function.

out = instrument.internal.stringConversionHelpers.str2char(out);
if isempty(out.Error)
    switch returnType
        case "both"
            val = {out.HostName, out.Address};
        case "address"
            val = {out.Address, ''};
        case "name"
            val = {out.HostName, ''};
    end
else
    % There was an error from the cpp mex call. The output needs to be
    % changed for such a case.
    val = prepareOutputForError(out, returnType);
end
end

function val = prepareOutputForError(out, returnType)
% Create the output cell array for the case of an error being returned from
% the cpp mex function.

if string(out.Address) == ""
    % If out.Address == "", this means that an incorrect input was passed
    % along to the cpp mex function (like "foo"). Return empty for both
    % cell array values.
    val = {'', ''};

elseif string(out.HostName) == ""
    % If out.HostName == "", this means that a correct ip address was
    % passed to the cpp mex function, but the ip address could not be
    % resolved to a host name. Set both values of the cell array to the
    % resolved address (without using the hostname).
    val = {out.Address, out.Address};
end

if returnType ~= "both"
    val{2} = '';
end
end

%% Validate Functions

function host = validateHost(host)
% Validate the host passed to the resolvehost function.

host = instrument.internal.stringConversionHelpers.str2char(host);
if ~ischar(host)
    throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxHostString')));
end
host = string(lower(host));
end

function returnType = validateReturnType(returnType)
% Validate the returntype passed to the resolvehost function.

returnType = instrument.internal.stringConversionHelpers.str2char(returnType);
if ~ischar(returnType)
    throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxFlagString')));
end
try
    returnType = validatestring(returnType,["name", "address"]);
catch ex
   throwAsCaller(MException(message('instrument:resolvehost:invalidSyntaxFlag')));
end
end