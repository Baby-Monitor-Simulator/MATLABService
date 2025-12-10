function out = horzcat(varargin)
%HORZCAT Horizontal concatenation of IVI Configuration Store objects.
%

%   MP 9-30-03
%   Copyright 1999-2011 The MathWorks, Inc.

% Concatenate objects.
try
    out = builtin('horzcat', varargin{:});
catch aException
    rethrow(aException);
end

% Error if a matrix of objects was created.
if (length(out) ~= numel(out))
    error(message('instrument:iviconfigurationstore:horzcat:nonMatrixConcat'))
end
