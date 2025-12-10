classdef LegacyIcdevice < instrument
    %ICDEVICE Construct device object.
    %
    %   OBJ = ICDEVICE(DRIVER, HWOBJ) constructs a device object, OBJ. The
    %   instrument specific information is defined in the MATLAB interface
    %   instrument driver, DRIVER. Communication to the instrument is done
    %   through the interface object, HWOBJ. An interface object is a serial
    %   port, GPIB, VISA, TCPIP or UDP object. If the DRIVER does not exist or
    %   HWOBJ is invalid, the device object will not be created.
    %
    %   Device objects may also be used with VXIplug&play and Interchangeable
    %   Virtual Instrument (IVI) drivers. To use these drivers you must first
    %   have a MATLAB instrument driver wrapper for the underlying VXIplug&play
    %   or IVI driver.  If the MATLAB instrument driver wrapper does not
    %   already exist, it may be created using MAKEMID or MIDEDIT. Note that
    %   MAKEMID or MIDEDIT only needs to be used once to create the MATLAB
    %   instrument driver wrapper.
    %
    %   OBJ = ICDEVICE(DRIVER) constructs a device object, OBJ using the
    %   MATLAB instrument driver, DRIVER. DRIVER must be a MATLAB IVI
    %   instrument driver, and the underlying IVI driver must be referenced
    %   using a logical name.
    %
    %   OBJ = ICDEVICE(DRIVER, RSRCNAME) constructs a device object, OBJ
    %   using the MATLAB instrument driver, DRIVER. DRIVER must be a MATLAB
    %   VXIplug&play instrument driver or MATLAB IVI instrument driver.
    %   Communication to the instrument is done through the resource specified
    %   by RSRCNAME.  For example, all VXIplug&play, and many IVI drivers
    %   require VISA resource names for RSRCNAME.
    %
    %   OBJ = ICDEVICE(DRIVER, RSRCNAME, 'optionstring', OPTIONSTRING) constructs a
    %   driver object using DRIVER and RSRCNAME, and passes OPTIONSTRING to
    %   the root Initialize method.  One common OPTIONSTRING would be
    %   'Simulate=true'
    %
    %   In order to communicate with the instrument, the device object must be
    %   connected to the instrument with the CONNECT function.
    %
    %   When the device object is constructed, the object's Status property is
    %   closed. Once the device object is connected to the instrument with the
    %   CONNECT function, the Status property is configured to open.
    %
    %   OBJ = ICDEVICE(DRIVER, P1, V1, P2, V2, ...)
    %   OBJ = ICDEVICE(DRIVER, RSRCNAME, P1, V1, P2, V2, ...)
    %   OBJ = ICDEVICE(DRIVER, RSRCNAME, 'optionstring', OPTIONSTRING, P1, V1, P2, V2, ...)
    %   OBJ = ICDEVICE(DRIVER, HWOBJ, P1, V1, P2, V2,...)
    %
    %   constructs a device object, OBJ, with the specified property
    %   values. If an invalid property name or property value is specified, the
    %   object will not be created.
    %
    %   Note that the param-value pairs can be in any format supported by the
    %   SET function, i.e., param-value string pairs, structures, and
    %   param-value cell array pairs.
    %
    % ICDEVICE Functions
    % ICDEVICE object construction.
    %   icdevice       - Construct ICDevice (device) object.
    %
    % Getting and setting parameters.
    %   get            - Get value of instrument object property.
    %   set            - Set value of instrument object property.
    %
    % State change.
    %   connect        - Connect object to instrument.
    %   disconnect     - Disconnect object from instrument.
    %
    % Instrument functions.
    %   devicereset    - Reset the instrument.
    %   geterror       - Check and return error message from instrument.
    %   selftest       - Run the instrument self-test.
    %   invoke         - Execute function on device object.
    %
    % General.
    %   delete         - Remove instrument object from memory.
    %   inspect        - Open inspector and inspect instrument object properties.
    %   instrid        - Define and retrieve commands used to identify instruments.
    %   isvalid        - True for instrument objects that can be connected to
    %                    instrument.
    %   obj2mfile      - Convert instrument object to MATLAB code.
    %
    % Information and Help.
    %   propinfo       - Return instrument object property information.
    %
    % ICDEVICE Properties
    %   DriverName         - Specifies the name of driver used to communicate
    %                        with instrument.
    %   DriverType         - Specifies the type of driver used to communicate
    %                        with instrument.
    %   InstrumentModel    - Model of the instrument.
    %   Interface          - Specifies the interface used to communicate with instrument.
    %   LogicalName        - Specifies an alias for the driver and interface used
    %                        to communicate with an instrument.
    %   RsrcName           - Specifies a description of the interface used to communicate
    %                        with the instrument.
    %   Status             - Indicates if the device object is connected to the
    %                        instrument.
    %   Tag                - Label for object.
    %   Timeout            - Seconds to wait to receive data.
    %   Type               - Object type.
    %   UserData           - User data for object.
    %
    %   Example using a MATLAB interface instrument driver:
    %       % Construct a device object that has specific information about a
    %       % Tektronix TDS 210 instrument. The instrument information is defined
    %       % in a MATLAB interface driver.
    %       g = gpib('ni', 0, 2);
    %       d = icdevice('tektronix_tds210', g);
    %
    %       % Connect to the instrument
    %       connect(d);
    %
    %       % List the oscilloscope settings that can be configured.
    %       props = set(d);
    %
    %       % Get the current configuration of the oscilloscope.
    %       values = get(d);
    %
    %       % Disconnect from the instrument and clean up.
    %       disconnect(d);
    %       delete([g d]);
    %
    %   Example using a MATLAB VXIplug&play instrument driver:
    %       % This example assumes that the 'tktds5k' VXIplug&play driver is
    %       % installed on your system.
    %
    %       % This first step is only necessary if the MATLAB VXIplug&play
    %       % instrument driver for the tktds5k does not exist on your system.
    %       makemid('tktds5k', 'Tktds5kMATLABDriver');
    %
    %       % Construct a device object that uses the VXIplug&play driver.  The
    %       % instrument is assumed to be located at a GPIB primary address of
    %       % 2.
    %       d = icdevice('Tktds5kMATLABDriver', 'GPIB0::2::INSTR');
    %
    %       % Connect to the instrument
    %       connect(d);
    %
    %       % List the oscilloscope settings that can be configured.
    %       props = set(d);
    %
    %       % Get the current configuration of the oscilloscope.
    %       values = get(d);
    %
    %       % Disconnect from the instrument and clean up.
    %       disconnect(d);
    %       delete(d);
    %
    %   See also ICDEVICE/CONNECT, ICDEVICE/DISCONNECT.

    % General.
    %   instrfind      - Find instrument objects with specified property values.
    %   instrfindall   - Find all instrument objects regardless of ObjectVisibility.
    %   instrnotify    - Define notification for instrument events.
    %   instrreset     - Disconnect and delete all instrument objects.
    %
    % Information and Help.
    %   instrhelp      - Display instrument object function and property help.
    %
    % Instrument Control tools.
    %   midedit        - Edit MATLAB instrument driver file.
    %   midtest        - Launch GUI for testing MATLAB instrument driver.
    %
    % Instrument Control tools.
    %   tmtool         - Tool for browsing available instruments, configuring
    %                    instrument communication and communicating with
    %                    instruments.
    
    %   Copyright 1999-2024 The MathWorks, Inc.

    properties
        % instrument - reference for serializing data
        instrument
    end

    properties (Constant)
        % LegacyMode is a boolean flag used to switch between legacy and
        % new driver interface modes
        %
        % True: operates in legacy mode
        % False: operates in new driver interface
        LegacyMode = true
    end

    properties(Constant, Access = private)
        % InterfaceTypeMap - Maps the class type of the new ICT interfaces
        % with the associated factory function names. The keys are the
        % actual class types, and their associated values are the
        % documented factory function names.
        InterfaceTypeMap = containers.Map(["internal.Serialport", "tcpclient", "visalib.Resource"], ... % keys
            ["serialport", "tcpclient", "visadev"]); % values
    end

    methods
        function obj = LegacyIcdevice(varargin)           
            
            obj = obj@instrument('icdevice');
            % Create the parent class.
            try
                obj.instrument = instrument('icdevice');
            catch aException
                rethrow(aException);
            end
            
            % Initialize variables.
            props = {};
            optionstring = '';
            
            % convert to char in order to accept string datatype
            varargin = instrument.internal.stringConversionHelpers.str2char(varargin);
            
            % Parse inputs.
            switch (nargin)
                case 0
                    % Need at least one input to ICDEVICE
                    error(message('instrument:icdevice:icdevice:toofewargs'));
                case 1
                    hwobj = varargin{1};
                    
                    if strfind(class(hwobj),'ICDevice')
                        % This case happens when connect and disconnect and
                        % potentially other methods of ICDEVICE are invoked
                        obj.jobject = handle(hwobj);
                        obj.constructor = 'icdevice';
                        return;
                    else
                        % This case is when the driver has  all information
                        % needed to make the connection. Particular cases
                        % are Generic Instrument Driver, or a MATLAB IVI
                        % Instrument Driver created from a logical name
                        driver = varargin{1};
                        hwobj = '';
                    end
                case 2
                    % Creating a device object with a driver and one
                    % additional input
                    
                    % Driver is always the first argument when invoked with
                    % two or more input arguments
                    driver = varargin{1};
                    
                    if isa(varargin{2},'struct')
                        % User passed in input P-V pairs as a structure.
                        % There is no resource name or interface object.
                        hwobj = '';
                        props = varargin(2);
                    else
                        % User passed in driver and resource name, or
                        % driver and interface object
                        hwobj  = varargin{2};
                    end
                otherwise
                    % Driver is always the first argument when invoked with
                    % two or more input arguments
                    driver = varargin{1};
                    % The second argument can be a resource name, or a
                    % parameter. Assume it is a resource name or interface
                    % object. It will be changed below if it is not a
                    % resource name.
                    hwobj = varargin{2};
                    % Assume additional input arguments are PV pairs. It
                    % will be changed below if not.
                    iFirstProp = 3;
                    
                    if ischar( varargin{2} )
                        [driverName, driverType] = getDriverNameAndType(driver);
                        if strncmpi(driverType,'MATLAB IVI',10)
                            % IVI driver. Input could be resource string
                            % and P-V pairs
                            
                            % Check if this is IVI driver made from logical
                            % name and the input string is not a VISA
                            % resource string
                            if isValidLogicalName(driverName) && ~isValidVISAResource(varargin{2})
                                % Driver made from logical name does
                                % not need resource. Treat all inputs
                                % as P-V pairs since 2nd argument is
                                % not a VISA resource
                                hwobj  = '';
                                iFirstProp = 2;
                            end
                        elseif strcmpi(driverType,'MATLAB generic')
                            if mod(nargin,2)
                                % If there are odd number of arguments
                                % including the driver, then, the 2nd input
                                % argument onwards is a PV pair
                                hwobj  = '';
                                iFirstProp = 2;
                            end
                        end
                    end
                    
                    if nargin >= 4 && ischar(varargin{3}) && ischar(varargin{4}) &&...
                            strcmpi(varargin{3},'optionstring')
                        % The 3rd and 4th arguments are 'optionstring' and
                        % the value to be passed in for the optionstring
                        % parameter.
                        iFirstProp = 5;
                        optionstring = varargin{4};
                    end
                    
                    if (isa(hwobj, 'instrument') || isa(hwobj, 'char')) && nargin >= iFirstProp
                        % Creating a device object that uses a MATLAB instrument driver
                        % with property values specified.
                        props  = varargin(iFirstProp:end);
                    end
            end
            
            % Error checking.
            if ~ischar(driver)
                error(message('instrument:icdevice:icdevice:invalidDriver'));
            end
            
            % Error checking if creating a device object that uses a MATLAB instrument
            % driver.
            if (~isempty(hwobj) && ~ischar(hwobj))
                if ~isa(hwobj, 'icinterface')
                    errStruct.message = getErrorMessageForInterfaceTypes(hwobj);
                    errStruct.identifier = "instrument:icdevice:icdevice:invalidType";
                    error(errStruct);
                end
                
                if (length(hwobj) > 1)
                    error(message('instrument:icdevice:icdevice:invalidLength'));
                end
                
                if ~isvalid(hwobj)
                    error(message('instrument:icdevice:icdevice:invalidobj'));
                end
            end
            
            % Store the warning state. A warning could occur if there is a problem with
            % the driver - on object creation.
            warnState = warning('backtrace', 'off');
            c=onCleanup(@()warning(warnState));
            
            try
                mdd  = localFindMATLABInstrumentDriverPath(driver);
            catch %#ok<CTCH>
                newExc =  MException('instrument:icdevice:icdevice:driverNotFound','The specified MATLAB instrument driver could not be found. DRIVER must be on the MATLAB path.' );
                throw(newExc);
            end
            
            
            % Create the object.
            if ~ischar(hwobj)
                                
                obj.jobject= localCreateMWIDObject(driver, hwobj);
            else
                
                obj.jobject = localCreateWithMatlabInstrumentDriver(mdd, hwobj,optionstring);
            end
            
            if  isempty(obj.jobject)
                errorID = 'instrument:icdevice:icdevice:invalidDriver';
                newExc =  MException(errorID,['The IVI or VXIplug&play driver referenced in ' driver ' could not be found.'] );
                throw(newExc);
            end
            
            % Assign the constructor.
            obj.constructor = 'icdevice';
            
            % Pass the OOPs object to java. Used for callbacks.
            obj.jobject(1).setMATLABObject(obj);
            
            % Determine what group objects are supported by the device object.
            jobj = java(obj.jobject);
            groups = jobj.getPropertyGroups;
            
            for i = 0:groups.size-1
                dc = jobj.getJGroup(groups.elementAt(i));
                dcGroup = icgroup(dc);
                jobj.assignMATLABGroup(groups.elementAt(i), dcGroup, localArray2Cell(dcGroup));
            end
            
            % Try configuring the object properties.
            if ~isempty(props)
                try
                    set(obj, props{:});
                catch aException
                    delete(obj);
                    instrgate('privateFixError', aException);
                end
            end
            
            hwobjOpen = awtinvoke(jobj,'getStatus');
            
            % Execute create code.
            try
                code = char(getCreateInitializationCode(jobj));
                willExecuteDriverCreateCode(jobj);
                instrgate('privateEvaluateCode', obj, code);
                didExecuteDriverCreateCode(jobj);
            catch aException
                delete(obj);
                msg = sprintf(['An error occurred while executing the driver create code.\n'...
                    '%s\nIf the error is not an instrument error, use MIDEDIT to inspect the driver.'...
                    ], aException.message);
                newExc = MException('instrument:icdevice:icdevice:opfailed' , msg);
                throw(newExc);
                
            end
            
            % The hardware may be connected already, which would cause the device
            % to appear connected when it really isn't.  We need to call the connect
            % code to be safe if the hardware is connected.  g358905 MJ
            % Restore the status of the hwobj.
            if( hwobjOpen )
                % Execute initialization and connect code.
                try
                    fopen(hwobj);
                    
                    code = char(getConnectInitializationCode(jobj));
                    willExecuteDriverConnectCode(jobj);
                    instrgate('privateEvaluateCode', obj, code);
                    didExecuteDriverConnectCode(jobj);
                catch aException
                    delete(obj);
                    msg = sprintf(['An error occurred while executing the driver initialization, or connect code.\n'...
                        '%s\nIf the error is not an instrument error, use MIDEDIT to inspect the driver.'...
                        ], aException.message);
                    
                    newExc = MException('instrument:icdevice:icdevice:opfailed' , msg);
                    throw(newExc);
                end
            end
            
            
        end
    end
    
    % Separate Files
    methods(Static = true, Hidden = true)
        obj = loadobj(B)
    end
    
