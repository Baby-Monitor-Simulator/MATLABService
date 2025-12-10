function data = memread(obj, varargin)
%MEMREAD High-level memory read from VXI or PXI register.
%
%   OUT = MEMREAD(OBJ) reads a uint8 value with an offset of 0 from the A16
%   address space (VXI) or PXICFG address space (PXI) from interface object,
%   OBJ. OBJ must be a 1-by-1 VISA-PXI, VISA-VXI or VISA-GPIB-VXI interface
%   object.
%
%   The interface object must be connected to the instrument with the 
%   FOPEN function before any data can be read from the instrument
%   otherwise an error is returned. A connected interface object
%   has a Status property value of open.
%
%   OUT = MEMREAD(OBJ, OFFSET) reads a uint8 value from the A16 address
%   space (VXI) or PXICFG address space (PXI) with an offset, OFFSET. 
%   OFFSET is a decimal value.
% 
%   OUT = MEMREAD(OBJ, OFFSET, 'PRECISION') reads the number of bits
%   specified by PRECISION from the A16 address space (VXI) or PXICFG 
%   address space with an offset, OFFSET. The precision can be 'uint8', 
%   'uint16', 'uint32', or 'single'.
%
%   OUT = MEMREAD(OBJ, OFFSET, 'PRECISION', 'ADRSPACE') reads the 
%   specified number of bits from the address space, ADRSPACE. ADRSPACE
%   can be 'A16', 'A24' or 'A32' for VXI hardware, and 'PXICFG', 'BAR0', 'BAR1',
%   'BAR2', 'BAR3', 'BAR4' and 'BAR5' for PXI hardware. OBJ's MemorySpace
%   property indicates which VXI (or PXI) address space(s) are used by the
%   instrument.
%
%   OUT = MEMREAD(OBJ, OFFSET, 'PRECISION', 'ADRSPACE', SIZE) reads a
%   block of data with a size specified by SIZE.
%    
%   Example:
%       v = visa('agilent', 'VXI0::8::INSTR');
%       fopen(v)
%       data = memread(v, 0, 'uint16');
%       data = memread(v, 2, 'uint8', 'A16', 3);
%       fclose(v);
%
%   See also ICINTERFACE/FOPEN, MEMWRITE, MEMPEEK, INSTRUMENT/PROPINFO,
%   INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 

% Error checking.
if nargin > 5
    error(message('instrument:memread:invalidSyntax'));
end

if (length(obj) > 1)
    error(message('instrument:memread:invalidOBJDim'));
end

if ~isa(obj, 'instrument')
   error(message('instrument:memread:invalidOBJInterface'));
end	

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi'))
    error(message('instrument:memread:invalidOBJType'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
case 1
    if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
        addressSpace = 'PXICFG';
    else
        addressSpace = 'A16';
    end
    offset = 0;
	precision = 'uint8';
    size = 1;
case 2
    offset = varargin{1};
    if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
        addressSpace = 'PXICFG';
    else
        addressSpace = 'A16';
    end
    precision = 'uint8';
    size = 1;
case 3
    [offset, precision] = deal(varargin{:});
    if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
        addressSpace = 'PXICFG';
    else
        addressSpace = 'A16';
    end
    size = 1;
case 4
    [offset, precision, addressSpace] = deal(varargin{:});
    size = 1;
case 5
    [offset, precision, addressSpace, size] = deal(varargin{:});
end


% Verify offset.
if ~isa(offset, 'double')
    error(message('instrument:memread:invalidOFFSETdouble'));
elseif isnan(offset) || ~isreal(offset)
    error(message('instrument:memread:invalidOFFSETfinite'));
elseif isinf(offset)
    error(message('instrument:memread:invalidOFFSETfinite'));
elseif (offset < 0)
	error(message('instrument:memread:invalidOFFSETpos'));
elseif (length(offset) > 1)
	error(message('instrument:memread:invalidOFFSETscalar'));
end

% Verify size.
if ~isa(size, 'double')
    error(message('instrument:memread:invalidSIZEdouble'));
elseif isnan(size) || ~isreal(size)
    error(message('instrument:memread:invalidSIZEfinite'));
elseif isinf(size)
    error(message('instrument:memread:invalidSIZEfinite'));
elseif (size < 1)
	error(message('instrument:memread:invalidSIZEpositive'));
elseif (length(size) > 1)
	error(message('instrument:memread:invalidSIZEscalar'));
end

% Verify addressSpace.
if ~ischar(addressSpace)
    if strcmpi(get(obj, 'Type'), 'visa-pxi')
        error(message('instrument:memread:invalidADRSPACEPXI'));
    else
        error(message('instrument:memread:invalidADRSPACEVXI'));        
    end
end

if strcmpi(get(obj, 'Type'), 'visa-pxi')
    % Address space for VISA-PXI objects
    switch lower(addressSpace)
        case 'pxicfg'
            space = 10; % Mapped to VI_PXI_CFG_SPACE
        case 'bar0'
            space = 11; % Mapped to VI_PXI_BAR0_SPACE
        case 'bar1'
            space = 12; % Mapped to VI_PXI_BAR1_SPACE
        case 'bar2'
            space = 13;
        case 'bar3'
            space = 14;
        case 'bar4'
            space = 15;
        case 'bar5'
            space = 16; % Mapped to VI_PXI_BAR5_SPACE
        otherwise
            error(message('instrument:memread:invalidADRSPACEPXI'));
    end
else    
    % Address space for VISA-VXI and VISA-GPIB-VXI objects
    switch lower(addressSpace)
        case 'a16'
            space = 1;
        case 'a24'
            space = 2;
        case 'a32'
            space = 3;        
        otherwise
            error(message('instrument:memread:invalidADRSPACEVXI'));
    end
end
    
% Verify precision.
if ~ischar(precision)
    error(message('instrument:memread:invalidPRECISION'));
end

switch lower(precision)
case 'uint8'
    precision = 0;
case 'uint16'
    precision = 1;
case 'uint32'
    precision = 2;
case 'single'
    precision = 3;
otherwise
    error(message('instrument:memread:invalidPRECISION'));
end

% Call the java memread method.
try
    data = memread(obj.jobject, space, offset, precision, size);
catch aException
    newExc = MException('instrument:memread:opfailed',aException.message);
    throw(newExc);
end

% Cast the results into the correct unsigned precision.
data = double(data);
switch precision
case 0
    data = data + (data<0).*256;
case 1
    data = data + (data<0).*65536;
case 2
    data = data + (data<0).*(2^32);
end

