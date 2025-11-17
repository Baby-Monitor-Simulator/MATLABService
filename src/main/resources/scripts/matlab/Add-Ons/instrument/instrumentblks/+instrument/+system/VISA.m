classdef VISA< matlab.System
    % VisaObj = instrument.system.VISA creates a VISA system object to
    % Send, Receive or query comamnds to instrument.

    % Copyright 2023 The MathWorks, Inc

    % Public, non-tunable properties
    properties(Nontunable)

        % Block sample time
        SampleTime = -1;

        %% Hardware Selection and Configuration
        HwConfigOptions = "Select from resource list"
        VendorName = ""
        ModelName = ""
        SlNumber = ""
        Interface = "TCP/IP Socket"

        % Configuration settings
        BoardNumber = 0
        IPAddress = ""
        DeviceID = 0
        Port = 4880

        % Specify resource name
        ResourceString = ""

        % Validate and test connection
        TestCommand = "*IDN?"
        Response = ""

        % Connection properties
        ReadTerminator = "off"
        WriteTerminator = "LF"
        ByteOrder = "little-endian"
        TimeOut = 10
        BaudRate = 9600
        DataBits = "8"
        StopBits = 1;
        Parity = "none"
        FlowControl = "none"
        EOIMode  (1, 1) logical = true

        %% Instrument Initialization
        InitOptions = "No initialization commands"
        SendString = "*RST;*CLS"
        ExecuteFunction = ""

        % Test initialization command
        InitTestCommand = "SYSTem:ERRor?"
        initStatus = ""

        %% Send, Receive and Query
        BlockMode = "Send command"

        % Send command fields
        SendCommandType = "SCPI command"
        StaticCommand = ""
        StaticBinary double
        BinBlockCommand double
        DataType = "uint8"
        Header = ""
        NumFormat = "Integer, signed (%d)"
        CustomNumericFormat = "%2f"
        delimiter = ","

        % Receive response fields
        RxOption = "Read string response and convert to numeric value"
        ResponseHeader = ""
        FormatString = "Integer, signed (%d)"
        CustomFormatString = "%2f"
        ResponseDelimiter = ","
        ReceiveDatatype = "uint8"
        Size = [1 1]
        AutoSize (1, 1) logical = true
        OutputSize = [10000 1]

        %% Check instrument error
        ActionWhenerror = "Stop Simulation"
        Checkerror (1, 1) logical = false
        CheckCommand = "SYSTem:ERRor?"
    end

    properties (Access = private)
        VISACommObj
    end

    properties(Nontunable,DynamicStringSet)
        ResourceName = "<Select a resource name>"
    end

    properties(Hidden)
        % Construct pop-ups in Hardware Configuration tab
        HwConfigOptionsSet = matlab.system.StringSet(["Select from resource list", "Configure new VISA resource", "Specify resource name"])
        ResourceNameSet = matlab.system.StringSet(["<Select a resource name>"])
        ByteOrderSet = matlab.system.StringSet(["big-endian", "little-endian"])
        DataBitsSet = matlab.system.StringSet(["5", "6", "7", "8"])
        ParitySet = matlab.system.StringSet(["none", "even", "odd"])
        FlowControlSet = matlab.system.StringSet(["none", "hardware", "software"])
        InterfaceSet = matlab.system.StringSet(["TCP/IP Socket", "TCP/IP HiSLIP 1", "TCP/IP VXI-11"])

        % Construct pop-ups in Instrument Initialization tab
        InitOptionsSet = matlab.system.StringSet(["No initialization commands", "Initialization commands", "MATLAB Code"])

        % Construct pop-ups in Send or Query tab
        BlockModeSet = matlab.system.StringSet(["Send command", "Query Instrument", "Receive response"])
        SendCommandTypeSet = matlab.system.StringSet(["SCPI command", "Binary","Binblock", "Compose command from input data", "Send input port data as is"])
        FormatStringSet =  matlab.system.StringSet(["Integer, signed (%d)", "Integer, unsigned (%u)", "Floating-point (%f)", "Characters (%c)", "Enter numeric format"])
        NumFormatSet =  matlab.system.StringSet(["Integer, signed (%d)", "Integer, unsigned (%u)", "Floating-point (%f)", "Characters (%c)", "Enter numeric format"])
        RxOptionSet = matlab.system.StringSet(["Read string response and convert to numeric value", "Read string response and output as is", "Read numeric data", "Binblock"])
        DataTypeSet = matlab.system.StringSet(["single", "double", "int8", ...
            "uint8", "int16", "uint16", "int32", "uint32", "uint64", "int64"])
        ReceiveDatatypeSet = matlab.system.StringSet(["single", "double", "int8", ...
            "uint8", "int16", "uint16", "int32", "uint32", "uint64", "int64"])

        % Construct pop-ups in Handle Error tab
        ActionWhenerrorSet = matlab.system.StringSet(["Stop Simulation", "Continue simulation"])
    end

    methods
        % Constructor
        function obj = VISA(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj, nargin, varargin{:})
        end

        % Set.functions() for parameters to validate the dialog value and
        % set the dialog value to underline block parameter or the system
        % object parameter.

        function set.BoardNumber(obj, value)
            validateattributes(value, {'numeric'}, ...
                {'real', 'nonempty', 'nonnan', 'scalar', '>=', 0, 'integer'}, ...
                '', 'Board index');
            obj.BoardNumber = value;
        end

        function set.DeviceID(obj, value)
            if ~isempty(value)
                validateattributes(value, {'numeric'}, ...
                    {'real', 'nonempty', 'nonnan', '>=', 0, 'scalar'}, ...
                    '', 'Device ID');
            end
            obj.DeviceID = value;
        end

        function set.Port(obj, value)
            validateattributes(value, {'numeric'}, ...
                { '>', 0,  '<=', 65535, 'real', 'nonnan', 'integer', 'scalar'}, ...
                '', 'Port')
            obj.Port = value;
        end

        function set.ReadTerminator(obj, value)
            validTermValues = ["off", "CR", "LF", "CR/LF"];
            if ~any(contains(validTermValues, value, "IgnoreCase", true))
                if   ~isscalar(str2num(value))  || (str2num(value) < 0) || str2num(value) > 255 || (floor(str2num(value))~=ceil(str2num(value)))
                    coder.internal.error("instrument:instrumentblks:InvalidReadTerminator");
                end
            end
            obj.ReadTerminator = value;
        end

        function set.WriteTerminator(obj, value)
            validTermValues = ["CR", "LF", "CR/LF"];
            if ~any(contains(validTermValues, value, "IgnoreCase", true))
                if   ~isscalar(str2num(value))  || (str2num(value) < 0) || str2num(value) > 255 || (floor(str2num(value))~=ceil(str2num(value)))
                    coder.internal.error("instrument:instrumentblks:InvalidWriteTerminator");
                end
            end
            obj.WriteTerminator = value;
        end

        function set.BaudRate(obj, value)
            validateattributes(value,{'numeric'}, ...
                { 'scalar', 'positive', 'real', 'nonnan', 'integer'}, ...
                '', 'Baud rate')
            obj.BaudRate = value;
        end

        function set.TimeOut(obj, value)
            validateattributes(value, {'numeric'}, ...
                {'real', 'nonempty', 'nonnan', 'positive', 'scalar'}, ...
                '', 'Timeout');
            obj.TimeOut = value;
        end

        function set.SampleTime(obj, value)
            if iscell(value)
                coder.internal.error('instrument:instrumentblks:invalidReceiveSampleTime');
            end
            if isscalar(value)
                if value < 0 && value ~= -1
                    coder.internal.error('instrument:instrumentblks:invalidReceiveSampleTime');
                elseif value == 0 || isempty(value) || ~isnumeric(value) || any(isnan(value)) || any(isinf(value))
                    coder.internal.error('instrument:instrumentblks:invalidReceiveSampleTime');
                end
            else % Handle cases when user provides initial time offset along with sample time.
                if any((value < 0), 'all') || ~isequal(size(value), [1 2]) || ~isnumeric(value) || any(isnan(value)) || any(isinf(value)) || value(1) == 0
                    coder.internal.error('instrument:instrumentblks:invalidReceiveSampleTime');
                end
            end
            obj.SampleTime = value;
        end

        function set.StaticBinary(obj, value)
            if ~isempty(value)
                validateattributes(value, {'numeric'}, ...
                    { '>=', 0, '<=', 255, 'real', 'nonnan', 'integer', 'row'}, ...
                    '', 'static binary')
            end
            obj.StaticBinary = value;
        end

        function set.BinBlockCommand(obj, value)
            if ~isempty(value)
                validateattributes(value, {'numeric'}, ...
                    { '>=', 0, '<=', 255, 'real', 'nonnan', 'integer', 'row'}, ...
                    '', 'Header')
            end
            obj.BinBlockCommand = value;
        end

        function set.Size(obj, value)
            if ~isempty(value)
                if ~strcmpi(obj.ReceiveDatatype, 'string') %#ok<MCSUP>
                    validateattributes(value, {'numeric'}, ...
                        { '>', 0, 'real', 'nonnan', 'integer', 'row'}, ...
                        '', 'Data size')
                else
                    validateattributes(value, {'numeric'}, ...
                        { '>', 0, 'real', 'nonnan', 'integer', 'row', 'ncols', 1}, ...
                        '', 'Data size')
                end
            end
            obj.Size = value;
        end

        function set.StopBits(obj, value)
            if ismember(real(str2double(obj.DataBits)), [6, 7, 8])
                if (~any(ismember(value,[1, 2])) || ~isscalar(value))
                    coder.internal.error('instrument:instrumentblks:invalidStopbitsDatabits1');
                end
            else
                if ismember(real(str2double(obj.DataBits)), 5)
                    if (~any(ismember(value,[1, 1.5])) || ~isscalar(value))
                        coder.internal.error('instrument:instrumentblks:invalidStopbitsDatabits2');
                    end
                end
            end
            obj.StopBits = value;
        end

        function set.OutputSize(obj, value)
            validateattributes(value, {'numeric'}, ...
                {'real', 'nonempty', 'nonnan', '>=', 0, 'integer'}, ...
                '', 'Data size');
            obj.OutputSize = value;
        end
    end

    methods (Access = protected)

        function num = getNumInputsImpl(obj)
            % Set the number of input ports for the block. Number of input
            % ports depends on the the mode(Send/Receive/Query) in which
            % block is operating and its associated settings.
            if (strcmpi(obj.BlockMode, 'Send command') || strcmpi(obj.BlockMode, 'Query Instrument')) && (strcmpi(obj.SendCommandType, 'Compose command from input data') || ...
                    strcmpi(obj.SendCommandType, 'Send input port data as is'))
                num = 1;
            else
                num = 0;
            end
        end

        function num = getNumOutputsImpl(obj)
            % Set the number of output ports for the block. Number of input
            % ports depends on the the mode(Send/Receive/Query) in which
            % block is operating and its associated settings. If the user
            % enables 'Instrument error check', there will be third port
            % which output the error information reveived from instrument.
            if strcmpi(obj.BlockMode, 'Send command')
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    num = 0;
                    return;
                end
                if obj.Checkerror
                    num = 1;
                else
                    num = 0;
                end
            else
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    num = 1; % Only Output port
                    return;
                end
                if obj.Checkerror
                    num = 3;
                else
                    num = 2;
                end
            end
        end

        function varargout = getOutputSizeImpl(obj)
            % Return output size for Data port
            if strcmpi(obj.BlockMode, 'Send command')
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return;
                end
                if obj.Checkerror
                    varargout{1} = [1 1];
                end
            else
                RxOptionsSizeRequired = ["Read string response and convert to numeric value", "binblock"];
                if strcmpi(obj.RxOption, 'Read numeric data')
                    varargout{1} = obj.Size;
                elseif any(strcmpi(RxOptionsSizeRequired, obj.RxOption))
                    varargout{1} = calculateOutputSize(obj);
                else
                    varargout{1} = [1 1];
                end
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return; % Only 'Output' port.
                end
                varargout{2} = [1 1];
                if obj.Checkerror
                    varargout{3} = [1 1];
                end
            end

        end


        function size = calculateOutputSize(obj)
            if ifDataSizeProvided(obj) % If datasize is provided by user.
                size = obj.OutputSize;
            else
                size  = calculateIfDataSizeNotProvided(obj); % If datasize is not provided by user.
            end
        end

        function sizeAvailable = ifDataSizeProvided(obj)
            sizeAvailable = obj.AutoSize == 0 && ...
                (strcmpi(obj.BlockMode, "Receive response") || strcmpi(obj.BlockMode, "Query Instrument"));
        end

        % If the user does not provide the datasize, we will configure the
        % instrument and obtain a response. Based on the response, we will
        % calculate the datasize. It is important to note that in this
        % scenario, we will lose the first byte of data.
        function  sizeAvailable = calculateIfDataSizeNotProvided(obj)
            configureAndInitializeInstrument(obj)
            if strcmpi(obj.BlockMode, 'Query Instrument')
                sendCommandToInstrument(obj)
                sizeAvailable = receiveResponsefromInstrument(obj);
                sizeAvailable = size(sizeAvailable);
            elseif strcmpi(obj.BlockMode, 'Receive response')
                sizeAvailable = receiveResponsefromInstrument(obj);
                sizeAvailable = size(str2double(sizeAvailable));
            end
            % Clearing the VISA communication object as setupImpl will
            % create another object to connect to same resource. Current
            % visadev implementation does not support creating multiple
            % object to connect to the same resource.
            obj.VISACommObj=[];
        end

        function configureAndInitializeInstrument(obj)
            % Based on the select options, get the correct resource name.
            rsName = getResourceName(obj);
            % Create the visadev object.
            obj.VISACommObj = visadev(rsName);

            % Set connection configuration parameters. Parameters are
            % different for Serial compared with other interfaces.
            if contains(extractBefore(rsName,"::"), "ASRL")
                obj.VISACommObj.BaudRate = obj.BaudRate;
                obj.VISACommObj.DataBits = str2double(obj.DataBits);
                obj.VISACommObj.StopBits = obj.StopBits;
                obj.VISACommObj.Parity = obj.Parity;
                obj.VISACommObj.FlowControl = obj.FlowControl;
            else
                obj.VISACommObj.EOIMode = obj.EOIMode;
            end
            obj.VISACommObj.ByteOrder = obj.ByteOrder;
            obj.VISACommObj.Timeout = obj.TimeOut;
            obj.VISACommObj.configureTerminator(obj.ReadTerminator,obj.WriteTerminator)

            % Do Instrument initialization.
            if strcmpi(obj.InitOptions, "Initialization commands")
                % If user entered multiple SCPI commands, If they are
                % seperated by semicolon, send all commands in one go. If
                % they are seperated by newline,send each scpi command one
                % by one to the instrument.
                initCommands = obj.SendString;
                % SCPI commands will be seperated by semicolon.
                if ~isempty(initCommands)
                    initCommandsString = string(initCommands);
                    initCommandEntries = split(initCommandsString, newline);
                    initCommandDim = size(initCommandEntries);
                    for i = 1:initCommandDim(1)
                        obj.VISACommObj.writeline(initCommandEntries(i));
                    end
                end
            elseif strcmpi(obj.InitOptions, "MATLAB Code") %TODO Enhance so user can specify function name
                % If user enters MATLAB code, evaluate the code.
                mlCommand = obj.ExecuteFunction;
                initCommands = strrep(mlCommand,'visaObj','obj.VISACommObj');
                eval(initCommands);
            end
        end

        function commandSent = sendCommandToInstrument(obj)
            % Check for 'Send command type' and call the corresponding
            % write functions.
            commandSent = 1;
            if strcmpi(obj.SendCommandType, "SCPI command")
                obj.VISACommObj.writeline(obj.StaticCommand);
            elseif strcmpi(obj.SendCommandType, "Binary")
                obj.VISACommObj.write(obj.StaticBinary, obj.DataType);
            elseif strcmpi(obj.SendCommandType, "Binblock")
                obj.VISACommObj.writebinblock(obj.BinBlockCommand, obj.DataType);
            else
                commandSent = 0;
            end
        end

        function data = receiveResponsefromInstrument(obj)

            if strcmpi(obj.RxOption, "Read string response and convert to numeric value")

                % Read instrument response.
                instrRes = obj.VISACommObj.readline();

                % Check if header is present in instrument response.
                headerVal = obj.ResponseHeader;
                if ~isempty(headerVal)
                    if strfind(instrRes,headerVal) ~= 1
                        coder.internal.error('instrument:instrumentblks:invalidHeader');
                    end
                    % Remove header part.
                    strToFormat = erase(instrRes, headerVal);
                else
                    strToFormat = instrRes;
                end

                % Get the format string from dropdown list
                switch obj.FormatString
                    case 'Integer, signed (%d)'
                        RxFormatString = '%d';
                    case 'Integer, unsigned (%u)'
                        RxFormatString = '%u';
                    case 'Floating-point (%f)'
                        RxFormatString = '%f';
                    case 'Characters (%c)'
                        RxFormatString = '%c';
                    case 'Enter numeric format'
                        RxFormatString = obj.CustomFormatString;
                end

                % Construct the format string using delimiter. Append the
                % delimiter to format string.
                finalFormalString = strcat(RxFormatString,obj.ResponseDelimiter);

                % Use sscanf() to format the response.
                formattedValue = sscanf(strToFormat, finalFormalString);

                % Output the formatted value.
                data = transpose(formattedValue);

            elseif strcmpi(obj.RxOption, "Read string response and output as is")
                data = obj.VISACommObj.readline();

            elseif strcmpi(obj.RxOption, "Read numeric data")
                RxData = obj.VISACommObj.read(prod(obj.Size), obj.ReceiveDatatype);
                data = reshape(RxData,obj.Size);

            elseif strcmpi(obj.RxOption, "Binblock")
                data = transpose(obj.VISACommObj.readbinblock(obj.ReceiveDatatype));
                % Flush the extra byte after binblock read
                obj.VISACommObj.flush();
            end
        end

        function varargout = getOutputDataTypeImpl(obj)
            if strcmpi(obj.BlockMode, 'Send command')
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return;
                end
                if obj.Checkerror
                    varargout{1} = 'string';
                end
            else
                doubleRxOptions = ["Read string response and convert to numeric value", "Read numeric data", "binblock"];
                if any(strcmpi(doubleRxOptions, obj.RxOption))
                    varargout{1} = 'double';
                else
                    varargout{1} = 'string';
                end

                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return; % Only 'Output' port.
                end
                varargout{2} = 'logical';
                if obj.Checkerror
                    varargout{3} = 'string';
                end
            end
        end

        function varargout  = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            varargout = {false, false, false};
        end

        function varargout = isOutputFixedSizeImpl(obj)
            if strcmpi(obj.BlockMode, 'Send command')
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return;
                end
                if obj.Checkerror
                    varargout{1} = true;
                end
            else
                if strcmpi(obj.RxOption, 'Read string response and convert to numeric value') || ...
                        strcmpi(obj.RxOption, 'Binblock')
                    varargout{1} = false;
                else
                    varargout{1} = true;
                end
                if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    return; % Only 'Output' port.
                end
                varargout{2} = true;
                if obj.Checkerror
                    varargout{3} = true;
                end
            end

        end

        function sts = getSampleTimeImpl(obj)
            if isequal(obj.SampleTime, -1)
                sts = obj.createSampleTime("Type", "Inherited");
            else
                sts = obj.createSampleTime("Type", "Discrete", ...
                    "SampleTime", obj.SampleTime);
            end
        end

        function setupImpl(obj)
            configureAndInitializeInstrument(obj);
        end

        function rsName = getResourceName(obj)
            % Based on the select options, get the correct resource name.
            if strcmpi(obj.HwConfigOptions, 'Select from resource list')
                if strcmpi(obj.ResourceName, '<Select a resource name>')
                    coder.internal.error('instrument:instrumentblks:noResourceSelected');
                end
                rsName = obj.ResourceName;
            elseif strcmpi(obj.HwConfigOptions, 'Configure new VISA resource')
                switch obj.Interface
                    case 'TCP/IP VXI-11'
                        rsName = sprintf("TCPIP%s::%s::inst%s::INSTR", ...
                            obj.BoardNumber, ...
                            obj.IPAddress, ...
                            obj.DeviceID);
                    case 'TCP/IP Socket'
                        rsName = sprintf("TCPIP%s::%s::%s::SOCKET", ...
                            obj.BoardNumber, ...
                            obj.IPAddress, ...
                            obj.Port);
                    case 'TCP/IP HiSLIP 1'
                        % If port is empty or 4880, the port is not used as
                        % part of the visa identification string.
                        if obj.Port == "" || obj.Port == "4880"
                            rsName = sprintf("TCPIP%s::%s::hislip%s::INSTR", ...
                                obj.BoardNumber, ...
                                obj.IPAddress, ...
                                obj.DeviceID);
                        else
                            rsName = sprintf("TCPIP%s::%s::hislip%s,%s::INSTR", ...
                                obj.BoardNumber, ...
                                obj.IPAddress, ...
                                obj.DeviceID, ...
                                obj.Port);
                        end
                end
            else
                rsName  = obj.ResourceString;
            end
        end

        function varargout = stepImpl(obj, varargin)
            % Handle Send, Query and Receive mode.
            if strcmpi(obj.BlockMode, 'Send command')
                sendCommand();
            elseif strcmpi(obj.BlockMode, 'Receive response')
                receiveResponse();
            elseif strcmpi(obj.BlockMode, 'Query Instrument')
                sendCommand();
                receiveResponse();
            end

            function sendCommand()
                try
                    % Check for 'Send command type' and call the
                    % corresponding write functions.
                    if ~sendCommandToInstrument(obj)
                        if strcmpi(obj.SendCommandType, "Compose command from input data")
                            % Get the format string from dropdown list
                            switch obj.NumFormat
                                case 'Integer, signed (%d)'
                                    formatString = '%d';
                                case 'Integer, unsigned (%u)'
                                    formatString = '%u';
                                case 'Floating-point (%f)'
                                    formatString = '%f';
                                case 'Characters (%c)'
                                    formatString = '%c';
                                case 'Enter numeric format'
                                    formatString = obj.CustomNumericFormat;
                            end
                            % Construct the format string using delimiter.
                            % Append the delimiter to format string.
                            finalFormalString = strcat(formatString,obj.delimiter);

                            % Call sprintf to format the input value.
                            formattedVal = sprintf(finalFormalString, varargin{1});

                            % Construct the final command by appending
                            % formatted value to Header.
                            commandToSend = strcat(obj.Header, formattedVal);

                            % Call writeline() to send the command.
                            obj.VISACommObj.writeline(commandToSend);

                        else
                            %Send input data as it is
                            obj.VISACommObj.writeline(varargin{1});
                        end
                    end
                catch ex
                    instrErrStatus = " ";
                    if obj.Checkerror
                        instrErrStatus = obj.VISACommObj.writeread(obj.CheckCommand);
                    end

                    if strcmpi(obj.ActionWhenerror, "Stop Simulation")
                        if ~isempty(instrErrStatus) && ~contains(instrErrStatus, "No error", 'IgnoreCase',true)
                            coder.internal.error('instrument:instrumentblks:sendCommandFailedWithInstrError', convertCharsToStrings(ex.message), instrErrStatus);
                        else
                            coder.internal.error('instrument:instrumentblks:sendCommandFailed', convertCharsToStrings(ex.message));
                        end
                    else % Continue simulation
                        if strcmpi(obj.BlockMode, 'Send command')
                            varargin{1} = instrErrStatus;
                        end
                    end
                end
            end

            function receiveResponse()
                % Set status port to 'true' by default. If this port
                % returns 1, new data is available to be read.
                if ~strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                    varargout{2} = true;
                end
                try
                    varargout{1} = receiveResponsefromInstrument(obj);
                catch ex
                    instrErrStatus = "";
                    if obj.Checkerror
                        instrErrStatus = obj.VISACommObj.writeread(obj.CheckCommand);
                        % Set instrument error port value if continuing
                        % simulation
                        if strcmpi(obj.ActionWhenerror, 'Continue Simulation')
                            varargout{3} = instrErrStatus;
                        end
                    end
                    % Output error incase of 'Stop Simulation'
                    if strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                        if instrErrStatus ~= "" &&  ~contains(instrErrStatus, "No error", 'IgnoreCase',true) % Show instrument error details if there is instrument error
                            coder.internal.error('instrument:instrumentblks:readAndInstrumentError', convertCharsToStrings(ex.message),instrErrStatus);
                        end
                        % Do not show instrument error details if there is
                        % no instrument error. Show only read error from
                        % visadev()
                        coder.internal.error('instrument:instrumentblks:instrumentReadError', convertCharsToStrings(ex.message));
                    end

                    if strcmpi(obj.RxOption, 'Read string response and convert to numeric value')
                        % Output zero if error occurs
                        varargout{1} = double(0);
                    elseif strcmpi(obj.RxOption, 'Read string response and output as is')
                        varargout{1} = "No data Received";
                    elseif strcmpi(obj.RxOption, 'Read numeric data')
                        varargout{1} = zeros(obj.Size, obj.DataType);
                    else % binblock
                        varargout{1} = double(0);
                    end
                    if ~strcmpi(obj.ActionWhenerror, 'Stop Simulation')
                        varargout{2} = false;
                    end
                end
                if strcmpi(obj.ActionWhenerror, 'Continue Simulation')
                    varargout{3} = obj.VISACommObj.writeread(obj.CheckCommand); % Check for instrument error even if read() is success
                end
            end
        end
    end

    methods (Access = protected, Static)
        function simMode = getSimulateUsingImpl
            % Return only allowed simulation mode in System block dialog
            simMode = "Interpreted execution";
        end

        function flag = showSimulateUsingImpl
            % Return false if simulation mode hidden in System block dialog
            flag = false;
        end
    end
end
