function privateSaveInstr(filename, creationtime)
%PRIVATESAVEINSTR Append an Instrument Object.
%
%   PRIVATESAVEINSTR appends an Instrument Object specified by creationtime
%   to the file specified by filename. A unique variable name is assigned
%   to each instrument based on the CreationTime of the Instrument Object
%   being saved.

%   MP 11-06-03
%   Copyright 2004-2005 The MathWorks, Inc.

eval(['instr' strrep(num2str(creationtime),'.','x') ' =  instrfind(''CreationTime'', creationtime)']);
if (exist(filename, 'file'))
    save(filename, ['instr' strrep(num2str(creationtime),'.','x')], '-append');
else
    save(filename, ['instr' strrep(num2str(creationtime),'.','x')]);
end
