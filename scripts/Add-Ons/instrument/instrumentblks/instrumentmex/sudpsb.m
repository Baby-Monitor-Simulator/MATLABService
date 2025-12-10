function sudpsb(block)
%SUDPSB Underlying S-Function for the ICT UDP Send block. 
%
%    SUDPSB(BLOCK) is the underlying S-Function for the ICT UDP Send
%    block. 

%    Copyright 2007-2019 The MathWorks, Inc.
  

% The setup method is used to setup the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.  
setup(block);

%endfunction

%% Function: setup ===================================================
%   Set up the S-function block's basic characteristics such as:
%   - Input ports
%   - Dialog parameters
%   - Options
% 
function setup(block)

    % Parameters: 
    % 1:Remote Address, 
    % 2:Port, 
    % 3:LocalPort, 
    % 4:EnableBlockingMode,
    % 5:ByteOrder, 
    % 6:OutputDatagramPacketSize,
    % 7:EnablePortSharing,
    % 8:LocalAddress

    % Register number of ports
    block.NumInputPorts = 1;

    % Register parameters
    block.NumDialogPrms = 8;
    block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable'};

    % Register sample times, Inherit sample time.
    block.SampleTimes = [-1 0];

    % Setup port properties to be inherited or dynamic
    block.SetPreCompInpPortInfoToDynamic;

    % Override input port properties
    for idx = 1:block.NumInputPorts
        block.InputPort(idx).Complexity   = 0;  % Real
        block.InputPort(idx).DirectFeedthrough = true; % Access inputs in Outputs function
    end

    % Specify if Accelerator should use TLC or call back into
    % MATLAB file
    block.SetAccelRunOnTLC(false);
    block.SetSimViewingDevice(true);% no TLC required
    
    % Allow multi dimensional signal support. 
    block.AllowSignalsWithMoreThan2D = true;

    %% -----------------------------------------------------------------
    %% Register methods called at run-time
    %% -----------------------------------------------------------------

    %% 
    %% Start:
    %%   Functionality    : Called in order to initialize state and work
    %%                      area values
    block.RegBlockMethod('Start', @Start);

    %% 
    %% Outputs:
    %%   Functionality    : Called to generate block outputs in
    %%                      simulation step
    block.RegBlockMethod('Outputs', @Outputs);

    %% 
    %% Terminate:
    %%   Functionality    : Called at the end of simulation for cleanup
    %%
    block.RegBlockMethod('Terminate', @Terminate);

%endfunction setup

%% Start - Set up the environment by creating objects, initializing data.
function Start(block)

    % Check the data type at the input port. 0 to 7 indicates the supported
    % data types for the block: single, double, uint8, int8, uint16, int16, uint32
    % and int32. 
    if (block.InputPort(1).DatatypeID < 0) || (block.InputPort(1).DatatypeID > 7)
        error(message('instrument:instrumentblks:invaliddatatype', get_param( block.BlockHandle, 'Name' )));
    end
    
    % Check the sample time of the block.
    if (block.SampleTimes(1) == 0)
        error(message('instrument:instrumentblks:invalidinheritedsampletime', get_param( block.BlockHandle, 'Name' )));
    end    
        
    % Check if the constant Remote Address and Local Address specified is empty/invalid.
    [remoteName, remoteAddress] = resolvehost(block.DialogPrm(1).Data);
    [localName, localAddress] = resolvehost(block.DialogPrm(8).Data);
    if isempty(remoteName) && isempty(remoteAddress)
        error(message('instrument:instrumentblks:hostinvalid'));
    end
    if isempty(localName) && isempty(localAddress)
        error(message('instrument:instrumentblks:localhostinvalid'));
    end

    % Find if any underlying objects exist with the same remote address and 
    % port.
    inputParams = {'udp' block.DialogPrm(1).Data block.DialogPrm(2).Data ...
                    'LocalHost' block.DialogPrm(8).Data};
    if (block.DialogPrm(3).Data ~= -1)
        inputParams = {inputParams{:} 'LocalPort' block.DialogPrm(3).Data}; %#ok<*CCAT>
    end
    % Add the byte ordering in the list of input params.
    inputParams = {inputParams{:} 'ByteOrder' block.DialogPrm(5).Data};
    % Create UDP Object.
    udpObj = instrumentslgate('privateslsfcncreatenetworkobject', ...
                            block, inputParams);
    
    % Set the UserData field so that it stays persistent during the
    % simulation.
    set_param(block.BlockHandle, 'UserData', udpObj)
    
    
    % If EnablePortSharing is different than value set on mask, close the
    % object and assign the required value to the field.
    if ~strcmp(block.DialogPrm(7).Data, get(udpObj, 'EnablePortSharing'))
        % Close the object
        fclose(udpObj);
        % Set user defined value to enable port sharing
        set(udpObj, 'EnablePortSharing', block.DialogPrm(7).Data);
    end
    
    % Set output buffer size to required value. 
    if block.InputPort(1).DataStorageSize > get(udpObj, 'OutputBufferSize')
        % Close the object. 
        fclose(udpObj);
        % Set it on the object. 
        set(udpObj, 'OutputBufferSize', block.InputPort(1).DataStorageSize);
    end
    
    % Setting Output buffer size might alter the value of 
    % OutputDatagramPacketSize. We need to set OutputDatagramPacketSize
    % after setting the OutputBufferSize
    % If OutputDatagramPacketSize is smaller than value set on mask, close 
    % the object and assign the required value to the field.
    if block.DialogPrm(6).Data > get(udpObj, 'OutputDatagramPacketSize')
        % Close the object
        fclose(udpObj);
        % Set user defined value to Output Datagram Packet Size
        set(udpObj, 'OutputDatagramPacketSize', min(block.DialogPrm(6).Data, 65535));
    end
    
    % Open the object
    if ~strcmp(get(udpObj, 'Status'), 'open')
        try
            fopen(udpObj);
        catch %#ok<*CTCH>
            error(message('instrument:instrumentblks:portinvalid', get_param( block.BlockHandle, 'Name' )));
        end
    end
%endfunction

%% Outputs - Generate block outputs at every timestep.
function Outputs(block)
    
    % Parameters: 
    % 1:Remote Address, 
    % 2:Port, 
    % 3:LocalPort, 
    % 4:EnableBlockingMode,
    % 5:ByteOrder, 
    % 6:OutputDatagramPacketSize,
    % 7:EnablePortSharing
 
    % Get the underlying object. 
    udpObj = get_param(block.BlockHandle, 'UserData');
    
    % Data at the input port is reshaped as a 1D vector. 
    data = reshape(block.InputPort(1).Data, 1, numel(block.InputPort(1).Data));
    if strcmpi(block.DialogPrm(4).Data, 'on')
        fwrite(udpObj, data, block.InputPort(1).Datatype);
    else % Non-blocking mode.
        while ~strcmp(get(udpObj,'TransferStatus'),'idle')
            % Must wait until previous async fwrite is complete.
            pause(0.01);
        end
        % Call fwrite.
        fwrite(udpObj, data, block.InputPort(1).Datatype, 'async');
    end
%endfunction Outputs

%% Terminate - Clean up
function Terminate(block)

    % Call the terminate method for network objects. 
    instrumentslgate('privateslsfcnterminatenetworkobject', block, 'udp');

%endfunction