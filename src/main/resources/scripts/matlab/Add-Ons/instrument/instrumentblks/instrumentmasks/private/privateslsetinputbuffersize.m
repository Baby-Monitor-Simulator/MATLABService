function isErr = privateslsetinputbuffersize(obj, block)
%PRIVATESLSETINPUTBUFFERSIZE Sets the Input Buffer Size on the underlying object. 
%
%    ISERR = PRIVATESLSETINPUTBUFFERSIZE(OBJ, BLOCK) Sets the input buffer size
%    parameter on the underlying object, OBJ for the block, BLOCK.
%
%    OBJ can be serial, tcpip or udp object. 
%

%    SS 10-01-07
%    Copyright 2007-2009 The MathWorks, Inc.

% Set err to false.
isErr = false;
% Close the object.
fclose(obj);
% Set input buffer size on the object.

% Setting the InputBufferSize to 100 times required to acquire data.
% G410113,G408760: The two gecks talk about throughput issues with
% the ICT blocks. The reason is that the buffer size is set to only
% required amount of data and causes a lot of overhead. Increasing
% the buffer size by a order of magnitude actually improves the
% throughput rate by a lot and matches the rate of the toolbox. 

idx = 100; % Magic number to set 100 times size of required data. 
while idx>=1
    try
        % Set it on the object.
        set(obj, 'InputBufferSize', idx*block.OutputPort(1).DataStorageSize);
    catch %#ok<CTCH>
        idx = idx/10;
        continue;
    end
    % Open the object.
    fopen(obj);
    return;
end

% Set error to true. 
isErr = true;
