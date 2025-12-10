function errflag = privateIviCLoadlibrary(driverName, binary, includeFile, primaryPath, secondaryPath)
% PRIVATEIVICLOADLIBRARY is used to load IVI-C and VXIPlug&play driver's
% libraries once their respective driver libraries and headers have been
% found.

% Copyright 2013-2017 The MathWorks, Inc.

% Some drivers advertise functions in the header that are not in the actual
% library. Suppress specific warnings that may be generated because of this
s1 = warning('off', 'MATLAB:loadlibrary:functionnotfound');
s2 = warning('off', 'MATLAB:loadlibrary:typenotfound');
s3 = warning('off', 'MATLAB:loadlibrary:cppoutput');
s4 = warning('off', 'MATLAB:loadlibrary:parsewarnings');
s5 = warning('off', 'MATLAB:loadlibrary:StructTypeExists');
s6 = warning('off', 'MATLAB:loadlibrary:TypeNotFoundForStructure');

errflag = false;
lastwarn('');

try
    mPrototypeName = sprintf('MATLABPrototypeFor%s', driverName);
    if ~(isdeployed)
        % We are in interactive MATLAB mode. Generate prototype files.
        % The thunk and prototype files need to be included manually if
        % deploying the code that uses the IVI-C driver
        protoFileDir = fullfile(tempdir, 'ICTDeploymentFiles',['R' version('-release')]);
        if ~exist(protoFileDir,'dir')
            mkdir(protoFileDir);
        else
            % The ICTDeploymentFiles folder exists.
            % Check if the prototype file exists.
            if exist(fullfile(protoFileDir,sprintf('%s.m',mPrototypeName)),'file');
                try
                    % Thunk is generated on 64-bit Windows. Check if the
                    % thunk file is locked by trying to open it.
                    if strcmpi(computer,'PCWIN64')
                        thunkFile = fullfile(protoFileDir,sprintf('%s_thunk_%s.dll',driverName,lower(computer)));
                        fid = fopen(thunkFile,'w');
                        % If file is locked FID will be -1 and the fclose
                        % will throw an error
                        fclose(fid);
                    end
                catch
                    % Thunk file is locked, so create the thunk in a
                    % new sub-folder
                    [~,uniqueSubDir] = fileparts(tempname);
                    protoFileDir = fullfile(protoFileDir,uniqueSubDir);
                    mkdir(protoFileDir);
                end
            end
        end
        currentDir = cd(protoFileDir);
        if (strcmpi(computer, 'PCWIN64')) % Configuration for 64 bit loadlibrary
            newconf = mex.getCompilerConfigurations('C','Selected'); % Find the C compiler
            % Check if there is a compiler.
            if ~isempty(newconf)
                if ~isequal(newconf.Manufacturer,'GNU') % Not MINGW Compiler
                    % remove __fastcall for the user selected compiler
                    newconf.Details.CompilerFlags = [newconf.Details.CompilerFlags ' -D__fastcall='];
                    if (isempty(secondaryPath))
                        % We only need to include primaryPath entries for the
                        % driver's include file
                        [~, warninginfo] = loadlibrary(binary, includeFile, 'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'compilerconfiguration', newconf, ...
                            'mfilename', mPrototypeName);
                    else
                        % secondary path contains additional directories that may
                        % include necessary header files.
                        [~, warninginfo] = loadlibrary(binary, includeFile, 'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'includepath',char(secondaryPath(1)),  ...
                            'includepath', char(secondaryPath(2)), ...
                            'compilerconfiguration', newconf, ...
                            'mfilename', mPrototypeName);
                    end
                else
                    dynamicHeader = generateDynamicHeader(includeFile);
                    if (isempty(secondaryPath))
                        % We only need to include primaryPath entries for the
                        % driver's include file
                        [~, warninginfo] = loadlibrary(binary, dynamicHeader,...
                            'addheader',includeFile, ...
                            'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'compilerconfiguration', newconf, ...
                            'mfilename', mPrototypeName);
                    else
                        % secondary path contains additional directories that may
                        % include necessary header files.
                        [~, warninginfo] = loadlibrary(binary, dynamicHeader,...
                            'addheader',includeFile, ...
                            'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'includepath',char(secondaryPath(1)),  ...
                            'includepath', char(secondaryPath(2)), ...
                            'compilerconfiguration', newconf, ...
                            'mfilename', mPrototypeName);
                    end
                    delete(dynamicHeader);
                end
            else    % We are on 64-bit Windows with no selected compiler
                try % Try LCCWIN64.
                    dynamicHeader = generateDynamicHeader(includeFile);
                    if (isempty(secondaryPath))
                        % We only need to include primaryPath entries for the
                        % driver's include file
                        [~, warninginfo] = loadlibrary(binary, dynamicHeader, ...
                            'addheader',includeFile, ...
                            'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'mfilename', mPrototypeName, ...
                            'uselcc64');
                    else
                        % secondary path contains additional directories that may
                        % include necessary header files.
                        [~, warninginfo] = loadlibrary(binary, dynamicHeader, ...
                            'addheader', includeFile, ...
                            'alias', driverName, ...
                            'includepath', primaryPath, ...
                            'includepath', char(secondaryPath(1)), ...
                            'includepath', char(secondaryPath(2)), ...
                            'mfilename', mPrototypeName, ...
                            'uselcc64');
                    end
                catch someException
                    % LCCWIN64 failed to generate thunk. Let the user know they need to install
                    % and configure a supported compiler
                    error(message('MATLAB:mex:NoCompilerFound'));
                end
                delete(dynamicHeader);                
            end
        else % We are on a 32-bit platform
            if (isempty(secondaryPath))
                % We only need to include primaryPath entries for the
                % driver's include file
                [~, warninginfo] = loadlibrary(binary, includeFile, 'alias', driverName, ...
                    'includepath', primaryPath, ...
                    'mfilename', mPrototypeName);
            else
                % secondary path contains additional directories that may
                % include necessary header files.
                [~, warninginfo] = loadlibrary(binary, includeFile, 'alias', driverName, ...
                    'includepath', primaryPath, ...
                    'includepath', char(secondaryPath(1)), ...
                    'includepath', char(secondaryPath(2)), ...
                    'mfilename', mPrototypeName);
            end
        end
        s7 = warning('off','MATLAB:DELETE:FileNotFound');
        % Delete unnecessary intermediate files
        delete('lccstub.obj');
        delete(sprintf('%s_thunk_%s.obj', driverName, computer));
        delete(sprintf('%s_thunk_%s.exp', driverName, computer));
        delete(sprintf('%s_thunk_%s.lib', driverName, computer));
        warning(s7);
        if strfind (warninginfo, 'lcc preprocessor error')
            error(message('instrument:ivic:lccPreprocessorError'));
        end
        cd(currentDir);
    else
        % We are in deployed MATLAB mode. Check for prototype and thunk files
        if ~exist(sprintf('%s.m', mPrototypeName),'file')
            % Error for prototype files not being included
            error(message('instrument:ivic:prototypefilenotincluded'));
        end
        [~, ~] = eval(['loadlibrary(binary, @' mPrototypeName ',''alias'', driverName);']);
    end
