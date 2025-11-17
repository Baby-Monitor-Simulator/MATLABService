classdef Bluetooth < icinterface & instrument.internal.ICTRemoveFunctionalityHelper
    %Bluetooth Construct BlueTooth object.
    %
    %   Bluetooth will be removed in a future release. Use bluetooth instead.
    %
    %   B = Bluetooth( 'RemoteID', Channel ) constructs a Bluetooth channel
    %   object to the device at the address specified by RemoteID using
    %   the specified Bluetooth channel.
    %
    %   B = Bluetooth( 'RemoteName', Channel ) constructs a Bluetooth
    %   channel object associated with the remote device ID matching the
    %   RemoteName and channel.  RemoteName is a friendly way to identify
    %   the RemoteID. It is preferable to use the RemoteID to construct the
    %   channel object as this is unique to each device. If a Channel is not
    %   specified, it will default to 0.
    %
    %   In order to communicate with the device, the object must be connected
    %   to the device with the FOPEN function.
    %
    %   When the Bluetooth object is constructed, the object's Status property
    %   is closed. Once the object is connected to the remote device with the
    %   FOPEN function, the Status property is configured to open. Only one Bluetooth
    %   object may be connected to a device at a time.
    %
    %   B = BLUETOOTH('RemoteID', Channel, 'P1',V1,'P2',V2,...) constructs a Bluetooth channel object
    %   associated with the RemoteID, Channel and with the specified property values. If
    %   an invalid property name or property value is specified the object will
    %   not be created.
    %
    %   Note that the property value pairs can be in any format supported by
    %   the SET function, i.e., param-value string pairs, structures, and
    %   param-value cell array pairs.
    %
    % BLUETOOTH Functions
    % BLUETOOTH object construction.
    %   Bluetooth          - Construct Bluetooth object.
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
    % BLUETOOTH Properties
    %   ByteOrder                 - Byte order of the instrument.
    %   BytesAvailable            - Specifies number of bytes available to be read.
    %   BytesAvailableFcn         - Callback function executed when specified number
    %                               of bytes are available.
    %   BytesAvailableFcnCount    - Number of bytes to be available before
    %                               executing BytesAvailableFcn.
    %   BytesAvailableFcnMode     - Specifies whether the BytesAvailableFcn is
    %                               based on the number of bytes or terminator
    %                               being reached.
    %   BytesToOutput             - Number of bytes currently waiting to be sent.
    %   Channel                   - The Bluetooth channel.
    %   ErrorFcn                  - Callback function executed when an error occurs.
    %   InputBufferSize           - Total size of the input buffer.
    %   Name                      - Descriptive name of the Bluetooth object.
    %   ObjectVisibility          - Control access to an object by command-line users and
    %                               GUIs.
    %   OutputBufferSize          - Total size of the output buffer.
    %   OutputEmptyFcn            - Callback function executed when output buffer is
    %                               empty.
    %   Profile                   - Bluetooth profile being used.
    %   ReadAsyncMode             - Specify whether an asynchronous read operation
    %                               is continuous or manual.
    %   RecordDetail              - Amount of information recorded to disk.
    %   RecordMode                - Specify whether data is saved to one disk file
    %                               or to multiple disk files.
    %   RecordName                - Name of disk file to which data sent and
    %                               received is recorded.
    %   RecordStatus              - Indicates if data is being written to disk.
    %   RemoteID                  - Bluetooth address of the remote device.
    %   RemoteName                - Friendly description of the remote device.
    %   Status                    - Indicates if the Bluetooth object is connected
    %                               to a remote host.
    %   Tag                       - Label for object.
    %   Terminator                - Character used to terminate commands sent to
    %                               the remote host.
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
    %       % Find available Bluetooth devices
    %         btInfo = instrhwinfo('Bluetooth')
    %
    %       % Display the information about the first device discovered
    %         btInfo.RemoteNames(1)
    %         btInfo.RemoteIDs(1)
    %
    %       % Construct a Bluetooth Channel object to the first Bluetooth device
    %         b = Bluetooth(btInfo.RemoteIDs(1), 3);
    %
    %       % Connect the Bluetooth Channel object to the specified remote device
    %         fopen(b)
    %
    %       % Write some data and query the device for an ascii string
    %         fprintf(b, data);
    %         idn = fscanf(b);
    %
    %       % Disconnect the object from the Bluetooth device
    %         fclose(b);
    %
    %   See also BLUETOOTHLIST, BLUETOOTH/FOPEN, INSTRHELP, INSTRUMENT/PROPINFO
    
    %   Copyright 2010-2021 The MathWorks, Inc.
    
    properties(Hidden, SetAccess = 'public', GetAccess = 'public')
        icinterface
    end
    methods
        function obj = Bluetooth(varargin)
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

            % Create the class that will throw a warning and error as part of the
            % legacy interface remove functionality "Warn" phase and "Error" phases.
            obj = obj@instrument.internal.ICTRemoveFunctionalityHelper("Bluetooth");

            obj = obj@icinterface('Bluetooth');
            try
                obj.icinterface=icinterface('Bluetooth');
            catch e
                error(message('instrument:Bluetooth:Bluetooth:nojvm'));
            end
            switch (nargin)
                case 0
                    error(message('instrument:Bluetooth:Bluetooth:invalidSyntax'));
                case 1
                    if (ischar(varargin{1}))
                        if isempty(varargin{1})
                            error(message('instrument:Bluetooth:Bluetooth:invalidRemoteString'));
                        else
                            obj.jobject = handle(javaObject('com.mathworks.toolbox.instrument.Bluetooth', varargin{1}, 0));
                        end
                    elseif strcmp(class(varargin{1}), 'Bluetooth')
                        obj = varargin{1};
                    elseif isa(varargin{1}, 'com.mathworks.toolbox.instrument.Bluetooth')
                        obj.jobject = handle(varargin{1});
                    elseif isa(varargin{1}, 'javahandle.com.mathworks.toolbox.instrument.Bluetooth')
                        obj.jobject = varargin{1};
                    elseif ishandle(varargin{1})
                        if isa(varargin{1}(1), 'javahandle.com.mathworks.toolbox.instrument.Bluetooth')
                            obj.jobject = varargin{1};
                        else
                            error(message('instrument:Bluetooth:Bluetooth:invalidRemoteDevice'));
                        end
                    else
                        error(message('instrument:Bluetooth:Bluetooth:invalidChannel'));
                    end
                otherwise
                    if (ischar(varargin{1}))
                        if isempty(varargin{1})
                            error(message('instrument:Bluetooth:Bluetooth:invalidRemoteString'));
                        end
                        try
                            obj.jobject = handle(javaObject('com.mathworks.toolbox.instrument.Bluetooth',varargin{1}, varargin{2}));
                        catch aException
                            error(message('instrument:Bluetooth:Bluetooth:cannotCreate', aException.message));
                        end
                        if(nargin > 2)
                            try
                                set(obj, varargin{3:end});
                            catch aException
                                delete(obj);
                                localFixError(aException);
                            end
                        end
                    else
                        error(message('instrument:Bluetooth:Bluetooth:invalidRemoteDevice'));
                    end
            end
            
            % Set the doc ID for the interface object. This sets values for
            % DocIDNoData and DocIDSomeData
            obj = obj.setDocID('Bluetooth');
            
            setMATLABClassName( obj.jobject(1),obj.constructor);
            
            if isvalid(obj)
                obj.jobject(1).setMATLABObject(obj);
            end
        end
    end
    methods(Static)
        obj = loadobj(B);
    end
end


function localFixError(aException)

errmsg = aException.message;

while errmsg(end) == sprintf('\n')
    errmsg = errmsg(1:end-1);
end

throwAsCaller(MException(aException.identifier, errmsg));

end
