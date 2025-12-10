function [headerFound startOfPacketIndex terminatorFound] = privatePacketPeek(serialobj, header, payloadsize, terminator)
%PRIVATEPACKETPEEK helper function used by Simulink Serial Receive Blocks.
%
%   [HEADERFOUND STARTOFPACKETINDEX TERMINATORFOUND] = ...
%                  PRIVATEPACKETPEEK(SERIALOBJ, HEADER, PAYLOADSIZE, TERMINATOR) 
%      Private helper function used by Simulink Serial Receive Blocks to:
%      1. determine if a packet header is in the input stream
%      2. determine how much information should be discarded prior to reading a packet, STARTOFPACKETINDEX.
%      3. determine if a packet terminator is available at the expected offset from the header.
%         AKA: determine if a packet is available for reading.
%   
%   This function should not be called directly by the user.
  
%   Copyright 2007-2008 The MathWorks, Inc. 

% Check for input arguments.
narginchk(4,4);

% Initialize outputs.
headerFound = false;
startOfPacketIndex = 0;
terminatorFound = false;
try
    % Call serial packet peek. 
    result = serialPacketPeek(igetfield(serialobj,'jobject'), header, payloadsize, terminator);
    if( isequal(length(result), 3 ))
        % Cast and assign outputs.
        headerFound = logical(result(1));
        startOfPacketIndex = double(result(2));
        terminatorFound = logical(result(3));
    end
catch aException
    newExc = MException('instrument:serialbreak:opfailed',aException.message);
    throw(newExc);
end
