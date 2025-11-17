function object = privateslsfcnfindnetworkobject(block, type, host, rPort, varargin)
%PRIVATESLSFCNFINDNETWORKOBJECT Returns the underlying object connected to the same host and port.
%
%    OBJECT = PRIVATESLSFCNFINDNETWORKOBJECT(BLOCK, TYPE, HOST, RPORT, 'byteorder', BYTEORDER)
%    Searches and returns the object, OBJECT, with connection to the host,
%    HOST, and remote port, RPORT, specified in the input. 
%    TYPE is a string which specifies 'udp' or 'tcpip'.
%
%    OBJECT = PRIVATESLSFCNFINDNETWORKOBJECT(BLOCK, TYPE, HOST, RPORT,  'byteorder', BYTEORDER, 'localport', LPORT)
%    Searches and returns the object, OBJECT, with connection to host, 
%    HOST, remote port, RPORT, local port, LPORT, specified in the input. 
%    TYPE is a string which specifies 'udp' or 'tcpip'.
%

%    Copyright 2007-2018 The MathWorks, Inc.

% Initialize.
object = [];

% Get name of the current block calling this method
currentBlockName = strrep(get_param(block.BlockHandle, 'ReferenceBlock'), 'instrumentlib/', '');

% Form the structure to search for the object.
structToFind.Type = type;
structToFind.RemoteHost = host;
structToFind.RemotePort = rPort;

% Append local host and local port fields if current block is UDP Receive
if (strcmpi(currentBlockName, 'UDP Receive') || strcmpi(currentBlockName, 'UDP Send'))
    structToFind.LocalHost = varargin{2};
    if strcmpi(varargin{3}, 'LocalPort')
        structToFind.LocalPort = varargin{4};
    end
end

% Objects created by Simulink have this tag.
structToFind.Tag = 'Simulink:ICTBlocks:zzzSimulinkNetworkObject';

% Find all the underlying objects.
allObjects = instrfind(structToFind);

if isempty(allObjects) % Return false if no object exists.
    return;
end

% Find the Reference block for the current block.
refBlock = get_param(block.BlockHandle, 'ReferenceBlock');

% Loop through all the existing objects. 
for index = 1: length(allObjects)

    % Get each object. 
    instrObj = allObjects(index);
    
    % Get the UserData on the instrument object.
    userData = get(instrObj, 'UserData');
    
    if strcmpi(userData.ReferenceBlock, refBlock)
        % Error as we cannot have two receive or send blocks in a model.
        blockName = localGetBlockNameOnly(userData.ReferenceBlock);
        if ~isempty(strfind(userData.ReferenceBlock, 'instrumentlib/UDP')) && ...
                strcmp(get_param(block.BlockHandle, 'EnablePortSharing'), 'on')
            continue;
        end
        error(message('instrument:instrumentblks:multipleBlocksSamePortError', blockName));
    elseif ~isempty(strfind(userData.ReferenceBlock, 'instrumentlib/UDP')) ...
            || ~isempty(strfind(userData.ReferenceBlock, 'instrumentlib/TCP'))% Check up until instrumentlib/TCP or instrumentlib/UDP
        % Assign the object and return.
        object = instrObj;
        
        % Check if already 2 blocks are referencing the underlying object.
        if (userData.ReferenceCount == 2)
            % Error as we cannot have two receive or send blocks in a model.
            blockName = localGetBlockNameOnly(userData.ReferenceBlock);
            if ~isempty(strfind(userData.ReferenceBlock, 'instrumentlib/UDP')) && ...
                    strcmp(get_param(block.BlockHandle, 'EnablePortSharing'), 'on')
                continue;
            end
            error(message('instrument:instrumentblks:multipleBlocksSamePortError', blockName));
        end
        
        % Check if the multiple blocks have conflicting Byte order
        % settings.
        checkByteOrder(instrObj, block)
        break;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local Function: Get string for error when multiple blocks try to access
% the same remote address and port. 
function blockName = localGetBlockNameOnly(referenceBlock)
% Reference block consists of full path name. Removing the library name
% from the block name.
blockName = strrep(referenceBlock, 'instrumentlib/', '');

% If it is a TCP/IP block, then reference block name is 'TCP//IP Receive' or
% 'TCP//IP Send'. We need to cut it to 'TCP/IP Receive' or 'TCP/IP Send'
% accordingly.
if strfind(blockName, '//')
    blockName = strrep(blockName, '//', '/');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkByteOrder(instrObj, block)
% Checks if the byte order property on multiple blocks is correct. 

% Get the current block handle.
blkh = get(block, 'BlockHandle');

% Get the user data stored in the object. 
userData = get(instrObj, 'UserData');

% Get byte order setting from the current block
blockByteOrder = get_param(blkh, 'ByteOrder');

% Get the byte order setting in the object. 
objectByteOrder = get(instrObj, 'ByteOrder');    

if ~isempty(strfind(userData.ReferenceBlock, 'Receive')) 
    % The object created already is for receive block.
    if userData.IsByteOrderRequired 
        % Check byte order.
        if ~strcmpi(blockByteOrder, objectByteOrder)
            % Error out that multiple blocks have conflicting Byte order
            % settings. 
            error(message('instrument:instrumentblks:conflictingbyteordererror', userData.FirstBlockName, get_param( blkh, 'Name' )));
        end
    else 
        % Set it in the object.
        set(instrObj, 'ByteOrder', blockByteOrder);
    end
else
    % The object created already is for send block.
    blockDataType = get_param(blkh, 'DataType');
    if ~any(strcmpi(blockDataType, {'uint8' 'int8'}))
        if ~strcmpi(blockByteOrder, objectByteOrder)
            % Error out that multiple blocks have conflicting Byte order
            % settings. 
            error(message('instrument:instrumentblks:conflictingbyteordererror', userData.FirstBlockName, get_param( blkh, 'Name' )));
        end        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
