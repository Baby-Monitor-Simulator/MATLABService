function varargout = getOptions(varargin)
%getOptions Return the current set of active options for the visalib
%interface
%   [options] = getOptions(option1name, option1setting,...) returns a
%   structure, OPTIONS, that contains the currently selected options for
%   the visalib interface.  Each option is set using the
%   following sequence:
%     1. The default setting for the option
%     2. The options specified as PV pairs parameter to getOptions
%
%   These options are typically determined once - all subsequent calls
%   to getOptions will return the cached options (until reset).
%
%    getOptions("reset") reset the cached options to a default set of
%    values.  
%    getOptions("clear") clears the cached options completely.

% Copyright 2020 The MathWorks, Inc.
nargoutchk(0, 2)

if nargout
    [varargout{1:nargout}] = visalib.internal.TestModeManager.getOptions(varargin{:});
else
    visalib.internal.TestModeManager.getOptions(varargin{:});
end


