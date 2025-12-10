function connect(varargin)
%CONNECT Connect device object to instrument.
%
%   CONNECT(OBJ) connects the device object, OBJ, to the instrument. OBJ
%   can be an array of device objects.
%
%   If OBJ was successfully connected to the instrument, OBJ's Status property 
%   is configured to open, otherwise the Status property remains configured to
%   closed. 
%
%   If OBJ is an array of device objects and one of the objects cannot be 
%   connected to the instrument, the remaining objects in the array will 
%   be connected to the instrument and a warning will be displayed.
%
%   CONNECT(OBJ, 'UPDATE') connects the device object, OBJ, to the instrument. 
%   UPDATE can be either 'object' or 'instrument'. If UPDATE is 'object', then
%   the object is updated to reflect the state of the instrument. If UPDATE 
%   is 'instrument' then the instrument is updated to reflect the state of 
%   the object, i.e. all property values defined by the object are sent to 
%   the instrument on open. By default, UPDATE is 'object'.
%
%   Example:
%       % Construct a device object that has specific information about a 
%       % Tektronix TDS 210 instrument.
%       g = gpib('ni', 0, 2);
%       d = icdevice('tektronix_tds210', g);      
%
%       % Connect to the instrument
%       connect(d);
%
%       % List the oscilloscope settings that can be configured.
%       props = set(d);
%
%       % Get the current configuration of the oscilloscope.
%       values = get(d);
%
%       % Disconnect from the instrument and cleanup.
%       disconnect(d);
%       delete([d g]);
%
%   See also ICDEVICE/DISCONNECT, INSTRUMENT/DELETE, INSTRHELP.
%

%   Copyright 1999-2024 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch (nargin)
case 0
    error(message('instrument:icdevice:connect:tooFewArgs'));
case 1
    obj = varargin{1};
    type = 'object';
case 2
    obj = varargin{1};
    type = varargin{2};
otherwise
    error(message('instrument:icdevice:connect:tooManyArgs'));
end

% Error checking on OBJ.
if ~isa(obj, 'instrument')
    error(message('instrument:icdevice:connect:invalidOBJ'));
end

% Error checking on Update flag.
if ~isa(type, 'char')
    error(message('instrument:icdevice:connect:invalidFlag'));
end

if ~any(strcmpi(type, {'object', 'instrument'}))
    error(message('instrument:icdevice:connect:invalidFlag'));
end

% Initialize variables.
errorOccurred = false;
jobject = igetfield(obj, 'jobject');

% Call fopen on each java object.  Keep looping even 
% if one of the objects could not be opened.
for i=1:length(jobject)

    wasOpen = jobject(i).getStatus;
    
    try
        open(jobject(i), type);

        % Execute initialization code.
        try
            code = char(getConnectInitializationCode(jobject(i)));
            willExecuteDriverConnectCode(jobject(i));
            localEvaluateCode(code, jobject(i));
            didExecuteDriverConnectCode(jobject(i));
        catch aException
            close(jobject(i));
            errorOccurred = true;
            errmsg = sprintf('An error occurred while executing the driver connect code.\n%s', aException.message);
        end
    catch aException
        errorOccurred = true;
        errmsg =  aException.message; 
        if (jobject(i).getStatus == 1 && ~wasOpen)
            close(jobject(i));
        end
    end
end

% Report error if one occurred.
if errorOccurred
    if length(jobject) == 1
        newExc = MException('instrument:connect:opfailed',[errmsg sprintf('\n') 'If this error is not an instrument error, use MIDEDIT to inspect the driver.']);
        throw(newExc);
    else
        warnState = warning('backtrace', 'off');
        warnID = 'instrument:icdevice:connect:invalid';
        warning(message('instrument:icdevice:connect:invalid'));
        warning(warnState);
    end
end

% -----------------------------------------------------------------
% Evaluate the initialization code.
function localEvaluateCode(fcn, jobj)

obj = icdevice(jobj);

% Evaluate the code.
instrgate('privateEvaluateCode', obj, fcn);

