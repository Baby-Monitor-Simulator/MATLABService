function [mapName, relativePathToMapFile, found] = getBlockHelpMapNameAndPath(block_type)
% Returns the mapName and the relative path to the maps file for this block_type
% This is a private function,not to be used directly.

% Copyright 2021-2022 The MathWorks, Inc.

blks = {...
    'instrument.system.TCPIPReceive'  'ICT_tcpiprec_Block'         ;...
    'instrument.system.TCPIPSend'     'ICT_tcpipsend_Block'        ;...
    'instrument.system.UDPReceive'    'ICT_udprec_Block'           ;...
    'instrument.system.UDPSend'       'ICT_udpsend_Block'          ;...
    'instrument.system.VISA'          'ICT_visa_Block'             ;...
    };
relativePathToMapFile = '/instrument/instrument.map';
found = false;

idx = strcmp(block_type, blks(:,1));

if ~any(idx)
    mapName = 'User Defined';
else
    found = true;
    mapName = blks(idx,2);
end