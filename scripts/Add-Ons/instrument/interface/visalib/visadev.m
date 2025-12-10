function v = visadev(resourceID, varargin)
%VISADEV Create a connection to a device using VISA
% 
% v = VISADEV(resourceID) creates a connection to a device using the
% resource identifier, specified as a VISA resource name or a non-empty
% VISA alias. Establishes a connection using an installed VISA driver
% (if multiple drivers are installed, then the preferred VISA is used).
%
% v = VISADEV(resourceID,"NAME","VALUE",...) creates a connection to a
% device using the resource identifier, specified as a VISA resource name
% or a non-empty VISA alias, and one or more name-value pair arguments.
% Establishes a connection using an installed VISA driver (if multiple
% drivers are installed, then the preferred VISA is used). VISADEV
% properties that can be set using name-value pairs is Tag.
%
% Input Arguments:
%
% RESOURCEID - Name or alias of the VISA resource, specified as a character
% vector or string scalar. If the control software does not yet recognize
% the device, you must use the resource name. You can use an alias only if
% an alias is assigned using the VISA vendor’s control software.
%
% Output Arguments:
%
% V - An object that represents a VISA device. You can use this object to
% configure and control the resource as well as acquire and generate data
% from it.
%
% VISA Resource methods:
%   <a href="matlab:help visalib.Resource.read"">read</a>                - Read data from device
%   <a href="matlab:help visalib.Resource.readline"">readline</a>            - Read ASCII-terminated string data from device 
%   <a href="matlab:help visalib.Resource.readbinblock"">readbinblock</a>        - Read binblock data from device
%   <a href="matlab:help visalib.Resource.writeread"">writeread</a>           - Write ASCII-terminated string data from device
%                         and read back ASCII-terminated string data in
%                         response
%   <a href="matlab:help visalib.Resource.write"">write</a>               - Write data to device
%   <a href="matlab:help visalib.Resource.writeline">writeline</a>           - Write ASCII-terminated string data to device
%   <a href="matlab:help visalib.Resource.writebinblock">writebinblock</a>       - Write binblock data to device
%   <a href="matlab:help visalib.Resource.configureTerminator">configureTerminator</a> - Set the read and write terminator properties
%   <a href="matlab:help visalib.Resource.flush">flush</a>               - Clear the input and/or output buffers of device
%   <a href="matlab:help visalib.Resource.visastatus">visastatus</a>          - Check whether a resource has requested service
%
% VISA GPIB methods:
%   <a href="matlab:help visalib.GPIB.visatrigger">visatrigger</a>         - Send trigger message to GPIB instruments on the
%                         same GPIB bus
%
% VISA VXI methods:
%   <a href="matlab:help visalib.VXI.visatrigger">visatrigger</a>         - Send trigger message to VXI instruments on the
%                         same VXI bus
%
% VISA serial methods:
%   <a href="matlab:help visalib.Serial.setDTR">setDTR</a>              - Set/reset the serial DTR (Data Terminal Ready) pin
%   <a href="matlab:help visalib.Serial.setRTS">setRTS</a>              - Set/reset the serial RTS (Ready to Send) pin
%   <a href="matlab:help visalib.Serial.getpinstatus">getpinstatus</a>        - Get status of the serial pins
%
% VISA Resource properties:
%   ResourceName            - VISA resource name
%   Alias                   - VISA alias associated with resource
%   Type                    - Type of VISA resource
%   NumBytesWritten         - Number of bytes written to device
%   ByteOrder               - Sequential order in which bytes are arranged into larger numerical values
%   Timeout                 - Waiting time to complete read and write operations
%   Tag                     - Unique identifier name for the resource
%   Terminator              - Read and write terminator for ASCII-terminated string communication
%   ErrorOccurredFcn        - Function handle to be called when an error event occurs
%   UserData                - User-defined application specific data
%
% VISA GPIB properties:
%   BoardIndex              - GPIB board index
%   PrimaryAddress          - GPIB primary address
%   SecondaryAddress        - GPIB secondary address
%   EOIMode                 - Specifies whether the EOI line is asserted at
%                             the end of a write operation
% VISA PXI properties:
%   Bus                     - PCI bus number for the device
%   DeviceIndex             - PXI device number for the device
%   FunctionIndex           - PXI function number for the device; all
%                             normal devices have function 0 (multifunction
%                             devices may support other function numbers)
%   ChassisIndex            - The index number of the PXI chassis
%   Slot                    - The slot location of the PXI instrument
%   EOIMode                 - Specifies whether the EOI line is asserted at
%                             the end of a write operation
%
% VISA VXI properties:
%   ChassisIndex            - The index number of the VXI chassis
%   LogicalAddress          - The logical address of the VXI instrument
%   Slot                    - The slot location of the VXI instrument
%   EOIMode                 - Specifies whether the EOI line is asserted at
%                             the end of a write operation
%
% VISA USB properties:
%   VendorID                - Manufacturer ID number of the device (VID)
%   ProductID               - Model code of the device (PID)
%   BoardIndex              - USB board number
%   InterfaceIndex          - USB interface number
%
% VISA Serial properties:
%   BaudRate                - Speed of the serial communication (in bits per second)
%   DataBits                - Number of bits used to represent one character of data
%   StopBits                - Pattern of bits that indicates the end of a
%                             character or of the whole transmission
%   Parity                  - Parity to check whether or not data has been lost
%   FlowControl             - Mode for managing the rate of data transmission
%   Port                    - VISA port used for connection 
%
% VISA TCPIP properties:
%   BoardIndex              - Index number of the network board associated
%                             with the instrument
%   LANName                 - Specifies the LAN device name used by the
%                             VXI-11 or HiSLIP protocol during connection
%   InstrumentAddress       - Specifies the TCP/IP address of the
%                             instrument (formatted in dot-notation)
%
% VISA Socket properties:
%   IPAddress               - Specifies the TCP/IP address of the socket
%                             (formatted in dot-notation)
%   Port                    - Port number for the given TCP/IP address
%
% Examples:
% % Creates a connection to the GPIB device with the specified resource name.
% gpibdev = visadev("GPIB0::5::INSTR")
% % Creates a connection to the serial device with the specified resource name.
% serialdev = visadev("ASRL1::INSTR")
% % Creates a connection to the device with the specified alias that is assigned to the resource using the vendor’s control software.
% dev = visadev("Keysight_33210A")
%
% See also VISADEVLIST

