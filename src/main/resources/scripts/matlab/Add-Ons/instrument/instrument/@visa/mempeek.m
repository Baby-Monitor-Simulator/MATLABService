function data = mempeek(obj, varargin)
%MEMPEEK Low-level memory read from VXI or PXI register.
%
%   OUT = MEMPEEK(OBJ, OFFSET) reads a uint8 value from the mapped
%   memory space specified by OFFSET, from interface object, OBJ.
%   OBJ must be a 1-by-1 VISA-VXI, VISA-PXI or VISA-GPIB-VXI interface 
%   object.
%
%   The interface object must be connected to the instrument with 
%   the FOPEN function before any data can be read from the instrument 
%   otherwise an error is returned. A connected interface object has
%   a Status property value of open.
%
%   Before using MEMPEEK, the memory space must be mapped with the MEMMAP
%   function. OBJ's MappedMemorySize property returns the amount of memory 
%   mapped. If this value is 0, then no memory has been mapped.
%
%   OUT = MEMPEEK(OBJ, OFFSET, 'PRECISION') reads the number of bits
%   specified by PRECISION from the mapped memory space specified by
%   OFFSET. The precision can be 'uint8', 'uint16', 'uint32' or 'single'.
%   
%   OFFSET indicates the offset in the mapped memory space from which
%   the data will be read. For example, if the mapped memory space begins 
%   at 200H, the offset is 2 and the precision is uint8, the data at 202H 
%   will be read. If the precision is uint16, the data at 202H and 203H
%   will be read. If the precision is uint32, the data at 202H, 203H, 204H
%   and 205H will be read.
%
%   To increase speed, MEMPEEK does not return error messages from
%   the instrument.
%
%   Example:
%       v = visa('agilent', 'VXI0::8::INSTR');
%       fopen(v)
%       memmap(v, 'A16', 0, 16);
%       data = mempeek(v, 0);
%       data = mempeek(v, 2, 'uint16');
%       memunmap(v);
%       fclose(v);
%
%   See also ICINTERFACE/FOPEN, MEMPOKE, MEMMAP, INSTRUMENT/PROPINFO,
%   INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 


% Error checking.
if nargin > 3
    error(message('instrument:mempeek:invalidSyntaxArgv'));
end

if (length(obj) > 1)
    error(message('instrument:mempeek:invalidOBJDim'));
end

if ~isa(obj, 'instrument')
   error(message('instrument:mempeek:invalidOBJInterface'));
end	

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi'))
    error(message('instrument:mempeek:invalidOBJType'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
case 1
    error(message('instrument:mempeek:invalidSyntax', 'OFFSET'));
case 2
    offset = varargin{1};
    precision = 'uint8';
case 3
    offset = varargin{1};
    precision = varargin{2};
end

% Verify precision.
if ~ischar(precision)
    error(message('instrument:mempeek:invalidPRECISION'));
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
    error(message('instrument:mempeek:invalidPRECISION'));
end

% Verify offset.
if ~isa(offset, 'double')
    error(message('instrument:mempeek:invalidOFFSETdouble'));
elseif isnan(offset) || ~isreal(offset)
    error(message('instrument:mempeek:invalidOFFSETfinite'));
elseif isinf(offset)
    error(message('instrument:mempeek:invalidOFFSETfinite'));
elseif (offset < 0)
	error(message('instrument:mempeek:invalidOFFSETpos'));
elseif (length(offset) > 1)
	error(message('instrument:mempeek:invalidOFFSETscalar'));
end

% Call the java mempeek method.
try
    data = mempeek(obj.jobject, offset, precision);
catch aException
    newExc = MException('instrument:mempeek:opfailed',aException.message);
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
