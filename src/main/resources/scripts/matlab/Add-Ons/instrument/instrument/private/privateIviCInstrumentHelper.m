function out = privateIviCInstrumentHelper(action, varargin)
%PrivateIviCInstrumentHelper function for working with MATLAB Class Wrappers.
%
%   PrivateIviCInstrumentHelper function used by the Test and Measurement
%   Tool to work with Ivi-C class compliant wrappers such as:

%       Create an IVI-C class compliant wrapper object.
%       Connect/disconnect the instrument
%       Exercise IVI-C class compliant wrapper object's properties and methods.
%
%   This function should not be called directly by the user.
%
%   Copyright 2011-2020 The MathWorks, Inc.


switch action
    case 'create'
        out = localCreateObject(varargin{:});
      
    case 'executeFunction'
        out = localExecuteFunction(varargin{:});
    case 'checkNICPInstallation'
        out = localCheckNICP();
    case 'connect'
        out = localConnect(varargin{:});
    case 'connectWithLogicalName'
        out = localConnectWithLogcialName(varargin{:});
    case 'disconnect'
        out = localDisconnect(varargin{:});
    case 'find_IviCDrivers'
        out = localGetIviCDrivers(varargin{:});
    otherwise
        error (message('instrument:ivic:notSupported'));
end
end

%% helper function to create an Ivi-C instrument object, if wrapper structure
% is needed, create a XML string representation and return to Java side
function out = localCreateObject(varargin)
out ={};
out{1}= 'yes';
instrumentType = varargin{1};
try
    out{end+1} = {eval(['instrument.ivic.',instrumentType] )};
catch e
    out{1}= 'no';
    return;
end

if varargin{2}
    out{end+1} = instrument.ivic.buildIviCWrapperXML(instrumentType);
    
end
end


function out = localCheckNICP()
out = 'NICPInstalled';
try
    instrgate ('privateCheckNICPVersion');
catch e
    out = 'noNICPInstalled';
end
end
 

%% Helper function to connect instrument. It creates temporary logical name, session and hardware asset
%%in IVI configuration store using driver name and resource string. Those entries need to be returned
%%so later on can be cleaned up.
function [out ,hardwareAsset, session, logicalName] = localConnect(varargin)

% Parse input.
objRef    = varargin{1};
objName =  varargin{2};
driverName  = varargin{3};
resource = varargin{4};
simulate = varargin{5};

hardwareAsset = '';
session = '';
logicalName = '';

