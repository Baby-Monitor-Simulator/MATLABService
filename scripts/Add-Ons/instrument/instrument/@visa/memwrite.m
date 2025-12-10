function memwrite(obj, varargin)
%MEMWRITE High-level memory write to VXI or PXI register.
%
%   MEMWRITE(OBJ, DATA) writes the uint8 value, DATA, to the A16 address
%   space for VXI, or PXICFG address space for PXI, with an offset of 0 for
%   interface object, OBJ. OBJ must be a 1-by-1 VISA-PXI, VISA-VXI or
%   VISA-GPIB-VXI interface object. DATA can be an array of values.
%
%   The interface object must be connected to the instrument with the
%   FOPEN function before any data can be written to the instrument
%   otherwise an error is returned. A connected interface object has
%   a Status property value of open.
%
%   MEMWRITE(OBJ, DATA, OFFSET) writes a uint8 value, DATA, to the A16
%   address space for VXI, or PXICFG address space for PXI, with an offset,
%   OFFSET. OFFSET is specified as a decimal value.
%
%   MEMWRITE(OBJ, DATA, OFFSET, 'PRECISION') writes DATA with precision,
%   PRECISION. PRECISION can be 'uint8', 'uint16', 'uint32' or 'single'.
%
%   MEMWRITE(OBJ, DATA, OFFSET, 'PRECISION', 'ADRSPACE') writes DATA to
%   the address space, ADRSPACE. ADRSPACE can be 'A16', 'A24' or 'A32' for
%   VXI and 'PXICFG', 'BAR0', 'BAR1', 'BAR2', 'BAR3', 'BAR4' and 'BAR5' for
%   PXI. OBJ's MemorySpace property indicates which address space(s) are
%   used by the instrument.
%
%   Example:
%       v = visa('ni', 'VXI0::1::INSTR');
%       fopen(v);
%       memwrite(v, 45056, 6, 'uint16', 'A16');
%       fclose(v)
%
%   See also ICINTERFACE/FOPEN, MEMREAD, MEMPOKE, INSTRUMENT/PROPINFO,
%   INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc.

% Error checking.
if nargin > 5
    error(message('instrument:memwrite:invalidSyntaxInput'));
end

if (length(obj) > 1)
    error(message('instrument:memwrite:invalidOBJDim'));
end

if ~isa(obj, 'instrument')
    error(message('instrument:memwrite:invalidOBJInterface'));
end

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi'))
    error(message('instrument:memwrite:invalidOBJType'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
    case 1
        error(message('instrument:memwrite:invalidSyntax', 'DATA'));
    case 2
        data = varargin{1};
        offset = 0;
        if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
            addressSpace = 'PXICFG';
        else
            addressSpace = 'A16';
        end
        precision = 'uint8';
    case 3
        [data, offset] = deal(varargin{:});
        if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
            addressSpace = 'PXICFG';
        else
            addressSpace = 'A16';
        end
        precision = 'uint8';
    case 4
        [data, offset, precision] = deal(varargin{:});
        if(strcmpi(get(obj, 'Type'), 'visa-pxi'))
            addressSpace = 'PXICFG';
        else
            addressSpace = 'A16';
        end
    case 5
        [data, offset, precision, addressSpace] = deal(varargin{:});
end

% Verify addressSpace.
if ~ischar(addressSpace)
    if strcmpi(get(obj, 'Type'), 'visa-pxi')
        error(message('instrument:memwrite:invalidADRSPACEPXI'));
    else
        error(message('instrument:memwrite:invalidADRSPACEVXI'));
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
            error(message('instrument:memwrite:invalidADRSPACEPXI'));
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
            error(message('instrument:memwrite:invalidADRSPACEVXI'));
    end
end

% Verify data.
if ~(isnumeric(data) || ischar(data))
    error(message('instrument:memwrite:invalidDATA'));
elseif ~all(isfinite(data))
    error(message('instrument:memwrite:invalidDATAfinite'))
elseif isempty(data)
    return;
end

% Verify precision.
if ~ischar(precision)
    error(message('instrument:memwrite:invalidPRECISION'));
end

switch lower(precision)
    case 'uint8'
        precision = 0;
        data = uint8(data);
    case 'uint16'
        precision = 1;
        data = uint16(data);
    case 'uint32'
        precision = 2;
        data = uint32(data);
    case 'single'
        precision = 3;
        data = single(data);
    otherwise
        error(message('instrument:memwrite:invalidPRECISION'));
end

% Verify offset.
if ~isa(offset, 'double')
    error(message('instrument:memwrite:invalidOFFSET'));
elseif isnan(offset) || ~isreal(offset)
    error(message('instrument:memwrite:invalidOFFSETFinite'));
elseif isinf(offset)
    error(message('instrument:memwrite:invalidOFFSETFinite'));
elseif (offset < 0)
    error(message('instrument:memwrite:invalidOFFSETPositive'));
elseif (length(offset) > 1)
    error(message('instrument:memwrite:invalidOFFSETScalar'));
end

% Call the java memwrite method.
try
    memwrite(obj.jobject, space, data, offset, precision, length(data));
catch aException
    newExc = MException('instrument:memwrite:opfailed',aException.message);
    throw(newExc);
end
