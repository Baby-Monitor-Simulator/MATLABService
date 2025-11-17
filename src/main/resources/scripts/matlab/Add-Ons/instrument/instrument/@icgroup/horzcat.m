function out = horzcat(varargin)
%HORZCAT Horizontal concatenation of device group objects.
%

%   MP 6-25-02
%   Copyright 1999-2011 The MathWorks, Inc. 


% Initialize variables.
c=[];

% Loop through each java object and concatenate.
for i = 1:nargin
    if ~isempty(varargin{i}),
        if isempty(c),
            % Must be an instrument object otherwise error.
            if ~isa(varargin{i},'icgroup'),
                error(message('instrument:icgroup:horzcat:invalidConcat'))
            end
            c=varargin{i};
        else
            typeForError = char(c.jobject(1).getType);
            
            % Extract needed information.
            try
               appendJObject = varargin{i}.jobject;
               appendType = varargin{i}.type;
               
               % Verify the object types are the same.
                if mclass(c.jobject(1)) ~= mclass(appendJObject(1))
                    error(message('instrument:icgroup:horzcat:notSameType'));
                end
            catch aException
                % Rethrow error from above.
                if strcmp(aException.identifier, 'instrument:icgroup:horzcat:notSameType')
                    rethrow(aException);
                end

                % This will fail if not an instrument object.
                error(message('instrument:icgroup:horzcat:invalidConcat'))
            end
            
            % Verify that the outputs have the same parent.
            if ~isequal(appendJObject(1).getParent, c.jobject(1).getParent)
                error(message('instrument:icgroup:horzcat:notSameParent'));    
            end
            
            % Append the jobject field.
            try
                c.jobject = [c.jobject appendJObject];
            catch aException
                localCleanupErrorMessage(aException);
            end
            
            % Append the type field.
            if ischar(c.type)
                if ischar(appendType)
                    c.type = {c.type appendType};
                else
                    c.type = {c.type appendType{:}};
                end
            else
                if ischar(appendType)
                    c.type = {c.type{:} appendType};
                else
                    c.type = {c.type{:} appendType{:}};
                end
            end
        end 
    end
end

% Verify that a matrix was not created.
if length(c.jobject) ~= numel(c.jobject)
   error(message('instrument:icgroup:horzcat:nonMatrixConcat'))
end

% Output the array of objects.
out = c;

% ------------------------------------------------
function localCleanupErrorMessage (aException)

% Initialize variables.
id = aException.identifier;
out = aException.message;

% Remove the "Error using ..." message.
if findstr(out, 'Error using') == 1
    index = findstr(out, sprintf('\n'));
    if (index ~= -1)
        out = out(index+1:end);
    end
end

% Define an ID if one isn't defined.
if isempty(id) || ~isempty(findstr(id, 'MATLAB:class:'))
    id = 'instrument:icgroup:horzcat:opfailed';
end

% Reset the error and it's id.
newExc = MException(id, out);
throwAsCaller(newExc);

