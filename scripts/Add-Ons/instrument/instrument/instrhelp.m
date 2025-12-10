function varargout = instrhelp(varargin)
%INSTRHELP Return instrument object function and property help.
%
%   INSTRHELP will be removed in a future release. For serialport,
%   tcpclient, tcpserver, udpport, visadev, bluetooth, aardvark/device,
%   and ni845x/device objects, use <a href="matlab:help help">help</a> instead.
%
%   INSTRHELP provides a complete listing of instrument object functions. 
%
%   INSTRHELP('NAME') provides on-line help for the function or property,
%   NAME. If NAME is the class name of an instrument object or device group
%   object, for example, visa, a complete listing of functions and properties
%   for the object class is displayed. The on-line help for the object's 
%   constructor is also displayed. If NAME is the class name of an instrument
%   object with a .m extension, the on-line help for the object's constructor 
%   is displayed.
%
%   Object specific function information can be displayed by specifying
%   NAME to be object/function. For example to display the on-line
%   help for a serial port object's FPRINTF function, NAME would be
%   serial/fprintf.
%
%   Object specific property information can be displayed by specifying
%   NAME to be object.property. For example to display the on-line help
%   for a serial port object's Parity property, NAME would be serial.Parity.
%
%   OUT = INSTRHELP('NAME') returns the help text in string, OUT.
%
%   INSTRHELP(OBJ) displays a complete listing of functions and properties
%   for the object, OBJ, along with the on-line help for the object's 
%   constructor. OBJ must be a 1-by-1 instrument object or a device
%   group object.
%
%   INSTRHELP(OBJ, 'NAME') displays the help for function or property, NAME,
%   for the object, OBJ.
%
%   OUT = INSTRHELP(OBJ, 'NAME') returns the help text in string, OUT.
%
%   Note, if NAME is a device object function or property or a device group
%   object function or property, the object, OBJ, must be specified.
%   
%   When displaying property help, the names in the See also section which
%   contain all upper case letters are function names. The names which
%   contain a mixture of upper and lower case letters are property names.
%
%   When displaying function help, the See also section contains only 
%   function names.
%
%   Example:
%       instrhelp('serial')
%       out = instrhelp('serial.m');
%       instrhelp set
%       instrhelp RecordMode     
%
%       g = gpib('ni', 0, 2);
%       instrhelp(g)
%       instrhelp(g, 'EOSMode');
%       out = instrhelp(g, 'propinfo');
% 
%   See also INSTRUMENT/PROPINFO, ICGROUP/PROPINFO.
%

%   Copyright 1999-2022 The MathWorks, Inc.

try
    instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Function");
catch ex
    throwAsCaller(ex);
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Error checking.
if nargin == 2
    error(message('instrument:instrhelp:invalidSyntaxArgOne'));
end

if nargout > 1
    error(message('instrument:instrhelp:invalidSyntaxRet'));
end

% Find the directory where the toolbox is installed.
instrRoot = which('instrgate', '-all');
instrRoot = fileparts(instrRoot{1});

% Parse the input.
switch nargin
    case 0
        % Return Contents help.
        switch nargout
            case 0
                disp(evalc('help([instrRoot filesep ''Contents.m''])'));
            case 1
                varargout{1} = help(instrRoot);
        end
        return;
    case 1
        if ~ischar(varargin{1})
            error(message('instrument:instrhelp:invalidSyntaxArgString'));
        end
        if regexpi(varargin{1}, '^Contents')
            switch nargout
                case 0
                    disp(evalc('help([instrRoot filesep ''Contents.m''])'))
                    return;
                case 1
                    varargout{1} = help(instrRoot);
                    return;
            end
        end
        name = varargin{1};
end

% Get the information on the method or property that is being looked up.
isMethod   = true;
isProperty = false;
includeContents = false;

if contains(name, '/')
    % Ex. instrhelp('serial/fopen').
    [className, lookupName] = fileparts(name);    
