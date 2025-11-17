function [serialPorts objConstructors] = privateslserialparsehwinfo()
%PRIVATESLSERIALPARSEHWINFO Parse the serial port hardware information.
%
%    [SERIALPORTS OBJCONSTRUCTORS] = PRIVATESLSERIALPARSEHWINFO parses the 
%    serial port hardware information into a cell array of port names, 
%    returned as SERIALPORTS and OBJCONSTRUCTORS.

%    SS 09-30-07
%    Copyright 2007-2021 The MathWorks, Inc.

% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

narginchk(0,0);

% Query the system for the available serial ports.
serialInfo = instrhwinfo('serial');
serialPorts = serialInfo.SerialPorts;

% Add options to serial ports and object constructor names.
allStrings = privateinstrumentslstring('errorstrings');
serialPorts = {allStrings.SelectPortString serialPorts{:}}; %#ok<*CCAT>
objConstructors = serialInfo.ObjectConstructorName;
objConstructors = {'' objConstructors{:}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%