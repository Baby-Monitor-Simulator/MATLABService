function varargout = privateDeviceConstructorHelper(action, varargin)
%PRIVATEDEVICECONSTRUCTORHELPER Helper function used by icdevice constructor.
%
%   PRIVATEDEVICECONSTRUCTORHELPER helper function used by icdevice constructor.
%
%   This function should not be called directly by the user.

%   Copyright 1999-2016 The MathWorks, Inc.

switch (action)
    case 'iviParserModelFromLogical'
        [parser, model] = localParserModelFromLogical(varargin{:});
        varargout{1} = parser;
        varargout{2} = model;
    case 'iviProgramIdFromLogical'
        programid = localProgramIdFromLogicalName(varargin{:});
        varargout{1} = programid;
    case 'iviProgramIdFromUnknown'
        [parser, model] = localParserModelFromUnknown(varargin{:});
        varargout{1} = parser;
        varargout{2} = model;
    case 'ividriverTypeNIdentifierFromLogical'
        [type, identifier] = localDriverTypeNIdentifierFromLogicalName(varargin{:});
        varargout{1} = type;
        varargout{2} = identifier;
end

%-------------------------------------------------------------------------------
%
function [parser, model] = localParserModelFromUnknown(driver, varargin)

if (nargin == 1)
    interface = '';
else
    interface = varargin{1};
end

try
    [parser, model] = localParserModelFromLogical(driver);
catch myException
    model = [];
end

% ------------------------------------------------------------------------------
% 
function [parser, model] = localParserModelFromLogical(logicalname, varargin)

programid = localProgramIdFromLogicalName(logicalname);
interfacename = varargin{1};
if (isempty(programid))
    parser = [];
    model = [];
    return;
end

% ------------------------------------------------------------------------------
% 
function programid = localProgramIdFromLogicalName(logicalName)

programid = '';

try
    obj = iviconfigurationstore;
catch
    return
end

logicals = get(obj, 'LogicalNames');
logicalRef = [];

for idx = 1:length(logicals)
    if (strcmpi(logicalName, logicals(idx).Name) == 1)
        logicalRef = logicals(idx);
        break;
    end
end

if (isempty(logicalRef))
    return;
end

sessions = get(obj, 'DriverSessions');
sessionRef = [];

for idx = 1:length(sessions)
    if (strcmpi(logicalRef.Session, sessions(idx).Name) == 1)
        sessionRef = sessions(idx);
        break;
    end
end

if (isempty(sessionRef))
    error(message('instrument:privateinstr:privateDeviceConstructor:invalidLogicalName'));
end

modules = get(obj, 'SoftwareModules');
moduleRef = [];

for idx = 1:length(modules)
    if (strcmpi(sessionRef.SoftwareModule, modules(idx).Name) == 1)
        moduleRef = modules(idx);
        break;
    end
end

if (isempty(moduleRef))
    error(message('instrument:privateinstr:privateDeviceConstructor:invalidLogicalNameModule'));
end

programid = moduleRef.ProgID;


%--------------------------------------------------------------------------
%provided a logical name, retrieve the corresponding entry in the
%configstore, 
%if it is a ivi-c driver, type ='ivi-c' identifier = ivi-c driver name
function [type, identifier] = localDriverTypeNIdentifierFromLogicalName(logicalName)

type = '';
identifier ='';

try
    obj = iviconfigurationstore;
catch
    return
end

logicals = get(obj, 'LogicalNames');
logicalRef = [];

for idx = 1:length(logicals)
    if (strcmpi(logicalName, logicals(idx).Name) == 1)
        logicalRef = logicals(idx);
        break;
    end
end

if (isempty(logicalRef))
    return;
end

sessions = get(obj, 'DriverSessions');
sessionRef = [];

for idx = 1:length(sessions)
    if (strcmpi(logicalRef.Session, sessions(idx).Name) == 1)
        sessionRef = sessions(idx);
        break;
    end
end

if (isempty(sessionRef))
    error(message('instrument:privateinstr:privateDeviceConstructor:invalidLogicalName'));
end

modules = get(obj, 'SoftwareModules');
moduleRef = [];

for idx = 1:length(modules)
    if (strcmpi(sessionRef.SoftwareModule, modules(idx).Name) == 1)
        moduleRef = modules(idx);
        break;
    end
end

if (isempty(moduleRef))
    error(message('instrument:privateinstr:privateDeviceConstructor:invalidLogicalNameModule'));
end

IVIInfo = instrhwinfo('ivi');
if ismember ( moduleRef.Name, IVIInfo.Modules )
    type = 'ivi-c';
    identifier = moduleRef.Name;
end


