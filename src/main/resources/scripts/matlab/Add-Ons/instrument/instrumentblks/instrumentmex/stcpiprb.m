function stcpiprb(block)
%STCPIPRB Underlying S-Function for the ICT TCPIP Receive block. 
%
%    STCPIPRB(BLOCK) is the underlying S-Function for the ICT TCPIP Receive
%    block. 

%    Copyright 2007-2018 The MathWorks, Inc.
  

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
    % 1:Host, 
    % 2:Port, 
    % 3:DataSize, 
    % 4:EnableBlockingMode, 
    % 5:Timeout, 
    % 6:SampleTime, 
    % 7:DataType,
    % 8:ByteOrder,
    % 9:ASCIIFormatting,
    % 10:Terminator

    % Register number of ports
    if strcmpi(block.DialogPrm(4).Data, 'on')
      block.NumOutputPorts = 1;
    else
      block.NumOutputPorts = 2;
    end

    % Register parameters
    block.NumDialogPrms = 10;
    block.DialogPrmsTunable = {'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', ...
                             'Nontunable', 'Nontunable', 'Nontunable', 'Nontunable'};

    % Check if variable entered for sample time is defined. This lets the
    % user set a sample time variable that is not yet defined in any
    % workspace. If the user tries to run the program without defining it,
    % Simulink will produce the required error message. If the variable is
    % defined before runtime, it will be used.
    if ~isempty(block.DialogPrm(6).Data)        
        % Register sample times
        block.SampleTimes = [block.DialogPrm(6).Data 0];
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
    block.OutputPort(1).Dimensions = block.DialogPrm(3).Data;

    % If there are two ports, set the second one too. 
    if (block.NumOutputPorts == 2)
        block.OutputPort(2).Dimensions = 1; % Size is 1.
    end
%endfunction SetOutputPortDims

%% SetOutputPortDataType - Check and set output port datatypes
function SetOutputPortDataType(block)

    % Set the output port properties.
    if strcmpi(block.DialogPrm(7).Data, 'ASCII')
        % If the data steam to be parsed is ASCII make the output data type
        % as double. This follows suit from Query and To instrument blocks.
        block.OutputPort(1).DatatypeID = 0;
    else
        block.OutputPort(1).DatatypeID = tamslgate('privateslgetdatatypeid', ...
            block.DialogPrm(7).Data);
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

    % Get the block name.
    blockName = get_param(block.BlockHandle, 'Name');
    
    % Check if the host specified is empty/invalid.
    [name, address] = resolvehost(block.DialogPrm(1).Data);
    if isempty(name) && isempty(address) % Error out if empty.
        error(message('instrument:instrumentblks:hostinvalid'));
    end
        
    % Find if any underlying objects exist with the same host and 
    % port.
    inputParams = {'tcpip' block.DialogPrm(1).Data , block.DialogPrm(2).Data, ... 
                   'ByteOrder', block.DialogPrm(8).Data};
    tcpipObj = instrumentslgate('privateslsfcncreatenetworkobject', ...
                            block, inputParams);
    
    % Set the UserData field for the block so that it stays persistent 
    % during the simulation. 
    set_param(block.BlockHandle, 'UserData', tcpipObj)
    
    % Set user defined Terminator is data type selected is ASCII, empty
    % otherwise.
    if strcmpi(block.DialogPrm(7).Data, 'ASCII')
        if isnan(str2double(block.DialogPrm(10).Data))
            set(tcpipObj, 'Terminator', block.DialogPrm(10).Data);
        else
            set(tcpipObj, 'Terminator', str2double(block.DialogPrm(10).Data));
        end
    else
        set(tcpipObj, 'Terminator', '');
    end
    
    % Set the Input buffer size on the object.
    isErr = instrumentslgate('privateslsetinputbuffersize', tcpipObj, block);
    
    if isErr % Error if input buffer size cannot be set.
        error(message('instrument:instrumentblks:bufferError', blockName));
    end
    
    % Set the timeout value on the object. 
    if strcmpi(block.DialogPrm(4).Data, 'on') % Blocking mode
        if (block.DialogPrm(5).Data > tcpipObj.Timeout) % Check if required timeout is more.
            % Wait for asynchronous write to get over before closing. 
            while (get(tcpipObj, 'BytesToOutput') ~= 0)
                % Just wait until previous async fwrite is complete.
                pause(0.01);
            end
            tcpipObj.Timeout = block.DialogPrm(5).Data;
        end
    else % Non-blocking model
        % Do nothing. Any timeout value is fine as we do not block at all.
    end
        
    % Open the object
    if ~strcmp(get(tcpipObj, 'Status'), 'open') %Check if already open.
        try %Try opening the object.
            fopen(tcpipObj);
        catch %#ok<CTCH>
            % Display error that port is invalid. 
            error(message('instrument:instrumentblks:portinvalid', blockName));
        end
    end
