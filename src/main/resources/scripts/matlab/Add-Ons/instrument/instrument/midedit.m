function midedit(varargin)
%MIDEDIT Edit MATLAB Instrument Driver file.
%
%   MIDEDIT DRIVER opens the file DRIVER.MDD in the MATLAB Instrument 
%   Driver Editor. DRIVER must be the name of a MATLAB Instrument Driver 
%   file or a MATLABPATH relative partial pathname (see PARTIALPATH).
% 
%   MIDEDIT FILE.EXT attempts to open the specified file as a MATLAB
%   Instrument Driver file.
% 
%   MIDEDIT, by itself, opens up a new driver editor window.
%
%   MIDEDIT may also be used to import VXIplug&play drivers. With MIDEDIT
%   open, select "Import..." from the File menu. The import process creates
%   a new MATLAB Instrument Driver based on the VXIplug&play driver. This
%   allows you to customize the behavior of device objects that use this
%   VXIplug&play driver.
%

%   Copyright 1999-2024 The MathWorks, Inc.

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

try
    if (nargin > 0)
        filename = varargin{1};
        
        if isempty(filename) || ~ischar(filename)
            error(message('instrument:midedit:invalidArgString'));
        end
        
        filename = strtrim(filename);
        
        if (isDirectory(filename) && hasExtension(filename))
            error(message('instrument:midedit:invalidArgDir', filename));
        end
        
        % Check if it is the fully-specified name.
        
        if ~openSpecifiedFile(filename)
            
            % Look for the file on the MATLAB path.
            
            fullname = which(filename);
            where = exist(filename, 'file');
            
            % Try with .mdd if there is no extension.
            if (isempty(fullname) && ~hasExtension(filename))
                fullname = which([filename '.mdd']);
            elseif (~isempty(fullname) && hasExtension(fullname))
                [unused1, unused2, ext] = fileparts(fullname);
                    if (strcmpi(ext(2:end), 'mdd') ~= 1)
                        error(message('instrument:midedit:invalidArgExtension', ext( 2:end ), fullname));
                    end
            end
            
            % If which returned a name, open it if it is a file, otherwise error
            % appropriately.
            if (~isempty(fullname))
                if (where == 2)
                    openEditor(fullname);
                elseif (where == 7)
                    error(message('instrument:midedit:invalidArgDir', fullname));
                else
                    % This shouldn't happen.
                    fileNotFoundError(filename);
                end
            else
                % Lastly, look in the toolbox/instrument/instrument/drivers
                % directory.  Assume everything in this directory is .mdd
                if (~hasExtension(filename))
                    filename = [filename '.mdd'];
                end
                
                driverName = [matlabroot filesep 'toolbox' filesep 'instrument' filesep 'instrument' filesep 'drivers' filesep filename];
                where = exist(driverName, 'file');
                
                if (where == 2)
                    openEditor(driverName);
                else
                    % Every attempt has failed.  Depending on the user
                    % preferences, either offer a dialog to create the
                    % file, create the file, return or error.
                    if (isSimpleFile(filename))
                        com.mathworks.toolbox.instrument.device.guiutil.midtool.MIDTool.openDocument(filename, true);
                    else
                        fileNotFoundError(filename);
                    end
                end
            end
        end
    else
        openEditor('');
    end
catch aException
    rethrow(aException)
end

% ------------------------------------------------------------------------------
% openEditor
% ------------------------------------------------------------------------------
function openEditor(driver)

if (isempty(driver))
    com.mathworks.toolbox.instrument.device.guiutil.midtool.MIDTool.newDocument(pwd);
else
    com.mathworks.toolbox.instrument.device.guiutil.midtool.MIDTool.openDocument(driver);
end

% ------------------------------------------------------------------------------
% openSpecifiedFile
% ------------------------------------------------------------------------------
function result = openSpecifiedFile(file)

result = false;

fullPathName = file;

if ~hasExtension(fullPathName)
    fullPathName = [fullPathName '.mdd'];
end

A = dir(fullPathName);

if ~isempty(A)
    % If it is not empty, we have already checked that it is not a directory. We
    % will try to open it.
    if (isSimpleFile(file))
        fullPathName = [pwd filesep A.name];
    end
    
    openEditor(fullPathName);
    
    result = true;
end
    
% ------------------------------------------------------------------------------
% isDirectory
% ------------------------------------------------------------------------------
function result = isDirectory(file)

result = false;

A = dir(file);

if ~isempty(A)
    if ((numel(A) > 1) || (A.isdir == 1))
        result = true; 
    end
end


% ------------------------------------------------------------------------------
% isSimpleFile
% ------------------------------------------------------------------------------
function result = isSimpleFile(file)

result = false;

if isunix
    if isempty(findstr(file, '/'))
        result = true;
    end
else
    if isempty(findstr(file, '\')) && isempty(findstr(file, '/'))...
        && isempty(findstr(file, ':')) % need to keep : for c: case
        result = true;
    end
end

% ------------------------------------------------------------------------------
% hasExtension
% ------------------------------------------------------------------------------
function result = hasExtension(file)

result = true;

[unused1, unused2, ext] = fileparts(file);

if (isempty(ext))
   result = false;
end   

% ------------------------------------------------------------------------------
% fileNotFoundError
% ------------------------------------------------------------------------------
function fileNotFoundError(file)

if (hasExtension(file))
    error(message('instrument:midedit:invalidArgDNE', file));
else
    error(message('instrument:midedit:invalidArgExtDNE', file, [ file, '.mdd' ]));
end

