classdef (Hidden) VISAMode
% VISAMode - enumeration class that defines modes of operation supported by
% a VISA device

% Copyright 2020 The MathWorks, Inc.

    enumeration
        Normal
        Test
        NoResources
        NoVISAInstalled
    end
end