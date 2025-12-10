function out = vertcat(varargin)
%VERTCAT Vertical concatenation of device group objects.
%

%   MP 6-25-02
%   Copyright 1999-2011 The MathWorks, Inc. 

% Initialize variables.
c=[];

% Loop through each java object and concatenate.
for i = 1:nargin
    if ~isempty(varargin{i})        
        if isempty(c)
            % Must be an instrument object otherwise error.
            if ~isa(varargin{i},'icgroup')
                error(message('instrument:icgroup:vertcat:invalidConcat'))
            end
            c=varargin{i};
        else       

            % Extract needed information.
            try
%                 info = struct(varargin{i});
%                 appendJObject = info.jobject;
%                 appendType = info.type;
               appendJObject = varargin{i}.jobject;
               appendType = varargin{i}.type;
               
                %Verify the object types are the same.
                if mclass(c.jobject(1)) ~= mclass(appendJObject(1))
                    error(message('instrument:icgroup:vertcat:notSameType'));
                end
            catch aException
                % Rethrow error from above.
                if strcmp(aException.identifier, 'instrument:icgroup:vertcat:notSameType')
                    rethrow(aException);
                end

                % This will fail if not an instrument object.
                error(message('instrument:icgroup:vertcat:invalidConcat'))
            end
            
            % Verify that the outputs have the same parent.
            if ~isequal(appendJObject(1).getParent, c.jobject(1).getParent)
                error(message('instrument:icgroup:vertcat:notSameParent'));    
            end
            
            % Append the jobject field.
            try
                c.jobject = [c.jobject; appendJObject];
            catch aException
                localCleanupErrorMessage(aException);
            end

            % Append the Type field.
            if ischar(c.type)
                if ischar(appendType)
                    c.type = {c.type appendType}';
                else
                    c.type = {c.type appendType{:}}';
                end
            else
                if ischar(appendType)
                    c.type = {c.type{:} appendType}';
                else
                    c.type = {c.type{:} appendType{:}}';
                end
            end
        end 
    end
end

% Verify that a matrix of objects was not created.
if length(c.jobject) ~= numel(c.jobject)
   error(message('instrument:icgroup:vertcat:nonMatrixConcat'))
end

% Output the array of objects.
out = c;

% ------------------------------------------------
function localCleanupErrorMessage (exception)

% Initialize variables.
id = exception.identifier;
out =  exception.message;

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

newExc = MException(id, out);
throwAsCaller(newExc);
 