% Assign the ivi-c instrument object and evaluate the code.
try
    eval([objName '=  objRef;']);
    % create temp logical name
    tmp_nam = tempname ;
    [~, name, ~] = fileparts(tmp_nam) ;
    
    % unique names for hwAsset, session and logical name
    hardwareAsset = sprintf('%s%s_HardwareAsset', name, driverName);
    session = sprintf('%s%s_Session', name, driverName);
    logicalName = sprintf('%s_%s', name, driverName);
    
    %create temporary configuration store entries used
    %by connect () method
    instrument.internal.udm.ConfigStoreUtility.addLogicalName(  hardwareAsset, resource ,  session, driverName, logicalName);

    
    % connect in real mode
    if ~simulate  
        eval ([objName , '.init(''' logicalName  ''',false, false);']);
    else  % simulation mode
        eval ([objName , '.initWithOption(''' logicalName  ''',false, false , ''simulate=true'');']);
    end
catch e
    
    instrument.internal.udm.ConfigStoreUtility.removeLogicalName(hardwareAsset, session,logicalName);
    out = ['<p>Can not connect to the instrument.</p><p>' e.message '</p>'];
    out = {'disconnected', out};
    return;
end
out = {'connected'};
out{end+1} = hardwareAsset;
out{end+1} = session;
out{end+1} = logicalName;

end


%% helper function to connect to the Ivi-c Instrument using existing logical name
function [out ] = localConnectWithLogcialName(varargin)

% Parse input.
objRef    = varargin{1}; %#ok<NASGU>
objName =  varargin{2};
logicalName  = varargin{3};
simulate = varargin{4};

% Assign the ivi- c instrument object and evaluate the code.
try
    eval([objName '=  objRef;']);
    % connect in real mode
    if ~simulate  
        eval ([objName , '.init(''' logicalName  ''',false, false);']);
    else  % simulation mode
        eval ([objName , '.initWithOption(''' logicalName  ''',false, false , ''simulate=true'');']);
    end
catch aException
    out = ['<p>Can not connect to the instrument.</p><p>' aException.message '</p>'];
    out = {'disconnected', out};
    return;
end
out = {'connected'};
end

 


%% helper function to disconnect the instrument
function out = localDisconnect(varargin)

% Parse input.
objRef    = varargin{1}; %#ok<NASGU>
objName =  varargin{2};

% Assign the device object and evaluate the code.
try
    eval([objName '=  objRef;']);
    
    eval([objName '.close']);
catch aException
    out = ['<p>Can not disconnect to the instrument.</p><p>' aException.message '</p>'];
    out = {'connected', out};
    return;
end
out = {'disconnected'};

end


%% helper function to execute the method sent from java side
function out = localExecuteFunction(varargin)

try
    
    % Parse input.
    objRef    = varargin{1};
    objName =  varargin{2};
    code   = varargin{3};
    output = varargin{4};
    
    % Assign the device object and evaluate the code.
    try
        eval([objName '=  objRef;']);
        eval(code);
    catch aException
        out = ['<p>An error occurred while executing the function.</p><p>' aException.message '</p>'];
        out = {out, 'no', aException.message};
        return;
    end
    
    % There are no output arguments so return a success message.
    if strcmp(output, '')
        out = '<p>Function completed successfully.</p>';
        out = {out, 'no'};
        return;
    end
    
    % There are output arguments. Return information on output arguments.
    result = '<p>Function completed successfully.</p>';
    
    % Get a list of output arguments.
    output     = strrep(output, ' ', '');
    indices    = strfind(output, ',');
    args       = cell(1, length(indices)+1);
    startIndex = 1;
    
    for i = 1:length(indices)
        args{i} = output(startIndex:indices(i)-1);
        startIndex = indices(i)+1;
    end
    
    args{end} = output(startIndex:end);
    
    % Create the display for the output arguments.
    for i = 1:length(args)
        temp = eval(args{i});
        if isnumeric(temp)
            if (numel(temp) == 1)
                result = [result '<p>' args{i} ': ' num2str(temp) '</p>']; %#ok<AGROW>
            else
                [sizeoutputr sizeoutputc] = size(temp);
                result = [result '<p>' args{i} ': &lt;' num2str(sizeoutputr) 'x' num2str(sizeoutputc) ' double&gt;</p>']; %#ok<AGROW>
            end
        elseif islogical(temp)
            temp = double(temp);
            result = [result '<p>' args{i} ': ' num2str(temp) '</p>']; %#ok<AGROW>
        elseif isobject(temp)
            txt = evalc ('disp(temp);');
            result = [result '<p>' args{i} ': ' txt  '</p>'];                 %#ok<AGROW>
        elseif iscell(temp)
            valueStr =  sprintf('<%dx%d> cell',size(temp , 1), size (temp, 2));
            
            result = [result '<p>' args{i} ': ' valueStr '</p>']; %#ok<AGROW>
        else
            result = [result '<p>' args{i} ': ' temp '</p>']; %#ok<AGROW>
        end
    end
    
    resultData = cell(1, length(args));
    for i = 1:length(resultData)
        eval(['resultData{i} = ' args{i} ';']);
    end
    
    % Return the result.
    out = {result, 'yes', resultData, args};
catch aException
    out = ['<p>An error occurred while executing the function.</p><p>' aException.message '</p>'];
    out = {out, 'no',aException.message };
end

end


