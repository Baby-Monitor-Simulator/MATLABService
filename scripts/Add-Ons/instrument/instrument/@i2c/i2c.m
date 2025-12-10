classdef i2c < icinterface & instrument.internal.ICTRemoveFunctionalityHelper
    %I2C Construct I2C communication object.
    %
    %   I2C will be removed in a future release. Use device() method of
    %   <a href="matlab:help ni845x">ni845x</a> or <a href="matlab:help aardvark">aardvark</a> instead.
    %
    %   S = I2C('VENDOR', BoardIndex, RemoteAddress) constructs an I2C
    %   communication object associated with BoardIndex and RemoteAddress.
    %
    %   In order to communicate with the device, the object must be
    %   connected to the I2C bus with the FOPEN function.
    %
    %   When the I2C object is constructed, the object's Status property is
    %   closed. Once the object is connected to the bus with the
    %   FOPEN function, the Status property is configured to open. Only one
    %   RemoteAddress may be connected with a board at a time.
    %
    %   If an invalid property name or property value is specified the object
    %   will not be created.
    %
    %   Note that the property value pairs can be in any format supported
    %   by the SET function, i.e., param-value string pairs, structures,
    %   and param-value cell array pairs.
    %
    % I2C Functions
    % I2C object construction.
    %   i2c            - Construct I2C object.
    %
    % Getting and setting parameters.
    %   get            - Get value of instrument object property.
    %   set            - Set value of instrument object property.
    %
    % State change.
    %   fopen          - Connect object to instrument.
    %   fclose         - Disconnect object from instrument.
    %   record         - Record data from instrument control session.
    %
    % Read and write functions.
    %   fread          - Read binary data from instrument.
    %   fwrite         - Write binary data to instrument.
    %
    % General.
    %   delete         - Remove instrument object from memory.
    %   inspect        - Open inspector and inspect instrument object properties.
    %   instrfind      - Find instrument objects with specified property values.
    %   instrfindall   - Find all instrument objects regardless of ObjectVisibility.
    %   instrid        - Define and retrieve commands used to identify instruments.
    %   instrnotify    - Define notification for instrument events.
    %   instrreset     - Disconnect and delete all instrument objects.
    %   isvalid        - True for instrument objects that can be connected to
    %                    instrument.
    %   obj2mfile      - Convert instrument object to MATLAB code.
    %
    % Information and Help.
    %   propinfo       - Return instrument object property information.
    %   instrhelp      - Display instrument object function and property help.
    %   instrhwinfo    - Return information on available hardware.
    %
    % Instrument Control tools.
    %   tmtool         - Tool for browsing available instruments, configuring
    %                    instrument communication and communicating with
    %                    instrument.
    %
    % I2C Properties
    %   BitRate                   - Bit Rate of the I2C bus.
    %   BoardIndex                - An arbitrary Index of the board.
    %   BoardSerial               - A unique identification of the board
    %   ByteOrder                 - Byte order of the instrument.
    %   BytesToOutput             - Number of bytes currently waiting to be sent.
    %   InputBufferSize           - Total size of the input buffer.
    %   Name                      - Descriptive name of the I2C object.
    %   ObjectVisibility          - Control access to an object by command-line users and
    %                               GUIs.
    %   OutputBufferSize          - Total size of the output buffer.
    %   PullupResistors           - Pullup resistor state if supported.
    %                               empty.
    %   RecordDetail              - Amount of information recorded to disk.
    %   RecordMode                - Specify whether data is saved to one disk file
    %                               or to multiple disk files.
    %   RecordName                - Name of disk file to which data sent and
    %                               received is recorded.
    %   RecordStatus              - Indicates if data is being written to disk.
    %   RemoteAddress             - Chip address in hex. example: '50h'
    %   Status                    - Indicates if the i2c object is connected
    %                               to a remote host.
    %   Tag                       - Label for object.
    %   TargetPower               - Board power state if supported
    %   Timeout                   - Seconds to wait to receive data.
    %   TimerFcn                  - Callback function executed when a timer event
    %                               occurs.
    %   TimerPeriod               - Time in seconds between timer events.
    %   TransferStatus            - Indicate the asynchronous read or write
    %                               operations that are in progress.
    %   Type                      - Object type.
    %   UserData                  - User data for object.
    %   ValuesReceived            - Number of values read from the instrument.
    %   ValuesSent                - Number of values written to instrument.
    %   Vendor                    - The provider of the underlying I2C device.
    %
    %   Example:
    %       % To construct a I2C object:
    %         i1 = i2c('Aardvark', 0, 80);
    %
    %       % To connect the I2C object to the I2C bus:
    %         fopen(i1)
    %
    %       % Write hex FF to the chip at address 80
    %         fwrite(i1, 0xFF);
    %       % Read a byte back from the chip
    %         data = fread(i1, 1);
    %
    %       % To disconnect the object from the I2C bus.
    %         fclose(i1);
    %
    %   See also NI845X AARDVARK I2C/FOPEN I2C/FREAD I2C/FWRITE.
    %
    
    %   Copyright 2011-2024 The MathWorks, Inc.
    
    properties(Hidden, SetAccess = 'public', GetAccess = 'public')
        icinterface
    end
    
    methods
        function obj = i2c(varargin)
            
            % Create the class that will throw a warning and error as part of the
            % legacy interface remove functionality "Warn" phase and "Error" phases.
            obj = obj@instrument.internal.ICTRemoveFunctionalityHelper("i2c");

            obj = obj@icinterface('i2c'); 
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            % Aardvark with I2C is not supported on MAC. Error out if
            % trying to create an I2C object for Aardvark on MAC.
            if nargin ~= 0 && ischar(varargin{1})
                if strcmpi(varargin{1}, 'aardvark') && strcmpi(computer('arch'),'maci64')
                    error(message('instrument_aardvark:aardvark:noAardvarkSupportOnMac'));
                end
            end

            try
                obj.icinterface = icinterface('i2c'); 
            catch
                error(message('instrument:i2c:nojvm'));
                
            end

            switch(nargin)
                case 0
                    error(message('instrument:i2c:invalidSyntax'));
                case 1
                    if isa(varargin{1}, 'i2c')
                        obj = varargin{1};
                    elseif isa(varargin{1}, 'com.mathworks.toolbox.instrument.I2C')
                        obj.jobject = handle(varargin{1});
                    elseif ishandle(varargin{1})
                        % True if loading an array of objects and the first is a I2C object.
                        if isa(varargin{1}(1).java, 'com.mathworks.toolbox.instrument.I2C')
                            obj.jobject = varargin{1};
                        else
                            error(message('instrument:i2c:invalidSyntax'))
                        end
                    else
                        error(message('instrument:i2c:invalidSyntax'))
                    end
                case 2
                    if isa(varargin{1}, 'i2c')
                        obj = varargin{1};
                    elseif ishandle(varargin{1})
                        % True if loading an array of objects and the first is a I2C object.
                        if isa(varargin{1}(1).java, 'com.mathworks.toolbox.instrument.I2C')
                            obj.jobject = varargin{1};
                        else
                            error(message('instrument:i2c:invalidPORT'));
                        end
                        
                    else
                        error(message('instrument:i2c:invalidSyntax'));
                    end
                case 3
                    if ischar(varargin{3})
                        if lower(varargin{3}(end))=='h' % if it is an accepted hex string try to convert it
                            varargin{3}=hex2dec(varargin{3}(1:end-1));
                        else
                            error(message('instrument:i2c:invalidRemoteAddress')); % Unacceptable string passed in
                        end
                    end
                    if isVararginTypeCorrect(obj, varargin{:})
                        vendor = varargin{1};
                        board = validateBoard(obj, varargin{2});
                        remoteChip = validateRemoteChip(obj, varargin{3});
                        try
                            obj.jobject=localGetHandle(vendor, board, remoteChip);
                        catch aException
                            if feature('hotlinks')
                                tripLineMsg = message('instrument:instrument:instrument:downloadAdditionalVendors', 'I2C');
                                decoratedMsg = sprintf([aException.message '\n\n' tripLineMsg.getString]);
                                decoratedException= MException(aException.identifier, decoratedMsg);
                                throwAsCaller(decoratedException);
                            else
                                throwAsCaller(aException);
                            end
                        end
                        
                    else
                        error(message('instrument:i2c:invalidSyntax'));
                    end
                otherwise
                    if ischar(varargin{3}) && lower(varargin{3}(end))=='h'
                        varargin{3}=hex2dec(varargin{3}(1:end-1));
                    end
                    if isVararginTypeCorrect(obj, varargin{:})
                        vendor = varargin{1};
                        board = validateBoard(obj, varargin{2});
                        remoteChip = validateRemoteChip(obj, varargin{3});
                        obj.jobject=localGetHandle(vendor, board, remoteChip);
                    else
                        error(message('instrument:i2c:invalidSyntax'));
                    end
                    try
                        set(obj, varargin{4:end});
                    catch aException
                        delete(obj);
                        localFixError(aException);
                    end
            end
            
            setMATLABClassName( obj.jobject(1),obj.constructor);
            obj.jobject(1).setMATLABObject(obj);
        end
    end
    
    methods(Static = true, Hidden = true)
        obj = loadobj(B)
    end
    
    methods (Access = private)
        function board = validateBoard(~, board)
            % Validate the board index of i2c object

            try
                validateattributes(board, {'numeric'}, {'finite', 'nonempty', 'nonnegative', 'integer'}, ...
                    mfilename, "BoardIndex");
            catch
                throw(MException(message('instrument:i2c:invalidBoardIndex')));
            end
        end
        
        function remoteChip = validateRemoteChip(~, remoteChip)
            % Validate the Remote Address of i2c object

            try
                validateattributes(remoteChip, {'numeric'}, {'finite', 'nonempty', 'nonnegative', 'integer', '<=', 127}, ...
                    mfilename, "RemoteAddress");
            catch
                throw(MException(message('instrument:i2c:invalidRemoteAddress')));
            end
        end
        
        function flag = isVararginTypeCorrect(~, varargin)
            % Helper function to verify the data type and size of varargin
            % arguments for the i2c constructor.

            flag = ischar(varargin{1}) && isnumeric(varargin{2}) && isnumeric(varargin{3}) && ...
                            isscalar(varargin{2}) && isscalar(varargin{3});
        end
    end
    
    methods(Hidden)
        function obj = scanstr(~, ~)
            % SCANSTR This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
        
        function varargout = query(~, varargin)
            % QUERY This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
        
        function varargout = fscanf(~, varargin)
            % FSCANF This function is not supported on I2C interface objects
            error(message('instrument:i2c:fscanfNotSupported'));
        end
        
        function fprintf(~, varargin)
            % FPRINTF This function is not supported on I2C interface objects
            error(message('instrument:i2c:fprintfNotSupported'));
        end
        
        function flushinput(~)
            % FLUSHINPUT This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
        
        function flushoutput(obj)
            % FLUSHOUTPUT This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
        
        function binblockwrite(~, varargin)
            % BINBLOCKWRITE This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
        
        function varargout = binblockread(~, varargin)
            % BINBLOCKREAD This function is not supported on I2C interface objects
            error(message('instrument:methods:notSupported'));
        end
    end
    
