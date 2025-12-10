function varargout = fread(obj, varargin)
%FREAD Read binary data from instrument.
%
%   A=FREAD(OBJ) reads values from the I2C device connected to
%   interface object, OBJ, and returns to A. The maximum number
%   of values is given by the InputBufferSize property.
%
%   A=FREAD(OBJ,SIZE) reads at most the specified number of values,
%   SIZE, from the I2C device connected to interface object, OBJ,
%   and returns to A.
%
%   For I2C objects, FREAD blocks until one of the following occurs:
%       1. InputBufferSize values have been received
%       2. SIZE values have been received
%       3. A timeout occurs as specified by the Timeout property
%
%   The interface object must be connected to the device with
%   the FOPEN function before any data can be read from the device
%   otherwise an error is returned. A connected interface object
%   has a Status property value of open.
%
%   A terminator cannot be defined for I2C objects.
%
%   Available options for SIZE include:
%
%      N      read at most N values into a column vector.
%      [M,N]  read at most M * N values filling an M-by-N matrix,
%             in column order.
%
%   SIZE cannot be set to INF. If SIZE is greater than the OBJ's
%   InputBufferSize property value an error will be returned. Note
%   that SIZE is specified in values while the InputBufferSize is
%   specified in bytes.
%
%   A=FREAD(OBJ,SIZE,'PRECISION') reads binary data with the specified
%   precision, PRECISION. The precision argument controls the number
%   of bits read for each value and the interpretation of those bits
%   as character, integer or floating point values. The supported
%   PRECISION strings are defined below. By default the 'uchar'
%   PRECISION is used. By default, numeric values are returned in
%   double precision arrays.
%
%      MATLAB           Description
%      'uchar'          unsigned character,  8 bits.
%      'schar'          signed character,    8 bits.
%      'int8'           integer,             8 bits.
%      'int16'          integer,             16 bits.
%      'int32'          integer,             32 bits.
%      'uint8'          unsigned integer,    8 bits.
%      'uint16'         unsigned integer,    16 bits.
%      'uint32'         unsigned integer,    32 bits.
%      'single'         floating point,      32 bits.
%      'float32'        floating point,      32 bits.
%      'double'         floating point,      64 bits.
%      'float64'        floating point,      64 bits.
%      'char'           character,           8 bits (signed or unsigned).
%      'short'          integer,             16 bits.
%      'int'            integer,             32 bits.
%      'long'           integer,             32 or 64 bits.
%      'ushort'         unsigned integer,    16 bits.
%      'uint'           unsigned integer,    32 bits.
%      'ulong'          unsigned integer,    32 bits or 64 bits.
%      'float'          floating point,      32 bits.
%
%   [A,COUNT]=FREAD(OBJ,...) returns the number of values read to COUNT.
%
%   [A,COUNT,MSG]=FREAD(OBJ,...) returns a message, MSG, if FREAD
%   did not complete successfully. If MSG is not specified a warning
%   is displayed to the command line.
%
%   [A,COUNT,MSG,DATAGRAMADDRESS]=FREAD(OBJ,...) returns the datagram
%   address to DATAGRAMADDRESS, if OBJ is a UDP object. If more than
%   one datagram is read, DATAGRAMADDRESS is ''.
%
%   [A,COUNT,MSG,DATAGRAMADDRESS,DATAGRAMPORT]=FREAD(OBJ,...) returns
%   the datagram port to DATAGRAMPORT, if OBJ is a UDP object. If more
%   than one datagram is read, DATAGRAMPORT is [].
%
%   The byte order of the instrument can be specified with OBJ's
%   ByteOrder property.
%
%   OBJ's ValuesReceived property will be updated by the number of
%   values read from the instrument.
%
%   If OBJ's RecordStatus property is configured to on with the RECORD
%   function, the data received will be recorded in the file specified
%   by OBJ's RecordName property value.
%
%   Example:
%       i2 = i2c('aardvark', 0, 0x38);
%       fopen(i2);
%       fwrite(i2, 18);
%       data = fread(i2, 2);
%       fclose(i2);
%
%   See also ICINTERFACE/FOPEN, ICINTERFACE/FCLOSE, ICINTERFACE/FWRITE,
%   ICINTERFACE/RECORD, INSTRUMENT/PROPINFO, INSTRHELP.
%

%   Copyright 2011-2016 The MathWorks, Inc.

% Error checking.
if nargout > 5
    error(message('instrument:fread:invalidSyntaxRet'));
end

if ~isa(obj, 'icinterface')
    error(message('instrument:fread:invalidOBJInterface'));
end

if length(obj)>1
    error(message('instrument:fread:invalidOBJDim'));
end

% Initialize variables.
warnMsg = 'The specified amount of data was not returned within the Timeout period.';

