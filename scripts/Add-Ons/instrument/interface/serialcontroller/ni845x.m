function obj = ni845x(varargin)
%

% NI845X creates a connection to the NI845x controller specified using the
% SERIALNUMBER input argument.
%
%   OBJ = NI845X("SERIALNUMBER") constructs a NI845x object, OBJ, that
%   creates a connection to a NI845x controller with unique identifier
%   SERIALNUMBER that is physically connected to the host machine.
%
%   OBJ = NI845X("SERIALNUMBER",NAME=VALUE, ...) constructs a
%   NI845x object, OBJ, using one or more optional name-value pair
%   arguments. If an invalid property name or property value is
%   specified, then the object is not created. NI845x properties
%   that can be set using name-value pair arguments are EnablePullupResistors,
%   VoltageLevel, and OutputDriverType.
%
% Input Arguments:
%   SERIALNUMBER specifies the unique identifier for the NI845x controller
%   that is being connected to from MATLAB.
%   The valid SERIALNUMBER values are returned by the ni845xlist function.
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
%
%   % Construct a NI845x object using the SERIALNUMBER input argument
%   % returned from ni845xlist function.
%   >> n = ni845x("0180D442")

% Copyright 2021-2022 The MathWorks, Inc.

try
    obj = serialcontroller.internal.ni845x.NI845x(true,varargin{:});
catch ex
    throwAsCaller(ex);
end
end