elseif contains(name, '.')
    [~, className, lookupName] = fileparts(name);
        
    if strcmpi(lookupName, '.m')
        % Ex. instrhelp('fopen.m')
        lookupName = className;
        className  = '';        
    else
        % Ex. instrhelp('serial.BaudRate')
        lookupName = lookupName(2:end);
        isMethod   = false;
        isProperty = true;
    end
else
    lookupName = name;    
    className = '';

    % Determine if lookupName is a directory, in which case the 
    % Contents information is also given.
    if any(strcmpi(lookupName, {'serial', 'Bluetooth', 'i2c', 'gpib', 'visa', 'tcpip', 'udp', 'icdevice', 'icgroup', 'iviconfigurationstore'}))
        includeContents = true;
    else
        % Could be one or the other.
        isMethod   = true;
        isProperty = true;
    end
end

% Get the method help.
errflag = false;
if isMethod    
    % Special case for instrument.m - Don't want to output the Contents 
	% help since not a true constructor.
	if strcmpi(lookupName, 'instrument')
		switch nargout
		case 0
			disp(evalc('help([instrRoot filesep ''Contents.m''])'));
		case 1
			varargout{1} = help([instrRoot filesep 'Contents.m']);
		end
		return;
	end
    
    pathName = localFindPath(lookupName, className, instrRoot);
    if ~isempty(pathName)
        % Path existed. It was a function.        
        if (includeContents)
            switch nargout
            case 0
                disp(evalc('help(pathName)'));
            case 1
                varargout{1} = help(pathName);
            end
            return;
        else
            switch nargout
            case 0
                out = evalc('help(pathName)');
            case 1    
                out = help(pathName);
            end
        end
    elseif any(strcmpi(lookupName, {'clear', 'load', 'save'}))
        if (nargout == 1)
            varargout{1} = sprintf(privateGetHelp(lookupName));
        else
            fprintf(privateGetHelp(lookupName));
        end
        return;
    else
        out = localGetInterfaceHelp(lookupName,className);
        if isempty(out)
            errflag = true;
        end
    end
end

% Get the property help.
if (isProperty && ~isMethod)  || (isProperty && isMethod && (errflag == true))
    [errflag, out] = localGetPropDesc(lookupName, className);
end

% If not a property or a function, error.
if errflag
	error(message('instrument:instrhelp:invalidNAME',name));
else		
	% Create output - either to command line or to output variable.
	switch nargout
	case 0
        fprintf('\n');
		disp(out)
	case 1
		varargout{1} = out;
	end   
end
 
function out = localGetInterfaceHelp(name, class) %#ok<STOUT>
    % Search for the method or property help for newer interfaces spi and
    % modbus which are not covered by any other cases in the instrhelp
    % function.
    
    % If no class is specified check the two interfaces spi and modbus
    if isempty(class)
        % First check modbus
        searchName = strcat('instrument.interface.modbus.Modbus.',name); %#ok<NASGU>
        evalc('out = help(searchName)');
        if isempty (out)
            % Not found, check spi
            searchName = strcat('instrument.interface.spi.Spi.',name); %#ok<NASGU>
            evalc('out = help(searchName)');
        end    
    elseif strcmpi(class,'modbus')
        searchName = strcat('instrument.interface.modbus.Modbus.',name); %#ok<NASGU>
        evalc('out = help(searchName)');    
    elseif strcmpi(class,'spi')
        searchName = strcat('instrument.interface.spi.Spi.',name); %#ok<NASGU>
        evalc('out = help(searchName)');
    end
    
% ********************************************************************
% Find the pathname when the object directory and method are given.
function pathname = localFindPath(name, path, instrRoot)

% Path is not empty.  The file can be in one of four locations.
% instrRoot
% instrRoot\@instrument
% instrRoot\@serial, instrRoot\@gpib, instrRoot\@visa

serialRoot = fullfile(matlabroot,'toolbox','matlab','serial','@serial');
instrRoot2 = fullfile(matlabroot,'toolbox','shared','instrument', '@instrument');
interfaceRoot = fullfile(matlabroot, 'toolbox', 'shared','instrument', '@icinterface');

% Initialize variables.
pathname = '';
allpaths = which(name, '-all');

