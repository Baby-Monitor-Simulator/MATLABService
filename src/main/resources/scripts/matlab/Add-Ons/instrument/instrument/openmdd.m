 function openmdd(name)
%OPENMDD Opens an Instrument Driver File
%   OPENMDD <FILENAME.MDD> opens the Instrument Driver
%   Editor for the file.  If FILENAME.MDD
%   does not exist, a blank driver with that name
%   will be created.
%
%   Helper function for OPEN.
%
%   See also OPEN, MIDEDIT

%   Copyright 2006 The MathWorks, Inc.
%   $Revision $  $Date $

midedit(name)
