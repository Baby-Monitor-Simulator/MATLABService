function out = privateInstrcommHelper(action, obj, varargin)
%PRIVATEINSTRCOMMHELPER helper function used by INSTRCOMM.
%
%   PRIVATEINSTRCOMMHELPER helper function used by INSTRCOMM to:
%      1. Connect to the object
%      2. Write to the object
%      3. Read from the object
%      4. Disconnect from the object
%      5. Flush the object.
%
%   This function should not be called directly be the user.
%
%   See also INSTRCOMM.
%

%   Copyright 1999-2015 The MathWorks, Inc.

% Convert the java instrument object to a MATLAB OOPs object.
if (nargin >= 2) && isa(obj, 'com.mathworks.toolbox.instrument.Instrument')
    obj = localGetValidObject(obj);
end

% Initialize output.
out = '';

switch action
    case 'isopen'
        % Determine if object is open so the instrcommLabel panel can be updated correctly.
        out = obj.Status;
    case 'fopen'
        % Connect to the object.
        fopen(obj);
        out = get(obj, 'Status');
    case 'fclose'
        % Disconnect from the object.
        fclose(obj);
        out = get(obj, 'Status');
    case 'fprintf'
        % Parse the input.
        source = varargin{3};
        cmd = varargin{2};
        origCmd = cmd;
        % Evaluate the expression in the MATLAB workspace if the user specified to.
        if (strcmp(source, 'Evaluate'))
            cmd = evalin('base', cmd);
        end
        
        % Store the initial number of values sent.
        initial = get(obj, 'ValuesSent');
        
        % Write the command.
        fprintf(obj, varargin{1}, cmd);
        cmd = origCmd;
        
        % Determine the number of values sent with the last command and return.
        current = get(obj, 'ValuesSent');
        out = {current-initial, cmd};
    case 'fwrite'
        % Parse the input.
        isHex = varargin{4};
        source = varargin{3};
        cmd = varargin{2}; % The expression to be written
        origCmd = cmd;
        validMATLABExpression = false;
        
        % Convert the cmd from hex representation to decimal
        if strcmp(isHex, 'Checked')
            cmd = convertFromHexToDecimalValString(cmd);
        end
        
        % Evaluate the expression in the MATLAB workspace if the user specified to.
        if (strcmp(source, 'Evaluate'))
            cmd = evalin('base', cmd);
        end
        
        % Store the initial number of values sent.
        initial = get(obj, 'ValuesSent');
        
        % convert the input string to a MATLAB num if the precision is not set to
        % uchar
        if ~strcmpi (varargin{1}, 'uchar') && ischar(cmd)
            cmd = str2num (cmd);
        end
        
        %If the above conversion failed check if the string was indeed a
        %valid MATLAB expression
        
        if isempty(cmd)
            %May have been valid MATLAB syntax that str2num doesn't handle
            try
                cmd = eval(origCmd);
                validMATLABExpression = true;
            catch
                %Invalid command: Set cmd to empty so session log doesn't
                %reflect any writable data
                cmd = [];
            end
        end
        
        % Write the command.
        fwrite(obj, cmd, varargin{1});
        
        % Determine the number of values sent with the last command and return.
        current = get(obj, 'ValuesSent');

        isHexSpecifiedForNonUcharPrecision= strcmpi(isHex, 'Checked')&& ~strcmpi(varargin{1}, 'uchar');
        
        % Only convert to hex2dec format if it is hex and the user hasn't
        % specified writing the input as chars
        outputToJava = cmd;
        
        if isHexSpecifiedForNonUcharPrecision
            outputToJava = localConvertFromDoubleToHex2Dec(outputToJava);
        elseif isnumeric(outputToJava)
            %It was a purely numeric command , convert into string for session log
            outputToJava = mat2str(outputToJava);
        end
        
        isEvalSpecifiedForNonHexExpression = ~strcmpi(isHex, 'Checked') && (strcmpi(source, 'Evaluate'));
        
        if isempty(outputToJava)
            % Invalid command was specified. write empty in session log
            outputToJava = '[]';
        elseif isEvalSpecifiedForNonHexExpression || validMATLABExpression
            % Eval was checked, and the cmd is not a formatted HEX2DEC
            % string
            outputToJava = origCmd;
        end
        
        % Pass the actual MATLAB expression to be evaluated to the session
        % log
        
        out = {current-initial, outputToJava};
        
    case 'binblockwrite'
        % Parse the input.
        source = varargin{3};
        cmd = varargin{2};
        
        
        % Evaluate the expression in the MATLAB workspace if the user specified to.
        if (strcmp(source, 'Evaluate'))
            cmd = evalin('base', cmd);
        end
        
        % Store the initial number of values sent.
        initial = get(obj, 'ValuesSent');
        
        % Write the command.
        binblockwrite(obj, cmd, varargin{1});
        
        % Determine the number of values sent with the last command and return.
        current = get(obj, 'ValuesSent');
        out = {current-initial, cmd};
    case 'fscanf'
        % Parse the input.
        size = varargin{2};
        
        % Read data from instrument.
        if isempty(size)
            [data, count, msg] = fscanf(obj, varargin{1});
        else
            [data, count, msg] = fscanf(obj, varargin{1}, str2num(varargin{2}));
        end
        
        % Construct variable name.
        variableName = ['data' num2str(varargin{3}+1)];
        
        % Remove any carriage returns or line feeds and return.
        data = removeCRLF(data);
        out = {data, count, msg, variableName};
    case 'fread'
        % Parse the input.
        size = varargin{2};
        isHex = varargin{4};
        % If size wasn't specified, determine the maximum SIZE that can be read.
        % Otherwise convert size string to a number.
        if isempty(size)
            if (isa(obj, 'i2c'))
                % I2C does not support BytesAvailable so size defaulted to
                % the InputBufferSize
                size = get(obj, 'InputBufferSize');
            else
                size = get(obj, 'InputBufferSize') - get(obj, 'BytesAvailable');
            end
        else
            size = str2num(size);  %#ok<*ST2NM>
        end
        
        % Read data from instrument.
        [data, count, msg] = fread(obj, size, varargin{1});
        
        %I2C objects return empty for msg
        if isempty(msg)
            msg = '';
        end
        
        % Assign the value to the MATLAB workspace and return.
        variableName = ['data' num2str(varargin{3}+1)];
        if strcmpi(isHex, 'Checked')
            data = dec2hex(data);
        end
        out = {data,count,msg, variableName};
    case 'binblockread'
        % Read data from instrument.
        [data, count, msg] = binblockread(obj, varargin{1});
        
        % Assign the value to the MATLAB workspace and return.
        variableName = ['data' num2str(varargin{3}+1)];
        out = {data,count,msg, variableName};
    case 'query'
        % Parse the input.
        source = varargin{5};
        cmd = varargin{1};
                
        % Evaluate the expression in the MATLAB workspace if the user specified to.
        if (strcmp(source, 'Evaluate'))
            cmd = evalin('base', cmd);
        end
        
        % Store the number of values that have been sent.
        initial = get(obj, 'ValuesSent');
        
        % Query the instrument.
        [data, count, msg] = query(obj, cmd, varargin{2}, varargin{3});
        
        % Construct variable name.
        variableName = ['data' num2str(varargin{4}+1)];
        
        % Determine the number of values that was just written to the instrument.
        current = get(obj, 'ValuesSent');
        out = {removeCRLF(data), count,msg, current-initial, variableName};
    case 'flushinput'
        % Flush the object.
        flushinput(obj);
        out = num2str(get(obj, 'BytesAvailable'));
    case 'demo'
        % Open the demos.
        demo('toolbox', 'instrument control');
    case 'doc'
        % Open the documentation.
        doc('instrument');
