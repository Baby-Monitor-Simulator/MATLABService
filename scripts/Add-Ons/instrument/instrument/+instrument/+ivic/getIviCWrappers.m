%% get available Ivi-C class compliant instruments
% iviscope, iviFgen etc...
function out = getIviCWrappers ()
%getIviCInstruments returns available Ivi-C class compliant instruments
%   MATLAB class wrappers.
%
% Copyright 2011 The MathWorks, Inc.

ivicClassCompliantPath = fullfile(matlabroot, 'toolbox\instrument\instrument\+instrument\+ivic' );
% Initialize output.
out = {};

% Loop through paths and extract those files that have a .m extension.
info = dir([ivicClassCompliantPath filesep '*.m']);

names = {info.name};
for i = 1:length(names)
    % remove .m from name
    if ~isempty (strfind (names{i}, 'Specification.m'))
        out{end+1}= strrep(names{i}, 'Specification.m', ''); %#ok<*AGROW>
        %add instrument type and path
        out{end+1}= 'IviCClassCompliant';
        out{end+1}= ivicClassCompliantPath;
    end
end
end