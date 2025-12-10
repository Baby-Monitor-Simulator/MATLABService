classdef gpib < icinterface & instrument.internal.ICTRemoveFunctionalityHelper
    %GPIB Construct GPIB object.
    %
    %   GPIB will be removed in a future release. Use visadev instead.
    %
    %   OBJ = GPIB('VENDOR',BOARDINDEX,PRIMARYADDRESS) constructs a
    %   GPIB object, OBJ, associated with board index, BOARDINDEX, and
    %   instrument primary address, PRIMARYADDRESS. The primary address
    %   can range between 0 and 30. The GPIB hardware is supplied by
    %   VENDOR. Supported vendors include:
    %
    %       'keysight'  - Keysight Technologies hardware.
    %       'ics'       - ICS Electronics hardware.
    %       'ni'        - National Instruments hardware.
    %       'adlink'    - ADLINK Technology hardware
    %       'mcc'       - Measurement Computing Corporation hardware
    %
    %   In order to communicate with the instrument, the object, OBJ, must
    %   be connected to the instrument with the FOPEN function.
    %
    %   When the GPIB object is constructed, the object's Status property
    %   is configured to closed. Once the object is connected to the GPIB
    %   instrument with the FOPEN function, the Status property is configured
    %   to open. Only one GPIB object can be connected to the instrument
    %   with the specified board index, primary address and secondary address
    %   at a time.
    %
    %   OBJ = GPIB('VENDOR',BOARDINDEX,PRIMARYADDRESS,'P1',V1,'P2',V2,...)
    %   constructs a GPIB object, OBJ, associated with board index, BOARDINDEX,
    %   and instrument primary address, PRIMARYADDRESS and with the specified
    %   property values. If an invalid property name or property value is
    %   specified the object will not be created.
    %
    %   Note that the param-value pairs can be in any format supported by
    %   the SET function, i.e., param-value string pairs, structures, and
    %   param-value cell array pairs.
    %
    %   At any time you can view a complete listing of GPIB functions and
    %   properties with the INSTRHELP function, i.e., instrhelp gpib.
    %
    % GPIB Functions
    % GPIB object construction.
    %   gpib           - Construct GPIB object.
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
    %   binblockread   - Read binblock from instrument.
    %   binblockwrite  - Write binblock to instrument.
    %   fprintf        - Write text to instrument.
    %   fgetl          - Read one line of text from instrument, discard terminator.
    %   fgets          - Read one line of text from instrument, keep terminator.
    %   fread          - Read binary data from instrument.
    %   fscanf         - Read data from instrument and format as text.
    %   fwrite         - Write binary data to instrument.
    %   query          - Write and read formatted data from instrument.
    %   readasync      - Read data asynchronously from instrument.
    %   scanstr        - Parse formatted data from instrument.
    %
    % GPIB Functions.
    %   clrdevice      - Clear instrument buffer.
    %   spoll          - Perform serial poll.
    %   trigger        - Send trigger message to instrument.
    %
    % General.
    %   delete         - Remove instrument object from memory.
    %   flushinput     - Remove data from input buffer.
    %   flushoutput    - Remove data from output buffer.
    %   inspect        - Open inspector and inspect instrument object properties.
    %   instrcallback  - Display event information for the event.
    %   instrfind      - Find instrument objects with specified property values.
    %   instrfindall   - Find all instrument objects regardless of ObjectVisibility.
    %   instrid        - Define and retrieve commands used to identify instruments.
    %   instrnotify    - Define notification for instrument events.
    %   instrreset     - Disconnect and delete all instrument objects.
    %   isvalid        - True for instrument objects that can be connected to
    %                    instrument.
    %   obj2mfile      - Convert instrument object to MATLAB code.
    %   stopasync      - Stop asynchronous read and write operation.
    %
    % Information and Help.
    %   propinfo       - Return instrument object property information.
    %   instrhelp      - Display instrument object function and property help.
    %   instrhwinfo    - Return information on available hardware.
    %
    % Instrument Control tools.
    %   tmtool         - Tool for browsing available instruments, configuring
    %                    instrument communication and and communicating with
    %                    instrument.
    %
    % GPIB Properties
    %   BoardIndex                - Index of the access board for the object.
    %   BusManagementStatus       - State of bus management lines.
    %   ByteOrder                 - Byte order of the instrument.
    %   BytesAvailable            - Specifies number of bytes available to be read.
    %   BytesAvailableFcn         - Callback function executed when specified number
    %                               of bytes are available.
    %   BytesAvailableFcnCount    - Number of bytes to be available before executing
    %                               BytesAvailableFcn.
    %   BytesAvailableFcnMode     - Specifies whether the BytesAvailableFcn is
    %                               based on the number of bytes or terminator
    %                               being reached.
    %   BytesToOutput             - Number of bytes currently waiting to be sent.
    %   CompareBits               - Specifies the number of bits to compare the EOS.
    %   EOIMode                   - Specifies whether the EOI line is asserted at the
    %                               end of a write.
    %   EOSCharCode               - Character to terminate on when EOSMode is enabled.
    %   EOSMode                   - Configure the end-of-string (EOS) termination mode.
    %   ErrorFcn                  - Callback function executed when an error occurs.
    %   HandshakeStatus           - State of the handshake lines.
    %   InputBufferSize           - Total size of the input buffer.
    %   Name                      - Descriptive name of the GPIB object.
    %   ObjectVisibility          - Control access to an object by command-line users and
    %                               GUIs.
    %   OutputBufferSize          - Total size of the output buffer.
    %   OutputEmptyFcn            - Callback function executed when output buffer is
    %                               empty.
    %   PrimaryAddress            - GPIB primary address.
    %   RecordDetail              - Amount of information recorded to disk.
    %   RecordMode                - Specify whether data is saved to one disk file
    %                               or to multiple disk files.
    %   RecordName                - Name of disk file to which data sent and
    %                               received is recorded.
    %   RecordStatus              - Indicates if data is being written to disk.
    %   SecondaryAddress          - GPIB secondary address.
    %   Status                    - Indicates if the GPIB object is connected to
    %                               GPIB instrument.
    %   Tag                       - Label for object.
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
    %
    %   Example:
    %       % To construct a GPIB object connected to an Keysight Technologies
    %         board at index 7 with an instrument at primary address 1:
    %         g = gpib('keysight', 7, 1);
    %
    %       % To connect the GPIB object to the instrument:
    %         fopen(g)
    %
    %       % To query the instrument.
    %         fprintf(g, '*IDN?');
    %         idn = fscanf(g);
    %
    %       % To disconnect the GPIB object from the instrument.
    %         fclose(g);
    %
    %   See also VISADEV, VISADEVLIST, ICINTERFACE/FOPEN, INSTRUMENT/PROPINFO, INSTRHELP.
    %
    
    %   Copyright 1999-2021 The MathWorks, Inc.
    
    properties(Hidden, SetAccess = 'public', GetAccess = 'public')
        icinterface
    end
    
    methods
        function obj = gpib(varargin)

            % Create the class that will throw a warning and error as part of the
            % legacy interface remove functionality "Warn" phase and "Error" phases.
            obj = obj@instrument.internal.ICTRemoveFunctionalityHelper("gpib");
            
            obj = obj@icinterface('gpib');
            
            % Create the parent class.
            try
                obj.icinterface = icinterface('gpib');
            catch %#ok<CTCH>
                error(message('instrument:gpib:nojvm'));
            end
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            switch (nargin)
                case 0
                    error(message('instrument:gpib:invalidSyntaxVendor'));
                case 1
                    if isa(varargin{1}, 'gpib')
                        obj = varargin{1};
                    elseif isa(varargin{1}, 'com.mathworks.toolbox.instrument.GpibDll')
                        obj.jobject = handle(varargin{1});
                    elseif contains(class(varargin{1}), 'com.mathworks.toolbox.instrument.Gpib')
                        obj.jobject = varargin{1};
                    elseif ishandle(varargin{1})
                        % True if loading an array of objects and the first is a GPIB object.
                        if contains(class(varargin{1}(1)), 'com.mathworks.toolbox.instrument.Gpib')
                            obj.jobject = varargin{1};
                        else
                            error(message('instrument:gpib:invalidSyntaxVendorInvalid'));
                        end
                    elseif ischar(varargin{1})
                        error(message('instrument:gpib:invalidSyntaxBoardIndex'));
                    else
                        error(message('instrument:gpib:invalidSyntaxVendorInvalid'));
                    end
                    
                    if isvalid(obj)
                        % Pass the OOPs object to java. Used for callbacks.
                        obj.jobject(1).setMATLABObject(obj);
                    end
                    return;
                case 2
                    error(message('instrument:gpib:invalidSyntaxPrimaryAddress'));
                otherwise
                    % Ex. g = gpib('ni', 0, 1);
                    % Ex. g = gpib('ni', 0, 1, 'SecondaryAddress', 98);
                    [vendor, boardIndex, primAdrs] = deal(varargin{1:3});
            end
            
            % Set the doc ID for the interface object. This sets values for
            % DocIDNoData and DocIDSomeData
            obj = obj.setDocID('gpib');
            
            % Error checking.
            if ~ischar(vendor)
                error(message('instrument:gpib:invalidVENDORString'));
            end
            if isempty(vendor)
                error(message('instrument:gpib:invalidVENDOREmpty'));
            end
            if ~isa(boardIndex, 'double')
                error(message('instrument:gpib:invalidBOARDINDEXDouble'));
            end
            if isempty(boardIndex)
                error(message('instrument:gpib:invalidBOARDINDEXEmpty'));
            end
            if ~isa(primAdrs, 'double') || isempty(primAdrs)
                error(message('instrument:gpib:invalidPRIMARYADDRESSDoubleRange'));
            end
            if boardIndex < 0
                error(message('instrument:gpib:invalidBOARDINDEXPositive'));
            end
            if (primAdrs < 0) || (primAdrs > 30)
                error(message('instrument:gpib:invalidPRIMARYADDRESSRange'));
            end
            
            % Determine the path to the dll. If the path is given use it otherwise try
            % to find the associated MathWorks adaptor.
            [pathToDll, name, ext] = fileparts(vendor);
            
            % Check and retrieve the older name for the adaptor, if it exists.
            name = instrgate('getInternalVendorName',name);
            
            if isempty(pathToDll)
                % The adaptor is a MathWorks adaptor - verify that it exists.
                pathToDll = localFindAdaptor(name, ext);
            end
            
            % Call the java constructor and store the java object in the jobject field.
            try
                obj.jobject = handle(javaObject(['com.mathworks.toolbox.instrument.Gpib' upper(name)], pathToDll, boardIndex, primAdrs));
            catch
                error(message('instrument:gpib:invalidInterface', vendor));
            end
            
            % Assign the properties.
            if nargin > 3
                try
                    set(obj, varargin{4:end});
                catch aException
                    delete(obj);
                    localFixError(aException);
                end
            end
            
            setMATLABClassName( obj.jobject(1),obj.constructor);
            % Pass the OOPs object to java. Used for callbacks.
            if isvalid(obj)
                % Pass the OOPs object to java. Used for callbacks.
                obj.jobject(1).setMATLABObject(obj);
            end
            
            
        end
    end
    methods(Static = true, Hidden = true)
        obj = loadobj(B);
    end
