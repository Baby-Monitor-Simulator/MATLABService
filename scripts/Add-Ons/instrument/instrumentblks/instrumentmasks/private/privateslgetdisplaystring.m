function [dispString, port] = privateslgetdisplaystring(EnableBlockingMode)
%PRIVATESLGETDISPLAYSTRING Return a display string for the Instrument Control blocks.
%
%    [DISPSTRING PORT] = PRIVATESLGETDISPLAYSTRING(ENABLEBLOCKINGMODE)
%    returns a display string DISPSTRING and port information, PORT, for
%    the Instrument Control block, with input information for blocking
%    mode, ENABLEBLOCKINGMODE.

%    Copyright 2007-2023 The MathWorks, Inc.


% We are always called every time the mask is initialized,
% so the current block is always ours.
blk = gcb;
blkh = gcbh;

% Determine the block type.
blkType = get_param(blk, 'FunctionName');

% Check if we're in the library. If so, don't display any dynamic info.
parentBlk = get_param(blk, 'Parent');
if strcmpi(parentBlk, 'instrumentlib')
    % This check should be done inside the outer level if statement.
    % Not all blocks have a BlockDiagramType parameter (e.g. subsystems),
    % but if the parent is instrumentlib, then it will.
     blkDiagType = get_param(bdroot(blk), 'BlockDiagramType');
     if strcmpi(blkDiagType, 'library')
        % Display String inside the library
        switch blkType
            case 'stcpiprb'
                dispString = sprintf('TCP/IP \nClient \nReceive');
            case 'stcpipsb'
                dispString = sprintf('TCP/IP \nClient \nSend');
            case 'sudprb'
                dispString = sprintf('UDP \nReceive');
            case 'sudpsb'
                dispString = sprintf('UDP \nSend');
            case 'sserialcb'
                dispString = sprintf('Serial\nConfiguration');
                port = [];
                return;
            case 'sserialrb'
                dispString = sprintf('Serial\nReceive');
            case 'sserialsb'
                dispString = sprintf('Serial\nSend');
        end
        % Assign port id and labels inside library
        port(1).id = 1;
        port(1).label = 'Data';
        return;
     end
end

% Get strings from the private method.
allStrings = privateinstrumentslstring('errorStrings');

switch blkType
    case {'sudprb' 'sudpsb'}
        % Query the block for the host name and port name. Local Address
        % for UDP receive block and Remote Address for UDP Send block.
        if strcmpi(blkType, 'sudprb')
            host = strtrim(get_param(blk, 'LocalAddress'));
        else
            host = strtrim(get_param(blk, 'Host'));
        end
        if strcmpi(host, '')
            host = sprintf('Address: (none)');
        end
        hostString = sprintf('%s', host);

        % Shorten the host display string if it's too long (arbitrarily set to 
        % N characters). Arbitrarily set to 15 characters currently.
        if length(hostString) > 15
            hostString = [hostString(1:12) '...'];
        end

        % Get the port setting. Local Port for UDP receive block and
        % Remote Port for UDP Send block.
        if strcmpi(blkType, 'sudprb')
            portNumber = get_param(blk, 'LocalPort');
        else
            portNumber = get_param(blk, 'Port');
        end
        portString = sprintf('Port: %s', portNumber);

        % Append host and port to the display string.
        dispString = sprintf('%s\n%s', hostString, portString);
        
    case {'stcpiprb' 'stcpipsb'}
        if strcmpi(blkType, 'stcpiprb')
            blkName = message("instrument:instrumentblks:tcpipReceive").getString;
        else
            blkName = message("instrument:instrumentblks:tcpipSend").getString;
        end
        
        % Query the block for the host name and port name.
        host = strtrim(get_param(blk, 'Host'));
        if strcmpi(host, '')
            host = sprintf('Address: (none)');
        end
        hostString = sprintf('%s', host);

        % Shorten the host display string if it's too long (arbitrarily set to 
        % N characters). Arbitrarily set to 15 characters currently.
        if length(hostString) > 15
            blkName = [blkName(1:12) '...'];
            hostString = [hostString(1:12) '...'];
        end

        % Get the port setting.
        portNumber = get_param(blk, 'Port');
        portString = sprintf('Port: %s', portNumber);

        % Append host and port to the display string.
        dispString = sprintf('%s\n%s\n%s', blkName, hostString, portString);
        
    case {'sserialrb' 'sserialsb'}
        % Query the block for serial port.
        serialPort = get_param(blk, 'ComPort');
        if strcmpi(serialPort, allStrings.SelectPortString)
            serialPort =  message("instrument:instrumentblks:noPortSelected").getString;
        end
        dispString = sprintf('%s', serialPort);
    case 'sserialcb'
        % Query the block for serial port.
        serialPort = get_param(blk, 'ComPort');
        if strcmpi(serialPort, allStrings.SelectPortString)
            dispString = message("instrument:instrumentblks:noPortSelected").getString;
        else
            % Query the baud rate.
            baudRate = get_param(blk, 'BaudRate');
            % Query data bits field.
            dataBits = get_param(blk, 'DataBits');
            % Query parity field.
            parity = get_param(blk, 'Parity');
            % Query stop bits field.
            stopBits = get_param(blk, 'StopBits');
            
            % Form the display string.
            line1 = sprintf('%s', serialPort);
            line2 = sprintf('%s', baudRate);
            line3 = sprintf('%s,%s,%s', dataBits, parity, stopBits);
            dispString = sprintf('%s\n%s\n%s', line1, line2, line3);
        end
end

% Set the number of ports for based on enable blocking mode selection.
port(1).id = 1;
port(1).label = 'Data';
switch blkType
    case {'stcpiprb' 'sudprb' ...
          'sserialrb'}        
        portType = '''output''';
        if strcmpi(EnableBlockingMode, 'off') % If non-blocking, then 2 ports.
            port(2).id = 2;
            port(2).label = 'Status';
        end
    case {'stcpipsb' 'sudpsb'...
          'sserialsb'}  
        portType = '''input''';
    case 'sserialcb'
        portType = ''; %No ports for Serial Configuration block.
        port = [];
    otherwise 
        errordlg(message("instrument:instrumentblks:invalidBlockRef").getString, message("instrument:instrumentblks:errorString").getString, 'modal');
end
        
% We need to build the 'MaskDisplay' in the Block Library
% based on the selection of channels.
maskDisplayString = localBuildMaskDisplayString(port, portType);
set(blkh, 'MaskDisplay', maskDisplayString);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function maskDisplayString = localBuildMaskDisplayString(port, portType)
%LOCALBUILDMASKDISPLAYSTRING Updates Mask Display String value
%
%    MASKDISPLAYSTRING = LOCALBUILDMASKDISPLAYSTRING(PORT, PORTTYPE)
%    updates MASKDISPLAYSTRING in the library model file.
%

% Build the MaskDisplayString in the block library based on NUMBERPORTS
maskDisplayString = 'disp(str);';

% Loop through number of ports and update mask display string.
for idx = 1:length(port)
    portID = sprintf('port(%d).id',idx);
    portLabel = sprintf('port(%d).label', idx);
    addStr = sprintf('\nport_label(%s,%s,%s);',portType, portID, portLabel);
    maskDisplayString = strcat(maskDisplayString, addStr);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%