classdef DriverUtility
    % DRIVERUTILITY class contains utility functions for finding and
    % parsing the MDD. It also uses the DriverLoadUtility to load the IVI-C
    % and VXI-PnP drivers using loadlibrary.

    %   Copyright 2022-2024 The MathWorks, Inc.

    properties (Constant)
        InstrumentDriverPath (1, 1) string = fullfile(matlabroot,"toolbox","instrument","instrument","drivers")
        MDDFileExtension (1, 1) string = ".mdd"
        InvalidFileNames = ["..", "."]
        ShippingInstrumentDriver (1, :) string = instrument.icdevice.internal.utility.DriverUtility.getShippingInstrumentDriverNames
    end

    methods (Static)
        function driverDetails = populateDriverDetailsFromInput(driverName, varargin)
            % Helper function that takes in all inout arguments from the
            % icdevice factory function and groups them into a
            % instrument.icdevice.internal.forms.DriverDetails class.

            arguments(Input)
                driverName (1, 1) string
            end

            arguments(Input, Repeating)
                varargin
            end

            arguments(Output)
                driverDetails (1, 1) instrument.icdevice.internal.forms.DriverDetails
            end

            driverDetails = instrument.icdevice.internal.forms.DriverDetails;

            % Note - do not put the resource name as an optional argument
            % to the input parser as this does not parse it correctly.
            % Instead use the getRsrcString() to parse through varargin and
            % get a default or passed-in resource name from varargin.
            driverDetails.DriverResourceName = parseResourceNameFromVarargin(nargin);

            % Create an input parser to parse varargin.
            parser = inputParser;
            parser.KeepUnmatched = true;

            % Driver Name is a required parameter.
            addRequired(parser, "DriverName");

            % NV Pairs
            addParameter(parser, "LegacyMode", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("LegacyMode"), @islogical);
            addParameter(parser, "OptionString", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("OptionString"), @(x) isstring(x) || ischar(x));
            addParameter(parser, "Timeout", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("Timeout"), @(x) isnumeric(x));
            addParameter(parser, "Tag", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("Tag"), @(x) isstring(x) || ischar(x));
            addParameter(parser, "UserData", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("UserData"));
            addParameter(parser, "ProductionMode", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("ProductionMode"), @islogical);
            addParameter(parser, "ObjectVisibility", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("ObjectVisibility"));
            addParameter(parser, "Name", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("Name"));
            addParameter(parser, "ConfirmationFcn", instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue("ConfirmationFcn"));

            parse(parser, driverName, varargin{2:end});
            matched = parser.Results;

            % Populate the driver name (required)
            driverDetails.DriverName = matched.DriverName;

            % Populate the supported NV pairs.
            fields = instrument.icdevice.internal.forms.DriverDetails.SupportedNVPair;
            for f = fields
                driverDetails.NVPairs.(f) = matched.(f);
            end

            % Populate the unsupported or legacy NV pairs.
            fields = instrument.icdevice.internal.forms.DriverDetails.UnsupportedNVPair;
            for f = fields
                driverDetails.NVPairsLegacy.(f) = matched.(f);
            end

            % Error for invalid NV Pairs that were passed.
            unmatchedFields = string(fieldnames(parser.Unmatched))';

            if ~isempty(unmatchedFields)
                joinedString = join(unmatchedFields, newline);
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument_icdevice:driver:invalidNVPairs", joinedString))));
            end

            %% NESTED FUNCTION
            function rsrcString = parseResourceNameFromVarargin(numInputs)
                % Parses varargin to extract the resource string, which is
                % an optional input parameter. If resource string is not
                % passed in, return a default resource string
                % (string.empty) and append the default resource string to
                % varargin. If resource string was found in varargin,
                % leave varargin unchanged and return the resource string. 

                rsrcString = string.empty;
                if numInputs == 1
                    % Add an empty resource string if none provided and
                    % append to varargin.
                    varargin{end+1} = rsrcString;
                else
                    % Insert a resource name if possible to varargin if the
                    % 2nd input argument is an NV pair name.
                    try
                        validatestring(varargin{1}, [instrument.icdevice.internal.forms.DriverDetails.SupportedNVPair, instrument.icdevice.internal.forms.DriverDetails.UnsupportedNVPair]);
                        varargin = [{rsrcString} varargin(:)'];
                    catch
                        % Possibly Resource string was passed - return the resource
                        % string.
                        rsrcString = varargin{1};
                    end
                end
            end
        end

        function parseUnmatched(driverDetails)
            % Does the following operations - 
            % 1. Shows an error for any invalid NV pair passed in.
            % 2. Shows a warning for any legacy NV pairs that are passed.

            arguments
                driverDetails (1, 1) instrument.icdevice.internal.forms.DriverDetails
            end

            % Show warning for each legacy NV pair names that are no longer
            % supported.
            unsupportedNVPairNames = instrument.icdevice.internal.forms.DriverDetails.UnsupportedNVPair;
            driverLegacyNVPairStruct = driverDetails.NVPairsLegacy;

            unsupportedNames = string.empty;
            for name = unsupportedNVPairNames
                currentValue = driverLegacyNVPairStruct.(name);
                defaultValue = instrument.icdevice.internal.forms.DriverDetails.getDefaultNVPairValue(name);
                if isequal(currentValue, defaultValue)
                    continue
                end
                % There could be a possibility that the value could be a
                % different case (upper and lower) for string values.
                isStringValued = (isstring(currentValue) || ischar(currentValue)) && (isstring(defaultValue) || ischar(defaultValue));
                
                if isStringValued && isequal(lower(currentValue), lower(defaultValue))
                    % E.g. setting the value of an NV Pair value to "On" vs
                    % "on". This should mean the same thing.
                    continue
                end
                unsupportedNames(end+1) = name;
            end

            if ~isempty(unsupportedNames)
                % Show the warning
                warnState = warning;
                backTraceVal = warning("backtrace").state;
                c = onCleanup(@()resetWarning(warnState, backTraceVal));
                warning("off", "backtrace");
                warning(message("instrument_icdevice:driver:legacyNVPairsNotSupported", join(upper(unsupportedNames), ", ")));
            end

            function resetWarning(warnState, backTraceVal)
                warning(warnState);
                warning(backTraceVal, "backtrace");
            end
        end

        function driver = readMDDFile(driverDetails)
            % Read the contents of the MDD file using the following steps -
            %
            % 1. Read the contents of the MDD as a text file.
            %
            % 2. From the contents read, replace all existing usages of
            % tokens like "&#34;" with custom tokens.
            %
            % 3. Create a temporary file in tempdir and populate it with the
            % read contents of the MDD file.
            %
            % 4. Use readstruct on this temporary file.

            arguments
                driverDetails (1, 1) instrument.icdevice.internal.forms.DriverDetails
            end

            % Read the MDD file as a text file
            fID = fopen(driverDetails.DriverFullPath, "r");
            if fID == -1
                throw(obj.getMException(MException(message("instrument_icdevice:driver:mddFileFail"))));
            end

            c = onCleanup(@()fclose(fID));
            textData = textscan(fID,"%s", "delimiter", newline);
            textData = join(string(textData{1}), newline);

            % From the contents read, replace all existing usages of
            % token like "&#34;" to a custom token.
            textData = instrument.icdevice.internal.utility.TokenReplacer. ...
                replaceTokensInMDDWithCustomTokens(textData);

            % Close the mdd file by clearing the onCleanup variable.
            clear c;

            % Create a temporary file in tempdir and populate it with the
            % read contents of the MDD file
            while true
                tempFile = string(tempname);
                tempFile = tempFile + ".xml";

                % Tempfile does not exist, it is safe to break out of the
                % loop.
                if exist(tempFile, "file") ~= 2
                    break
                end
            end
            fID = fopen(tempFile, "w");
            if fID == -1
                throw(obj.getMException(MException(message("instrument_icdevice:driver:tempFileFail"))));
            end
            c = onCleanup(@()clearTempFile(fID, tempFile));
            fprintf(fID, "%s", textData);

            % Use readstruct on this temporary file created.
            driver = readstruct(tempFile, "FileType", "xml");

            function clearTempFile(fID, tempFileName)
                fclose(fID);
                delete(tempFileName);
            end
        end

        function driverDetails = validateAndGetMDDPath(driverDetails)
            % Parse the driver name to find the driver path, driver name,
            % and extension. If the driver path does not exist, try to find
            % the driver on the MATLAB path.

            arguments
                driverDetails (1, 1) instrument.icdevice.internal.forms.DriverDetails
            end

            import instrument.icdevice.internal.utility.DriverUtility

            % Parse the driverName to see the information provided - this
            % includes the full driver path, the driver name, and the
            % driver extension.
            driverName = driverDetails.DriverName;
            [pathToDriver, driverDetails.DriverName, ext] = fileparts(driverName);

            % If the file extension was not provided in the driver name,
            % append it.
            if isempty(ext) || ext == ""
                driverName = driverName + DriverUtility.MDDFileExtension;
            elseif ext ~= DriverUtility.MDDFileExtension
                ep = instrument.icdevice.internal.mixins.base.ErrorProxyMixin;
                throw(ep.getMException(MException(message("instrument_icdevice:driver:unsupportedFileType"))));
            end

            % If the full file path was provided as part of the driverName,
            % check to see if the driver was indeed present in the location
            % specified.
            if pathToDriver ~= ""
                driverFound = driverFoundOnCustomPath(driverName);
                driverDetails.DriverFound = driverFound;
                driverDetails.DriverFullPath = driverName;
                return
            end

            % The full path of the driver was not provided. Try to find the
            % full path to the driver.
            [driverDetails.DriverFullPath, driverDetails.DriverFound] = ...
                validateDriverOnMATLABPath(driverName);

            if ~driverDetails.DriverFound
                %If no driver is found, return the default struct
                driverDetails.DriverFullPath = "";
            end

            %% NESTED FUNCTION
            function found = driverFoundOnCustomPath(driverName)
                found = exist(driverName, "file") == 2;
            end

            %% NESTED FUNCTION
            function [driverName, found] = validateDriverOnMATLABPath(driverName)
                import instrument.icdevice.internal.utility.DriverUtility

                found = true;
                driverWithPath = string(which(driverName));

                if driverWithPath ~= ""
                    % If driver is found on the MATLAB path.

                    driverName = driverWithPath;

                elseif any(driverName == DriverUtility.ShippingInstrumentDriver)
                    % If driver is one of the drivers present in the
                    % Instrument Driver folder.
                    driverName = fullfile(DriverUtility.InstrumentDriverPath, driverName);
                else
                    % Driver was not found.
                    found = false;
                end
            end
        end
        
        function instrumentType = getInstrumentType(instrumentType)
            % Converts verbose instrument type names to their corresponding
            % shorthand codes.
            switch string(instrumentType)
                case "DC Power Supply"
                    instrumentType ="dcpower";
                case "Digital Multimeter"
                    instrumentType = "multimeter";
                case "Filter"
                    instrumentType = "filter";
                case "Function Generator"
                    instrumentType = "fcngen";
                case "Oscilloscope"
                    instrumentType = "scope";
                case "Power Meter"
                    instrumentType = "pwrmeter";
                case "Pulser-Receiver"
                    instrumentType = "pulser";
                case "Spectrum Analyzer"
                    instrumentType = "specanalyzer";
                case "Switch"
                    instrumentType = "switch";
                otherwise
                    instrumentType = "unknown instrument";
            end
        end
    end

    methods (Static, Access = private)
        function names = getShippingInstrumentDriverNames()
            % Get list of driver names shipping with the ICT toolbox.

            import instrument.icdevice.internal.utility.DriverUtility
            fileNames = dir(DriverUtility.InstrumentDriverPath)';
            names = string.empty;

            for fileName = fileNames
                name = string(fileName.name);
                if any(name == DriverUtility.InvalidFileNames) || ~isMDD(name)
                    continue
                end

                names(end+1) = string(fileName.name); %#ok<*AGROW>
            end

            %% NESTED FUNCTION
            function flag = isMDD(fileName)
                % Check if the filename is an MDD.

                import instrument.icdevice.internal.utility.DriverUtility
                [~, ~, ext] = fileparts(fileName);
                flag = ext == DriverUtility.MDDFileExtension;
            end
        end
    end

    methods (Static)
        function out = checkInequality(varargin)
            out = true;
            % Get the size of the first input to compare with others.
            refSize = size(varargin{1});

            for i = 2:nargin
                obj = varargin{i};
                % Check for size mismatch.
                if ~isequal(refSize, size(obj))
                    out = false;
                    return
                end
                if ~all(eq(varargin{1}, obj))
                    out = false;
                    return
                end
            end
        end
    end

    %% PRIVATE CONSTRUCTOR
    methods (Access = private)
        function obj = DriverUtility()
        end
    end
end
