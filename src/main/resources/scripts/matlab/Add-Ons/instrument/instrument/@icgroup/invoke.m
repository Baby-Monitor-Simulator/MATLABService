function varargout = invoke(obj, name, varargin)
%INVOKE Execute driver function on device or device group object.
%
%   OUT=INVOKE(OBJ, 'NAME') execute driver function, NAME, on object, OBJ
%   and returns the result to OUT. OBJ must be a device object, a device
%   group object or an array of device group objects. OUT can be an array
%   of arguments depending on the output of the driver function, NAME.
%
%   OUT=INVOKE(OBJ, 'NAME', ARG1, ARG2, ...) executes driver function, NAME,
%   on OBJ and passes NAME the specified arguments, ARG1, ARG2,... and
%   returns the result to OUT.
%
%   The driver functions supported by OBJ can be found with INSTRHELP(OBJ)
%   or METHODS(OBJ). Help on the driver functions can be found with
%   INSTRHELP(OBJ, 'NAME').
%
%   See also INSTRHELP, METHODS.
%

%   Copyright 1999-2020 The MathWorks, Inc.

% Error checking.
if (nargin == 1)
    error(message('instrument:icgroup:invoke:invalidSyntax'));
end

% convert to char in order to accept string datatype
name = instrument.internal.stringConversionHelpers.str2char(name);
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

if ~ischar(name)
    error(message('instrument:icgroup:invoke:invalidArgName'));
end

if ~isa(obj, 'icgroup')
    error(message('instrument:icgroup:invoke:invalidArgDim'));
end

if ~all(isvalid(obj))
    error(message('instrument:icgroup:invoke:invalidArgObj'));
end

% Extract java object.
jobj = igetfield(obj, 'jobject');

% Verify method is supported by object.
if ~isDeviceChildMethod(java(jobj(1)), name)
    errorMessageFlag = false;

    try
        if isParentMethod(java(jobj), name)
            errorMessageFlag = true;
        end
    catch
    end

    if(errorMessageFlag)
    	error(message('instrument:icgroup:invoke:invalidFcnParent', name));
    else
    	error(message('instrument:icgroup:invoke:invalidFcn', name));
    end
end

% Verify that the objects are connected to the instrument.
try
    verifyObjectState(jobj(1))
catch
    newExc = MException('instrument:icgroup:invoke:invalidState', 'OBJ''s parent must be connected to the instrument with CONNECT.');
    throw(newExc);
end

% If method was defined as code execute.
if isMethodMCode(jobj(1), name)
    try
        code = char(getMethodMCode(jobj(1), name));
        for idx = 1:length(jobj)
            willExecuteDriverMethodCode(jobj(idx));
        end
        output = instrgate('privateExecuteMCode', code, obj, varargin, nargout);
        for idx = 1:length(jobj)
            didExecuteDriverMethodCode(jobj(idx));
        end
        
        % Create varargout appropriately based on type of output.
        if ~iscell(output)
            varargout{1} = output;
            return;
        end

        for idx = 1:length(output)
            varargout{idx} = output{idx}; %#ok<*AGROW>
        end
        return;
    catch aException
        localFixError(aException, 'instrument:icgroup:invoke:invalidArg');
    end
end

% Execute the java method.
try
    tempOut = {};
    for idx = 1:length(obj)
        tempOut{idx} = executeMethod(jobj(idx), name, varargin);
    end
catch aException
    localFixError(aException, 'instrument:icgroup:invoke:executionErr');
end

% Create output.
out = cell(length(tempOut), length(tempOut{1}));
for idx = 1:length(tempOut)
    x = tempOut{idx};

    if isempty(x)
        out{idx,1} = [];
    elseif isa(x(1), 'java.lang.Object[]') && (length(x(1)) == 2)
        % Special case for binary data that needs to be formatted.
        out{idx,1} = localFormatData(x(1));
    else
        % If a string was returned, don't split each character into a
        % cell element.
        if ischar(x)
            out{idx,1} = x;
        else
            % Loop through and add to the output cell array.
            for jdx = 1:length(x)
                out{idx,jdx} = x(jdx);
            end
        end
    end
end

if isempty(out)
    out = [];
end

% Assign to varargout.
if (nargout == 1) || ~isempty(out)
    if size(out,2) == 1
        if length(out) == 1
            % There is one output argument and one group object.
            varargout{1} = out{:};
        else
            % There is one output argument and multiple group objects.
            varargout{1} = out;
        end
    elseif size(out,1) == 1
        % There is one group object and multiple output arguments.
        [varargout(1:numel(out))] = out;
    else
        % There are more than one group objects and multiple output
        % arguments.
        for idx = 1:nargout
            varargout{idx} = out(:,idx);
        end
    end
end

% ---------------------------------------------------------------------
% Format the binary data read from the instrument.
function data = localFormatData(dataread)

data = dataread(1);
precision = char(dataread(2));

try
    switch precision
        case {'uint8', 'uchar', 'char'}
            data = double(data);
            data = data + (data<0).*256;
        case {'uint16', 'ushort'}
            data = double(data);
            data = data + (data<0).*65536;
        case {'uint32', 'uint', 'ulong'}
            data = double(data);
            data = data + (data<0).*(2^32);
        case {'int8', 'schar'}
            data = double(data);
            data = data - (data>127)*256;
        otherwise
            data = double(data);
    end
catch
end

% -------------------------------------------------------------------
% Fix the error message.
function localFixError (exception, id )

% Initialize variables.
out = exception.message;

if (isempty(out))
    throwAsCaller(MException(id,...
                    message(id).getString()));
end

% Remove the trailing carriage returns from err msg.
while out(end) == sprintf('\n')
    out = out(1:end-1);
end

% Remove the "Error using ..." message.
if strfind(out, 'Error using') == 1
    index = strfind(out, sprintf('\n'));
    if (~isempty(index))
        out = out(index+1:end);
    end
end

% Reset the error and it's id.
out = strrep(out, '\', '\\');
newExc = MException(id, out);
throwAsCaller(newExc);

