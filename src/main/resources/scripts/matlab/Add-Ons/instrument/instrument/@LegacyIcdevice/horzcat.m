function out = horzcat(varargin)
%HORZCAT Horizontal concatenation of instrument objects.
%

%   Copyright 1999-2024 The MathWorks, Inc. 


% Initialize variables.
c=[];

% Loop through each java object and concatenate.
for i = 1:nargin
    if ~isempty(varargin{i}),
        if isempty(c),
            % Must be an instrument object otherwise error.
            if ~isa(varargin{i},'instrument'),
                error(message('instrument:horzcat:nonInstrumentConcat'))
            end
            c=varargin{i};
        else
            
            % Extract needed information.
            try
               appendJObject = varargin{i}.jobject;
               appendConstructor = varargin{i}.constructor;
               appendStore = varargin{i}.store;
            catch
                % This will fail if not an instrument object.
                newExc = MException('instrument:horzcat:nonInstrumentConcat', 'Instrument objects can only be concatenated with other instrument objects.');
                throw(newExc); 
            end
            
            % Append the jobject field.
            try
                c.jobject = [c.jobject appendJObject];
            catch aException
                localCleanupErrorMessage (aException);
            end
            
            % Append the constructor.
            if ischar(c.constructor)
                if ischar(appendConstructor)
                    c.constructor = {c.constructor appendConstructor};
                else
                    c.constructor = {c.constructor appendConstructor{:}};
                end
            else
                if ischar(appendConstructor)
                    c.constructor = {c.constructor{:} appendConstructor};
                else
                    c.constructor = {c.constructor{:} appendConstructor{:}};
                end
            end
        end 
    end
end

% Verify that a matrix was not created.
if length(c.jobject) ~= numel(c.jobject)
   error(message('instrument:horzcat:nonMatrixConcat'))
end

% Output the array of objects.
out = c;

% ------------------------------------------------
function localCleanupErrorMessage (exception)

% Initialize variables.
msg = exception.message;
id = exception.identifier;

% Remove the "Error using ..." message.
if findstr(msg, 'Error using') == 1
    index = findstr(msg, sprintf('\n'));
    if (index ~= -1)
        msg = msg(index+1:end);
    end
end

% Define an ID if one isn't defined.
if isempty(id) || ~isempty(findstr(id, 'MATLAB:class:'))
    id = 'instrument:horzcat:opfailed';
end

% Reset the error and it's id.
newExc =  MException(id, msg);
throwAsCaller(newExc);


