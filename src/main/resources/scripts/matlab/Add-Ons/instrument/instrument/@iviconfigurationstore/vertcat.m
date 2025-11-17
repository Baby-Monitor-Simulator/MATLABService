function out = vertcat(varargin)
%VERTCAT Vertical concatenation of IVI Configuration Store objects.
%

%   MP 9-30-03
%   Copyright 1999-2011 The MathWorks, Inc. 

% Concatenate objects.
try
    out = builtin('vertcat', varargin{:});
catch aException
    rethrow(aException);
end

% Error if a matrix of objects was created.
if (length(out) ~= numel(out))
    error(message('instrument:iviconfigurationstore:vertcat:nonMatrixConcat'))
end