end

% --------------------------------------------
% Get the MATLAB OOPs object for the java instrument object.
function out = localGetValidObject(instr)

objs = instrfindall;
for i = 1:length(objs)
    obj = objs(i);
    jobj = java(igetfield(obj, 'jobject'));
    if (jobj == instr)
        out = obj;
        return;
    end
end

% --------------------------------------------
% Remove any trailing carriage returns or line feeds.
function out = removeCRLF(out)

if isempty(out)
    return;
end

while out(end) == sprintf('\n')
    out = out(1:end-1);
    if isempty(out)
        break;
    end
end

if isempty(out)
    return;
end

while out(end) == sprintf('\r')
    out = out(1:end-1);
    if isempty(out)
        break;
    end
end

% --------------------------------------------
% Convert any hex values to decimal values
function out = convertFromHexToDecimalValString(s)

% Initialize
bracketFound = false;

if (strfind(s, '['))
    bracketFound = true;
end

%Remove the brackets
s = strrep(s, '[', '');
s = strrep(s, ']', '');

% read the numbers into a cell array
nums = textscan(s, '%s');

%if the number contains a prepended 0x, convert to hex
convertedVals = cellfun(@convertIfHex, nums{1});
%convert the array into a matlab style array string
out = convertedVals';
out = mat2str(out);

if (~bracketFound)
    %Remove the brackets
    out = strrep(out, '[', '');
    out = strrep(out, ']', '');
end

% --------------------------------------------
function out = convertIfHex(s)
if strfind(s, '0x')
    strippedString = strrep(s, '0x', '');
    out = hex2dec(strippedString);
else
    out = hex2dec(s);
end

function out = localConvertFromDoubleToHex2Dec(cmd)

baseCommand = 'hex2dec(''__'') ';
% Create copies equal to the number of hex bytes sent out
out = repmat(baseCommand, length(cellstr(dec2hex(cmd))),1);
% Create a cellstr out of the char matrix
out = cellstr(out);
% Add a space after each hex2dec for array element separation
out = cellfun(@(x) strrep(x,')', ') '), out, 'UniformOutput', false);
% replace each double with it's equivalent hex string inside the
% baseCommand
out = strrep(out, '__', cellstr(dec2hex(cmd)));
% convert into a single string
out = cell2mat(out');
% Add the array brackets
out = [ '[' out(1:end-1) ']'];


