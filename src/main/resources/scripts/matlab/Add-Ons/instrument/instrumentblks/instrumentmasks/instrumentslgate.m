function varargout = instrumentslgate(varargin)
%INSTRUMENTSLGATE Gateway routine to call Instrument Control Toolbox SL private functions.
%
%    [OUT1, OUT2,...] = INSTRUMENTSLGATE(FCN, VAR1, VAR2,...) calls FCN in 
%    the Instrument Control Toolbox Simulink private directory with input arguments
%    VAR1, VAR2,... and returns the output, OUT1, OUT2,....
%

%    SS 03-03-07
%    Copyright 2007-2011 The MathWorks, Inc.

if nargin == 0
   error(message('instrument:instrumentblks:argcheck'));
end

nout = nargout;
if nout==0,
   feval(varargin{:});
else
   [varargout{1:nout}] = feval(varargin{:});
end