end

% -------------------------------------------------------------------------
% Check if logical name is in the configuration store.
function ret = isValidLogicalName(logicalName)
ret = false;
try
    h = actxserver('IviConfigServer.IviConfigStore.1');
    h.Deserialize(h.MasterLocation);
    
    logicals = get(h, 'LogicalNames');
    
    for idx = 1:logicals.Count
        if (strcmpi(logicalName, logicals.Item(idx).Name) == 1)
            ret =  true;
            break;
        end
    end
catch %#ok<CTCH>
    return;
end
end

% -------------------------------------------------------------------------
% Get the associated error message when creating a SCPI-Based MDD driver
% with an invalid hwobj type.
function msg = getErrorMessageForInterfaceTypes(hwobj)
msg = message("instrument:icdevice:icdevice:expectedHardwareObjectType").string;

allNewTypes = LegacyIcdevice.InterfaceTypeMap;
newType = string.empty;

for type = string(keys(allNewTypes))
    if isa(hwobj, type)
        newType = allNewTypes(type);
        break
    end
end

% The hwobj is a new ICT interface (visadev, serialport, tcpclient). Add
% the extra error line to the error message in this case.
if ~isempty(newType)
    msg = message("instrument:icdevice:icdevice:useIcdeviceSupportedAPI", newType).string;
