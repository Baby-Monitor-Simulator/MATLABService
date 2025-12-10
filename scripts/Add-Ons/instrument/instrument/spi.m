function obj = spi(vendorName, boardIndex, port)

%SPI Construct SPI communication object.
%
%   S = SPI('Vendor', BoardIndex, Port) constructs a SPI
%   communication object associated with Vendor, BoardIndex and
%   Port.
%
%   When the SPI object is constructed, the object's ConnectionStatus
%   property is disconnected. Once the object is connected to the bus with
%   the CONNECT function, the ConnectionStatus property is configured to
%   connected. Only one Port may be connected with a board at a
%   time.
%
%   If an invalid property name or property value is specified the object
%   will not be created.
%
%
%   Example:
%       % Construct a spi interface object.
%       s = spi('aardvark', 0, 0);
%
%       % Connect to the device.
%       connect(s);
%
%       % The data to write.
%       dataToWrite = [2 0 0 255]
%
%       % Write and read the data from the device.
%       data = writeAndRead(s, dataToWrite);
%
%       % Disconnect from the instrument and clean up.
%       disconnect(s);
%       clear('s');
%
    
%   Copyright 2013-2018 The MathWorks, Inc.

try
   if nargin ~= 3
        error(message('instrument:spi:invalidInputArguments'));
    end
    % Convert vendorName to lower case
    vendorName = lower(vendorName);
    
    % Validate vendorName
    validatestring(vendorName, instrument.interface.spi.HardwareInfo().SupportedVendors, 'spi', 'vendorName', 1);
    
    % Validate boardIndex
    validateattributes(boardIndex,{'numeric'}, {'scalar','finite','nonnegative'}, 'spi', 'boardIndex', 2);
    
    % Validated port
    validateattributes(port,{'numeric'}, {'scalar','finite','nonnegative'}, 'spi', 'port', 3);
    
    % Throw an error if trying to construct an SPI object with Aardvark devices on MAC
    if (strcmpi(vendorName, 'aardvark') && strcmpi(computer('arch'),'maci64'))
        error(message('instrument_aardvark:aardvark:noAardvarkSupportOnMac'));
    end
    
catch validationException
    throw(MException('instrument:spi:objectCreationError', validationException.message));
end

try
    % Create the vendor specific SPI object
    obj= eval(sprintf('instrument.interface.spi.%s.Spi(vendorName, boardIndex, port)', vendorName));
    
catch objectCreationError
    throwAsCaller(objectCreationError);
end