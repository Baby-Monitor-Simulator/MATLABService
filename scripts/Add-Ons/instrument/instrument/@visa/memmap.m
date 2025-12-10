function memmap(obj, varargin)
%MEMMAP Map memory for low-level memory read and write.
%
%   MEMMAP(OBJ, 'ADRSPACE', OFFSET, SIZE) maps the amount of memory
%   specified by SIZE in address space, ADRSPACE, with the offset, 
%   OFFSET, for interface object OBJ. OBJ must be a 1-by-1 VISA-PXI, VISA-VXI 
%   or VISA-GPIB-VXI interface object. ADRSPACE can be set to 'A16', 
%   'A24' or 'A32' for VISA-VXI and VISA-GPIB-VXI objects. ADRSPACE can be
%   set to 'PXICFG', 'BAR0', 'BAR1', 'BAR2', BAR3', 'BAR4' and 'BAR5' for VISA-PXI.
%
%   OBJ's MemorySpace property indicates which VXI address space(s) are
%   used by the instrument.
%
%   The interface object must be connected to the instrument with the 
%   FOPEN function before memory can be mapped for low-level memory read
%   and write operations otherwise an error is returned. A connected
%   interface object has a Status property value of open.
%
%   The MappedMemorySize property returns the amount of memory mapped.  
%   If this value is 0, then no memory has been mapped.
%
%   The memory space must be mapped before MEMPOKE or MEMPEEK can be
%   used.
%
%   To unmap the memory use the MEMUNMAP function. If memory is mapped
%   and FCLOSE is called, the memory is unmapped before the object is 
%   disconnected from the instrument.
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
%   See also ICINTERFACE/FOPEN, ICINTERFACE/FCLOSE, MEMPEEK, MEMPOKE, 
%   MEMUNMAP, INSTRUMENT/PROPINFO, INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 

% Error checking.
if nargin > 4
    error(message('instrument:memmap:invalidSyntaxRet'));
end

if (length(obj) > 1)
    error(message('instrument:memmap:invalidOBJDim'));
end

if ~isa(obj, 'instrument')
   error(message('instrument:memmap:invalidOBJInterface'));
end	

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi'))
    error(message('instrument:memmap:invalidOBJ'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
case 1
    error(message('instrument:memmap:invalidSyntax', 'ADRSPACE'));
case 2
    error(message('instrument:memmap:invalidSyntax', 'OFFSET'));
case 3
    error(message('instrument:memmap:invalidSyntax', 'SIZE'));	
case 4
    [addressSpace, offset, size] = deal(varargin{:});
end

% Verify addressSpace.
if ~ischar(addressSpace)
    if strcmpi(get(obj, 'Type'), 'visa-pxi')
        error(message('instrument:memmap:invalidADRSPACEPXI'));
    else
        error(message('instrument:memmap:invalidADRSPACEVXI'));        
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
            error(message('instrument:memmap:invalidADRSPACEPXI'));
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
            error(message('instrument:memmap:invalidADRSPACEVXI'));
    end
end

% Verify offset.
if ~isa(offset, 'double')
    error(message('instrument:memmap:invalidOFFSETdobule'));
elseif isnan(offset) || ~isreal(offset)
    error(message('instrument:memmap:invalidOFFSETfinite'));
elseif isinf(offset)
    error(message('instrument:memmap:invalidOFFSETfinite'));
elseif (offset < 0)
	error(message('instrument:memmap:invalidOFFSETpos'));
elseif (length(offset) > 1)
	error(message('instrument:memmap:invalidOFFSETscalar'));
end

% Verify size.
if ~isa(size, 'double')
    error(message('instrument:memmap:invalidSIZEdouble'));
elseif isnan(size) || ~isreal(size)
    error(message('instrument:memmap:invalidSIZEfinite'));
elseif isinf(size)
    error(message('instrument:memmap:invalidSIZEfinite'));
elseif (size < 1)
	error(message('instrument:memmap:invalidSIZEpos'));
elseif (length(size) > 1)
	error(message('instrument:memmap:invalidSIZEscalar'));
end	

% Call the java memmap method.
try
    memmap(obj.jobject, space, offset, size);
catch aException
    newExc = MException('instrument:memmap:opfailed', aException.message);
    throw(newExc);
end
	
