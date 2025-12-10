function privateslsfcnterminatenetworkobject(block, type)
%PRIVATESLSFCNTERMINATENETWORKOBJECT Cleanup for TCPIP/UDP blocks during simulation
%
%    PRIVATESLSFCNTERMINATENETWORKOBJECT(BLOCK, TYPE) Performs cleanup for
%    TCPIP and UDP Receive and Send block passed by the Terminate method in
%    the S-Function.
%    BLOCK - Stores the current block object and
%    TYPE is a string that takes values 'udp' or 'tcpip'

%    SS 03/25/07
%    Copyright 2007 The MathWorks, Inc.

% Get the object from UserData.
obj = get_param(block.BlockHandle, 'UserData');

if isa(obj, type) && isvalid(obj)
    % Get the user data from underlying object.
    userData = get(obj, 'UserData');

    % Decrease the reference count by 1.
    userData.ReferenceCount = userData.ReferenceCount - 1;

    % Set it on the object.
    set(obj, 'UserData', userData);

    if (userData.ReferenceCount == 0)
        % Check if bytesToOutput is zero.
        while ~(strcmpi(get(obj, 'TransferStatus'), 'idle'))
            % Pause for some time for asynchronous operation to get over.
            pause(0.001);
        end

        % Close the underlying object.
        fclose(obj);

        % Delete the underlying object.
        delete(obj);
    end
end

% Set the UserData to empty string.
set_param(block.BlockHandle, 'UserData', []);
