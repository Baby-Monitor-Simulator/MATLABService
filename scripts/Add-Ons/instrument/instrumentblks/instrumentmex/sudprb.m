function sudprb(block)
%SUDPRB Underlying S-Function for the ICT UDP Receive block. 
%
%    SUDPRB(BLOCK) is the underlying S-Function for the ICT UDP Receive
%    block. 

%    Copyright 2007-2019 The MathWorks, Inc.
  

% The setup method is used to setup the basic attributes of the
% S-function such as ports, parameters, etc. Do not add any other
% calls to the main body of the function.  
setup(block);
SetOutputPortDataType(block);
SetOutputPortDims(block);

%endfunction

%% Function: setup ===================================================
%   Set up the S-function block's basic characteristics such as:
%   - Output ports
%   - Dialog parameters
%   - Options
% 
function setup(block)

    % Parameters: 
    % 1:Remote Address, 
    % 2:Port, 
    % 3:LocalPort,
    % 4:DataSize, 
    % 5:EnableBlockingMode, 
    % 6:Timeout, 
    % 7:SampleTime, 
    % 8:DataType,
    % 9:ByteOrder,
    % 10:GetLatestData,
    % 11:EnablePortSharing,
    % 12:ASCIIFormatting,
    % 13:LocalAddress
    % 14:Terminator

    % Register number of ports
    if strcmpi(block.DialogPrm(5).Data, 'on')
      block.NumOutputPorts = 1;
    else
      block.NumOutputPorts = 2;
    end

    % Register parameters
    block.NumDialogPrms = 14;
    block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable'};

    % Check if variable entered for sample time is defined. This lets the
    % user set a sample time variable that is not yet defined in any
    % workspace. If the user tries to run the program without defining it,
    % Simulink will produce the required error message. If the variable is
    % defined before runtime, it will be used.
    if ~isempty(block.DialogPrm(7).Data)        
        % Register sample times
        block.SampleTimes = [block.DialogPrm(7).Data 0];
    end

    % Specify if Accelerator should use TLC or call back into 
    % MATLAB file
    block.SetAccelRunOnTLC(false);
    block.SetSimViewingDevice(true);% no TLC required

    % Allow multi dimensional signal support. 
    block.AllowSignalsWithMoreThan2D = true;

    %% -----------------------------------------------------------------
    %% Register methods called during update diagram/compilation
    %% -----------------------------------------------------------------

    %%
    %% SetOutputPortDimensions:
    %%   Functionality    : Check and set output port dimensions
    block.RegBlockMethod('SetOutputPortDimensions', @SetOutputPortDims);

    %%
    %% SetOutputPortDatatype:
    %%   Functionality    : Check and set output port datatypes
    block.RegBlockMethod('SetOutputPortDataType', @SetOutputPortDataType);

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

%% SetOutputPortDims - Check and set output port dimensions
function SetOutputPortDims(block)

    % Set the output port dimensions.
    block.OutputPort(1).Dimensions = block.DialogPrm(4).Data;

    % If there are two ports, set the second one too. 
    if (block.NumOutputPorts == 2)
        block.OutputPort(2).Dimensions = 1; % Size is 1.
    end
%endfunction SetOutputPortDims

%% SetOutputPortDataType - Check and set output port datatypes
function SetOutputPortDataType(block)

    % Set the output port properties.
    if strcmpi(block.DialogPrm(8).Data, 'ASCII')
        % If the data steam to be parsed is ASCII make the output data type
        % as double. This follows suit from Query and To instrument blocks.
        block.OutputPort(1).DatatypeID = 0;
    else
        block.OutputPort(1).DatatypeID = tamslgate('privateslgetdatatypeid', ...
            block.DialogPrm(8).Data);
    end
    block.OutputPort(1).Complexity  = 'Real';
    block.OutputPort(1).SamplingMode = 'Sample';

    % If there are two ports, set the second one too. 
    if (block.NumOutputPorts == 2)
        block.OutputPort(2).DatatypeID = 0; % double
        block.OutputPort(2).SamplingMode = 'Sample';
        block.OutputPort(2).Complexity = 'Real';
    end
%endfunction SetOutputPortDataType