%   Copyright 2020-2023 The MathWorks, Inc.

narginchk(1, inf)

try
    [syncRead,nvPair] = parseInputArgs(varargin{:});

    if ~isempty(syncRead)
        [resourceID, options] = checkArguments(resourceID, SynchronousRead=syncRead);
    else
        [resourceID, options] = checkArguments(resourceID);
    end
catch e
    id = string(e.identifier);
    if id == "MATLAB:TooManyInputs" && contains(e.message, "SynchronousRead")
        e = visalib.internal.ErrorProxy.getException(id);
    end

    throwAsCaller(e);
end

try
    % This function throws only for maca64 platform.
    instrument.internal.errorMessagesHelpers.throwMacaNoSupportError(mfilename);
    
    visalib.internal.validatePlatform;
    % empty if visadevlist hasn't been called; do not call visadevlist in
    % Normal mode
    if visalib.internal.TestModeManager.getTestMode() ~= visalib.internal.VISAMode.Normal
        visadevlist;
    end
    
    allIDs = visalib.internal.ResourceManager.getResourceIDs;
catch e
    throwAsCaller(e);
end

%%% unregister resources that may appear locked
if resourceID == "reset"
    visalib.internal.ResourceFactory.getInstance().unregisterAllResources();
    return
end

%%% Look for the resource type in the cache

% Use the resource ID to look up the resource name and type; these values
% are used to create the appropriate resource object.

type = visalib.InterfaceType.unset; %#ok<NASGU> 

% The resourceID can be:
% 1. Recognized as a specific resource      (valid)
% 2. Not recognized as a specific resource  (invalid)

if ~isempty(allIDs) && any(contains(allIDs, resourceID))
    resourceInfo = lookupResourceInfoFromID(resourceID);
    type = resourceInfo.Type;
else
    % If the resource type is not present in the cache, then ask the
    % ResourceManager what the type of the resource is.
    try
        resource = visalib.internal.ResourceManager.getSpecifiedResource(resourceID);
        resourceInfo = visalib.internal.ResourceInfo(resource);
        type = resourceInfo.Type;
    catch e
        throwAsCaller(e)
    end
end

%%% Create the appropriate resource object
try
    v = visalib.internal.ResourceFactory.getInstance().createAndRegisterVisaResource(type, resourceInfo, options.SynchronousRead);
    v.Tag = nvPair.Tag;
catch e
    throwAsCaller(e);
end
end

function resourceInfo = lookupResourceInfoFromID(resourceID)
% Find the resource correspoding to a specific resourceID (resource name or
% alias). 
resourceList = visalib.internal.ResourceManager.getCachedResourceList;
hasAlias = contains([resourceList.Alias]', resourceID);
hasName = contains([resourceList.ResourceName]', resourceID);

resourceStruct = resourceList(bitor(hasAlias, hasName));
resourceInfo = visalib.internal.ResourceInfo(resourceStruct);
end

function [syncRead, nvPairs] = parseInputArgs(varargin)

%Default values
syncRead = [];

% Return Tag as a struct field. This is forward looking - In the future,
% more NV pairs can be added to the visadev constructor.
nvPairs = struct("Tag", "");

p = inputParser;
p.PartialMatching = true;
p.addOptional("SynchronousRead", [], @(x) isempty(x) || islogical(x));
p.addParameter("Tag", "", @(x)isstring(x) || ischar(x));
parse(p, varargin{:});

results = p.Results;

if ~isempty(results)
    syncRead = results.SynchronousRead;
    nvPairs.Tag = results.Tag;
end
end

function [resourceID, options] = checkArguments(resourceID, options)
arguments
    resourceID {mustBeNonzeroLengthText}
    % default: true(synchronous)
    options.SynchronousRead (1, 1) logical = true
end

% Convert to a string only after it is guaranteed to be valid text.
resourceID = convertCharsToStrings(resourceID);
end