end

end

% -------------------------------------------------------------------------
% Check if input string is a valid VISA Resource
function ret = isValidVISAResource(VISARsrc)
% Suppress warn phase warnings
originalWarningState = warning;
cleanup = onCleanup(@()warning(originalWarningState));
warning('off',"instrument:instrhwinfo:FunctionToBeRemoved");

ret = false;
% Cycle through all installed adaptors to check if this is a valid VISA
% resource defined in the VISA
visas = instrhwinfo('visa');
for iLoop = 1:numel(visas.InstalledAdaptors)
    % Locate the adaptor
    adaptorName = lower(['mw' visas.InstalledAdaptors{iLoop} 'visa']);
    instrRoot = which('instrgate', '-all');
    adaptorRoot = [fileparts(instrRoot{1}) 'adaptors'];
    dirname = instrgate('privatePlatformProperty', 'dirname');
    extension = instrgate('privatePlatformProperty', 'libext');
    pathToDll = fullfile(adaptorRoot,dirname);
    vendor = [adaptorName extension];
    info = [];
    % Check if this is a VISA alias defined in the vendor VISA
    try
        tempobj = com.mathworks.toolbox.instrument.SerialVisa(pathToDll,vendor,'ASRL1::INSTR','');
        info = getAliasInfo(tempobj, VISARsrc);
        tempobj.dispose;
    catch
        % Exception ocurred while trying to find if this is a valid VISA
        % resource. Catch the exception and move on.
    end
    if ~isempty(info)
        % If we are here, the VISARsrc is a valid VISA resource.
        ret = true;
        break;
    end
