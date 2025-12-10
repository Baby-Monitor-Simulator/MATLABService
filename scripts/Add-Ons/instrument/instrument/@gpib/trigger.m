function trigger(obj)
%TRIGGER Send trigger message to instrument.
%
%   TRIGGER(OBJ) sends a trigger message to the instrument. OBJ must be 
%   a 1-by-1 GPIB, VISA-GPIB, VISA-VXI, VISA-USB or VISA-RSIB object. 
%
%   For GPIB, VISA-GPIB and VISA-RSIB objects, the Group Execute Trigger
%   (GET) message is sent to the instrument.  
%
%   For VISA-VXI objects, if OBJ's TriggerType property is configured to 
%   software, the Word Serial Trigger command is sent to the instrument.
%   If OBJ's TriggerType property is configured to hardware, a hardware
%   trigger is sent on the line specified by OBJ's TriggerLine property.
%
%   For VISA-USB objects, the TRIGGER message ID is sent on the Bulk-OUT 
%   pipe. If the USB instrument is not 488.2 compliant, TRIGGER will return
%   an error.
%
%   The object, OBJ, must be connected to the instrument with the FOPEN
%   function before the TRIGGER function is issued otherwise an error 
%   will be returned. A connected object has a Status property value 
%   of open.
%
%   Example:
%       g = gpib('ni', 0, 2);
%       fopen(g);
%       trigger(g);
%
%   See also INSTRHELP, INSTRUMENT/PROPINFO.
%

%   Copyright 1999-2013 The MathWorks, Inc. 

% Error checking.
if (length(obj) > 1)
    error(message('instrument:trigger:invalidOBJDim'));
end

if ~strcmpi(get(obj, 'Type'), 'gpib')
    error(message('instrument:clrdevice:invalidOBJType'));
end

% Call java method.
try
	trigger(obj.jobject);
catch aException
    newExc =  MException('instrument:trigger:opfailed',aException.message);
    throw (newExc);
end