%endfunction Start

%% Outputs - Generate block outputs at every timestep.
function Outputs(block)
    
    % Parameters: 
    % 1:Host, 
    % 2:Port, 
    % 3:DataSize, 
    % 4:EnableBlockingMode, 
    % 5:Timeout, 
    % 6:SampleTime, 
    % 7:DataType,
    % 8:ByteOrder,
    % 9:ASCIIFormatting

    % Get the underlying TCPIP object. 
    tcpipObj = get_param(block.BlockHandle, 'UserData');
    
    % If blocking mode, just wait until data is received. 
    if strcmpi(block.DialogPrm(4).Data, 'on')
        data = localGetData(tcpipObj, block);
        if (numel(data) ~= prod(block.DialogPrm(3).Data))
            error(message('instrument:instrumentblks:timeouterror'));
        end
    else
        bytesAvailable  = get(tcpipObj, 'BytesAvailable');
        if (bytesAvailable >= block.OutputPort(1).DataStorageSize)
            data = localGetData(tcpipObj, block);
            block.OutputPort(2).Data = 1; % Set status to 1.
        else % If requested data not available
            data = [];
            block.OutputPort(2).Data = 0; % Set status to 0.
        end
    end
    
    % Reshaping the size. 
    if ~isempty(data)
        if ~isscalar(block.DialogPrm(3).Data)
            data = reshape(data, block.DialogPrm(3).Data);
        end
        if strcmpi(block.DialogPrm(7).Data, 'ASCII')
            block.OutputPort(1).Data = double(data);
        else
            block.OutputPort(1).Data = data;
        end
    end
%endfunction
%% Terminate - Clean up.
function Terminate(block)

    % Call the terminate method for network objects. 
    instrumentslgate('privateslsfcnterminatenetworkobject', block, 'tcpip');

%endfunction Terminate

%% localGetData - Return DATA in specified data type. 
function data = localGetData(obj, block)
    % Perform a fread for all datatype format except ASCII. Use fscanf for
    % ASCII output data
    if strcmpi(block.DialogPrm(7).Data, 'ASCII')
        [data, ~, msgText] = fscanf(obj, block.DialogPrm(9).Data, ...
            prod(block.DialogPrm(3).Data));
        if contains(msgText, 'timeout occurred')
            error(message('instrument:instrumentblks:timeouterror'));
        elseif (numel(data) ~= prod(block.DialogPrm(3).Data))
            error(message('instrument:instrumentblks:incorrectASCIIRead'));
        elseif ischar(data) || isstring(data)
            error(msgText);
        elseif ~isempty(msgText)
            warning(msgText);
        end
    else
        % Perform fread of specified size and precision.
        tempData = fread(obj, prod(block.DialogPrm(3).Data), ...
            block.DialogPrm(7).Data); %#ok<NASGU>
        dataStr = sprintf('%s(tempData)', block.DialogPrm(7).Data);
        % Convert to required data type.
        data = eval(dataStr);
    end

%endlocalfunction localGetData.