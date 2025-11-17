function showDeprecationError(blkHandle)
% SHOWDEPRECATIONERROR shows ERROR in model if the model contains 'To
% Instrument' or 'Query Instrument' block.
%
% Copyright 2023-2024 The MathWorks, Inc.

% Get the block's library name.
libraryBlkName = get_param(blkHandle, 'ReferenceBlock');
blkName = erase( libraryBlkName , 'instrumentlib/');

% Throw error in model that contains 'To Instrument' or 'Query Instrument' block.
if ~bdIsLibrary(bdroot(gcbh))
    me = MSLException(blkHandle, message('instrument:instrumentblks:warnBlockDeprecation',convertStringsToChars(blkName), gcb));
    error(me.identifier, me.message);
end