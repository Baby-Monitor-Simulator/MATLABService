function outputStringStruct = privateinstrumentslstring(inputString)
%PRIVATEINSTRUMENTSLSTRING Return a string struct used by simulink ICT code.
%
%    OUTPUTSTRINGSTRUCT = PRIVATEINSTRUMENTSLSTRING(INPUTSTRING) returns a
%    structure, OUTPUTSTRINGSTRUCT that contains message strings specific
%    to the input query passed in INPUTSTRING.
%    Valid values for INPUTSTRING are:
%    1. 'ErrorStrings' - Returns all error and user message strings. 
%    2. 'tcpiprb' - Returns tags for TCPIP Receive block. 
%    3. 'tcpipsb' - Returns tags for TCPIP Send block. 
%    4. 'udprb' - Returns tags for UDP Receive block. 
%    5. 'udpsb' - Returns tags for UDP Send block.
%    6. 'serialcb' - Returns tags for Serial Configuration block. 
%    7. 'serialrb' - Returns tags for Serial Receive block. 
%    8. 'serialsb' - Returns tags for Serial Send block. 
%    9. 'alltags' - Returns tags for all the blocks. 

%    Copyright 2007-2023 The MathWorks, Inc.


% Return the structure requested by the input string.
switch lower(inputString)
    case 'errorstrings' %Error Strings.
        outputStringStruct = localInitErrorStrings([]);
    case 'tcpiprb' % TCP/IP Receive block widget tags only.
        outputStringStruct = localInitCommonTags([]);
        outputStringStruct = localInitTCPIPReceiveTags(outputStringStruct);
    case 'udprb' % UDP Receive block widget tags only.
        outputStringStruct = localInitCommonTags([]);
        outputStringStruct = localInitUDPReceiveTags(outputStringStruct);
    case 'tcpipsb' % TCP/IP Send block widget tags only.
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitTCPIPSendTags(outputStringStruct);
    case 'udpsb' % UDP Send block widget tags only.
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitUDPSendTags(outputStringStruct);
    case 'serialcb' % Serial Configuration block widget tags only.
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitSerialConfigurationTags(outputStringStruct);
    case 'serialrb' % Serial Receive block widget tags only.
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitSerialReceiveTags(outputStringStruct);
    case 'serialsb' % Serial Send block widget tags only.        
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitSerialSendTags(outputStringStruct);
    case 'alltags' % All tags for the four blocks.
        outputStringStruct = localInitCommonTags([]);        
        outputStringStruct = localInitTCPIPReceiveTags(outputStringStruct);
        outputStringStruct = localInitTCPIPSendTags(outputStringStruct);
        outputStringStruct = localInitUDPReceiveTags(outputStringStruct);
        outputStringStruct = localInitUDPSendTags(outputStringStruct);  
        outputStringStruct = localInitSerialConfigurationTags(outputStringStruct);        
        outputStringStruct = localInitSerialReceiveTags(outputStringStruct);        
        outputStringStruct = localInitSerialSendTags(outputStringStruct);        
    otherwise
        % Assert as an invalid string is passed. 
        assert(false, 'instrument:instrumentblks:InvalidString', 'Wrong input string.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function structToReturn = localInitCommonTags(structToReturn)

% Initializes common widget tags.
structToReturn.ParameterPane = 'ParameterPane';
structToReturn.Description = 'Description';
structToReturn.DescriptionPane = 'DescriptionPane';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function structToReturn = localInitTCPIPReceiveTags(structToReturn)

% TCPIP Receive tags. 
structToReturn.Host = 'Host';
structToReturn.Port = 'Port';
structToReturn.CheckValidity = 'CheckValidity';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
structToReturn.DataSize = 'DataSize';
structToReturn.Timeout = 'Timeout';
structToReturn.SampleTime = 'SampleTime';
structToReturn.DataType = 'DataType';
structToReturn.ASCIIFormatting = 'ASCIIFormatting';
structToReturn.Terminator = 'Terminator';
structToReturn.ByteOrder = 'ByteOrder';
structToReturn.Timeout = 'Timeout';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function structToReturn = localInitTCPIPSendTags(structToReturn)

% TCPIP Send tags. 
structToReturn.Host = 'Host';
structToReturn.Port = 'Port';
structToReturn.CheckValidity = 'CheckValidity';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
structToReturn.Timeout = 'Timeout';
structToReturn.ByteOrder = 'ByteOrder';
structToReturn.TransferDelay = 'TransferDelay';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function structToReturn = localInitUDPReceiveTags(structToReturn)

% Initializes UDP Receive tags.
structToReturn.Host = 'Host';
structToReturn.Port = 'Port';
structToReturn.GetLatestData = 'GetLatestData';
structToReturn.CheckValidity = 'CheckValidity';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
structToReturn.DataSize = 'DataSize';
structToReturn.Timeout = 'Timeout';
structToReturn.SampleTime = 'SampleTime';
structToReturn.DataType = 'DataType';
structToReturn.ASCIIFormatting = 'ASCIIFormatting';
structToReturn.Terminator = 'Terminator';
structToReturn.Timeout = 'Timeout';
structToReturn.LocalPort = 'LocalPort';
structToReturn.LocalAddress = 'LocalAddress';
structToReturn.AutoAssignText = 'AutoAssignText';
structToReturn.NoteUDPReceiveBlk = 'NoteUDPReceiveBlk';
structToReturn.NoteClkHelpText = 'NoteClkHelpText';
structToReturn.ByteOrder = 'ByteOrder';
structToReturn.EnablePortSharing = 'EnablePortSharing';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function structToReturn = localInitUDPSendTags(structToReturn)

% Initializes UDP Send widget tags.
structToReturn.Host = 'Host';
structToReturn.Port = 'Port';
structToReturn.CheckValidity = 'CheckValidity';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
structToReturn.LocalPort = 'LocalPort';
structToReturn.LocalAddress = 'LocalAddress';
structToReturn.ByteOrder = 'ByteOrder';
structToReturn.AutoAssignText = 'AutoAssignText';
structToReturn.NoteUDPSendBlk = 'NoteUDPSendBlk';
structToReturn.NoteClkHelpText = 'NoteClkHelpText';
structToReturn.OutputDatagramPacketSize = 'OutputDatagramPacketSize';
structToReturn.EnablePortSharing = 'EnablePortSharing';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function structToReturn = localInitSerialConfigurationTags(structToReturn)
% Init serial configuration widget tags.
structToReturn.ComPortMenu = 'ComPortMenu';
structToReturn.BaudRate = 'BaudRate';
structToReturn.DataBits = 'DataBits';
structToReturn.Parity = 'Parity';
structToReturn.ByteOrder = 'ByteOrder';
structToReturn.StopBits = 'StopBits';
structToReturn.FlowControl = 'FlowControl';
structToReturn.Timeout = 'Timeout';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function structToReturn = localInitSerialReceiveTags(structToReturn)

% Init serial receive widget tags.
structToReturn.ComPortMenu = 'ComPortMenu';
structToReturn.Header = 'Header';
structToReturn.Terminator = 'Terminator';
structToReturn.DataSize = 'DataSize';
structToReturn.DataType = 'DataType';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
structToReturn.ActionDataUnavailable = 'ActionDataUnavailable';
structToReturn.CustomValue = 'CustomValue';
structToReturn.SampleTime = 'SampleTime';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function structToReturn = localInitSerialSendTags(structToReturn)

% Init serial send widget tags.
structToReturn.ComPortMenu = 'ComPortMenu';
structToReturn.Header = 'Header';
structToReturn.Terminator = 'Terminator';
structToReturn.EnableBlockingMode = 'EnableBlockingMode';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function structToReturn = localInitErrorStrings(structToReturn)

% Invalid sample time error. 
structToReturn.InvalidSampleTime = message("instrument:instrumentblks:invalidReceiveSampleTime").getString;

% Invalid timeout value error.
structToReturn.InvalidTimeout = message("instrument:instrumentblks:nonPositiveTimeout").getString;


% Invalid port specified. 
structToReturn.InvalidPort = message("instrument:instrumentblks:portNumericRange").getString;

% Invalid data size value specified.
structToReturn.InvalidDataSize = message("instrument:instrumentblks:invalidDataSize").getString;

% Host not resolving error. 
structToReturn.HostDoesNotResolve = message("instrument:instrumentblks:hostinvalid").getString;

% Host successfully resolving user message.
structToReturn.HostResolves = [message("instrument:instrumentblks:remoteAddressFound", "%s", "").getString blanks(1)];
structToReturn.HostResolvesWithIP = [message("instrument:instrumentblks:remoteAddressFound", "%s", " (%s)").getString blanks(1)];

% Incorrect host and port connection. 
structToReturn.HostAndPortIncorrect = message("instrument:instrumentblks:portUnavailable").getString;

% User message for correct host and port.
structToReturn.HostAndPortCorrect = message("instrument:instrumentblks:remoteHostAndPortCorrect", "%s", "%s").getString;

structToReturn.HostAndPortCorrectWithIP = message("instrument:instrumentblks:remoteHostAndPortCorrectWithIP", "%s", "%s", "%s").getString;
                                         
% Error dialog title. 
structToReturn.ErrorDialogTitle = message("instrument:instrumentblks:configError").getString;

% Serial Port invalid. 
structToReturn.SerialPortUnavailable = message("instrument:instrumentblks:specifiedSerialportUnavailable", "%s").getString;
structToReturn.NoSerialPorts = message("instrument:instrumentblks:serialportUnavailable").getString;

% Message to user for requirement of Serial Configuration block. 
structToReturn.AddSerialConfigBlock = message("instrument:instrumentblks:inquirySerialConfigurationBlock", "%s", "%s").getString;
structToReturn.QuestDlgTitle = message("instrument:instrumentblks:successString").getString;
 
% Invalid baud rate. 
structToReturn.InvalidBaudRate = message("instrument:instrumentblks:invalidBaudRate").getString;

% Invalid header or terminator.
structToReturn.InvalidHeadTerm = message("instrument:instrumentblks:mismatchedSingleQuotes", "%s", "%s").getString; 

% Please select a port string. 
structToReturn.SelectPortString = message("instrument:instrumentblks:selectPort").getString;
% Invalid baud rate. 
structToReturn.InvalidCustomValue = message("instrument:instrumentblks:invalidCustomValue").getString;

% Simulation error messages.
% Attaching error IDs even though Simulink strips them off. 
structToReturn.HostInvalidID = sprintf('instrument:instrumentblks:hostinvalid');

% Local Host not resolving error. 
structToReturn.LocalHostDoesNotResolveID = 'instrument:instrumentblks:localHostDoesNotResolve';

% Local Host successfully resolving user message.
structToReturn.LocalHostResolvesID = 'instrument:instrumentblks:localHostResolves';
structToReturn.LocalHostResolvesWithIPID = 'instrument:instrumentblks:localHostResolvesWithIP';

% User message for correct local host and local port.
structToReturn.LocalHostAndPortCorrectID = 'instrument:instrumentblks:localHostAndPortCorrect';
structToReturn.LocalHostAndPortCorrectWithIPID = 'instrument:instrumentblks:localHostAndPortCorrectWithIP';

% Invalid port error. 
structToReturn.PortInvalidID = sprintf('instrument:instrumentblks:portinvalid');
structToReturn.PortInvalid = message(structToReturn.PortInvalidID,"%s").getString;   

% Data size error. 
structToReturn.BufferSizeErrorID = sprintf('instrument:instrumentblks:bufferError');
structToReturn.BufferSizeError = message(structToReturn.BufferSizeErrorID, "%s").getString;

% Timeout error.
structToReturn.TimeoutErrorID = sprintf('instrument:instrumentblks:timeouterror');
structToReturn.TimeoutError = message(structToReturn.TimeoutErrorID).getString;  

% Error displayed when two receive or two send blocks use same host/rport/lport combination. 
structToReturn.TwoBlocksUsingSamePropsErrorID = sprintf('instrument:instrumentblks:multipleBlocksSamePortError');
structToReturn.TwoBlocksUsingSamePropsError = message(structToReturn.TwoBlocksUsingSamePropsErrorID, "%s").getString;

% Unsupported Data type at the input port of UDP and TCPIP Send blocks. 
structToReturn.InvalidDataTypeID = sprintf('instrument:instrumentblks:invaliddatatype');
structToReturn.InvalidDataType = message(structToReturn.InvalidDataTypeID, "%s").getString;


% Invalid inherited sample time field during simulation.
structToReturn.InvalidInheritedSampleTimeID = sprintf('instrument:instrumentblks:invalidinheritedsampletime');
structToReturn.InvalidInheritedSampleTime = message(structToReturn.InvalidInheritedSampleTimeID, "%s").getString;

% Conflicting byte order error.
structToReturn.ConflictingByteOrderID = sprintf('instrument:instrumentblks:conflictingbyteordererror');
structToReturn.ConflictingByteOrder = message(structToReturn.ConflictingByteOrderID, "%s", "%s").getString;
                      
% No serial configuration block found. 
structToReturn.NoSCBlocksID = sprintf('instrument:instrumentblks:noSCBlocks');
structToReturn.NoSCBlocks = message(structToReturn.NoSCBlocksID, "%s", "%s").getString;

% Multiple serial configuration blocks for same port.
structToReturn.MultipleSCBlocksID = sprintf('instrument:instrumentblks:multipleSCBlocks');
structToReturn.MultipleSCBlocks = message(structToReturn.MultipleSCBlocksID, "%s", "%s").getString;

% Multiple serial send blocks for same port.
structToReturn.MultipleSSBlocksID = sprintf('instrument:instrumentblks:multipleSSBlocks');
structToReturn.MultipleSSBlocks = message(structToReturn.MultipleSSBlocksID, "%s", "%s").getString;

% Multiple serial receive blocks for same port.
structToReturn.MultipleSRBlocksID = sprintf('instrument:instrumentblks:multipleSRBlocks');
structToReturn.MultipleSRBlocks = message(structToReturn.MultipleSRBlocksID, "%s", "%s").getString;

% Dimension mismatch with custom data value and output port for Serial block.
structToReturn.DimMismatchOutputPortID = sprintf('instrument:instrumentblks:outputSizeMismatch');
structToReturn.DimMismatchOutputPort = message(structToReturn.DimMismatchOutputPortID).getString;
                               
% Invalid serial port error. 
structToReturn.InvalidSerialPortID = sprintf('instrument:instrumentblks:invalidSerialPort');
structToReturn.InvalidSerialPort = message(structToReturn.InvalidSerialPortID, "%s").getString;

% Invalid Output Datagram Packet Size value specified.
structToReturn.OutputDatagramPacketSizeID = 'instrument:instrumentblks:outputDatagramPacketSize';

% Invalid ASCII Format String value specified.
structToReturn.InvalidASCIIFormatStringID = 'instrument:instrumentblks:invalidASCIIFormatString';

% Invalid Terminator value specified.
structToReturn.InvalidTerminatorID = 'instrument:instrumentblks:invalidTerminator';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%