function obj = privateslsfcncreatenetworkobject(block, inputParams)
%PRIVATESLSFCNCREATENETWORKOBJECT Creates the network object for UDP/TCPIP blocks.
%
%    OBJ = PRIVATESLSFCNCREATENETWORKOBJECT(BLOCK, INPUTPARAMS)
%    Creates the object, OBJ, using the specified parameters, INPUTPARAMS.
%    INPUTPARAMS consists of TYPE, RHOST, and RPORT in order. 
%    It also contains PV pair: 'byteorder' and BYTEORDER setting for both
%    TCPIP and UDP objects. 
%    It optionally contains PV pair: 'localport' and LPORT for UDP objects.

%    SS 03/25/07
%    Copyright 2007 The MathWorks, Inc.


% Check if the object of specified type already exists.
obj = privateslsfcnfindnetworkobject(block, inputParams{:});

if isempty(obj) % If no object is found

    switch lower(inputParams{1}) % Type of object.
        case 'udp'
            obj = udp(inputParams{2:end});
            % Set the DatagramTerminateMode to off
            set(obj, 'DatagramTerminateMode', 'off');                   
        case 'tcpip'
            obj = tcpip(inputParams{2:end});
        otherwise
            % Assert as invalid network object is passed. 
            assert(false, 'instrument:instrumentblks:InvalidNetworkObject', 'Invalid network object.');
    end

    % Set the UserData structure in the underlying interface object.
    setUserDataOnObject(obj, block);

    % Set the Tag in the underlying object - This is a unique identifier
    % which ensures that user does not have the same tag. 
    set(obj, 'Tag', 'Simulink:ICTBlocks:zzzSimulinkNetworkObject');
    
    % Set the Timeout in the underlying object. We want to set it to the
    % default value so that it gets updated once the user has set a
    % higher value in the block. 
    set(obj, 'Timeout', 3);
else
    % Get the block object reference count and increment it. 
    userData = get(obj, 'UserData');
    userData.ReferenceCount = userData.ReferenceCount + 1;
    % Set it on the object. 
    set(obj, 'UserData', userData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setUserDataOnObject(obj, block)
% Sets the UserData field in the underlying interface object, OBJ.

structToSet.ReferenceCount = 1; % This is the first block to use the object.
structToSet.ReferenceBlock = get_param(block.BlockHandle, 'ReferenceBlock');        
structToSet.FirstBlockName = get_param(block.BlockHandle, 'Name');

% Setting for byte order field. 
if ~isempty(strfind(structToSet.ReferenceBlock, 'Receive')) 
    % Receive block.
    if ~any(strcmpi(get_param(block.BlockHandle, 'DataType'), {'uint8' 'int8'}))
        % Byte order does matter as Data type not int8 or uint8.
        structToSet.IsByteOrderRequired = true;
    else
        % Byte order does not matter as data type is int8 or uint8.
        structToSet.IsByteOrderRequired = false;
    end
else
    % For send block, it always matters.
    structToSet.IsByteOrderRequired = true;
end

% Set the structure. 
set(obj, 'UserData', structToSet);

