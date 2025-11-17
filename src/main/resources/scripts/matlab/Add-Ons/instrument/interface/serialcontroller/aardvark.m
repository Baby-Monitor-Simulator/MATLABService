function obj = aardvark(varargin)
%

% AARDVARK creates a connection to the Aardvark controller specified using the
% SERIALNUMBER input argument.
%
%   OBJ = AARDVARK("SERIALNUMBER") constructs an Aardvark object, OBJ, that
%   creates a connection to an Aardvark controller with unique identifier
%   SERIALNUMBER that is physically connected to the host machine.
%
%   OBJ = AARDVARK("SERIALNUMBER",NAME=VALUE, ...) constructs an
%   Aardvark object, OBJ, using one or more optional name-value pair
%   arguments. If an invalid property name or property value is
%   specified, then the object is not created. Aardvark properties
%   that can be set using name-value pair arguments are EnablePullupResistors,
%   VoltageLevel, and EnableTargetPower.
%
% Input Arguments:
%   SERIALNUMBER specifies the unique identifier for the Aardvark controller
%   that is being connected to from MATLAB.
%   The valid SERIALNUMBER values are returned by the aardvarklist function.
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
%
%   % Construct an Aardvark object using the SERIALNUMBER input argument
%   % returned from aardvarklist function.
%   >> a = aardvark("2237718007")

% Copyright 2021-2022 The MathWorks, Inc.

try
    obj = serialcontroller.internal.aardvark.Aardvark(true,varargin{:});
catch ex
    throwAsCaller(ex);
end
end
