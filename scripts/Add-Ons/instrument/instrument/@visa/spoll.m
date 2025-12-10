function [out byte_values] = spoll(obj, val)
%SPOLL Perform serial poll.
%
%   OUT = SPOLL(OBJ) reads the status byte of the services request on the
%   VISA object, where OBJ an array of VISA objects. OUT contains the VISA
%   objects that are ready for servicing. If there are no objects ready for
%   servicing, then OUT is empty.
%
%   OUT = SPOLL(OBJ, VAL), where VAL is a numeric array of indices into
%   OBJ, performs a serial poll on the VISA object, OBJ, and waits until
%   the specified instruments, VAL, have requested servicing. VAL is a
%   numeric array which contains the indices of the objects in OBJ which
%   must be ready for servicing before SPOLL returns control to MATLAB.
%   SPOLL will block for up to the number of seconds specified by the
%   Timeout property for each OBJ specified by VAL.
%
%   An error is returned if a value specified in VAL does not match an
%   index value in OBJ.
%
%   For example, if OBJ is a four element VISA array [OBJ1 OBJ2 OBJ3 OBJ4]
%   and if VAL is set to [1 3], SPOLL will not return until both OBJ1 and
%   OBJ3 have requested servicing or until the timeout period, as specified
%   by the Timeout property, expires. With the same VISA array, OBJ, if VAL
%   is set to 5, it returns an error since OBJ has a length of 4.
%
%   For any of the above methods of calling SPOLL, if a second output
%   argument is specified then full serial poll bytes are returned in
%   addition to the service request status in that second argument.
%
%   Examples:
%       v1 = visa('agilent', 'TCPIP0::TMWWAVEMASTER::inst0::INSTR'); 
%       v2 = visa('agilent', 'TCPIP0::TMWSMU200::inst0::INSTR'); 
%       fopen([v1 v2]);
%       out1 = spoll(v1);
%       out2 = spoll([v1 v2], 1);
%       out3 = spoll([v1 v2], [1 2])
%       [out4 statusBytes] = spoll([v1 v2])
%       [out5 statusBytes] = spoll([v1 v2], 2)
%       fclose([v1 v2]);
%
%   See also VISA.
%

%   Copyright 2009-2014 The MathWorks, Inc. 

% Error if too many output arguments.
if nargout > 2
    error(message('instrument:spoll:invalidSyntax'));
end

% Verify OBJ consists of only visa objects.
objType = get(obj, {'Type'});
objType = unique(objType);
for m=1:length(objType)
    if ~((strcmp(objType(m),'gpib') || ~isempty(strfind(objType(m), 'visa'))))
        error(message('instrument:spoll:invalidOBJ', 'VISA', 'VISA'));
    end
end

% Verify that each object is connected to the hardware.
status = get(obj, {'Status'});
status = unique(status);
if ~((length(status) == 1) && (strcmp(status, 'open')))
    error(message('instrument:spoll:OBJnotConnected'));
end

% wait(i) = 0 indicates no waiting for service
% wait(i) = 1 indicates wait for service
wait = zeros(1,length(obj));
if (nargin == 2)
    value = unique(val);
    % Verify that value corresponds to an object in OBJ.
    if max(value) > length(obj)
        error(message('instrument:spoll:invalidVAL'));
    end
    % Indicate which objects should wait for service.
    wait(value)=1;
end

% Get the java objects.
% info = struct(obj);
info.jobject = obj.jobject;
jobject = info.jobject;

% Conduct the serial poll for each object.
line = [];
for i=1:length(jobject),
    try
        line = [line uint8(spoll(jobject(i), wait(i)))]; %#ok<AGROW>
    catch aException
        newExc = MException('instrument:spoll:opfailed',aException.message );
        throw (newExc);
    end
end

if (nargout == 2)
    byte_values=line;
end

ind = find(bitand(line, 64)==64);
if isempty(ind)
    out = [];
else
    out = localIndexOf(obj,{ind});
end

end % end spoll

% *********************************************************************
% Index into an instrument array.
function result  = localIndexOf(obj, index1)

try
   % Get the field information of the entire object.
   jobj = igetfield(obj, 'jobject');
   constructor = igetfield(obj, 'constructor');	
   
   if ischar(constructor)
   	   % Ex. obj(1) when obj only contains one element.	
       constructor = {constructor};
   end
   
   % Create the first object and then append the remaining objects.
   if (length([index1{1}]) == 1)
       % This is needed so that the correct classname is assigned
       % to the object.
	   result = feval(constructor{index1{1}(1)}, jobj(index1{:}));
   else
       % The class will be instrument since there are more than 
       % one instrument objects.  
       result = obj;
   	   result = isetfield(result, 'jobject', jobj(index1{:}));
       result = isetfield(result, 'constructor', constructor(index1{:}));
   end
catch %#ok<CTCH>
   newExc = MException ('instrument:spoll:exceedsdims','Index exceeds matrix dimensions.');
   throwAsCaller (newExc);
end

end % end localIndexOf