readCompleteDg = false;

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
    case 1
        size = get(obj, 'InputBufferSize');
        precision = 'uchar';
    case 2
        size = varargin{1};
        precision = 'uchar';
    case 3
        [size, precision] = deal(varargin{:});
    otherwise
        error(message('instrument:fread:invalidSyntaxArgv'));
end

% Error checking.
if ~isa(precision, 'char')
    error(message('instrument:fread:invalidPRECISIONstring'));
end

if ~isa(size, 'double')
    error(message('instrument:fread:invalidSIZEdouble'));
elseif size<=0
    error(message('instrument:fread:invalidSIZEpos'));
elseif (any(isinf(size)))
    error(message('instrument:fread:invalidSIZEinf'));
elseif (any(isnan(size)))
    error(message('instrument:fread:invalidSIZEnan'));
end

% Define the type of data to be read.
switch (precision)
    case {'uchar', 'char'}
        type = 5;
        signed = 0;
    case {'schar'}
        type = 5;
        signed = 1;
    case {'int8'}
        type = 0;
        signed = 1;
    case {'int16', 'short'}
        type = 1;
        signed = 1;
    case {'int32', 'int', 'long'}
        type = 2;
        signed = 1;
    case {'uint8'}
        type = 0;
        signed = 0;
    case {'uint16', 'ushort'}
        type = 1;
        signed = 0;
    case {'uint32', 'uint', 'ulong'}
        type = 2;
        signed = 0;
    case {'single', 'float32', 'float'}
        type = 3;
        signed = 1;
    case {'double' ,'float64'}
        type = 4;
        signed = 1;
    otherwise
        error(message('instrument:fread:invalidPRECISION'));
end

% Floor the size.
% Note: The call to floor must be done after the error checking
% since floor on a string converts the string to its ascii value.
size = floor(size);

% Determine the total number of elements to read.
switch (length(size))
    case 1
        totalSize = size;
        size = [size 1];
    case 2
        totalSize = size(1)*size(2);
    otherwise
        error(message('instrument:fread:invalidSIZE'));
end

if (readCompleteDg)
    totalSize = 1;
end

% Call the fread java method.
try
    % Out contains the data and the number of data ready.
    out = hexread(igetfield(obj, 'jobject'), totalSize, type, signed);
catch aException
    newExc = MException('instrument:fread:opfailed', aException.message);
    throw(newExc);
end

% Parse the result from the java fread method.
data     = out(1);
numRead  = out(2);
errmsg   = out(3);

% Overwrite generic warning message with the
% error message if one exsits.
if ~isempty(errmsg)
    warnMsg = errmsg;
end

% If the specified number of values were not available - return.
if (((numRead ~= totalSize) && (~readCompleteDg)))
    data = localFormatData(double(data(1:numRead)), precision);
    varargout = {data, numRead, warnMsg };
    if (nargout < 3)
        % Store the warning state.
        warnState = warning('backtrace', 'off');

        % Display warning.
        warning('instrument:fread:unsuccessfulRead','Unsuccessful read: %s', warnMsg);

        % Restore warning state.
        warning(warnState);
    end
    return;
end

% Construct the output.
varargout = cell(1,5);
try
    data = localFormatData(data, precision);
    if( length(data) == size(1)*size(2))
        varargout{1} = reshape(data, size(1), size(2));
    else
        varargout{1} = data;
    end

    % Data was successfully read and formatted.  Return the formatted
    % data, the number of values read and any errors that occurred
    % in the java code.
    varargout{2} = numRead;
    varargout{3} = errmsg;
catch %#ok<CTCH>
    % An error occurred while reshaping. Return the data as an array.
    varargout{1} = double(data);
    varargout{2} = numRead;
    varargout{3} = 'Returning data as an array since it is not the same size as requested.\nYou may want to set the DataTerminateMode to ''off''.';
end

% Warn if the MSG output variable is not specified.
if (nargout < 3) && ~isempty(varargout{3})
    % Store the warning state.
    warnState = warning('backtrace', 'off');

    warning('instrument:fread:unsuccessfulRead', 'Unsuccessful read: %s', varargout{3});

    % Restore the warning state.
    warning(warnState);
end

% --------------------------------------------------------------
function dataout = localFormatData(datain, precision)

try
    switch precision
        case {'uint8', 'uchar', 'char'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*256;
        case {'uint16', 'ushort'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*65536;
        case {'uint32', 'uint', 'ulong'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*(2^32);
        case {'int8', 'schar'}
            dataout = double(datain);
            dataout = dataout - (dataout>127)*256;
        otherwise
            dataout = double(datain);
    end
catch %#ok<CTCH>
    dataout = double(datain);
end

% LocalWords:  OBJ's uchar schar ushort ulong datagram
