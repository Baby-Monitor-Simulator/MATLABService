function blkStruct = slblocks
%SLBLOCKS Define the Simulink library block representation.
%
%    Define the Simulink library block representation for the Instrument
%    Control Toolbox Block Library.

%   PE 01-06-03
%   Copyright 2003-2007 The MathWorks, Inc. 

blkStruct.Name    = sprintf('Instrument\nControl\nToolbox');
blkStruct.OpenFcn = 'instrumentlib';
blkStruct.MaskInitialization = '';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it
Browser(1).Library = 'instrumentlib';
Browser(1).Name    = 'Instrument Control Toolbox';
Browser(1).IsFlat  = 1;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks.m
