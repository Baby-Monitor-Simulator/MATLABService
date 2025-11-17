function varargout = makemid(driver, varargin)
% MAKEMID Convert a driver to MATLAB instrument driver format.
%
%   MAKEMID will be removed in a future release. There is no simple
%   replacement for this.
%
%   MAKEMID('DRIVER') searches through known driver types for DRIVER and
%   creates a MATLAB instrument driver representation of the driver. For
%   driver you can use a Module (for IVI-C), a LogicalName (for IVI-C), or 
%   the original VXIplug&play instrument driver name. The MATLAB instrument
%   driver will be saved in the current working directory as DRIVER.MDD
%
%   The MATLAB instrument driver can then be modified using MIDEDIT to 
%   customize the  driver behavior, and may be used to instantiate a device
%   object using ICDEVICE.
%
%   MAKEMID('DRIVER', 'FILENAME') saves the newly created MATLAB instrument
%   driver using the name and path specified by FILENAME.
% 
%   MAKEMID('DRIVER', 'TYPE') and MAKEMID('DRIVER', 'FILENAME', 'TYPE') 
%   override the default search order and only look for drivers of type 
%   TYPE. Valid types are vxiplug&play and ivi-c.
%
%    Examples:
%        makemid('hp34401');
%        makemid('tktds5k', 'C:\MyDrivers\tektronix_5k.mdd');
%        makemid('tktds5k', 'ivi-c');
%        makemid('MyIviLogicalName');
%
%    See also ICDEVICE.

%   Copyright 1999-2021 The MathWorks, Inc.

try
    instrument.internal.ICTRemoveFunctionalityHelper(mfilename, "Warn", "Function");
catch ex
    throwAsCaller(ex);
end

% convert to char in order to accept string datatype
driver = instrument.internal.stringConversionHelpers.str2char(driver);
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

narginchk(1,4)

if (~ischar(driver))
    error(message('instrument:makemid:conversionError', 'DRIVER'));
end

interface  = '';
drivertype = '';

switch nargin
    case 1      
        filename = localValidateExtension(fullfile(pwd, driver));
    case 2
        if (~ischar(varargin{1}))
            error(message('instrument:makemid:conversionError', 'TYPE'));
        end
        
        if (localIsDriverType(varargin{1}))
            filename = localValidateExtension(fullfile(pwd, driver));
            drivertype = varargin{1};
        else
            filename = localValidateExtension(varargin{1});
        end
    case 3
        if (~ischar(varargin{1}))
            error(message('instrument:makemid:conversionError', 'TYPE or FILENAME'));
        end
        
        if (~ischar(varargin{2}))
            error(message('instrument:makemid:conversionError', 'TYPE or INTERFACE'));
        end
        
        if (localIsDriverType(varargin{2}))
            filename = localValidateExtension(varargin{1});
            drivertype = varargin{2};
        else
            drivertype = varargin{1};
            interface = varargin{2};
            filename = localValidateExtension(fullfile(pwd, driver));
        end
    case 4
        if (~ischar(varargin{1}))
            error(message('instrument:makemid:conversionError', 'FILENAME'));
        end
        
        if (~ischar(varargin{3}))
            error(message('instrument:makemid:conversionError', 'INTERFACE'));
        end
        
        filename = localValidateExtension(varargin{1});
        drivertype = varargin{2};
        interface = varargin{3};
end

% Verify the specified path is not a directory.

if (exist(filename, 'dir'))
    error(message('instrument:makemid:conversionErrorDir'));
end

% Verify the interface name is only defined for IVI-COM drivers.

if (~isempty(interface) && ~isempty(drivertype) && ~strcmpi(drivertype, 'ivi-com'))
     error(message('instrument:makemid:conversionErrorInterface'));
end

model = [];

% Attempt to create a DriverModel based on the specified driver type, or the
% driver that is found.

try
    if (~isempty(drivertype))
        switch lower(drivertype)
            case 'vxiplug&play'
                model = localConvertFromVxi(driver);
            case 'ivi-c'
                model = localConvertFromIviC(driver);
            case 'ivi-com'
                error(message('instrument:makemid:no64bitMATLABSupport')); 
        end
    else
        % Is this an IVI-C driver?        
        if isempty(model)
            model = localConvertFromIviC(driver);
        end
        % Is this an VXIPnP driver?
        if isempty(model)
            model = localConvertFromVxi(driver);
        end
    end
catch aException
    newExc =  MException('instrument:makemid:conversionError' ,aException.message );
    throw (newExc);
end

if (isempty(model))
    error(message('instrument:makemid:conversionErrorLoad'));
end

% Attempt to write the driver data.

try
    writer = com.mathworks.toolbox.instrument.device.guiutil.midtool.DriverFileWriter(model);

    % Throws TMException with appropriate error if it fails.
    writer.writeXML(filename, pwd);
catch aException
    % Better error formatting if we don't simply allow the exception through.
    newExc =  MException('instrument:makemid:conversionError' ,aException.message );
    throw (newExc);
end

if nargout
    varargout{1} = model;
end

%-------------------------------------------------------------------------------
% Enforce the .mdd extension if necessary.  Append if no extension.
%
function str = localValidateExtension(str)

if (length(str) < 5)
    return;
end

idx = strfind(str, '.');

if (~isempty(idx))
    str(idx(end):end) = '';
end

str = [str '.mdd'];

%-------------------------------------------------------------------------------
%
function isdrivertype = localIsDriverType(str)

isdrivertype =  any(strcmpi(str, {'vxiplug&play','ivi-c'}));

%-------------------------------------------------------------------------------
%
function model = localConvertFromVxi(driver)
import com.mathworks.toolbox.instrument.device.drivers.vxipnp.VXIPnPLoader;

model = [];

prefix = instrgate('privateGetVXIPNPPath');

if (isempty(prefix))
    return
end;

frontPanelFile = fullfile(prefix, driver, [driver '.fp']);

if (exist(frontPanelFile, 'file'))
    model = VXIPnPLoader.toDriverModel(frontPanelFile, false);
end

%-------------------------------------------------------------------------------
%
function model = localConvertFromIviC(driver)

import com.mathworks.toolbox.instrument.device.drivers.vxipnp.VXIPnPLoader;

model = [];
logicalName ='';

% if driver is a logical ivi-c driver name, convert it to a driver name
isLogicalName = localCheckIsLogicalName(driver);
if  isLogicalName
    logicalName = driver;
    [type, identifier] = instrgate('privateDeviceConstructorHelper', ...
        'ividriverTypeNIdentifierFromLogical', driver);
    if strcmp (type, 'ivi-c')
        driver = identifier;
    end
end
frontPanelFile = instrgate('privateGetIviCDriverName', driver);
if (~isempty(frontPanelFile))
     model = VXIPnPLoader.toDriverModel(frontPanelFile, true);
end

% update driver name to store info needed in icdevice
if (isLogicalName)
    model.setDriverName(logicalName);
end
         
%-----------------------------------------------------------------------
% check if driver name is in the configstore
function isLogicalName =  localCheckIsLogicalName (driverName)
IVIInfo = instrhwinfo('ivi');
isLogicalName = ismember (driverName, IVIInfo.LogicalNames );

