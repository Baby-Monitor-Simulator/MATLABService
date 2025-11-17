function outForCustomFunction = privateExecuteMCode(fcn, obj, args, numout)
%PRIVATEEXECUTEMCODE helper function used by device objects.
%
%   PRIVATEEXECUTEMCODE helper function used by the device objects and
%   device input and output channels. 
%
%   PRIVATEEXECUTEMCODE is used when the INVOKE method is called.
%   
%   This function should not be called directly by the user.
%  
 
%   MP 01-03-03
%   Copyright 1999-2012 The MathWorks, Inc.

% Extract the code from the fcn to be evaluated.
index   = findstr(fcn, sprintf('\n'));
fcnline = fcn(1:index(1));
code    = fcn(index(1)+1:end);

[output, input] = localParseFcnLine(fcnline);

% Check for varargin.
if (~isempty(input)) && (strcmp(input(end), 'varargin'))
    varargin = args(length(input)-1:end);
    input(end) = [];
end    

% Evaluate the input arguments.
for i=1:length(args)
    value = args{i};
    if (length(input) >= i+1)
        inputName = input{i+1};
        eval([inputName ' = value ;']);
    end
end

eval(['nargin = ' num2str(length(args)+1) ';']);
eval(['nargout = ' num2str(numout) ';']);

% Evaluate the code.
try
    eval(code);
catch aException
    localCleanupError(aException)
end

% Determine if varargout has been defined.
tempvarargout = {};
numOfOutput = length(output);

if (~isempty(output)) && (strcmp(output(end), 'varargout'))
    numOfOutput = length(output)-1;
    try
        eval('tempvarargout = varargout;');
    catch
        tempvarargout = {};
    end
end

% Assign output.
outForCustomFunction = cell(1, (length(output)-1) + length(tempvarargout));
for i = 1:numOfOutput
    outForCustomFunction{i} = eval(output{i});
end

if (numOfOutput ~= length(output))
    for i = numOfOutput+1:length(outForCustomFunction)
        outForCustomFunction{i} = tempvarargout{i-numOfOutput};
    end
end

% ---------------------------------------------------------------------
function [output, input] = localParseFcnLine(fcnline)

% Initialize variables.
output = {};
input  = {};

% Determine if there are any output arguments.
index = findstr(fcnline, '=');
if (index ~= -1)
    output = localParseOutputArguments(fcnline(9:index));
end

% Determine if there are any input arguments.
index = findstr(fcnline, '(');
if (index ~= -1)
    input = localParseInputArguments(fcnline(index:end));
end

% ---------------------------------------------------------------------
function output = localParseOutputArguments(str)

str = strrep(str, '[', '');
str = strrep(str, ']', '');
str = strrep(str, '=', '');
str = strtrim(str);

% Delimiter can be a space, comma, or tab.
output = strread(str,'%s','delimiter',', \t');

% ---------------------------------------------------------------------
function output = localParseInputArguments(str)

str = strrep(str, '(', '');
str = strrep(str, ')', '');
str = strtrim(str);

output = strread(str,'%s','delimiter', ',');

% ---------------------------------------------------------------------
function localCleanupError(aException)

msg = aException.message ; 
id = aException.identifier;
msg = strrep(msg, [getString(message('MATLAB:legacy_two_part:error_using')) ' ==> privateExecuteMCode' sprintf('\n')], '');
throwAsCaller(MException(id, msg));

 
            