catch e
    % Reset the warning states
    warning([s1 s2 s3 s4 s5 s6]);
    
    % Only change directories if we switched in the first place
    if exist('currentDir','var')
        cd(currentDir);
    end
    
    if strcmpi(e.identifier, 'MATLAB:mex:NoCompilerFound')
        throwAsCaller(e);
    else
        errorID = 'instrument:ivic:FailedToloadSharedLibrary';
        excp = MException(errorID, getString(message(errorID)));
        excp = excp.addCause(e);
        throwAsCaller(excp);
    end
end

% Reset the warning states
warning([s1 s2 s3 s4 s5 s6]);

[msg, id] = lastwarn;
if (~isempty(msg))
    if strcmpi(id, 'MATLAB:loadlibrary:typenotfound')
        warning(message('instrument:ivic:missinglibrarydata'));
    end
    if strcmpi(id, 'MATLAB:loadlibrary:cppoutput')
        warning(message('instrument:ivic:preprocessorerror'));
    end
end


    function dynamicHeader = generateDynamicHeader(includeFile)
        % Dynamically generate a header that has the necessary #defines
        % needed for MINGW or LCC to generate the thunk files needed by
        % LOADLIBRARY
        dynamicHeader = [tempname '.h'];
        fid = fopen(dynamicHeader,'w');
        fprintf(fid,'%s\n','#if (defined(__GNUC__) && (__GNUC__ >= 3)) || defined(__LCC__)');
        fprintf(fid,'%s\n','#define __fastcall');
        fprintf(fid,'%s\n','typedef unsigned __int64 ViUInt64;');
        fprintf(fid,'%s\n','typedef __int64 ViInt64;');
        fprintf(fid,'%s\n','#define _VI_INT64_UINT64_DEFINED');
        fprintf(fid,'%s\n','#if defined(LONG_MAX) && (LONG_MAX > 0x7FFFFFFFL)');
        fprintf(fid,'%s\n','#define _VISA_ENV_IS_64_BIT');
        fprintf(fid,'%s\n','#else');
        fprintf(fid,'%s\n','/* This is a 32-bit OS, not a 64-bit OS */');
        fprintf(fid,'%s\n','#endif');
        fprintf(fid,'%s\n','#else');
        fprintf(fid,'%s\n','/* This platform does not support 64-bit types */');
        fprintf(fid,'%s\n','#endif');
        fprintf(fid,'#include "%s"\n',includeFile);
        fclose(fid);
    end
end