end
function jobj  = localGetHandle(vendor, board, remoteChip)
if(strcmpi(vendor,'test'))
    pathToDll='Not_Used';
else
    pathToDll = localFindAdaptor([vendor 'i2c']);
end
try
    jobj = handle(javaObject(['com.mathworks.toolbox.instrument.I2C' upper(vendor)], pathToDll, vendor, board, remoteChip));
catch ex
    newExc = MException('instrument:i2c:ObjectCreationError', message('instrument:i2c:ObjectCreationError').getString);
    newExc.addCause(ex);
    throwAsCaller(newExc);
end
end

function adaptorPath = localFindAdaptor(adaptorName)

% Define the toolbox root location.
instrRoot = [toolboxdir('instrument') '/instrumentadaptors'];


adaptorName = lower(['mw' adaptorName ]);

dirname = instrgate('privatePlatformProperty', 'dirname');
extension = instrgate('privatePlatformProperty', 'libext');

if (isempty(dirname) || isempty(extension))
    msg=message('instrument:i2c:unsupportedPlatform','i2c', computer);
    throwAsCaller(MException(msg.Identifier, msg.getString()));
end

% Define the adaptor directory location.
adaptorRoot = fullfile(instrRoot, dirname, [adaptorName extension]);

% Determine if the adaptor exists.
if exist(adaptorRoot,'file')
    adaptorPath = adaptorRoot;
else
    newExc = MException(message('instrument:i2c:adaptorNotFound'));
    throwAsCaller(newExc);
end
end


% *******************************************************************
% Fix the error message.
function localFixError(aException)

errmsg = aException.message;

% Remove the trailing carriage returns from errmsg.
while errmsg(end) == newline
    errmsg = errmsg(1:end-1);
end

throwAsCaller(MException(aException.identifier, errmsg));

end
