function mempoke(obj, varargin)
%MEMPOKE Low-level memory write to VXI or PXI register.
%
%   MEMPOKE(OBJ, DATA, OFFSET) writes a uint8 value, DATA, to the 
%   mapped memory address specified by OFFSET for interface object, 
%   OBJ. OBJ must be a 1-by-1 VISA-PXI, VISA-VXI or VISA-GPIB-VXI
%   instrument object.
%
%   The interface object must be connected to the instrument with the 
%   FOPEN function before any data can be written to the instrument 
%   otherwise an error is returned. A connected interface object 
%   has a Status property value of open.
%
%   Before using MEMPOKE, the memory space must be mapped with the 
%   MEMMAP function. OBJ's MappedMemorySize property returns the amount
%   of memory mapped. If this value is 0, then no memory has been mapped.
%
%   MEMPOKE(OBJ, DATA, OFFSET, 'PRECISION') writes DATA with precision,
%   PRECISION, to the mapped memory address specified by OFFSET. PRECISION
%   can be 'uint8', 'uint16', 'uint32' or 'single'.
%
%   OFFSET indicates the offset in the mapped memory space to which the
%   data will be written. For example, if the mapped memory space begins 
%   at 200H, the offset is 2 and the precision is uint8, the data will be
%   written to 202H. If the precision is uint16, the data will be written
%   to 202H and 203H. If the precision is uint32, the data will be written
%   to 202H, 203H, 204H and 205H.
%
%   To increase speed, MEMPOKE does not return error messages from
%   the instrument.
%
%   Example:
%       v = visa('agilent', 'VXI0::8::INSTR');
%       fopen(v)
%       memmap(v, 'A16', 0, 16);
%       mempoke(v, 45056, 6, 'uint16');
%       memunmap(v);
%       fclose(v);
%
%   See also ICINTERFACE/FOPEN, MEMPEEK, MEMMAP, INSTRUMENT/PROPINFO,
%   INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 

% Error checking.
if nargin > 4
    error(message('instrument:mempoke:invalidSyntaxArgv'));
end

if (length(obj) > 1)
    error(message('instrument:mempoke:invalidOBJDim'));
end

if ~isa(obj, 'instrument')
   error(message('instrument:mempoke:invalidOBJInterface'));
end	

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi'))
    error(message('instrument:mempoke:invalidOBJType'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
case 1
    error(message('instrument:mempoke:invalidSyntaxDataOffset'));
case 2
    error(message('instrument:mempoke:invalidSyntaxOffset'));
case 3
    [data, offset] = deal(varargin{:});
    precision = 'uint8';
case 4
    [data, offset, precision] = deal(varargin{:});
end

% Verify offset.
if ~isa(offset, 'double')
    error(message('instrument:mempoke:invalidOFFSETdouble'));
elseif isnan(offset) || ~isreal(offset)
    error(message('instrument:mempoke:invalidOFFSETfinite'));
elseif isinf(offset)
    error(message('instrument:mempoke:invalidOFFSETfinite'));
elseif (offset < 0)
	error(message('instrument:mempoke:invalidOFFSETpositive'));
elseif (length(offset) > 1)
	error(message('instrument:mempoke:invalidOFFSETscalar'));
end

% Verify data.
if ~(isnumeric(data) || ischar(data))
	error(message('instrument:mempoke:invalidDATAstring'));
elseif length(data) > 1
    error(message('instrument:mempoke:invalidDATAscalar'));
elseif ~isfinite(data)
    error(message('instrument:mempoke:invalidDATAfinite'))
elseif isempty(data)
    return;
end

% Verify precision.
if ~ischar(precision)
    error(message('instrument:mempoke:invalidPRECISION'));
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
    error(message('instrument:mempoke:invalidPRECISION'));
end

% Call the java mempoke method.
try
    mempoke(obj.jobject, data, precision, offset);
catch aException
    newExc = MException('instrument:mempoke:opfailed',aException.message);
    throw(newExc);
end