%% Start - Set up the environment by creating objects, initializing data.
function Start(block)

    % Get the block name
    blockName = get_param(block.BlockHandle, 'Name');

    % Check if the Remote Address and Local Address specified is empty/invalid.
    [remoteName, remoteAddress] = resolvehost(block.DialogPrm(1).Data);
    [localName, localAddress] = resolvehost(block.DialogPrm(13).Data);
    if isempty(remoteName) && isempty(remoteAddress)
        error(message('instrument:instrumentblks:hostinvalid'));
    end
    if isempty(localName) && isempty(localAddress)
        error(message('instrument:instrumentblks:localhostinvalid'));
    end
    
    % Form input parameters. 
    inputParams = {'udp' block.DialogPrm(1).Data block.DialogPrm(2).Data ...
                   'LocalHost' block.DialogPrm(13).Data};
    % Check if LocalPort setting is set to any value other than -1
    if (block.DialogPrm(3).Data ~= -1)
        inputParams = {inputParams{:} 'LocalPort' block.DialogPrm(3).Data}; %#ok<*CCAT>
    end
    
    % Add the byte ordering to input params.
    inputParams = {inputParams{:} 'ByteOrder' block.DialogPrm(9).Data};
    
    % Create UDP Object.
    udpObj = instrumentslgate('privateslsfcncreatenetworkobject', ...
                                block, inputParams);
    
    % Set the UserData field so that it stays persistent during the
    % simulation. 
    set_param(block.BlockHandle, 'UserData', udpObj)
    
    % Set specific object parameters.
    % Set the DatagramTerminateMode to off
    set(udpObj, 'DatagramTerminateMode', 'off');

    % If EnablePortSharing is different than value set on mask, close the
    % object and assign the required value to the field.
    if ~strcmp(block.DialogPrm(11).Data, get(udpObj, 'EnablePortSharing'))
        % Close the object if status is open.
        fclose(udpObj);
        % Set user defined value to enable port sharing
        set(udpObj, 'EnablePortSharing', block.DialogPrm(11).Data);
    end
    
    % Set user defined Terminator is data type selected is ASCII, empty
    % otherwise.
    if strcmpi(block.DialogPrm(8).Data, 'ASCII')
        if isnan(str2double(block.DialogPrm(14).Data))
            set(udpObj, 'Terminator', block.DialogPrm(14).Data);
        else
            set(udpObj, 'Terminator', str2double(block.DialogPrm(14).Data));
        end
    else
        set(udpObj, 'Terminator', '');
    end
    
    % Set the Input buffer size on the object.
    isErr = instrumentslgate('privateslsetinputbuffersize', udpObj, block);
    
    if isErr % Error if input buffer size cannot be set.
        error(message('instrument:instrumentblks:bufferError', blockName));
    end
    
    if strcmpi(block.DialogPrm(8).Data, 'ASCII')
        % This is a heuristic number. Assuming each number has less than 10
        % digits on average.
        numBytesPerElement = 10;
    else
        % For numeric types
        switch lower(block.DialogPrm(8).Data)
            case {'double', 'int64', 'uint64'}
                numBytesPerElement = 8;
            case {'single', 'int32', 'uint32'}
                numBytesPerElement = 4;
            case {'int16', 'uint16'}
                numBytesPerElement = 2;
            case {'int8', 'uint8'}
                numBytesPerElement = 1;
        end
    end
    
    % Setting Input buffer size might alter the value of 
    % InputDatagramPacketSize. We need to set InputDatagramPacketSize
    % after setting the InputBufferSize.
    % If InputDatagramPacketSize is smaller than value set on mask, close the
    % object and assign the required value to the field.
    if prod(block.DialogPrm(4).Data)*numBytesPerElement > get(udpObj, 'InputDatagramPacketSize')
        % Close the object
        fclose(udpObj);
        % Set user defined value to Output Datagram Packet Size
        set(udpObj, 'InputDatagramPacketSize', min(prod(block.DialogPrm(4).Data)*numBytesPerElement, 65535));
    end

    % Set the timeout value on the object. 
    if strcmpi(block.DialogPrm(5).Data, 'on')% Blocking mode
       if (  block.DialogPrm(6).Data > udpObj.Timeout )% Check if current timeout is less.
          % Wait for asynchronous write to get over before closing. 
          while (get(udpObj, 'BytesToOutput') ~= 0)
            % Just wait until previous async fwrite is complete.
            pause(0.01);
          end
          udpObj.Timeout = block.DialogPrm(6).Data;
       end
    else % Non-blocking model
        % Do nothing. Any timeout value is fine as we do not block at all.            
    end
        
    % Open the object
    if ~strcmp(get(udpObj, 'Status'), 'open')
        try
            fopen(udpObj);
        catch %#ok<CTCH>
            error(message('instrument:instrumentblks:portinvalid', blockName));
        end
    end
%endfunction Start

