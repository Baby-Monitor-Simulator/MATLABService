function clrdevice(obj)
%CLRDEVICE Clear instrument buffer.
%
%   CLRDEVICE(OBJ) clears the buffer of the instrument connected to
%   interface object, OBJ. OBJ must be a 1-by-1 GPIB, VISA-GPIB, 
%   VISA-VXI, VISA-USB or VISA-RSIB object.
%
%   For GPIB or VISA-GPIB objects, the GPIB Selected Device Clear (SDC)
%   message is sent to the instrument. 
%
%   For VISA-VXI objects, the Word Serial Clear message is sent to the 
%   instrument. 
%
%   For VISA-USB objects, the INITIATE_CLEAR and CHECK_CLEAR_STATUS commands
%   are sent to the instrument on the control pipe.
%
%   The object, OBJ, must be connected to the instrument with the 
%   FOPEN function before the CLRDEVICE function is issued otherwise 
%   an error will be returned. A connected object has a Status 
%   property value of open.
%
%   You can clear the software input buffer using the FLUSHINPUT 
%   function. You can clear the software output buffer using the 
%   FLUSHOUTPUT function.
%
%   Example:
%       g = gpib('ni', 0, 2);
%       fopen(g);
%       fprintf(g, '*IDN?');
%       clrdevice(g);
%
%   See also ICINTERFACE/FOPEN, ICINTERFACE/FLUSHINPUT, ICINTERFACE/FLUSHOUTPUT,
%   INSTRHELP.
%

%   Copyright 1999-2016 The MathWorks, Inc. 

% Error checking.
if length(obj)>1 || ~isvalid(obj)
    error(message('instrument:clrdevice:invalidOBJ'));
end

if ~strcmpi(get(obj, 'Type'), 'gpib')
    error(message('instrument:clrdevice:invalidOBJType'));
end

% Call the java clrdevice method.  
try
	clrdevice(igetfield(obj, 'jobject'));
catch aException
    newExc =  MException('instrument:clrdevice:opfailed', aException.message);
    throw (newExc);
end

