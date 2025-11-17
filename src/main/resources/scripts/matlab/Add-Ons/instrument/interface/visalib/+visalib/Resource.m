classdef Resource < matlabshared.testmeas.internal.SetGet & ... % implies handle
                    matlab.mixin.Heterogeneous & ...
                    matlabshared.testmeas.CustomDisplay & ...
                    matlabshared.transportlib.internal.compatibility.LegacyVisa & ...
                    matlabshared.testmeas.internal.mixins.CacheEnabler & ...
                    matlabshared.transportlib.internal.TagAccessor
    %RESOURCE Class representing a VISA resource

    % Copyright 2020-2023 The MathWorks, Inc.

    properties (Dependent)
        ByteOrder
        Terminator
        Timeout

        ErrorOccurredFcn

        UserData
    end

    properties(Dependent, SetAccess = private)
        NumBytesWritten
    end

    properties(Dependent, Hidden)
        TransferPeriod (1, 1) double
        TransferSize (1, 1) uint64
    end

    properties(Dependent, Hidden, SetAccess = private)
        % Starting in R2022a, visadev no longer supports NumBytesAvailable.
        NumBytesAvailable
    end

    properties(Dependent, Hidden)
        % Starting in R2022a, visadev no longer supports BytesAvailableFcnMode.
        BytesAvailableFcnMode
        % Starting in R2022a, visadev no longer supports BytesAvailableFcnCount.
        BytesAvailableFcnCount
        % Starting in R2022a, visadev no longer supports BytesAvailableFcn.
        BytesAvailableFcn        
    end    

    %% Read-only properties

    properties (SetAccess = protected)
        % Name of the VISA vendor used to access the Resource
        PreferredVisa string
    end

    properties(Hidden, SetAccess = protected)
        % Class of VISA resource (supported types are INSTR and SOCKET)
        ResourceClass (1, 1) string = "INSTR"
        Connected = false
    end

    properties (SetAccess = private)
        % VISA Resource name
        ResourceName (1, 1) string

        % VISA alias for the resource name
        Alias (1, 1) string

        % Instrument vendor name
        Vendor (1, 1) string

        % Instrument model
        Model (1, 1) string

        % Hardware serial number
        SerialNumber (1, 1) string

        % Type of VISA interface represented by the resource
        Type (1, 1) visalib.InterfaceType
    end

    properties (Constant, Hidden)
        ObjectType = "visadev"
    end

    %% Lifetime
    methods (Hidden)
        function obj = Resource(info, synchronousRead)
            arguments
                info (1, 1) visalib.internal.ResourceInfo
                synchronousRead (1, 1) logical = false
            end

            % Initialize the client
            % Initialize the resource
            % Connect to the client
            % Set up the custom display

            mode = visalib.internal.TestModeManager.getTestMode();
            p = initProperties(obj, mode, string(info.Type));
            p.CallbackSource = obj;
            obj.Client = visalib.internal.VisaClient(p);
            obj.SynchronousRead = synchronousRead;

            obj.initResource(info);
            obj.connect();

            % Ensure that caches are set the first time these properties
            % are queried.
            obj.TermCharEnableToggled = true;
            obj.SuppressEndEnableToggled = true;

            % Custom Display
            obj.PropertyGroupList = obj.getGroupList();
            obj.PropertyGroupNames = strings(1, length(obj.PropertyGroupList));

            function p = initProperties(callbackSource, mode, visaType)
                p = matlabshared.transportlib.internal.client.PropertiesFactory.getInstance("channel");

                % Client Properties
                p.InterfaceName = ["visadev", visaType];
                p.InterfaceObjectName = "v";
                p.CallbackSource = callbackSource;
                p.PrecisionRequired = false;
                p.ErrorRegistry = [];

                pluginInfo = visalib.internal.ResourceManager.getPluginInfo();

                p.DevicePlugin = pluginInfo.DevicePluginPath;
                p.ConverterPlugin = pluginInfo.ConverterPluginPath;
                p.EventHandler = [];

                p.AsyncIOOptions = struct('Mode', string(mode));
                p.InputBufferSize = inf;
                p.OutputBufferSize = inf;
            end
        end

        function delete(obj)
            obj.disconnect();
        end
    end

    %% Getters and Setters (from Generic)
    methods
        %% Getters
        function value = get.ByteOrder(obj)
            value = string(getProperty(obj.Client, "ByteOrder"));
        end

        function value = get.Terminator(obj)
            value = getProperty(obj.Client, "Terminator");
            if obj.ReadTerminatorDisabled
                value{1} = "off";
            end
        end

        function value = get.Timeout(obj)
            if visalib.internal.TestModeManager.getTestMode == ...
               visalib.internal.VISAMode.Normal && obj.SynchronousRead 
                value = obj.getInputOutputTimeout/1000;
            else
                value = getProperty(obj.Client, "Timeout");
            end
        end

        function value = get.NumBytesAvailable(obj)
            value = getAsyncProperty(obj, "NumBytesAvailable");
        end

        function value = get.NumBytesWritten(obj)
            value = getProperty(obj.Client, "NumBytesWritten");
        end

        function value = get.BytesAvailableFcnMode(obj)
            value = getAsyncProperty(obj, "BytesAvailableFcnMode");
        end

        function value = get.BytesAvailableFcnCount(obj)
            value = getAsyncProperty(obj, "BytesAvailableFcnCount");
        end

        function value = get.BytesAvailableFcn(obj)
            value = getAsyncProperty(obj, "BytesAvailableFcn");
        end

        function value = get.ErrorOccurredFcn(obj)
            value = getProperty(obj.Client, "ErrorOccurredFcn");
        end

        function value = get.UserData(obj)
            value = getProperty(obj.Client, "UserData");
        end

        %% Setters
        function set.ByteOrder(obj, value)
            try
                setProperty(obj.Client, "ByteOrder", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.Terminator(obj, value)
            try
                setProperty(obj.Client, "Terminator", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.Timeout(obj, value)
            try
                % Always set the property, as is (this will error if the
                % value is improperly formatted or typed).
                setProperty(obj.Client, "Timeout", value);

                if visalib.internal.TestModeManager.getTestMode == ...
                   visalib.internal.VISAMode.Normal && obj.SynchronousRead
                    obj.setTimeoutNormal(value);
                    % VISA      timeout is in ms 
                    % MATLAB    timeout is in s
                    actualTimeout = obj.VisaWriteTimeout/1000;
                    setProperty(obj.Client, "Timeout", actualTimeout);
                end                
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.BytesAvailableFcnMode(obj, value)
            try
                setAsyncProperty(obj, "BytesAvailableFcnMode", value);
            catch e
                throwAsCaller(e)
            end
        end

        function set.BytesAvailableFcnCount(obj, value)
            try
                setAsyncProperty(obj, "BytesAvailableFcnCount", value);
            catch e
                throwAsCaller(e)
            end                
        end

        function set.BytesAvailableFcn(obj, value)
            try
                setAsyncProperty(obj, "BytesAvailableFcn", value);
            catch e
                throwAsCaller(e)
            end
        end

        function set.ErrorOccurredFcn(obj, value)
            try
                setProperty(obj.Client, "ErrorOccurredFcn", value);
            catch ex
                throwAsCaller(ex);
            end
        end

        function set.UserData(obj, value)
            setProperty(obj.Client, "UserData", value);
        end
    end

    %%% Getters and Setters (Internal)
    methods
        function value = get.TransferPeriod(obj)
            value = obj.CurrentTransferPeriod;
        end

        function value = get.TransferSize(obj)
            value = obj.CurrentTransferSize;
        end

        function value = get.NumBytesAvailableInternal(obj)
            value = getProperty(obj.Client, "NumBytesAvailable");
        end

        function set.TransferPeriod(obj, value)
            arguments
                obj
                value (1, 1) {mustBeNumeric, mustBePositive}
            end

            obj.CurrentTransferPeriod = value;
            obj.setTransferPeriod(value);
        end        

        function set.TransferSize(obj, value)
            arguments
                obj
                value (1, 1) {mustBeInteger, mustBePositive}
            end

            obj.CurrentTransferSize = value;
            obj.setTransferSize(obj.CurrentTransferSize);
        end
    end

    %% Standard methods (from Generic)
    methods
        function data = read(obj, varargin)
            %READ Read data from a VISA resource.
            %
            %   DATA = READ(OBJ,COUNT) Reads the specified number of bytes
            %   from the VISA resource.
            %
            %   DATA = READ(OBJ,COUNT,DATATYPE) reads the specified
            %   number of values with the specified data type from the
            %   VISA resource. Valid data types are "char",
            %   "string", "uint8", "int8", "uint16", "int16", "uint32",
            %   "int32", "uint64", "int64", "single", and "double".
            %
            %   Note: For numeric data types, DATA is represented as a
            %   DOUBLE array in row format. For char and string data
            %   types, DATA is represented as is.
            %
            %   Note: the read terminator is ignored during the read
            %   operation.
            %
            % Example:
            %      % Read five bytes from device.
            %      data = read(v,5);
            %
            %      % Read five uint32 values from device.
            %      data = read(v,5,"uint32");
            %
            %      % Read five characters from device.
            %      data = read(v,5,"char");
            %
            % See also write, readline, writeline
            try
                obj.setTimeoutCached(obj.VisaReadTimeout);

                if nargin == 1
                    % do nothing: calling read with 0 arguments will error
                elseif obj.SynchronousRead
                    numValues = varargin{1};
    
                    if nargin == 3
                        datatype = varargin{2};
                    else
                        datatype = "uint8";
                    end

                    % Read should not respond to the presence of
                    % terminating characters in the data.

                    % Heed the terminating character or not?
                    termCharEnable = obj.getTermCharEnabled();

                    if termCharEnable
                        obj.disableVisaTerminator();
                        numBytes = getNumBytesToRead(numValues, datatype);
                        obj.Client.initiateReadSync(numBytes);
                        obj.enableVisaTerminator();
                    else
                        numBytes = getNumBytesToRead(numValues, datatype);
                        obj.Client.initiateReadSync(numBytes);
                    end
                end
                
                data = read(obj.Client, varargin{:});
            catch ex
                ex = visalib.internal.ErrorProxy.translateVisaException(ex);
                throwAsCaller(ex);
            end
        end

        function data = readline(obj, varargin)
            %READLINE Read terminated ASCII string data from the VISA
            %resource. 
            %
            %  DATA = READLINE(OBJ) reads until the first occurrence of the
            %         terminator and returns the data back as a STRING.
            %         This function waits until the terminator is reached
            %         or a timeout occurs. The returned data does not
            %         include the terminator.
            %
            %   Note: to read data terminated only using an END message,
            %   set EOIMode to "true" and configure the read terminator to
            %   "off".
            %
            % Example:
            %      % Read a string value until a terminator is reached.
            %      data = readline(v);
            %
            % See also writeline, read, write
            try
                obj.setTimeoutCached(obj.VisaReadTimeout);
                                
                if obj.SynchronousRead
                    obj.Client.initiateReadlineSync();
      
                    % If END message is enabled and the termination
                    % character is not enabled, then the driver is
                    % configured to fetch data that might contain
                    % terminators ("multi-line data"). In this case, ask
                    % the client to read all the samples available in the
                    % buffer.
                    %
                    % If the termination character is enabled (irrespective
                    % of whether the END message is enabled), then it is
                    % safe to ask the client for to read a line of data
                    %
                    % If neither the END message is enabled nor the
                    % termination character enabled, then the client will 
                    % time out.
                
                    endEnabled = ~obj.getSuppressEndEnabled;
                    termCharEnabled = obj.getTermCharEnabled;

                    n = obj.NumBytesAvailableInternal;
                    if endEnabled && ~termCharEnabled && n ~= 0
                        data = read(obj.Client, n, "string");
                    else
                        data = readline(obj.Client, varargin{:});
                    end
                else
                    data = readline(obj.Client, varargin{:});
                end                
            catch ex
                ex = visalib.internal.ErrorProxy.translateVisaException(ex);
                throwAsCaller(ex);
            end
        end

        function write(obj, varargin)
            %WRITE Write data to the VISA resource.
            %
            %   WRITE(OBJ,DATA) writes the given data to the VISA resource.
            %   All data values must be representable as an uint8.
            %
            %   WRITE(OBJ,DATA,DATATYPE) writes the given data of the
            %   specified data type to the VISA resource. Valid
            %   precisions are "char", "string", "uint8", "int8", "uint16",
            %   "int16", "uint32", "int32", "uint64", "int64", "single" and
            %   "double".
            %
            % Example:
            %      % Write an array of five bytes to the device.
            %      write(v,1:5);
            %
            %      % Write an array of five uint16 values to the device.
            %      write(v,301:305,"uint16");
            %
            % See also read, readline, writeline
            try
                transferWasInProgress = obj.TransferInProgress;

                % Disable read transfer
                obj.stopTransferWhen(transferWasInProgress);
                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaWriteTimeout);
                end

                write(obj.Client, varargin{:});

                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaReadTimeout);
                end

                obj.restartTransferIf(transferWasInProgress);
            catch ex
                obj.restartTransferIf(transferWasInProgress);
                throwAsCaller(ex);
            end
        end

        function writeline(obj, varargin)
            %WRITELINE Write ASCII data followed by the terminator to the
            %VISA resource.
            %
            %   WRITELINE(OBJ,DATA) writes the ASCII data, DATA, followed
            %   by the terminator, to the VISA resource.
            %
            % Input Arguments:
            %   DATA is the ASCII data that is written to the VISA resource. This
            %   DATA is always followed by the write terminator character(s).
            %
            % Notes:
            %   WRITELINE waits until the ASCII DATA followed by terminator
            %   is written to the VISA resource.
            %
            % Example:
            %      % Writes "*IDN?" and add the terminator to the end of
            %      % the line before writing to the VISA resource.
            %      writeline(v,"*IDN?");
            %
            % See also readline, read, write

            try
                transferWasInProgress = obj.TransferInProgress;

                % Disable read transfer
                obj.stopTransferWhen(transferWasInProgress);
                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaWriteTimeout);
                end                

                writeline(obj.Client, varargin{:});
                
                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaReadTimeout);
                end

                obj.restartTransferIf(transferWasInProgress);
            catch ex
                obj.restartTransferIf(transferWasInProgress);
                throwAsCaller(ex);
            end
        end

        function configureTerminator(obj, varargin)
            %CONFIGURETERMINATOR Set the Terminator property for
            % ASCII-terminated string communication.
            %
            % CONFIGURETERMINATOR(OBJ,TERMINATOR) - Sets both read and
            % write terminators to the specified terminator value. If
            % TERMINATOR is 'off' or "off", configures read operations to
            % ignore termination characters (see VI_ATTR_TERMCHAR_EN).
            %
            % CONFIGURETERMINATOR(OBJ,READTERMINATOR,WRITETERMINATOR) -
            % Sets the read terminator to READTERMINATOR and the write
            % terminator to WRITETERMINATOR. Both values are stored as a
            % cell array in the Terminator property of the VISA object.
            %
            % Example:
            %      % Set both read and write terminators to "CR/LF".
            %      configureTerminator(v,"CR/LF")
            %
            %      % Set read terminator to "CR" and write terminator to
            %      % ASCII value of 10.
            %      configureTerminator(v,"CR",10)
            %
            %      % Configure read operations to ignore termination
            %      % characters
            %      configureTerminator(v,"off")
            %
            %      % Configure read operations to ignore termination
            %      % characters and the write terminator to "CR"
            %      configureTerminator(v,"off","CR")            
            %
            % See also readline, writeline

            % configureTerminator('') or configureTerminator("") =>
            % ignore termination characters during read operations

            try 
                narginchk(2,3)
            catch
                % A nested try-catch is required in order to obtain the
                % expected error message, for the wrong number of input
                % arguments, from the client.
                try
                    configureTerminator(obj.Client, varargin{:})
                catch ex
                    throwAsCaller(ex);
                end
            end

            t = convertCharsToStrings(varargin{1});
            if isstring(t) && ~iscell(t) && lower(t(1)) == "off"
                obj.ReadTerminatorDisabled = false;
                disableVisaTerminator(obj);
                [readTerm, writeTerm] = getTerminators(obj.Terminator);

                if nargin == 3
                    writeTerm = varargin{2};
                end

                configureTerminator(obj.Client, readTerm, writeTerm);
                obj.ReadTerminatorDisabled = true;
                return
            end

            try
                obj.ReadTerminatorDisabled = false;
                configureTerminator(obj.Client, varargin{:});

                if iscell(obj.Terminator)
                    value = obj.Terminator{1,2};
                else
                    value = obj.Terminator;
                end

                % For pairs of terminators, only keep the final terminator
                value = convertStringsToChars(value);
                if ischar(value)
                    switch value
                        case {'CR/LF', 'LF'}
                            value = uint8(10);
                        case {'LF/CR', 'CR'}
                            value = uint8(13);
                    end
                else
                    % Assumption: configureTerminator performs validation
                    value = uint8(value);
                end

                setVisaTerminator(obj, value);
                enableVisaTerminator(obj);
            catch ex
                throwAsCaller(ex);
            end

            function [readTerminator, writeTerminator] = getTerminators(terminators)
                if iscell(terminators)
                    readTerminator = terminators{1};
                    writeTerminator = terminators{2};
                else
                    readTerminator = terminators;
                    writeTerminator = terminators;
                end
            end
        end

        function flush(obj, varargin)
            %FLUSH Flush the input buffer, output buffer, or both.
            %
            % FLUSH(OBJ) clears both the input and output buffers.
            %
            % FLUSH(OBJ,BUFFER) clears the specified buffer.
            %
            % Example:
            %      % Flush the input buffer.
            %      flush(v,"input");
            %
            %      % Flush the output buffer.
            %      flush(v,"output");
            %
            %      % Flush both the input and output buffers.
            %      flush(v);
            %
            % See also read, write, readline, writeline, configureCallback
            try
                % Only flush hardware when it is safe to do so (hardware
                % flush indiscriminately flushes input/output buffers).
                if nargin == 1
                    transferWasInProgress = obj.TransferInProgress;
                    obj.stopTransferWhen(transferWasInProgress);
                    obj.flushDeviceHook();
                    obj.restartTransferIf(transferWasInProgress);
                end

                flush(obj.Client, varargin{:});
            catch ex
                throwAsCaller(ex);
            end
        end
    end

    methods
        function data = readbinblock(obj, varargin)
            %READBINBLOCK Read one binblock of data from the VISA resource.
            %
            %   DATA = READBINBLOCK(OBJ) reads the binblock data as UINT8
            %   and returns to DATA
            %
            %   DATA = READBINBLOCK(OBJ, DATATYPE) reads the binblock data
            %   as DATATYPE type. For numeric DATATYPE types DATA is
            %   returned as a row vector of doubles.
            %   For char and string DATATYPE types, DATA is returned as a
            %   character vector or string scalar, as specified.
            %
            % Input Arguments:
            %   DATATYPE indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   DATATYPE must be one of "uint8", "int8", "uint16", "int16",
            %   "uint32", "int32", "uint64", "int64", "single", "double",
            %   "char", or "string".
            %
            %   Default DATATYPE: "uint8"
            %
            % Output Arguments:
            %   DATA is a 1xN matrix of numeric or ASCII data. If no data
            %   was returned this is an empty array.
            %
            % Notes:
            %   READBINBLOCK waits until a binblock is read from the
            %   VISA resource.
            %
            % Example:
            %      % Read the raw bytes in the binblock as uint8 and
            %      % represent them as a double array in row format.
            %      data = readbinblock(v);
            %
            %      % Read the raw bytes in the binblock as uint16 and
            %      % represent them as a double array in row format.
            %      data = readbinblock(v,"uint16")
            %
            % See also writebinblock
            try
                obj.setTimeoutCached(obj.VisaReadTimeout);

                if obj.SynchronousRead
                    % Readbinblock should not respond to the presence of
                    % terminating characters in the data.

                    % Heed the terminating character or not?
                    termCharEnable = obj.getTermCharEnabled();

                    if termCharEnable
                        obj.disableVisaTerminator();
                        obj.Client.initiateReadBinblockSync();
                        obj.enableVisaTerminator();
                    else
                        obj.Client.initiateReadBinblockSync();
                    end                    
                end
                
                data = readbinblock(obj.Client, varargin{:});
            catch ex
                ex = visalib.internal.ErrorProxy.translateVisaException(ex);
                throwAsCaller(ex);
            end
        end

        function writebinblock(obj, varargin)
            %WRITEBINBLOCK Write one binblock of data to the VISA resource.
            %
            %   WRITEBINBLOCK(OBJ,DATA,DATATYPE) writes DATA to the
            %   VISA resource using the binblock protocol (IEEE 488.2
            %   Definite Length Arbitrary Block Response Data). The data is
            %   cast to the specified data type DATATYPE regardless of the
            %   data type of DATA.
            %
            %   WRITEBINBLOCK(OBJ,DATA,DATATYPE,HEADER) writes DATA to the
            %   VISA resource using the binblock protocol (IEEE 488.2
            %   Definite Length Arbitrary Block Response Data). The data is
            %   cast to the specified data type DATATYPE regardless of the
            %   data type of DATA. The HEADER is prepended to the binblock
            %   before writing.
            %
            % Input Arguments:
            %   DATA is a 1xN matrix of numeric or ASCII data.
            %
            %   DATATYPE indicates the number of bits read for each value
            %   and the interpretation of those bits as a MATLAB data type.
            %   DATATYPE must be one of "uint8", "int8", "uint16", "int16",
            %   "uint32", "int32", "uint64", "int64", "single", "double",
            %   "char", or "string".
            %
            %   HEADER is the optional custom header to prepend to the
            %   binblock before writing. HEADER must be an ASCII string.
            %
            % Notes:
            %   WRITEBINBLOCK waits until the requested number of values
            %   are written to the VISA resource.
            %
            % Example:
            %      % Write 1, 2, 3, 4, 5 as uint8 values (5*1 = 5 bytes
            %      total) % to the VISA resource.
            %      writebinblock(v,1:5,"uint8");
            %
            %      % Write 1, 2, 3, 4, 5 as uint8 values (5*1 = 5 bytes
            %      % total) to the VISA resource with the custom header
            %      % "MyHeader" prepended to the binblock packet before
            %      % writing.
            %      writebinblock(v,1:5,"uint8","MyHeader");
            %
            % See also readbinblock

            try
                transferWasInProgress = obj.TransferInProgress;

                % Disable read transfer
                obj.stopTransferWhen(transferWasInProgress);
                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaWriteTimeout);
                end 

                writebinblock(obj.Client, varargin{:});

                if ~obj.SynchronousRead
                    obj.setInputOutputTimeout(obj.VisaReadTimeout);
                end

                obj.restartTransferIf(transferWasInProgress);
            catch ex
                obj.restartTransferIf(transferWasInProgress);
                throwAsCaller(ex);
            end
        end

        function response = writeread(obj, command)
            %WRITEREAD Write ASCII-terminated string to VISA
            %resource and read back an ASCII-terminated string.
            %This function can be used to query an instrument connected to
            %the VISA resource.
            %
            %   RESPONSE = WRITEREAD(OBJ,COMMAND) writes COMMAND
            %   followed by the write terminator to the VISA resource. It
            %   reads back RESPONSE from the VISA resource, which is an
            %   ASCII-terminated string, and returns RESPONSE after
            %   removing the read terminator.
            %
            % Input Arguments:
            %   COMMAND is the terminated ASCII data that is written to the
            %   VISA resource.
            %
            % Output Arguments:
            %   RESPONSE is the terminated ASCII data that is returned back
            %   from the VISA resource.
            %
            % Notes:
            %   WRITEREAD waits until the ASCII-terminated command is
            %   written and an ASCII-terminated response is returned from
            %   the VISA resource.
            %
            % Example:
            %      % Query the VISA resource for a response by sending the
            %      % "*IDN?" command.
            %      response = writeread(s,"*IDN?");
            %
            %
            % See also readline, writeline
            try
                % Don't call writeread directly (see g2350109)
                obj.Client.enableErrorOnRead();

                obj.writeline(command);
                response = obj.readline();
                
                obj.Client.disableErrorOnRead();                
            catch ex
                switch (ex.identifier)
                    case 'transportclients:string:timeoutToken'
                        ex = visalib.internal.ErrorProxy.getVisaException("terminatorTimeout");
                end
                obj.Client.disableErrorOnRead();
                throwAsCaller(ex);
            end
        end
    end

    methods (Hidden)
        function configureCallback(obj, varargin)
            % Starting in R2022a, visadev no longer supports configureCallback.
            if obj.SynchronousRead
                ex = visalib.internal.ErrorProxy.getVisaException(...
                            "MethodNotSupportedForVISA", ...
                            "configureCallback");
                throwAsCaller(ex);
            else
                try
                    configureCallback(obj.Client, varargin{:});
                catch ex
                    throwAsCaller(ex);
                end
            end
        end
    end

    %% VISA methods
    methods (Sealed)
        function [ready, status] = visastatus(obj)
            %VISASTATUS Check whether a resource requested service.
            %
            %   [READY] = VISASTATUS(OBJ) returns READY, which is true if
            %   the resource requested service.
            %
            %   [READY,STATUS] = VISASTATUS(OBJ) returns READY and STATUS,
            %   which is service request (SRQ) status byte.
            %
            % Example:
            %      % Check whether the resource requested service.
            %      ready = visastatus(v);
            %
            %      % Check the service request status byte
            %      [~,status] = visastatus(v);

            arguments
                obj (1, 1) visalib.Resource
            end

            try
                [ready, status] = readStatusByte(obj.Client, obj.ResourceName);
            catch ex
                switch ex.identifier
                    case 'instrument:interface:visa:inconsistentAttributeState'
                        ex = visalib.internal.ErrorProxy.getVisaException(...
                            "visaStatusUnavailableAsConfigured",...
                            obj.ResourceName);
                end

                throwAsCaller(ex);
            end
        end
    end

    methods (Hidden, Sealed)
        function setTransferPeriod(obj, period)
            %SETTRANSFERPERIOD Determines how often to check for data from
            %the resource
            %
            %   SETTRANSFERPERIOD(OBJ, PERIOD) sets how often to check for
            %   new data (in seconds)

            arguments
                obj (1, 1) visalib.Resource
                period (1, 1) double
            end

            try
                setTransferPeriod(obj.Client, period);
            catch ex
                throwAsCaller(ex);
            end
        end

        function setTransferSize(obj, numSamples)
            %SETTRANSFERSIZE Determines the maximum amount of data to send
            %back every transfer period
            %
            %   SETTRANSFERSIZE(OBJ, NUMSAMPLES) sets the maximum amount of
            %   data to send back every transfer period

            arguments
                obj (1, 1) visalib.Resource
                numSamples (1, 1) uint64
            end

            try
                setTransferSize(obj.Client, numSamples);
            catch ex
                throwAsCaller(ex);
            end
        end

        function startTransfer(obj)
            %STARTRANSFER Initiate transfer of data (if not already
            %started).
            %
            %   STARTRANSFER(OBJ) start transfer

            arguments
                obj (1, 1) visalib.Resource
            end

            try
                startTransfer(obj.Client);
                obj.TransferInProgress = true;
            catch ex
                throwAsCaller(ex);
            end
        end

        function stopTransfer(obj)
            %STOPTRANSFER Initiate transfer of data (if not already
            %started).
            %
            %   STOPTRANSFER(OBJ) stop transfer

            arguments
                obj (1, 1) visalib.Resource
            end

            try
                stopTransfer(obj.Client);
                obj.TransferInProgress = false;
            catch ex
                throwAsCaller(ex);
            end
        end

        function setInputOutputTimeout(obj, timeout)
            %SETINPUTOUTPUTTIMEOUT Set the timeout value for VISA read and
            %write operations (this is the maximum amount of time that the
            %driver will wait for read or write to complete)
            %
            %   SETINPUTOUTPUTTIMEOUT(OBJ) set timeout

            try
                attrTimeout = visalib.internal.VISAAttribute.TMO_VALUE;
                obj.setAttributeByType(attrTimeout, timeout);
            catch ex
                throwAsCaller(ex);
            end
        end

        function timeout = getInputOutputTimeout(obj)
            %GETINPUTOUTPUTTIMEOUT Get the timeout value for VISA read and
            %write operations (this is the maximum amount of time that the
            %driver will wait for read or write to complete)
            %
            %   GETINPUTOUTPUTTIMEOUT(OBJ) get timeout

            try
                attrTimeout = visalib.internal.VISAAttribute.TMO_VALUE;
                timeout = obj.getAttributeByType(attrTimeout);
            catch ex
                throwAsCaller(ex);
            end
        end        

        function attribute = getAttributeByType(obj, attributeValue)
            % GETATTRIBUTEBYTYPE get specific VISA attribute using curated
            % list of available attributes

            arguments
                obj (1, 1) visalib.Resource
                attributeValue (1, 1) visalib.internal.VISAAttribute
            end

            try
                obj.Client.getAttributesByType(obj.ResourceName, attributeValue);
            catch e
                throwAsCaller(e);
            end

            attribute = obj.Client.getCustomProperty("VisaAttributeValue");
            attribute = attribute{1};

            if isnumeric(attribute)
                attribute = double(attribute);
            else
                attribute = convertCharsToStrings(attribute);
            end
        end

        function setAttributeByType(obj, attributeValue, attributeState)
            % SETATTRIBUTEBYTYPE set specific VISA attribute using curated
            % list of available attributes

            arguments
                obj (1, 1) visalib.Resource
                attributeValue (1, 1) visalib.internal.VISAAttribute
                attributeState (1, 1) uint64
            end

            try
                obj.Client.setAttributesByType(obj.ResourceName, attributeValue, attributeState);
            catch e
                throwAsCaller(e);
            end
        end

        function attribute = getUnclassifiedAttributeByType(obj, attributeValue)
            % GETUNCLASSIFIEDATTRIBUTEBYTYPE get specific VISA attribute
            % using VISA attribute

            arguments
                obj (1, 1) visalib.Resource
                attributeValue (1, 1) visalib.internal.VISAUnclassifiedAttribute
            end

            try
                obj.Client.getAttributesByType(obj.ResourceName, attributeValue);
            catch e
                throwAsCaller(e);
            end

            attribute = obj.Client.getCustomProperty("VisaAttributeValue");
            attribute = attribute{1};

            if isnumeric(attribute)
                attribute = double(attribute);
            else
                attribute = convertCharsToStrings(attribute);
            end
        end

        function setUnclassifiedAttributeByType(obj, attributeValue, attributeState)
            % SETUNCLASSIFIEDATTRIBUTEBYTYPE set specific VISA attribute
            % using VISA attribute

            arguments
                obj (1, 1) visalib.Resource
                attributeValue (1, 1) visalib.internal.VISAUnclassifiedAttribute
                attributeState (1, 1) uint64
            end

            try
                obj.Client.setAttributesByType(obj.ResourceName, attributeValue, attributeState);
            catch e
                throwAsCaller(e);
            end
        end
    end

    %% Save / Load
    % Save and Load are both disabled

    methods (Sealed, Hidden)
        function info = saveobj(obj)
            info = [];

            if ~obj.HasSaveWarningBeenIssued
                obj.HasSaveWarningBeenIssued = true;

                visalib.internal.ErrorProxy.sendWarning("instrument:interface:visa:noSave");
            end
        end
    end
    
    methods (Hidden, Static)
        function resource = loadobj(~)
            visalib.internal.ErrorProxy.sendWarning("instrument:interface:visa:noLoad");
            resource = visalib.Resource.empty;
        end
    end

    %% Protected

    % Custom Display
    properties (Access = protected)
        ResourceIDProperties = ["ResourceName", "Alias"];
        AdditionalIDProperties = ["Vendor", "Model"];
        InterfaceSpecificProperties = strings(0);
        LastStandardProperty = "NumBytesAvailable";

        SupplementalIDProperties = ["SerialNumber", "Type", "PreferredVisa"];
        SupplementalInterfaceProperties = strings(0);

        SharedProperties = ["ByteOrder", "Timeout", "Terminator"];
        SharedPropertiesList = {"NumBytesWritten";...
            ["ErrorOccurredFcn", "UserData"]};
    end

    % Methods of matlabshared.testmeas.CustomDisplay (must be overridden)
    methods (Sealed, Access = protected)
        function header = getHeader(obj)
            header = getHeader@matlabshared.testmeas.CustomDisplay(obj);
        end

        function displayNonScalarObject(obj)
            displayNonScalarObject@matlabshared.testmeas.CustomDisplay(obj);
        end

        function valueOut = setAndVerifyAttributeValue(obj, attribute, valueIn)
            obj.setAttributeByType(attribute, valueIn);
            valueOut = obj.getAttributeByType(attribute);
        end
    end

    % Services needed by specific instrument classes that are provided by
    % visalib.Resource
    methods (Sealed, Access = protected)
        function disableVisaTerminator(obj)
            % Instruct the VISA driver to ignore terminators found during a
            % read operation.
            obj.setTermCharEnabled(false);
            obj.disableVisaTerminatorHook();
        end

        function enableVisaTerminator(obj, value)
            % Instruct the VISA driver to terminate a read operation when 
            % a specified terminator is detected.

            arguments
                obj
                value (1, 1) logical = true
            end

            obj.setTermCharEnabled(value);
            obj.enableVisaTerminatorHook();
        end

        function setSuppressEndEnabled(obj, enabled)
            % Set VI_ATTR_SUPPRESS_END_EN to 'enabled' (see "Message-Based
            % INSTR Resource Attributes" of "The VISA Library"
            % specification (Vpp 4.3). 

            arguments
                obj
                enabled (1, 1) logical
            end

            attrSuppressEndEnable = visalib.internal.VISAAttribute.SUPPRESS_END_EN;
            obj.setAttributeByType(attrSuppressEndEnable, enabled);

            % Set the flag to let the getter know it should fetch the value
            % from the driver and not from the cached value
            obj.SuppressEndEnableToggled = true;
        end

        function setTermCharEnabled(obj, enabled)
            % Set VI_ATTR_TERMCHAR_EN to 'enabled' (see "Message-Based
            % INSTR Resource Attributes" of "The VISA Library"
            % specification (Vpp 4.3).

            arguments
                obj
                enabled (1, 1) logical
            end

            attrTermCharEnable = visalib.internal.VISAAttribute.TERMCHAR_EN;
            obj.setAttributeByType(attrTermCharEnable, enabled);

            % Set the flag to let the getter know it should fetch the value
            % from the driver and not from the cached value
            obj.TermCharEnableToggled = true;
        end

        function setVisaTerminator(obj, value)
            % Set VI_ATTR_TERMCHAR (see "Message-Based INSTR Resource
            % Attributes" of "The VISA Library" specification (Vpp 4.3).

            arguments
                obj
                value (1, 1) uint8
            end

            attrTermChar = visalib.internal.VISAAttribute.TERMCHAR;
            obj.setAttributeByType(attrTermChar, value);
        end

        function termCharEn = getTermCharEnabled(obj)
            % Return currently configured TermChar value. If the value
            % has not changed since the last query, return the previous
            % value.
            if obj.TermCharEnableToggled
                attrTermCharEnable = visalib.internal.VISAAttribute.TERMCHAR_EN;
                termCharEn = obj.getAttributeByType(attrTermCharEnable);

                % Cache the value for subsequent queries
                obj.TermCharEnableCached = termCharEn;
                obj.TermCharEnableToggled = false;
            else
                termCharEn = obj.TermCharEnableCached;
            end
        end

        function suppressEndEnabled = getSuppressEndEnabled(obj)
            % Returns whether or not the END message is suppressed. If the
            % value has has not changed since the last query, return the
            % previous value.
            if obj.SuppressEndEnableToggled
                attrSuppressEndEnable = visalib.internal.VISAAttribute.SUPPRESS_END_EN;
                suppressEndEnabled = obj.getAttributeByType(attrSuppressEndEnable);

                % Cache the value for subsequent queries
                obj.SuppressEndEnableCached = suppressEndEnabled;
                obj.SuppressEndEnableToggled = false;
            else
                suppressEndEnabled = obj.SuppressEndEnableCached;
            end
        end
    end

    % Impl / Hook methods
    methods (Access = protected)
        function initResourceHook(obj) %#ok<MANU>
            % Initialize resource-specific properties (in normal mode of
            % operation).
        end

        function postConnectHook(obj) %#ok<MANU>
        end

        function preDisconnectHook(obj) %#ok<MANU>
        end

        function flushDeviceHook(obj)
            try
                clearDevice(obj.Client, obj.ResourceName);
            catch ex
                throwAsCaller(ex);
            end
        end

        function adjustGroupListHook(obj)  %#ok<MANU>
        end

        function disableVisaTerminatorHook(obj) %#ok<MANU> 
            % Allow specific instrument classes to perform additional
            % actions required to disable terminators
        end

        function enableVisaTerminatorHook(obj) %#ok<MANU>
            % Allow specific instrument classes to perform additional
            % actions required to enable terminators
        end       
    end

    %% Private
    properties(Dependent, Access = private)
        NumBytesAvailableInternal
    end

    properties (Transient, GetAccess = protected, SetAccess = private)
        Client (1, :) visalib.internal.VisaClient
    end

    properties (Constant, Access = private)
        % Timeouts:         ms
        VisaReadAsyncTimeout = 5 
        VisaReadSyncTimeout = 10000 

        % Transfer Period:  s        
        DefaultTransferPeriod = 0.010

        % Maximum number of samples transferred during a single viRead.
        % Default is chosen to accommodate GPIB devices (larger values have
        % been reported to cause errors when viRead is called multiple
        % times in succcession).
        DefaultTransferSize = 1024
    end
    
    properties(Access = private)
        % True once the saveobj method has been called
        HasSaveWarningBeenIssued = false
        VisaWriteTimeout = visalib.internal.VISAProperties.TMO_INFINITE
        TransferInProgress (1, 1) logical = false

        CurrentTransferPeriod (1, 1) double = visalib.Resource.DefaultTransferPeriod
        CurrentTransferSize (1, 1) double = visalib.Resource.DefaultTransferSize

        SynchronousRead (1, 1) logical = false
        VisaReadTimeout

        % Cached timeout value
        VisaPreviousTimeout

        TermCharEnable (1, 1) logical
        ReadTerminatorDisabled (1, 1) logical = false

        % Flag indicating whether TermCharEnable has changed
        TermCharEnableToggled (1, 1) logical
        % Last queried value of TermCharEnable
        TermCharEnableCached (1, 1) logical 

        % Flag indicating whether SuppressEndEnabled has changed
        SuppressEndEnableToggled (1, 1) logical
        % Last queried value of SuppressEndEnabled
        SuppressEndEnableCached (1, 1) logical
    end

    methods (Access = private)
        function initResource(obj, info)
            obj.ResourceName = info.Name;
            obj.Alias = info.Alias;
            obj.Vendor = info.Vendor;
            obj.Model = info.Model;
            obj.SerialNumber = info.SerialNumber;
            obj.Type = info.Type;

            obj.PreferredVisa = obj.getVisaForResource();

            % In test mode, use the default assignments for
            % resource-specific properties; in normal mode, query the VISA
            % driver
            if visalib.internal.TestModeManager.getTestMode == ...
                    visalib.internal.VISAMode.Normal
                obj.initResourceHook();
            end
        end

        function visaForResource = getVisaForResource(obj)
            interfaceType = visaInterfaceType(obj.Type);
            resourceType = obj.ResourceClass;

            if ~ismac
                interfaceNum = uint16(obj.getAttributeByType(visalib.internal.VISAAttribute.INTF_NUM));
            else
                interfaceNum = uint16(0);
            end

            try
                visaForResource = visalib.internal.ConflictManager.findVisaForResource(interfaceType, interfaceNum, resourceType);
            catch ex
                switch ex.identifier
                    % If the preferred VISA can't be established, indicate that it
                    % occurred without erroring/warning.
                    case 'instrument:interface:visa:noVisaLibraryFoundForResource'
                        e = visalib.internal.ErrorProxy.getVisaException("unknownPreferredVISA");
                        visaForResource = e.message;                        
                    otherwise
                        throwAsCaller(ex);
                end                
            end
        end

        function connect(obj)
            if obj.SynchronousRead
                timeout = obj.VisaReadSyncTimeout;
                % The total timeout is the client timeout + the VISA driver
                % timeout; the client timeout is set to something suitably
                % small (it cannot be set to 0).
                setProperty(obj.Client, "Timeout", 0.01);
                obj.Timeout = timeout/1000;                
            else
                % g2325890: read requires a shorter timeout (write should use a
                % timeout greater than 100 ms)
                timeout = obj.VisaReadAsyncTimeout;
                obj.setInputOutputTimeout(timeout);
            end

            obj.VisaReadTimeout = timeout;

            options.ResourceName = obj.ResourceName;
            options.TransferPeriod = obj.CurrentTransferPeriod;

            if obj.SynchronousRead
                options.StartTransfer = false;
            else
                options.StartTransfer = true;
            end

            connect(obj.Client, options);

            if ~obj.SynchronousRead && visalib.internal.TestModeManager.getTestMode == ...
                    visalib.internal.VISAMode.Normal
                obj.TransferInProgress = true;
            else
                obj.TransferInProgress = false;
            end            

            obj.Client.setProperty("WriteAsync", false);
            obj.setTransferSize(obj.CurrentTransferSize);

            postConnectHook(obj);
            obj.Connected = true;
        end

        function disconnect(obj)
            if obj.Connected
                obj.stopTransfer();

                if ~isempty(obj.Client)
                    preDisconnectHook(obj);
                    disconnect(obj.Client);
                end
            end

            visalib.internal.ResourceFactory.getInstance().unregisterVisaResource(obj.ResourceName);
        end

        function grouplist = getGroupList(obj)
            obj.adjustGroupListHook();

            headerlist = {[obj.ResourceIDProperties,...
                obj.AdditionalIDProperties,...
                obj.InterfaceSpecificProperties]};

            grouplist = vertcat(headerlist,...
                {obj.SupplementalIDProperties},...
                {obj.SupplementalInterfaceProperties},...
                {obj.SharedProperties},...
                obj.SharedPropertiesList);

            % Add "Tag" as the last element in the main property group.
            grouplist{1}(end+1) = "Tag";
        end

        function stopTransferWhen(obj, transferIsInProgress)
            if transferIsInProgress
                obj.stopTransfer
            end
        end

        function restartTransferIf(obj, transferWasInProgress)
            if transferWasInProgress
                obj.startTransfer
            end
        end
    
        function setTimeoutNormal(obj, value)
            % Write operations should timeout after the prescribed
            % period (timeout is specified in seconds, and the VISA
            % write timeout is specified in milliseconds)
            desiredTimeout = 1000 * value;
            obj.setInputOutputTimeout(desiredTimeout);
            actualTimeout = obj.getInputOutputTimeout;

            if actualTimeout ~= desiredTimeout && ...
                    visalib.internal.TestModeManager.getTestMode == ...
                    visalib.internal.VISAMode.Normal

                % warn user that timeout isn't sustainable
                visalib.internal.ErrorProxy.sendWarning(...
                    "instrument:interface:visa:unableToSetTimeoutValue", ...
                    num2str(value), ...
                    num2str(actualTimeout/1000));
            end

            obj.VisaWriteTimeout = actualTimeout;

            if obj.SynchronousRead
                obj.VisaReadTimeout = actualTimeout;
            end
        end

        function setTimeoutCached(obj, timeout)
            % Set the VISA timeout value if it has changed since the last
            % time this function was called.
            if timeout ~= obj.VisaPreviousTimeout
                obj.setInputOutputTimeout(timeout);
                obj.VisaPreviousTimeout = timeout;
            end
        end
    
        function value = getAsyncProperty(obj, propName)
            if obj.SynchronousRead
                ex = visalib.internal.ErrorProxy.getVisaException(...
                            "PropertyNotSupportedForVISA", ...
                            propName);
                throwAsCaller(ex);
            else
                value = getProperty(obj.Client, propName);
            end
        end

        function setAsyncProperty(obj, propName, value)
            if obj.SynchronousRead
                ex = visalib.internal.ErrorProxy.getVisaException(...
                            "PropertyNotSupportedForVISA", ...
                            propName);
                throwAsCaller(ex);
            else
                setProperty(obj.Client, propName, value);
            end            
        end
    end

    methods (Static, Access = {?visalib.Resource})
        function checkResourceType(actualType, expectedType)
            arguments
                actualType (1, 1) visalib.InterfaceType
                expectedType (1, 1) visalib.InterfaceType
            end

            if actualType ~= expectedType
                visalib.internal.ErrorProxy.getError(...
                    "instrument:interface:visa:interfaceTypeMismatch",...
                    actualType,...
                    expectedType);
            end
        end
    end
end

function numBytes = getNumBytesToRead(numValues, precision)

arguments
    numValues (1, 1) double
    precision (1, 1) string = "uint8"
end

switch(precision)
    case {"int8", "uint8","char","string"}
        bytesPerValue = 1;
    case {"int16","uint16"}
        bytesPerValue = 2;
    case {"int32","uint32","single"}
        bytesPerValue = 4;
    case {"int64","uint64","double"}
        bytesPerValue = 8;
    otherwise
        throw(MException(message("transportlib:transport:unknownPrecision")));
end

numBytes = numValues*bytesPerValue;
end
