function controllerList = ni845xlist(varargin)
%

% NI845XLIST Returns a list of all NI845x controllers found connected to
% host machine.
%
%    CONTROLLERLIST = NI845XLIST returns a table with MODEL and
%    SERIALNUMBER of discovered controllers.
%
%   Examples:
%
%   >> nl = ni845xlist
%
%   nl =
%
%     1×2 table
%
%                Model        SerialNumber
%            _____________    ____________
%
%       1    "NI USB-8451"     "0180D442"

% Copyright 2022 The MathWorks, Inc.

try
    vendor = "ni845x";
    controllerList = serialcontroller.internal.utility.SerialControllerUtility.createList(vendor,nargin,mfilename);
catch ex
    throwAsCaller(ex);
end