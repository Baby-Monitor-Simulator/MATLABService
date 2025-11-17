function memunmap(obj)
%MEMUNMAP Unmap memory for low-level memory read and write operations.
%
%   MEMUNMAP(OBJ) unmaps memory space previously mapped by the MEMMAP
%   function. OBJ must be a 1-by-1 VISA-PXI, VISA-VXI or VISA-GPIB-VXI 
%   instrument object.
%
%   OBJ's MappedMemorySize property will be set to 0 and OBJ's 
%   MappedMemoryBase property will be set to 0H if the memory was
%   unmapped successfully.
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
%   See also MEMPEEK, MEMPOKE, MEMMAP, INSTRUMENT/PROPINFO, INSTRHELP.
%

%   Copyright 1999-2014 The MathWorks, Inc. 


% Error checking.
if (length(obj) > 1)
    error(message('instrument:memunmap:invalidOBJDim'));
end

if ~(strcmpi(get(obj, 'Type'), 'visa-vxi') || strcmpi(get(obj, 'Type'), 'visa-gpib-vxi') || strcmpi(get(obj, 'Type'), 'visa-pxi')) 
    error(message('instrument:memunmap:invalidOBJType'));
end

% Call the java memunmap method.
try
    memunmap(obj.jobject);
catch aException
    newExc = MException('instrument:memunmap:opfailed',aException.message);
    throw(newExc);
end