%% Outputs - Generate block outputs at every timestep.
function Outputs(block)
    
    % Parameters: 
    % 1:Remote Address, 
    % 2:Port, 
    % 3:LocalPort,
    % 4:DataSize, 
    % 5:EnableBlockingMode, 
    % 6:Timeout, 
    % 7:SampleTime, 
    % 8:DataType,
    % 9:ByteOrder,
    % 10:GetLatestData,
    % 11:EnablePortSharing,
    % 12:ASCIIFormatting,
    % 13:LocalAddress

    % Get the underlying object. 
    udpObj = get_param(block.BlockHandle, 'UserData');
    
    % Get bytes available
    bytesAvailable  = get(udpObj, 'BytesAvailable');
    
    % If blocking mode, just wait until data is received. 
    if strcmpi(block.DialogPrm(5).Data, 'on')
        if (((bytesAvailable >= block.OutputPort(1).DataStorageSize) && strcmpi(block.DialogPrm(10).Data, 'on')) && ...
                ~strcmpi(block.DialogPrm(8).Data, 'ASCII'))
            % Blocking mode; if enough data in the buffer, return latest data
            data = localGetLatestData(udpObj, block, bytesAvailable);
        else
            % Blocking mode; wait until data is received 
            data = localGetData(udpObj, block);
        end
        if (numel(data) ~= prod(block.DialogPrm(4).Data))
            error(message('instrument:instrumentblks:timeouterror'));
        end
    else
        if (bytesAvailable >= block.OutputPort(1).DataStorageSize)
            if (strcmpi(block.DialogPrm(10).Data, 'on') && ~strcmpi(block.DialogPrm(8).Data, 'ASCII'))
                data = localGetLatestData(udpObj, block, bytesAvailable);
            else
                data = localGetData(udpObj, block);
            end
            block.OutputPort(2).Data = 1; % Set status to 1.
        else % If requested data not available
            data = [];
            block.OutputPort(2).Data = 0; % Set status to 0.
        end
    end
    
    % Reshaping the size. 
    if ~isempty(data)
        if ~isscalar(block.DialogPrm(4).Data)
            data = reshape(data, block.DialogPrm(4).Data);
        end
        if strcmpi(block.DialogPrm(8).Data, 'ASCII')
            block.OutputPort(1).Data = double(data);
        else
            block.OutputPort(1).Data = data;
        end
    end
%endfunction Outputs

%% Terminate - Clean up.
function Terminate(block)

    % Call the terminate method for network objects. 
    instrumentslgate('privateslsfcnterminatenetworkobject', block, 'udp');

%endfunction Terminate

%% localGetData - Return DATA in specified data type.
function data = localGetData(obj, block)
    % Perform a fread for all datatype format except ASCII. Use fscanf for
    % ASCII output data
    if strcmpi(block.DialogPrm(8).Data, 'ASCII')
        [data, ~, msgText] = fscanf(obj, block.DialogPrm(12).Data, ...
            prod(block.DialogPrm(4).Data));
        if contains(msgText, 'timeout occurred')
            error(message('instrument:instrumentblks:timeouterror'));
        elseif (numel(data) ~= prod(block.DialogPrm(4).Data))
            error(message('instrument:instrumentblks:incorrectASCIIRead'));
        elseif ischar(data) || isstring(data)
            error(msgText);
        elseif ~isempty(msgText)
            warning(msgText);
        end
    else
        tempData = fread(obj, prod(block.DialogPrm(4).Data), ...
            block.DialogPrm(8).Data); %#ok<NASGU>
        dataStr = sprintf('%s(tempData)', block.DialogPrm(8).Data);
        data = eval(dataStr);
    end
  
%% localGetLatestData - Return latest DATA in specified data type
function data = localGetLatestData(obj, block, bytesAvailable)
    % Perform a fread for all datatype format except ASCII. Error if trying
    % access latest data with ASCII mode.
    if strcmpi(block.DialogPrm(8).Data, 'ASCII')
        error(message('instrument:instrumentblks:outputlatestdataunavailable'));
    else
        % Calculate the amout of data to read in order to be able to read latest data.
        tempDataToRead = bytesAvailable - ...
            prod(block.DialogPrm(4).Data)*sizeOfDataType(block.DialogPrm(8).Data);
        
        % Read the buffered data
        if tempDataToRead > 0
            tempData = fread(obj, tempDataToRead); %#ok<NASGU>
        end
        
        % Read Latest available data
        data = fread(obj, prod(block.DialogPrm(4).Data), block.DialogPrm(8).Data); %#ok<NASGU>
        dataStr = sprintf('%s(data)', block.DialogPrm(8).Data);
        data = eval(dataStr);
    end
    
%% sizeOfDataType - Return the storage size of data type selected by the user
function storageSize = sizeOfDataType(dataType)
    switch (dataType)
        case {'double'}
            storageSize = 8;
        case {'single' 'uint32' 'int32'}
            storageSize = 4;
        case {'uint16' 'int16'}
            storageSize = 2;
        case {'uint8' 'int8'}
            storageSize = 1;
        otherwise
            error(message('SimulinkTypes:general:InvalidDataType', dataType));
    end