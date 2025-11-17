function controllerList = aardvarklist(varargin)
%

% AARDVARKLIST Returns a list of all Aardvark controllers found connected to
% host machine.
%
%    CONTROLLERLIST = AARDVARKLIST returns a table with MODEL and
%    SERIALNUMBER of discovered controllers.
%
%   Examples:
%
%   >> al = aardvarklist
%
%   al =
%
%     1×2 table
%
%                    Model             SerialNumber
%            ______________________    ____________
%
%       1    "Total Phase Aardvark"    "2237718007"

% Copyright 2022 The MathWorks, Inc.

try
    vendor = "aardvark";
    controllerList = serialcontroller.internal.utility.SerialControllerUtility.createList(vendor,nargin,mfilename);
catch ex
    throwAsCaller(ex);
end