end

% *******************************************************************
% Fix the error message.
function localFixError (aException)

% Initialize variables.
errmsg =  aException.message;

% Remove the trailing carriage returns from errmsg.
while errmsg(end) == newline
    errmsg = errmsg(1:end-1);
end

newExc = MException(aException.identifier,errmsg );
throwAsCaller(newExc);
end

% *******************************************************************
% Find the adaptor that is being loaded. The path was not specified.
function adaptorPath = localFindAdaptor(adaptorName, adaptorExt)

% Define the toolbox root location.
instrRoot = which('instrgate', '-all');

% From the adaptorName construct the adaptor filename.
if isempty(adaptorExt)
    adaptorName = lower(['mw' adaptorName 'gpib']);
end

dirname = instrgate('privatePlatformProperty', 'dirname');
extension = instrgate('privatePlatformProperty', 'libext');

if (isempty(dirname) || isempty(extension))
    newExc = MException('instrument:gpib:unsupportedPlatform', ['GPIB hardware on the ' computer ' platform is not supported.'] );
    throwAsCaller(newExc);
end

% Define the adaptor directory location.
instrRoot = [fileparts(instrRoot{1}) 'adaptors'];
adaptorRoot = fullfile(instrRoot, dirname, [adaptorName extension]);

% Determine if the adaptor exists.
if exist(adaptorRoot, 'file')
    adaptorPath = adaptorRoot;
else
    newExc = MException('instrument:gpib:adaptorNotFound', 'The specified VENDOR adaptor could not be found.');
    throwAsCaller(newExc);
end
end
