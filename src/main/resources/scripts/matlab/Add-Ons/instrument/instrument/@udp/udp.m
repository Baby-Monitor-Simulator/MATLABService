classdef udp < icinterface & instrument.internal.ICTRemoveFunctionalityHelper
    %UDP Construct UDP object.
    %
    %   UDP will be removed in a future release. Use udpport instead.
    %
    %   OBJ = UDP('') constructs an UDP object not associated with a remote host.
    %
    %   OBJ = UDP('RHOST') constructs an UDP object associated with remote host,
    %   RHOST.
    %
    %   OBJ = UDP('RHOST', RPORT) constructs an UDP object associated with remote
    %   host, RHOST, and remote port value, RPORT.
    %
    %   The object, OBJ, must be bound to the local socket with the FOPEN function.
    %   The default remote port is 9090. The default local host in multi-homed
    %   hosts is the systems default. The LocalPort property defaults to a value of
    %   [], and it causes any free local port to be picked up as the local port. The
    %   LocalPort property is updated when FOPEN is issued.
    %
    %   When the UDP object is constructed, the object's Status property is closed.
    %   Once the object is bound to the local socket with the FOPEN function, the
    %   Status property is configured to open.
    %
    %   OBJ = UDP(...,'P1',V1,'P2',V2,...) construct UDP objects with the specified
    %   properties, P1, etc., and values V1, etc. If an invalid property name or
    %   property value is specified the object will not be created.
    %
    %   Note that the property value pairs can be in any format supported by the
    %   SET function, i.e., property-value string pairs, structures, and
    %   property-value cell array pairs.
    %
    % UDP Functions
    % UDP object construction.
    %   udp            - Construct UDP object.
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
    % UDP Functions
    %   echoudp        - Create a UDP echo server.
    %   resolvehost    - Return IP address or name of network address.
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
    % UDP Properties
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
    %   DatagramAddress           - Specifies remote host for the next datagram available for reading.
    %   DatagramPort              - Specifies remote port for the next datagram available for reading.
    %   DatagramReceivedFcn       - Callback function executed when a datagram is received.
    %   DatagramTerminateMode     - Configure how FREAD and FSCANF terminate the read operation.
    %   EnablePortSharing         - Enables multiple UDP socket bindings to this
    %                               sockets LocalPort.
    %   ErrorFcn                  - Callback function executed when an error occurs.
    %   InputBufferSize           - Total size of the input buffer.
    %   Name                      - Descriptive name of the udp object.
    %   ObjectVisibility          - Control access to an object by command-line users and
    %                               GUIs.
    %   OutputBufferSize          - Total size of the output buffer.
    %   OutputEmptyFcn            - Callback function executed when output buffer is
    %                               empty.
    %   LocalHost                 - Description of a socket local host.
    %   LocalPort                 - Description of a socket local port.
    %   LocalPortMode             - Specify automatic local port assignment.
    %   ReadAsyncMode             - Specify whether an asynchronous read operation
    %                               is continuous or manual.
    %   RecordDetail              - Amount of information recorded to disk.
    %   RecordMode                - Specify whether data is saved to one disk file
    %                               or to multiple disk files.
    %   RecordName                - Name of disk file to which data sent and
    %                               received is recorded.
    %   RecordStatus              - Indicates if data is being written to disk.
    %   RemoteHost                - Description of a network host.
    %   RemotePort                - Description of a network host port.
    %   Status                    - Indicates if the udp object is connected
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
    %       echoudp('on',4012)
    %       u = udp('127.0.0.1',4012);
    %       fopen(u)
    %       fwrite(u,65:74)
    %       A = fread(u, 10);
    %       fclose(u)
    %       delete(u)
    %       echoudp('off')
    %
    %   See also UDPPORT, ECHOUDP, ICINTERFACE/FOPEN, INSTRUMENT/PROPINFO, INSTRHELP
    %
    
    %   Copyright 1999-2021 The MathWorks, Inc.
    
    properties(Hidden, SetAccess = 'public', GetAccess = 'public')
        icinterface
    end
    
    
    methods
        function obj = udp(varargin)

            % Create the class that will throw a warning and error as part of the
            % legacy interface remove functionality "Warn" phase and "Error" phases.
            obj = obj@instrument.internal.ICTRemoveFunctionalityHelper("udp");

            obj = obj@icinterface('udp');
            % Create the parent class.
            try
                obj.icinterface = icinterface('udp');
            catch
                newExc = MException('instrument:udp:nojvm','UDP objects require JAVA support.');
                throw(newExc);
            end
            
            defaultPort = 9090;
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            switch (nargin)
                case 0
                    host = '';
                    port = defaultPort;
                    props = {};
                case 1
                    host = varargin{1};
                    port = defaultPort;
                    props = {};
                case 2
                    host = varargin{1};
                    port = varargin{2};
                    if ~localIsValidPort(port)
                        error(message('instrument:udp:invalidRPORT'));
                    end
                    props = {};
                otherwise
                    % Ex. t = tcpip('144.212.100.10', 8080, 'p','v',...);
                    host = varargin{1};
                    port = varargin{2};
                    if isa(port,'numeric')
                        if ~localIsValidPort(port)
                            error(message('instrument:udp:invalidRPORT'));
                        end
                        iniprop = 3;
                    else
                        port = defaultPort;
                        iniprop = 2;
                    end
                    props = {varargin{iniprop:end}};
            end
            
            % Set the doc ID for the interface object. This sets values for
            % DocIDNoData and DocIDSomeData
            obj = obj.setDocID('udp');
            
            % parse the host
            if (strcmp(class(host), 'char'))
                % Ex. t = udpp('144.212.100.10')
                % Call the java constructor and store the java object in the
                % udp object.
                try
                    obj.jobject = handle(com.mathworks.toolbox.instrument.UDP(host,port));
                catch aException
                    newExc = MException('instrument:udp:cannotCreate', aException.message);
                    throw(newExc);
                end
            elseif strcmp(class(host), 'udp')
                obj = host;
            elseif isa(host, 'com.mathworks.toolbox.instrument.UDP')
                obj.jobject = handle(host);
            elseif isa(host, 'javahandle.com.mathworks.toolbox.instrument.UDP')
                obj.jobject = host;
            elseif ishandle(host)
                % True if loading an array of objects and the first is a TCPIP object.
                if ~isempty(findstr(class(host(1)), 'com.mathworks.toolbox.instrument.UDP'))
                    obj.jobject = host;
                else
                    error(message('instrument:udp:invalidRHOST'));
                end
            else
                error(message('instrument:udp:invalidRHOST'));
            end
            
            if ~isempty(props)
                % Try setting the object properties.
                try
                    set(obj, varargin{iniprop:end});
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
% Determine if the specified port is in a valid range.
function out = localIsValidPort(port)

out = true;
if (~(isa(port,'numeric') && (port >= 1) && (port <= 65535) && (fix(port) == port)))
    out = false;
end
% *******************************************************************
end
% Fix the error message.
function localFixError (exception)

% Initialize variables.
errmsg = exception.message;

% Remove the trailing carriage returns from errmsg.
while errmsg(end) == sprintf('\n')
    errmsg = errmsg(1:end-1);
end

newExc = MException(exception.identifier , errmsg);
throwAsCaller(newExc);

end
