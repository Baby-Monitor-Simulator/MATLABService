classdef DriverLoadUtility
    %DRIVERLOADUTILITY contains helper functions for loading IVI-C and
    %VXI-PNP drivers using loadlibrary.

    %   Copyright 2022-2024 The MathWorks, Inc.

    methods (Static)
        function driverFound = loadVXIPnPLibrary(driver)
            arguments
                driver (1, 1) string
            end
            prefix = instrument.icdevice.internal.utility.DriverLoadUtility.getVXIPNPPath();
            binDirectory = ["bin", "Bin"];

            driverFound = instrument.icdevice.internal.utility.DriverLoadUtility. ...
                loadBinaryForIVICAndVXIPnPDrivers(driver, prefix, binDirectory);
        end

        function driverFound = loadIviCLibrary(driver)
            arguments
                driver (1, 1) string
            end

            prefix = instrument.icdevice.internal.utility.DriverLoadUtility.getIVIPath;
            binDirectory = ["Bin", "bin"];

            driverFound = instrument.icdevice.internal.utility.DriverLoadUtility. ...
                loadBinaryForIVICAndVXIPnPDrivers(driver, prefix, binDirectory);
        end
    end

    methods (Static, Access = private)
        function driverFound = loadBinaryForIVICAndVXIPnPDrivers(driver, prefix, binDirectory)
            % Prepare the inputs for a loadlibrary call and pass that along
            % to the DriverLoadUtility.driverLoadLibrary.

            arguments
                driver (1, 1) string
                prefix (1, 1) string
                binDirectory (1, 2) string
            end
            import instrument.icdevice.internal.utility.DriverLoadUtility

            fileEnd = "_64.dll";
            if computer ~= "PCWIN64"
                fileEnd = "_32.dll";
            end

            binary = fullfile(prefix, binDirectory(1), driver + fileEnd);

            % Check to see if the binary exists
            [driverFound, binary] = searchForBinaryFile(binary, prefix, binDirectory, driver);

            if ~driverFound
                return
            end

            includePath = fullfile(prefix, "include");
            includeFile = fullfile(includePath, driver + ".h");

            visaIncludePath = DriverLoadUtility.getIVIPath;

            if visaPathSameAsIVIPath(visaIncludePath)
                visaIncludePath = fullfile(visaIncludePath, "include");
            else
                visaIncludePath = localToolboxVisaPath;
            end

            if ~libisloaded(driver)
                DriverLoadUtility.driverLoadLibrary(driver, binary, includeFile, includePath, visaIncludePath);
            end

            %% NESTED FUNCTION
            function visaIncludePath = localToolboxVisaPath
                % for 64 bit support, sometimes visa.h and vpptype.h is not installed under visa\win64\include , instead
                % it is in visa\win64\agvisa\include

                visaIncludePath = {};
                visaPath = instrument.icdevice.internal.utility.DriverLoadUtility.getVXIPNPPath();

                if ~isempty(visaPath)
                    visaIncludePath(end+1) = {fullfile(visaPath, 'include')};
                    visaIncludePath(end+1) = {fullfile(visaPath, 'agvisa', 'include')};
                end
            end

            %% NESTED FUNCTION
            function flag = visaPathSameAsIVIPath(visaIncludePath)
                % Check if VISA path is the same as IVI-C path.

                flag = ~isempty(visaIncludePath) && ...
                    exist(fullfile(visaIncludePath, "include", "visa.h"), "file") == 2;
            end

            %% NESTED FUNCTION
            function [driverFound, binary] = searchForBinaryFile(binary, prefix, binDirectory, driver)
                % If file does not exist, try to find it in the default
                % IVI-C or VXI-PnP path.

                if exist(binary, "file") ~= 2
                    eof = ".dll";
                    binary = fullfile(prefix, binDirectory(2), driver + eof);
                end
                driverFound = exist(binary, "file") == 2;
            end
        end

        function p = getVXIPNPPath()
            %getVXIPNPPath Find the VXI plug&play installation directory.
            %
            %   getVXIPNPPath finds the VXI plug&play installation
            %   directory to allow access to the drivers and function
            %   panels.

            rootPath = localFindPath();
            if ~isempty(rootPath)
                p = fullfile(rootPath, localFindFramework());
            else
                p = string.empty;
            end

            function p = localFindPath()
                % See the VPP-6 VXI plug-n-play spec for the logic below.

                p = getenv("VPNPPATH");
                if ispc
                    if isempty(p)
                        try
                            p = winqueryreg("HKEY_LOCAL_MACHINE", "SOFTWARE\VXIPNP_Alliance\VXIPNP\CurrentVersion", "VXIPNPPATH");
                        catch %#ok<CTCH>
                            folderPath = "C:\VXIPNP";
                            if exist(folderPath, "dir")
                                p = folderPath;
                            end
                        end
                    end
                end

                if isempty(p)
                    p = string.empty;
                end
            end

            function p = localFindFramework()
                % Return the current platform type.

                p = "";
                if ~ispc
                    return
                end

                computerType = computer;
                if computerType == "PCWIN64"
                    p = "Win64";
                elseif computerType == "PCWIN"
                    p = "WINNT";
                end
            end

        end

        function p = getIVIPath()
            %getIVIPath Find the IVI-C driver installation directory.
            %
            %   D = getIVIPath returns the IVI-C driver installation
            %   directory to allow access to the drivers and function
            %   panels.
            %
            %   If the IVI shared components have not been properly
            %   installed, D will be an empty string.
            %

            persistent ivicpath

            if isempty(ivicpath)
                try
                    ivicpath = string(winqueryreg("HKEY_LOCAL_MACHINE", "SOFTWARE\IVI\", "IVIStandardRootDir"));
                catch
                    ivicpath = string.empty;
                end
            end

            p = ivicpath;
        end

        function driverLoadLibrary(driverName, binary, includeFile, primaryPath, secondaryPath)
            % driverLoadLibrary is used to load IVI-C and VXIPlug&play
            % driver"s libraries once their respective driver libraries and
            % headers have been found.

            % Some drivers advertise functions in the header that are not
            % in the actual library. Suppress specific warnings that may be
            % generated because of this.

            import instrument.icdevice.internal.utility.WarningUtility
            %Restore warning state when execution is complete.
            warnState = warning;
            c = onCleanup(@()WarningUtility.cleanupEndMethod(warnState));

            s1 = warning("off", "MATLAB:loadlibrary:functionnotfound");
            s2 = warning("off", "MATLAB:loadlibrary:typenotfound");
            s3 = warning("off", "MATLAB:loadlibrary:cppoutput");
            s4 = warning("off", "MATLAB:loadlibrary:parsewarnings");
            s5 = warning("off", "MATLAB:loadlibrary:StructTypeExists");
            s6 = warning("off", "MATLAB:loadlibrary:TypeNotFoundForStructure");

            lastwarn("");
            secondaryPath = cellstr(secondaryPath);
            try
                mPrototypeName = "MATLABPrototypeFor" + driverName;
                if ~isdeployed
                    % We are in interactive MATLAB mode. Generate prototype
                    % files. The thunk and prototype files need to be
                    % included manually if deploying the code that uses the
                    % IVI-C driver
                    protoFileDir = fullfile(tempdir, "ICTDeploymentFiles", "R" + version("-release"));
                    if ~exist(protoFileDir,"dir")
                        mkdir(protoFileDir);
                    else
                        % The ICTDeploymentFiles folder exists. Check if
                        % the prototype file exists.
                        if exist(fullfile(protoFileDir, mPrototypeName + ".m"), "file")
                            try
                                % Thunk is generated on 64-bit Windows.
                                % Check if the thunk file is locked by
                                % trying to open it.
                                if computer == "PCWIN64"

                                    thunkFile = fullfile(protoFileDir, driverName + "_thunk_" + lower(computer) + "s.dll");
                                    fid = fopen(thunkFile,"w");
                                    % If file is locked FID will be -1 and
                                    % the fclose will throw an error
                                    fclose(fid);
                                end
                            catch
                                % Thunk file is locked, so create the thunk
                                % in a new sub-folder
                                [~,uniqueSubDir] = fileparts(tempname);
                                protoFileDir = fullfile(protoFileDir,uniqueSubDir);
                                mkdir(protoFileDir);
                            end
                        end
                    end
                    currentDir = cd(protoFileDir);
                    if computer == "PCWIN64" % Configuration for 64 bit loadlibrary
                        newconf = mex.getCompilerConfigurations("C", "Selected"); % Find the C compiler

                        % Check if there is a compiler.
                        if ~isempty(newconf)
                            if newconf.Manufacturer ~= "GNU" % Not MINGW Compiler

                                % remove __fastcall for the user selected
                                % compiler
                                newconf.Details.CompilerFlags = newconf.Details.CompilerFlags + " -D__fastcall=";
                                if isempty(secondaryPath)

                                    % We only need to include primaryPath
                                    % entries for the driver's include file
                                    [~, warninginfo] = loadlibrary(binary, includeFile, "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "compilerconfiguration", newconf, ...
                                        "mfilename", mPrototypeName);
                                else
                                    % secondary path contains additional
                                    % directories that may include
                                    % necessary header files.
                                    [~, warninginfo] = loadlibrary(binary, includeFile, "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "includepath",char(secondaryPath(1)),  ...
                                        "includepath", char(secondaryPath(2)), ...
                                        "compilerconfiguration", newconf, ...
                                        "mfilename", mPrototypeName);
                                end
                            else
                                dynamicHeader = generateDynamicHeader(includeFile);
                                if isempty(secondaryPath)
                                    % We only need to include primaryPath
                                    % entries for the driver's include file
                                    [~, warninginfo] = loadlibrary(binary, dynamicHeader,...
                                        "addheader",includeFile, ...
                                        "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "compilerconfiguration", newconf, ...
                                        "mfilename", mPrototypeName);
                                else
                                    % secondary path contains additional
                                    % directories that may include
                                    % necessary header files.
                                    [~, warninginfo] = loadlibrary(binary, dynamicHeader,...
                                        "addheader",includeFile, ...
                                        "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "includepath",char(secondaryPath(1)),  ...
                                        "includepath", char(secondaryPath(2)), ...
                                        "compilerconfiguration", newconf, ...
                                        "mfilename", mPrototypeName);
                                end
                                delete(dynamicHeader);
                            end
                        else    % We are on 64-bit Windows with no selected compiler
                            try % Try LCCWIN64.
                                dynamicHeader = generateDynamicHeader(includeFile);
                                if isempty(secondaryPath)
                                    % We only need to include primaryPath
                                    % entries for the driver's include file
                                    [~, warninginfo] = loadlibrary(binary, dynamicHeader, ...
                                        "addheader",includeFile, ...
                                        "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "mfilename", mPrototypeName, ...
                                        "uselcc64");
                                else
                                    % secondary path contains additional
                                    % directories that may include
                                    % necessary header files.
                                    [~, warninginfo] = loadlibrary(binary, dynamicHeader, ...
                                        "addheader", includeFile, ...
                                        "alias", driverName, ...
                                        "includepath", primaryPath, ...
                                        "includepath", char(secondaryPath(1)), ...
                                        "includepath", char(secondaryPath(2)), ...
                                        "mfilename", mPrototypeName, ...
                                        "uselcc64");
                                end
                            catch someException
                                % LCCWIN64 failed to generate thunk. Let
                                % the user know they need to install and
                                % configure a supported compiler
                                throw(obj.getMException(MException(message("MATLAB:mex:NoCompilerFound"))));
                            end
                            delete(dynamicHeader);
                        end
                    else % We are on a 32-bit platform
                        if isempty(secondaryPath)
                            % We only need to include primaryPath entries
                            % for the driver"s include file
                            [~, warninginfo] = loadlibrary(binary, includeFile, "alias", driverName, ...
                                "includepath", primaryPath, ...
                                "mfilename", mPrototypeName);
                        else
                            % secondary path contains additional
                            % directories that may include necessary header
                            % files.
                            [~, warninginfo] = loadlibrary(binary, includeFile, "alias", driverName, ...
                                "includepath", primaryPath, ...
                                "includepath", char(secondaryPath(1)), ...
                                "includepath", char(secondaryPath(2)), ...
                                "mfilename", mPrototypeName);
                        end
                    end

                    s7 = warning("off","MATLAB:DELETE:FileNotFound");

                    % Delete unnecessary intermediate files
                    delete("lccstub.obj");
                    fileExtensions = ["obj", "exp", "lib"];
                    for fileExt = fileExtensions
                        delete(driverName + "_thunk_" + computer + "." + fileExt);
                    end
                    warning(s7);

                    if contains(warninginfo, "lcc preprocessor error")
                        throw(obj.getMException(MException(message("instrument:ivic:lccPreprocessorError"))));
                    end
                    cd(currentDir);
                else
                    % We are in deployed MATLAB mode. Check for prototype
                    % and thunk files
                    if ~exist(sprintf('%s.m', mPrototypeName),'file')
                        % Error for prototype files not being included
                        throw(obj.getMException(MException(message('instrument:ivic:prototypefilenotincluded'))));
                    end
                    loadLibraryEvalText = "loadlibrary(binary, @" + mPrototypeName + ", 'alias', driverName);";
                    [~, ~] = eval(loadLibraryEvalText);
                end
            catch e
                % Only change directories if we switched in the first place
                if exist(currentDir, "var")
                    cd(currentDir);
                end

                if e.identifier == "MATLAB:mex:NoCompilerFound"
                    throwAsCaller(e);
                else
                    errorID = "instrument:ivic:FailedToloadSharedLibrary";
                    excp = MException(message(errorID));
                    excp = excp.addCause(e);
                    throwAsCaller(excp);
                end
            end

            % Reset the warning states
            warning([s1 s2 s3 s4 s5 s6]);

            [msg, id] = lastwarn;
            if ~isempty(msg)
                if id == "MATLAB:loadlibrary:typenotfound"
                    warning(message("instrument:ivic:missinglibrarydata"));
                end
                if id == "MATLAB:loadlibrary:cppoutput"
                    warning(message("instrument:ivic:preprocessorerror"));
                end
            end

            %% NESTED FUNCTION
            function dynamicHeader = generateDynamicHeader(includeFile)
                % Dynamically generate a header that has the necessary
                % #defines needed for MINGW or LCC to generate the thunk
                % files needed by LOADLIBRARY
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
    end
end