end
end

% -------------------------------------------------------------------------
% Get Name and Type of MATLAB Driver
function [driverName, driverType] = getDriverNameAndType(driver)
try
    driver = localFindMATLABInstrumentDriverPath(driver);
    driverContentDOM = parseFile(matlab.io.xml.dom.Parser, driver);
catch someException
    if strcmpi(someException.identifier,'MATLAB:Java:GenericException')
        % Will get into this case if the XML file is not properly
        % terminated
        errorID = 'instrument:icdevice:icdevice:invalidDriver';
        newExc = MException(errorID , sprintf('The driver %s is not a valid MATLAB instrument driver.',strrep(driver,'\','\\')));
        throwAsCaller(newExc);
    else
        errorID = 'instrument:icdevice:icdevice:driverNotFound';
        newExc = MException(errorID , someException.message);
        throwAsCaller(newExc);
    end
end
driverTypeNodes = driverContentDOM.getElementsByTagName('DriverType');
driverNameNodes = driverContentDOM.getElementsByTagName('DriverName');
if ~isequal(driverTypeNodes.getLength,1) && ~isequal(driverNameNodes.getLength,1)
    errorID = 'instrument:icdevice:icdevice:invalidDriver';
    newExc = MException(errorID , sprintf('The driver %s is not a valid MATLAB instrument driver.',strrep(driver,'\','\\')));
    throwAsCaller(newExc);
end

driverTypeNode = driverTypeNodes.item(0);
driverType = char(driverTypeNode.getTextContent);

driverNameNode = driverNameNodes.item(0);
driverName = char(driverNameNode.getTextContent);
[~,driverName,~] = fileparts(driverName);
end

% -------------------------------------------------------------------------
% Create a device object that uses a MATLAB Instrument Driver.
function obj = localCreateMWIDObject(driver, hwobj)

% Find the location of the MATLAB instrument driver.
driver = localFindMATLABInstrumentDriverPath(driver);

% Create the object.
try
    obj = handle(com.mathworks.toolbox.instrument.device.icdevice.ICDeviceObject.getInstance(driver, hwobj, java(igetfield(hwobj, 'jobject'))));
catch aException
    errorID = 'instrument:icdevice:icdevice:invalidDriver';
    newExc = MException(errorID , aException.message);
    throwAsCaller(newExc);
end
end

% -------------------------------------------------------------------------
% Find the location of the MATLAB instrument driver.
function driver = localFindMATLABInstrumentDriverPath(driver)

% Find the driver.
[pathstr, ~, ext] = fileparts(driver);
if isempty(ext)
    driver = [driver '.mdd'];
end

if isempty(pathstr)
    driverWithPath = which(driver);
    % If found driver, use it.
    if ~isempty(driverWithPath)
        driver = driverWithPath;
    end
end

% If not on MATLAB path, check the drivers directory.
pathstr = fileparts(driver);
if isempty(pathstr)
    driver = fullfile(matlabroot,'toolbox','instrument','instrument','drivers', driver);
end

% Verify that the driver exists.
if ~exist(driver, 'file')
    newExc = MException(message('instrument:icdevice:icdevice:driverNotFound'));
    throwAsCaller(newExc);
end
end

% -------------------------------------------------------------------------
% Load a VXIplug&play driver library. Returns false if the driver is not
% found. Throws error if a problem occurs loading the driver.
function [driverFound, errflag] = localLoadVXIPnPLibrary(driverName)

driverFound = true;
errflag = false;

prefix = instrgate('privateGetVXIPNPPath');

if strcmpi(computer, 'pcwin64')
    binary = fullfile(prefix, 'bin', [driverName '_64.dll']);
else
    binary = fullfile(prefix, 'bin', [driverName '_32.dll']);
end

if (~exist(binary, 'file'))
    binary = fullfile(prefix, 'Bin', [driverName '.dll']);
end

if (~exist(binary, 'file'))
    driverFound = false;
    return;
end

includePath = fullfile(prefix, 'include');
includeFile = fullfile(includePath, [driverName '.h']);

visaIncludePath = instrgate('privateGetIviPath');

if (~isempty(visaIncludePath))
    if (exist(fullfile(visaIncludePath, 'include', 'visa.h'), 'file'))
        visaIncludePath = fullfile(visaIncludePath, 'include');
    else
        visaIncludePath = localToolboxVisaPath;
    end
else
    visaIncludePath = localToolboxVisaPath;
end

if (~libisloaded(driverName))
    errflag = instrgate('privateIviCLoadlibrary',driverName, binary, includeFile, includePath, visaIncludePath);
end
end

% -------------------------------------------------------------------------
% Load an IVI-C driver library. Returns false if the driver is not found.
% Throws error if a problem occurs loading the driver.
function [driverFound, errflag] = localLoadIviCLibrary(driverName)

driverFound = true;
errflag = false;

prefix = instrgate('privateGetIviPath');

if strcmpi(computer, 'pcwin64')
    binary = fullfile(prefix, 'bin', [driverName '_64.dll']);
else
    binary = fullfile(prefix, 'bin', [driverName '_32.dll']);
end

if (~exist(binary, 'file'))
    binary = fullfile(prefix, 'Bin', [driverName '.dll']);
end

if (~exist(binary, 'file'))
    driverFound = false;
    return;
end

includePath = fullfile(prefix, 'Include');
includeFile = fullfile(includePath, [driverName '.h']);

visaIncludePath = localToolboxVisaPath;

if (~libisloaded(driverName))
    errflag = instrgate('privateIviCLoadlibrary',driverName, binary, includeFile, includePath, visaIncludePath);
end
end

% for 64 bit support, sometimes visa.h and vpptype.h is not installed under visa\win64\include , instead
% it is in visa\win64\agvisa\include,
function visaIncludePath = localToolboxVisaPath

visaIncludePath = {};
visaPath = instrgate('privateGetVXIPNPPath');

if (~isempty (visaPath))
    visaIncludePath(end+ 1) =  {fullfile(visaPath, 'include')};
    visaIncludePath(end+ 1)  =  {fullfile(visaPath, 'agvisa','include')};
    
end

end

% -------------------------------------------------------------------------
% Attempt to locate an IVI-C driver from a logical name

function [ivicDriverFileName, resourceName, optionstring , errflag ] = localIviCDriverGetInfoFromLogicalName(logicalName)

resourceName ='';
optionstring ='';
errflag = false;

try
    h = actxserver('IviConfigServer.IviConfigStore.1');
    h.Deserialize(h.MasterLocation);
    
    logicalNameRef = [];
    logicals = get(h, 'LogicalNames');
    
    for idx = 1:logicals.Count
        if (strcmpi(logicalName, logicals.Item(idx).Name) == 1)
            logicalNameRef = logicals.Item(idx);
            break;
        end
    end
    ivicDriverFileName = logicalNameRef.Session.SoftwareModule.Name;
    resourceName = logicalNameRef.Session.HardwareAsset.IOResourceDescriptor;
    simulate = logicalNameRef.Session.Simulate;
    if (simulate ==1)
        optionstring = 'simulate=true';
    end
catch %#ok<CTCH>
    errflag = true;
    return;
end
end
% -------------------------------------------------------------------------
% Load an IVI driver using the configuration server and a logical name.
function [progid, comobj, instrType,resourceName, simulate , errflag ] = localIviFromLogicalName(instrumenttype,logicalName,driverFileVersion)

resourceName ='';
simulate = 0;
%If the driver was created in R2007a (ICT version 2.42) or later, then use
% IUnknown to create the COM object.
if driverFileVersion >= 2.42
    useIUnknown = true;
else
    useIUnknown = false;
end

comobj = [];
progid = '';
instrType = '';
errflag = false;

try
    h = actxserver('IviConfigServer.IviConfigStore.1');
    h.Deserialize(h.MasterLocation);
    
    logicalNameRef = [];
    logicals = get(h, 'LogicalNames');
    
    for idx = 1:logicals.Count
        if (strcmpi(logicalName, logicals.Item(idx).Name) == 1)
            logicalNameRef = logicals.Item(idx);
            break;
        end
    end
    
    resourceName = logicalNameRef.Session.HardwareAsset.IOResourceDescriptor;
    simulate = logicalNameRef.Session.Simulate;
    swm = logicalNameRef.Session.SoftwareModule;
    progid = swm.ProgID;
    instrType = swm.Prefix;
    
catch %#ok<CTCH>
    % Failed to locate a program id through the configuration server for a
    % given logical name.  May or may not be an error to calling function.
    return;
end

try
    if useIUnknown
        % Use IUnknown interface for R2007a drivers and later
        comobj = actxserver(progid,'interface','IUnknown');
        comobj = invoke(comobj,instrumenttype);
    else
        % Use IDispatch for R2006b and earlier
        comobj = actxserver(progid);
        
    end
catch %#ok<CTCH>
    % A potentially valid driver was identified, however the load failed.
    % This is a failure.
    errflag = true;
end
end

% -------------------------------------------------------------------------
% Load an IVI driver using a program id and resource name.  Does not use
% the IVI Configuration server.
function [comobj, instrType, errflag] = localIviFromProgramID(instrumenttype,progid,driverFileVersion)
%If the driver was created in R2007a (ICT version 2.42) or later, then use IUnknown to create
%the COM object.
if driverFileVersion >= 2.42
    useIUnknown = true;
else
    useIUnknown = false;
end

comobj = [];
instrType = [];
errflag = false;

try
    if useIUnknown
        % Use IUnknown interface for R2007a drivers and later
        comobj = actxserver(progid,'interface','IUnknown');
    else
        % Use IDispatch for R2006b and earlier
        comobj = actxserver(progid);
    end
catch %#ok<CTCH>
    return;
end

if (isempty(comobj))
    return;
end


try
    % for backward compatibility
    if  any(strcmpi(instrumenttype, { 'dc power supply', 'digital multimeter', 'filter', 'function generator', 'vector analyzer' ,'oscilloscope', 'switch' } ))
        idx = find(progid == '.');
        if (~isempty(idx))
            instrumenttype = ['I' progid(1:(idx(1) - 1))];
        else
            instrumenttype = ['I' progid];
        end
    end
    
    if useIUnknown
        comobj = invoke(comobj,instrumenttype);
    end
catch %#ok<CTCH>
    errflag = true;
end
end


% -------------------------------------------------------------------------
% Load a MATLAB instrument driver file that is not of type MID.
function obj = localCreateWithMatlabInstrumentDriver(fullDriverName, resourceName,optionstring)
import com.mathworks.toolbox.instrument.device.icdevice.ICDeviceObject;
import com.mathworks.toolbox.instrument.device.drivers.xml.Parser;
import com.mathworks.toolbox.instrument.device.Device;

obj = [];

try
    parser = Parser(fullDriverName);
    parser.setWarnState(false);
    parser.parse;
    parser.setWarnState(true);
catch aException
    throwAsCaller(aException);
end

driverTypeId = parser.getDriverTypeId;
driverFileVersion = str2num(parser.getFileVersion); %#ok<ST2NM>

if driverFileVersion > 2.43
    warning(message('instrument:icdevice:icdevice:futuredriver'));
end

switch (char(driverTypeId))
    case Device.VXIPNP
        if (~ispc)
            errorID = 'instrument:icdevice:icdevice:platformNotSupported';
            newExc = MException( errorID, 'VXIplug&play is supported on the Windows platform only.');
            throwAsCaller(newExc);
        end
        
        try
            obj = handle(ICDeviceObject.getInstance(parser, resourceName));
            vxiDriverFileName = get(obj, 'DriverName');
        catch aException
            localDispose(obj);
            errorID = 'instrument:icdevice:icdevice:invalidDriver';
            newExc = MException(errorID,aException.message );
            throwAsCaller(newExc);
        end
        
        driverFound = localLoadVXIPnPLibrary(vxiDriverFileName);
        if (~driverFound)
            localDispose(obj);
            errorID = 'instrument:icdevice:icdevice:invalidDriver';
            theMessage  = sprintf('The VXIplug&play driver referenced in %s cannot be found.', strrep(fullDriverName,'\','\\'));
            newExc = MException( errorID, theMessage);
            throwAsCaller(newExc);
        end
        obj.OptionString = optionstring;
        
    case Device.IVI_C
        if (~ispc)
            errorID = 'instrument:icdevice:icdevice:platformNotSupported';
            newExc = MException( errorID, 'IVI-C is supported on the Windows platform only.');
            throwAsCaller(newExc);
        end
        
        ivicDriverFileName = char(parser.getDriverName);
        % if mdd's driverName is a logical name in the configstore, probe the entry
        % to get more info such as real driver name, resource name, optionstring etc...
        IVIInfo = instrhwinfo('ivi');
        if ismember (ivicDriverFileName, IVIInfo.LogicalNames )
            [ivicDriverFileName, resourceName , optionstring, errflag ] = localIviCDriverGetInfoFromLogicalName(ivicDriverFileName);
            if  errflag
                errorID ='instrument:icdevice:icdevice:driverNotLoaded';
                e = MException(errorID,sprintf('%s referenced in %s is not valid, does not point to a valid software module or requires a resource string.\n', ivicDriverFileName, strrep(fullDriverName,'\','\\')));
                throw (e);
            end
        end
        try
            obj = handle(ICDeviceObject.getInstance(parser, resourceName));
            %need to set java instrument object's driver name to the underlying
            %driver name instead of using logical name (will fail upon
            %calling library APIs )
            obj.setDriverName( ivicDriverFileName);
            driverFound = localLoadIviCLibrary(ivicDriverFileName);
            if (~driverFound)
                localDispose(obj);
                errorID = 'instrument:icdevice:icdevice:invalidDriver';
                newExc = MException( errorID, sprintf('The IVI-C driver referenced in %s cannot be found.', strrep(fullDriverName,'\','\\')));
                throwAsCaller(newExc);
            end
            obj.OptionString = optionstring;
        catch aException
            localDispose(obj);
            errorID = 'instrument:icdevice:icdevice:invalidDriver';
            newExc = MException(errorID,strrep(aException.message,'\','\\'));
            throwAsCaller(newExc);
        end
        
    case Device.IVI_C_CLASS
        if (~ispc)
            errorID = 'instrument:icdevice:icdevice:platformNotSupported';
            newExc = MException( errorID, 'IVI-C is supported on the Windows platform only.');
            throwAsCaller(newExc);
        end
        
        try
            % for ivi-c class driver, resourceName is actually a logical
            % name which represents a underlying ivi-c class specific driver.
            % need to verify it is valid logical name
            if ~isValidLogicalName(resourceName)
                errorID = 'instrument:icdevice:icdevice:notValidLogicalName';
                newExc = MException( errorID, 'IVI-C Class driver needs to have an IVI-C class-compliant specific driver defined in the IVI configuration store.');
                throwAsCaller(newExc);
            end
            
            obj = handle(ICDeviceObject.getInstance(parser, resourceName));
            ivicDriverFileName = get(obj, 'DriverName');
            driverFound = localLoadIviCLibrary(ivicDriverFileName);
            if (~driverFound)
                localDispose(obj);
                errorID = 'instrument:icdevice:icdevice:invalidDriver';
                newExc = MException( errorID, sprintf('The IVI-C Class driver referenced in %s cannot be found.', strrep(fullDriverName,'\','\\')));
                throwAsCaller(newExc);
                
            end
            obj.OptionString = optionstring;
        catch aException
            localDispose(obj);
            errorID = 'instrument:icdevice:icdevice:invalidDriver';
            newExc = MException(errorID,strrep(aException.message,'\','\\'));
            throwAsCaller(newExc);
        end
        
        
    case Device.IVI_COM
        if (~ispc)
            errorID = 'instrument:icdevice:icdevice:unsupportedDriverType';
            newExc = MException(errorID,['The specified driver is an unknown or unsupported type: ' char(parser.getDriverType)]);
            throwAsCaller(newExc);
        end
        
        logicalName = char(parser.getDriverName);
        
        % The LeCroy driver does not use IUnknown, so check if it works.
        if (strncmpi(logicalName, 'Lecroy.ActiveDSOCtrl', 20) == 1 || ...
                strncmpi(logicalName, 'LeCroy.XStreamDSO', 17) == 1 )
            try
                comobj = actxserver(logicalName);
                obj = handle(ICDeviceObject.getInstance(parser, resourceName, comobj, false));
            catch aException
                localDispose(obj);
                errorID = 'instrument:icdevice:icdevice:invalidDriver';
                newExc = MException(errorID,aException.message );
                throwAsCaller(newExc);
            end
            return;
        else
            error(message('instrument:icdevice:icdevice:no64bitMATLABSupport'));
        end
        
    case Device.GENERIC
        try
            obj = handle(ICDeviceObject.getInstance(parser, resourceName));
        catch aException
            localDispose(obj);
            errorID = 'instrument:icdevice:icdevice:invalidDriver';
            newExc = MException(errorID,aException.message );
            throwAsCaller(newExc);
        end
        
    case Device.INTERFACE_OBJECT
        errorID = 'instrument:icdevice:icdevice:driverNotLoaded';
        newExc = MException(errorID,'The specified driver requires an interface object as the second argument.');
        throwAsCaller(newExc);
        
    otherwise
        errorID = 'instrument:icdevice:icdevice:unsupportedDriverType';
        newExc = MException(errorID,['The specified driver is an unknown or unsupported type: ' char(parser.getDriverType)]);
        throwAsCaller(newExc);
end
end
% -------------------------------------------------------------------------
% Convert an array of objects to a cell array.
function out = localArray2Cell(obj)

out = cell(1, length(obj));
for i = 1:length(obj)
    out{i} = obj(i);
end
end

% -------------------------------------------------------------------------
% Dispose of an invalid java device object.
function localDispose(obj)

if (~isempty(obj))
    dispose(obj);
    disconnect(obj);
    cleanup(obj);
end
end