if any(strcmpi(path, {'visa-serial', 'visa-gpib', 'visa-gpib-vxi', 'visa-pxi','visa-vxi', 'visa-tcpip', 'visa-usb', 'visa-rsib', 'visa-generic'}))
    path = 'visa';
end

name = lower(name);

% Loop through and check if one of the paths begins with the
% Instrument Control Toolbox's root directory + specified path.
	
% Check strmatch
index = strmatch([instrRoot filesep name], allpaths);
if ~isempty(index)
	pathname = allpaths{index};
	return;
end

% Check instrRoot\@instrument
index = strmatch([instrRoot filesep '@instrument'], allpaths);
if ~isempty(index)
	pathname = allpaths{index};
	return;
end

% Check instrRoot\@icinterface
if any(strcmpi(path, {'serial', 'Bluetooth','i2c', 'gpib', 'visa', 'tcpip', 'udp', ''}))
	index = strmatch([instrRoot filesep '@icinterface'], allpaths);
	if ~isempty(index)
		pathname = allpaths{index};
		return;
	end
end

% Check instrRoot\@icdevice
if (any(strcmpi(path, {'icdevice'})))
	index = strmatch([instrRoot filesep '@icdevice'], allpaths);
    if ~isempty(index)
        pathname = allpaths{index};
        return;
    end
end

% Check instrRoot\@iviconfigurationstore
if (any(strcmpi(path, {'iviconfigurationstore'})))
    index = strmatch([instrRoot filesep '@iviconfigurationstore'], allpaths);
    if ~isempty(index)
        pathname = allpaths{index};
        return;
    end
end

% Check instrRoot\@serial, instrRoot\@gpib or instrRoot\@visa
if ~isempty(path)
	index = strmatch([instrRoot filesep '@' path], allpaths);
    if ~isempty(index)
        pathname = allpaths{index};
        return;
    end
else
    objectPaths = {[instrRoot filesep '@gpib'], ...
            [instrRoot filesep '@visa'],...
            [instrRoot filesep '@tcpip'],...
            [instrRoot filesep '@udp'],...
            [instrRoot filesep '@instrument'],...
            [instrRoot filesep '@serial'],...
            [instrRoot filesep '@Bluetooth'],...
            [instrRoot filesep '@i2c'],...
            [instrRoot filesep '@icdevice'],...
            [instrRoot filesep '@icgroup'],...
            [instrRoot filesep '@iviconfigurationstore'],...
            [instrRoot filesep '@gpib']};
    for i = 1:length(objectPaths)
        index = strmatch(objectPaths{i}, allpaths);
        if ~isempty(index)
            pathname = allpaths{index};
            return;
        end
    end
end

% Check instrRoot\instrumentdemos
index = strmatch([instrRoot 'demos' filesep name], allpaths);
if ~isempty(index)
	pathname = allpaths{index};
	return;
end

% If serial, look into the MATLAB serial directories.
if strcmpi(path, 'serial') || isempty(path)
    % Check iofun\@serial
	index = strmatch([serialRoot filesep name], allpaths);
	if ~isempty(index)
		pathname = allpaths{index};
		return;
	end
    
    % Check iofun\@instrument.
	index = strmatch([instrRoot2 filesep name], allpaths);
	if ~isempty(index)
		pathname = allpaths{index};
		return;
	end

    % Check iofun\@icinterface.
	index = strmatch([interfaceRoot filesep name], allpaths);
	if ~isempty(index)
		pathname = allpaths{index};
		return;
	end
end

% ********************************************************************
% Find the pathname when the object directory and method are given.
function [errflag, out] = localGetPropDesc(prop, classtype)

% Initialize output.
errflag = false;
out     = '';

% Get property help. First assume it is an icinterface object.
try
    out = com.mathworks.toolbox.instrument.util.PropertyHelp.getHelp(classtype, prop);
catch
    errflag = true;
end

% Property was found.
if errflag == false
    return
end

% Reset flag.
errflag = false;

% Get property help. Assume it is a device object.
try
    out = com.mathworks.toolbox.instrument.device.util.PropertyHelp.getHelp(prop);
catch
    errflag = true;
end

