classdef WriteController < matlabshared.transportapp.internal.toolstrip.write.Controller
    %WRITECONTROLLER Controller class for VISA Explorer toolstrip Write
    %section. Extends Shared Transport App write.Constroller class to
    %handle writeread and binblock operations.

    % Copyright 2022-2023 The MathWorks, Inc.

    properties(Constant, Access = private)
        WriteReadType = "WriteRead"
        WriteBinBlockType = "WriteBinblock"
        BinblockTag = "Binblock"
    end

    properties(SetObservable)
        % Publish WriteReadButton state
        WriteReadButtonPressed (1, 1) logical = false
    end

    methods
        function subscribeToMediatorProperties(obj, varargin)
            subscribeToMediatorProperties@matlabshared.transportapp.internal.toolstrip.write.Controller(obj, varargin{:});

            % Enable WriteRead and Write buttons when WriteRead or Write operation completes
            obj.subscribe("QueryComplete", ...
                @(src,evt) obj.handleWriteSectionButtonState(true));

            obj.subscribe("WriteComplete", ...
                @(src,evt) obj.handleWriteSectionButtonState(true));

            % Handle Write button and WriteRead button state while Read
            % operation is active.
            obj.subscribe("ReadButtonPressed", ...
                @(src,evt) obj.handleWriteSectionButtonState(false));

            obj.subscribe("ReadComplete", ...
                @(src,evt) obj.handleWriteSectionButtonState(true));
        end
    end

    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function setupListeners(obj)
            setupListeners@matlabshared.transportapp.internal.toolstrip.write.Controller(obj);

            % Add listener for WriteRead Button pushed event.
            obj.ViewListeners(end+1) = listener(obj.View, "WriteReadButtonPressed", ...
                @(src,evt)obj.writeReadButtonPressed(src,evt));
        end
    end

    %% Override methods from Shared_App Write Controller
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function dataFormatValueChanged(obj, src, evt)
            obj.ViewConfiguration.setViewProperty("HeaderEditField", "Enabled", ...
                string(evt.Data) == obj.BinblockTag);
            dataFormatValueChanged@matlabshared.transportapp.internal.toolstrip.write.Controller(obj, src, evt);
        end

        function val = getTransportData(obj, type, data, dataTypeValue)
            val = getTransportData@matlabshared.transportapp.internal.toolstrip.write.Controller ...
                (obj, type, data, dataTypeValue);

            if obj.ViewConfiguration.getViewProperty("DataFormat", "Value") == obj.BinblockTag
                % Check for the binblock custom header.
                %
                % Error Conditions for the Custom Header
                % Error if the header -
                % 1. Begins with and ends with double quotes, or
                % 2. Begins with and ends with single quotes, or
                % 3. Has a mix of single and double quotes

                headerVal = string(obj.ViewConfiguration.getViewProperty("HeaderEditField", "Value"));
                if beginsAndEndsWithQuotes(obj, headerVal)
                    throwAsCaller(MException(message("transportapp:visadevapp:NoSurroundingQuotesInCustomHeader")));
                end

                if containsMixedQuotes(obj, headerVal)
                    throwAsCaller(MException(message("transportapp:visadevapp:CustomHeaderSingleDoubleQuotesMixed")));
                end

                val.UserData.Header = headerVal;
            end

            %% NESTED FUNCTION
            function flag = beginsAndEndsWithQuotes(~, headerVal)
                flag = (startsWith(headerVal, "'") && endsWith(headerVal, "'")) || ...
                    (startsWith(headerVal, """") && endsWith(headerVal, """"));
            end

            %% NESTED FUNCTION
            function flag = containsMixedQuotes(~, headerVal)
                flag = contains(headerVal, "'") && contains(headerVal, """");
            end
        end

        % Override Write Button callback to disable WriteRead button
        function writeButtonPressed(obj, varargin)
            % Disable WriteRead button while write is processed
            obj.handleWriteReadButtonState(false);

            % Process write
            writeButtonPressed@matlabshared.transportapp.internal.toolstrip.write.Controller(obj, varargin{:});

            if obj.ViewConfiguration.getViewProperty("WriteButton", "Enabled")
                % Enable WriteRead button if Write button was enabled (eg.
                % write operation errored)
                obj.handleWriteReadButtonState(true);
            end
        end

        function consts = getConstants(~)
            consts = transportapp.visadev.internal.toolstrip.WriteConstants;
        end

        % Override function to handle Binblock format
        function type = getWriteType(obj)
            % Derive the Write Type based on the Data Format dropdown
            % value.

            dataFormatValue = string(obj.ViewConfiguration.getViewProperty("DataFormat", "Value"));
            if dataFormatValue == obj.DataFormatDropDownOptions(3) % BinBlock
                type = obj.WriteBinBlockType;
            else
                % Use shared_app function for shared write types
                type = getWriteType@matlabshared.transportapp.internal.toolstrip.write.Controller(obj);
            end
        end

        % Override function to handle Binblock format
        function precision = getPrecisionForDropDownOption(obj, dataFormat)
            % Return precision values for the dropdown based on the
            % dataformat value.

            if dataFormat == obj.DataFormatDropDownOptions(3) % Binblock
                precision = obj.Constants.AllPrecision;
            else
                % Use shared_app function for shared write types
                precision = ...
                    getPrecisionForDropDownOption@matlabshared.transportapp.internal.toolstrip.write.Controller(obj, dataFormat);
            end
        end

        % Override function to handle WriteRead operations
        function flag = needDoubleQuotesAroundData(obj, action, precision)
            if action == obj.WriteReadType
                % WriteRead should always be treated as a String value and will
                % need surrounding double quotes
                flag = true;
            elseif action == obj.WriteBinBlockType
                % If performing binblock write and the precision is an
                % ASCII type or failed to evaluate to a valid numeric
                % value, send data with quotes
                asciiPrecision = precision == "char" || precision == "string";
                flag = asciiPrecision || ~obj.ValidNumericDataEval;
            else
                % Use shared_app function to handle shared cases
                flag = ...
                    needDoubleQuotesAroundData@matlabshared.transportapp.internal.toolstrip.write.Controller(obj, action, precision);
            end
        end

        % Override function to handle Binblock format
        function populateWorkspaceVariableList(obj, varList)
            % Populate the Workspace Variable Dropdown list with a list of
            % valid variable names.

            arguments
                obj matlabshared.transportapp.internal.toolstrip.write.Controller
                varList matlabshared.transportapp.internal.utilities.forms.WorkspaceVariableInfo
            end

            import matlabshared.transportapp.internal.utilities.forms.WorkspaceTypeEnum
            for var = varList

                switch var.Type
                    case WorkspaceTypeEnum.Numeric

                        % Add the value to the drop down list for "Binary"
                        % and "Binblock"
                        obj.addNewValueToWorkspaceVariableList([obj.Constants.BinaryFormat obj.Constants.BinblockFormat], var.Name);

                    case {WorkspaceTypeEnum.String, WorkspaceTypeEnum.Char}

                        % Add the variable name to the drop down list for
                        % "Binary" and "ASCII-Terminated String" and "Binblock"
                        obj.addNewValueToWorkspaceVariableList(obj.DataFormatDropDownOptions, var.Name);
                end
            end
        end

        % Override function to include Binblock format
        function resetWorkspaceVariableList(obj)
            keySet = obj.DataFormatDropDownOptions;
            % Add third empty string for Binblock format
            valueSet = {string.empty() string.empty() string.empty()};
            obj.WorkspaceVariableList = containers.Map(keySet, valueSet);
        end
    end

    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function writeReadButtonPressed(obj, ~, ~)
            % Check if the user selected option, Enter Data or Workspace
            % Variable, is empty.
            try
                % Reset write-related flags on exit (these apply to WriteRead)
                cleanup = onCleanup(@obj.resetWriteButtonPressedFlags);

                if ~isFormatASCII(obj)
                    throw(MException(message("transportapp:visadevapp:WriteReadFormatInvalid")));
                end

                if isWriteEmpty(obj)
                    throw(MException(message("transportapp:toolstrip:write:WriteEmpty")));
                end

                % Use WriteRead as TransportData type
                type = obj.WriteReadType;

                % Get the data to be written, from Enter Data or Workspace
                % Variable, whichever is selected by the user.
                data = getWriteData(obj);

                % Always use ASCII-terminated string as data type
                dataTypeValue = obj.Constants.ASCIITerminatedPrecision;

                % Disable the WriteRead and Write buttons until the write completes.
                obj.handleWriteSectionButtonState(false);

                % Notify WriteReadButtonPressed so that Read section can update
                % accordingly
                obj.WriteReadButtonPressed = true;

                % Send the transport action information to the subscriber for
                % this published property.
                obj.TransportData = ...
                    matlabshared.transportapp.internal.utilities.forms.TransportData(type, data, dataTypeValue);

                if obj.WorkspaceVariableWrite
                    fieldName = "WorkspaceVariableDropdown";
                else
                    fieldName = "CustomDataEditField";
                end
                data = string(obj.ViewConfiguration.getViewProperty(fieldName, "Value"));
                obj.generateWriteCode(type, data, dataTypeValue);
            catch ex
                showErrorDialog(obj, ex);
            end
        end
    end

    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        % Helper function to check if format is set to ASCII-terminated
        % string
        function status = isFormatASCII(obj)
            formatVal = obj.ViewConfiguration.getViewProperty("DataFormat", "Value");
            status = strcmp(formatVal, obj.Constants.ASCIITerminatedStringFormat);
        end

        % Enable/disable WriteReadButton
        function handleWriteReadButtonState(obj, flag)
            obj.ViewConfiguration.setViewProperty("WriteReadButton", "Enabled", flag);
        end

        % Enable/disable both Write and WriteRead buttons
        function handleWriteSectionButtonState(obj, flag)
            obj.handleWriteButtonState(flag);
            obj.handleWriteReadButtonState(flag);
        end
    end
end

