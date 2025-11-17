function varargout = instrgate(varargin)
%INSTRGATE Gateway routine to call Instrument Control Toolbox private functions.
%
%   [OUT1, OUT2,...] = INSTRGATE(FCN, VAR1, VAR2,...) calls FCN in 
%   the Instrument Control Toolbox private directory with input 
%   arguments VAR1, VAR2,... and returns the output, OUT1, OUT2,....
%

%   MP 7-13-99
%   Copyright 1999-2005 The MathWorks, Inc.

if nargin == 0
   error(message('instrument:instrgate:invalidSyntax'));
end

nout = nargout;
if nout==0,
   feval(varargin{:});
else
   [varargout{1:nout}] = feval(varargin{:});
end
