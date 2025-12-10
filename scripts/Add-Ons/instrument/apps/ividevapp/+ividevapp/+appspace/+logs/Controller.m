classdef Controller < matlabshared.mediator.internal.Publisher & ...
        matlabshared.mediator.internal.Subscriber & ...
        matlabshared.testmeasapps.internal.ITestable & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource & ...
        matlabshared.testmeasapps.internal.contextmenu.ContextMenuSource
    %CONTROLLER is the Appspace Logs Controller Class. It contains business
    % logic for operations that need to be performed regarding the activity
    % log.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (SetObservable)
        ClearTableDetails (1, 1) logical = false
        ExportSuccessful (1,1) logical = false
        ExportMenuItemPressed (1,1) logical = false

        % Status bar text update properties
        ExportVariable

        % true - means plot operation is starting
        % false - means plot operation has completed or not begun
        PlotStatusBar (1,1) logical = false

        % true - means exporting data to signal analyzer operation is
        % starting
        % false - means exporting data to signal analyzer operation has
        % completed or not begun
        ExportSignalAnStatusBar (1,1) logical = false
    end

    properties (Dependent)
        View
        Table
    end

    properties
        % Stores function/property names, input argument and output
        % argument names and their corresponding values
        TableDetails (1, :) ividevapp.utilities.forms.TableDetails = ividevapp.utilities.forms.TableDetails.empty

        % Driver Function or Property name that was used
        FuncOrPropName

        % Input argument names of function
        % Will be empty for property
        InputNames

        % Input values specified for function or property
        % Set value for property
        InputValues

        % Output argument names of function
        % Will be empty for property
        OutputNames

        % Output values returned for function
        % Get value for property
        OutputValues

        % containers.Map that correlates the Activity Log table index to the
        % function/property operation index in the Activity Log.
        TableIndexToDetailsIndexMap

        % Stores the function/property operation index in the Activity Log.
        ActivityCounter

        % The right click context menu for the Activity Log table.
        ContextMenu

        % The context menu text items.
        MenuItems

        % Check for whether the Signal Analyzer app is installed
        SPToolboxInstalled = []

        % The handle to the ViewConfiguration instance containing the View.
        ViewConfiguration

        % Stores all plot figure handles
        FigureHandles

        % Flag that only allows the input and output value columns of the
        % Activity Log to be selected for operations such as plotting data
        % and viewing data in signal analyzer.
        StrictColumnSelection (1, 1) logical = true
    end

    properties (Constant)
        % Activity Log columns that can be used for plot and viewing in
        % Signal Analyzer.
        InputNameColumn = 3
        InputValueColumn = 4
        OutputNameColumn = 5
        OutputValueColumn = 6

        % Context Menu options
        ContextMenuExportOption = message("ividevapp:ividevapp:ActivityLogContextMenuExport").string
        ContextMenuPlotOption = message("ividevapp:ividevapp:ActivityLogContextMenuPlot").string
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration, ~)
            arguments
                mediator (1, 1) matlabshared.mediator.internal.Mediator
                viewConfiguration (1, 1) matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
                ~
            end

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);
            obj@matlabshared.testmeasapps.internal.contextmenu.ContextMenuSource(mediator);

            obj.ViewConfiguration = viewConfiguration;
            obj.TableIndexToDetailsIndexMap = containers.Map;
            obj.ActivityCounter = 0;
        end

        function delete(obj)
            for figHandle = obj.FigureHandles
                if isvalid(figHandle)
                    delete(figHandle);
                end
            end
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe('TableData', ...
                @(src, event)obj.injectTableDetails(event.AffectedObject.TableData));

            obj.subscribe("ExportCommLog", ...
                @(src, event)obj.exportActivityLogPressed(event.AffectedObject.ExportCommLog));

            obj.subscribe("PlotButtonPressed", ...
                @(src, event)obj.createPlot());

            obj.subscribe("SignalAnalyzerButtonPressed", ...
                @(src, event)obj.sigAnButtonPressed());

            obj.subscribe("ClearButtonPressed", ...
                @(src, event)obj.clearButtonPressed());

            obj.subscribe('EditorURL', ...
                @(src, event)obj.injectCodeLogEM(event.AffectedObject.EditorURL));

            obj.subscribe("ExportSelectedCell", ...
                @(src, event)obj.exportSelectedCell(event.AffectedObject.ExportSelectedCell));
        end
    end

    %% Subscriber Handler Functions
    methods
        function injectTableDetails(obj, tableDetails)
            % Handler to inject data for the executed operation into the
            % Activity Log table.

            if isempty(obj.TableDetails) && isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                obj.createTableContextMenu();
            end

            obj.TableDetails(end+1) = tableDetails(end);
            obj.insertTableData();
        end

        function exportActivityLogPressed(obj, workspaceVar)
            % Handler to export complete Activity Log data when the user
            % presses the "Export Activity Log" button.

            try
                validateBeforeExport(obj, workspaceVar);

                % Get the complete Activity Log table data
                tableDetails = getTableDetails(obj);

                % Assign the selected TableDetails to the specified
                % workspace variable.
                assignin("base", string(workspaceVar), tableDetails);

                % Save export variable to use in status bar text.
                obj.ExportVariable = string(workspaceVar);
            catch ex
                obj.showErrorDialog(ex);
            end

            % Notify the toolstrip export section that the export has
            % completed successfully.
            obj.ExportSuccessful = true;

            function tableDetails = getTableDetails(obj)
                % Get complete Activity Log data in table format.

                tableDetails = cell2table(obj.Table.Data, "VariableNames", obj.View.Constants.TableProperties.ColumnName);
                tableDetails = varfun(@string, tableDetails);
                tableDetails.Properties.VariableNames = replace(string(tableDetails.Properties.VariableNames), "string_", "");
                tableDetails.Index = str2double(tableDetails(:,1).Variables);
                tableDetails.Properties.RowNames = string(1:height(tableDetails))';
            end
        end

        function exportSelectedCell(obj, workspaceVar)
            % Handler to export data when the user selects a cell in the
            % Activity Log and then presses "Export Selected Cell in
            % Activity Log" button.

            try
                validateBeforeExport(obj, workspaceVar);

                % Make sure there is a selected cell in the Activity Log.
                if isempty(obj.Table.Selection)
                    throw(MException(message("ividevapp:ividevapp:ExportNoCellSelected")));
                end

                % Allow any Activity Log table column cells to be selected
                % for exporting data.
                obj.StrictColumnSelection = false;

                % Get the data from the selected cell.
                data = getSelectedTableValue(obj);

                % After export operation is complete, change back to only
                % allow input and output value columns of the Activity Log
                % to be selected for any operation.
                obj.StrictColumnSelection = true;

                % Assign the selected data to the specified
                % workspace variable.
                assignin("base", string(workspaceVar), data);

                % Save export variable to use in status bar text.
                obj.ExportVariable = string(workspaceVar);
            catch ex
                obj.showErrorDialog(ex);
            end

            % Notify the toolstrip export section that the export has
            % completed successfully.
            obj.ExportSuccessful = true;
        end

        function createPlot(obj)
            % Handler to plot data when the user selects a cell in the
            % Activity Log and then presses the "Plot Data" button.
            % Also handler for right-click plot context menu option.

            % Set PlotStatusBar to true to indicate that operation is
            % starting. This will be used when making status bar text
            % updates.
            obj.PlotStatusBar = true;

            try
                % Make sure the Activity Log is not empty.
                if isempty(obj.Table.Data)
                    throw(MException(message("ividevapp:ividevapp:PlotErrorTableEmpty")));
                end

                % Make sure there is a selected cell in the Activity Log
                if isempty(obj.Table.Selection)
                    throw(MException(message("ividevapp:ividevapp:PlotNoCellSelected")));
                end

                % Get the data from the selected cell.
                data = getSelectedTableValue(obj);

                % Plot the selected table cell value.
                obj.plotValue(data);
            catch ex
                obj.showErrorDialog(ex);
            end

            % Set PlotStatusBar to false to indicate that operation has
            % completed. This will be used when making status bar text
            % updates.
            obj.PlotStatusBar = false;
        end

        function sigAnButtonPressed(obj)
            % Handler to move data into Signal Analyzer when the user
            % selects a cell in the Activity Log and then presses the
            % "Signal Analyzer" button.

            % Do a one time check for toolbox installed.
            if isempty(obj.SPToolboxInstalled)
                obj.SPToolboxInstalled = ~isempty(ver('signal'));
            end

            try
                % If the Signal Processing Toolbox is installed, validate
                % that there is a valid license associated with the
                % toolbox.
                if obj.SPToolboxInstalled
                    validateSPTLicense(obj);

                    % Set ExportSignalAnStatusBar to true to indicate that
                    % operation to export data to signal analyzer is
                    % starting. This will be used when making status bar
                    % text updates.
                    obj.ExportSignalAnStatusBar = true;
                    exportToSignalAnalyzer(obj);

                    % Set ExportSignalAnStatusBar to false to indicate that
                    % operation to export data to signal analyzer has
                    % completed. This will be used when making status bar
                    % text updates.
                    obj.ExportSignalAnStatusBar = false;
                else
                    % Prepare the option dialogs for when the Signal
                    % Analyzer button is pressed when there is no Signal
                    % Processing Toolbox.
                    options = matlabshared.testmeasapps.internal.dialoghandler.forms.OptionsForm;
                    options.Message = message("transportapp:toolstrip:analyze:SigAnOptionsNoLicense").string;
                    options.Options = [message("transportapp:toolstrip:analyze:OpenOption").string, message("transportapp:toolstrip:analyze:NoOption").string];
                    options.DefaultOption = message("transportapp:toolstrip:analyze:NoOption").string;
                    result = showConfirmationDialog(obj, options);

                    % Launch the addons explorer for Signal Processing Toolbox if
                    % user clicks "Open" to launching the add-ons explorer page
                    % when they do not have the SPT license.
                    if result == message("transportapp:toolstrip:analyze:OpenOption").string
                        matlab.internal.addons.launchers.showExplorer(matlabshared.transportapp.internal.toolstrip.analyze.Constants.SigAnUniqueID, "identifier", "SG");
                    end
                end
            catch ex
                obj.showErrorDialog(ex);

                % Set ExportSignalAnStatusBar to false to indicate that
                % operation to export data to signal analyzer has
                % completed. This will be used when making status bar
                % text updates.
                obj.ExportSignalAnStatusBar = false;
            end
        end

        function clearButtonPressed(obj)
            % Handler to clear all Activity Log data when the user presses
            % the "Clear Activity Log" button.

            option = matlabshared.testmeasapps.internal.dialoghandler.forms.OptionsForm;
            option.Message = message("ividevapp:ividevapp:ClearActivityLogQuestion").string;
            option.Options = [message("ividevapp:ividevapp:YesOption").string, message("ividevapp:ividevapp:NoOption").string];
            option.DefaultOption = option.Options(2);
            result = obj.showConfirmationDialog(option);

            % Clear the table data and reset properties once the user
            % confirms.
            if result == message("ividevapp:ividevapp:YesOption").string
                removeStyle(obj.Table);
                obj.Table.Data = [];
                obj.ActivityCounter = 0;
                obj.TableDetails = ividevapp.utilities.forms.TableDetails.empty;
                obj.clearTableContextMenu();
                obj.TableIndexToDetailsIndexMap = containers.Map;
                obj.ClearTableDetails = true;
            end
        end

        function injectCodeLogEM(obj, url)
            % Sets the Code Log Editor Manager as the HTMLSource for the
            % CodeLogUIHTMLHandle.
            obj.View.CodeLogUIHTMLHandle.HTMLSource = url;
        end
    end

    %% Helper Functions
    methods (Access = {?matlabshared.testmeasapps.internal.ITestable})
        function exportToSignalAnalyzer(obj)
            % Launch Signal Analyser app with the selected cell data.
            % When the table is empty or no table cell is selected,
            % inform the user that no data is present or no data is
            % selected to be viewed in the Signal Analyzer app, and ask
            % users if they still want to open the Signal Analyzer app.

            if isempty(obj.Table.Data) || isempty(obj.Table.Selection)
                option = matlabshared.testmeasapps.internal.dialoghandler.forms.OptionsForm;

                if isempty(obj.Table.Data)
                    option.Message = message("ividevapp:ividevapp:SignalAnalyzerNoData").string;
                else
                    option.Message = message("ividevapp:ividevapp:SignalAnalyzerNoDataSelected").string;
                end

                option.Options = [message("transportapp:toolstrip:analyze:OpenAnywayOption").string, message("transportapp:toolstrip:analyze:NoOption").string];
                option.DefaultOption = message("transportapp:toolstrip:analyze:OpenAnywayOption").string;
                result = showConfirmationDialog(obj, option);

                % User clicks "Open Anyway" to launch the signal
                % analyzer app with no data.
                if result == message("transportapp:toolstrip:analyze:OpenAnywayOption").string
                    signalAnalyzer();
                end
            else
                % Launch the Signal Analyzer app with the selected cell
                % data. Error out if data is not valid for Signal Analyzer app.

                data = getSelectedTableValue(obj);
                data = str2num(join(string(data))); %#ok<ST2NM>

                try
                    signalAnalyzer(data);
                catch ex
                    throw(MException(message("ividevapp:ividevapp:SignalAnalyzerError", ex.message)));
                end
            end
        end

        function insertTableData(obj)
            % Store the passed in values in the Activity Log table.

            % Format data in table and map table cell information to
            % executed driver operation information.
            obj.adjustData();
            obj.mapTableIndexToDetails();

            % Add a numbers column for each operation and save data as cell arrays.
            numbersColumn = [obj.ActivityCounter, strings(1, length(obj.FuncOrPropName)-1)];
            newData = arrayfun(@cellstr, [numbersColumn; obj.FuncOrPropName; obj.InputNames; obj.InputValues; obj.OutputNames; obj.OutputValues]');

            % Append new data to existing table data.
            obj.Table.Data = [obj.Table.Data; newData];

            if isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                % Format the table
                obj.View.styleTable();
            end
        end

        function adjustData(obj)
            % Adjust the data to be of the proper type and size before
            % adding into table.

            obj.FuncOrPropName = string(obj.TableDetails(end).FcnOrPropName);
            obj.InputNames = convertToString(obj.TableDetails(end).InputArgs.Names);
            obj.OutputNames = convertToString(obj.TableDetails(end).OutputArgs.Names);
            obj.InputValues = convertToString(obj.TableDetails(end).InputArgs.Values);
            obj.OutputValues = convertToString(obj.TableDetails(end).OutputArgs.Values);

            % Find the maximum number of rows for an operation based on the
            % max number of input or output arguments. The max could be 1
            % (e.g. for a property or even some functions).
            maxRow = max([length(obj.InputNames), length(obj.OutputNames), length(obj.FuncOrPropName)]);

            % Set the additional rows uptil maxRow to empty.
            %
            % E.g. If max number of rows for an operation is 3 (number of
            % input arguments) and if there is only 1 output argument, then
            % the last 2 rows for the output argument column will be
            % created and will be set to empty. Similarly if other columns
            % do not have 3 values they will also be set to empty.
            obj.FuncOrPropName(2:maxRow) = "";
            obj.InputNames(end+1:maxRow) = "";
            obj.InputValues(end+1:maxRow) = "";
            obj.OutputNames(end+1:maxRow) = "";
            obj.OutputValues(end+1:maxRow) = "";

            function strData = convertToString(data)
                % Convert the data to strings to display in the table.
                strData = [];

                if isempty(data)
                    return
                end

                for i = 1 : length(data)
                    if isstruct(data{i})
                        strData = [strData, join(obj.OutputNames(i))]; %#ok<AGROW>
                    else
                        strData = [strData, join(string(data{i}))]; %#ok<AGROW>
                    end
                end
            end
        end

        function mapTableIndexToDetails(obj)
            % Map the indices of the table cells to the index of the
            % corresponding TableDetails instance. There is a unique
            % TableDetails instance for each completed operation.

            % Increment TableDetails instance counter
            obj.ActivityCounter = obj.ActivityCounter + 1;

            % Max rows for new operation
            maxRows = max([length(obj.InputNames), length(obj.OutputNames), length(obj.FuncOrPropName)]);

            % Find last filled row for table.
            [row, ~] = size(obj.Table.Data);

            % Map all rowsToFill to the new TableDetails index.
            rowsToFill = row + 1 : row + maxRows;
            for index = rowsToFill
                key = num2str(index);
                obj.TableIndexToDetailsIndexMap(key) = obj.ActivityCounter;
            end

            storeIndicesInDetails(obj, maxRows);

            function storeIndicesInDetails(obj, numValues)
                % Store the indices of the table cells in the TableDetails
                % instance for inputs and outputs.

                [lastRow, ~] = size(obj.Table.Data);
                newTopRow = lastRow + 1;
                tableIndices = newTopRow : newTopRow + numValues - 1;
                obj.TableDetails(end).TableIndices = tableIndices;
            end
        end

        function plotValue(obj, value)
            % Plot the selected cell value.

            % Make sure the cell selected has a valid value.
            if ~canPlot(value)
                throw(MException(message("ividevapp:ividevapp:PlotNonNumericError")));
            end

            % Only convert string and char values that can be converted to
            % numeric data.
            if ~isnumeric(value) && ~islogical(value)
                value = str2num(value); %#ok<ST2NM>
            end

            % Create figure handle to show a new plot. Keep the older
            % figures around.
            if isempty(obj.FigureHandles)
                obj.FigureHandles = figure;
            else
                obj.FigureHandles(end+1) = figure;
            end

            % Make the figure window themeable.
            matlab.graphics.internal.themes.figureUseDesktopTheme(obj.FigureHandles(end));
            ax = axes(Parent=obj.FigureHandles(end));

            % Mark scalar value and move latest plot to the top.
            if isscalar(value)
                plot(value, "-o", Parent=ax);
            else
                plot(value, Parent=ax);
            end
            uistack(ax,"top");

            function flag = canPlot(val)
                try
                    flag = isnumeric(val) || islogical(val) || ~isempty(str2num(val)); %#ok<ST2NM>
                catch
                    % Set flag to false if str2num conversion fails for
                    % invalid values.
                    flag = false;
                end
            end
        end

        function createTableContextMenu(obj)
            % Creates the right-click context menu for the Activity log table.

            import matlabshared.transportapp.internal.utilities.factories.AppSpaceElementsFactory

            obj.ContextMenu = requestContextMenu(obj);
            obj.MenuItems = AppSpaceElementsFactory.createMenu(obj.ContextMenu, ...
                [obj.ContextMenuExportOption, obj.ContextMenuPlotOption], {@obj.exportMenuSelected, @(src, evt)obj.createPlot});
            obj.Table.ContextMenu = obj.ContextMenu;
        end

        function exportMenuSelected(obj, ~, ~)
            % Handler for right-click export context menu option.
            obj.ExportMenuItemPressed = true;
        end

        function clearTableContextMenu(obj, ~, ~)
            % Cleans up the context menu and its options.
            obj.MenuItems = [];
            obj.ContextMenu = [];
            obj.Table.ContextMenu = [];
        end

        function value = getSelectedTableValue(obj)
            % Returns the value of the selected table cell in the Activity
            % Log table.

            selectedRow = obj.Table.Selection(1);
            selectedColumn = obj.Table.Selection(2);

            % If a non-value column cell is selected and the operation
            % allows to get data from this cell, then get data from it
            % otherwise return empty.
            value = getTableDataInNonValueColumn(obj, selectedRow, selectedColumn);
            if ~isempty(value)
                return
            end

            % Error if correct columns are not selected
            incorrectColumnSelected = ~ismember(selectedColumn, [obj.InputValueColumn, obj.OutputValueColumn]);
            if incorrectColumnSelected
                throw(MException(message("ividevapp:ividevapp:InvalidActivityLogCellSelected")));
            end

            % Get the TableDetails instance corresponding to the selected row.
            tableIndex = num2str(selectedRow);
            detailsIndex = obj.TableIndexToDetailsIndexMap(tableIndex);
            selectedTableDetails = obj.TableDetails(detailsIndex);

            % Get the input value or output value of the selected table
            % cell from the selected TableDetails instance.
            if any(selectedColumn == obj.InputValueColumn)
                value = getInputValue(selectedTableDetails, selectedRow);
            else
                value = getOutputValue(selectedTableDetails, selectedRow);
            end

            function value = getTableDataInNonValueColumn(obj, selectedRow, selectedColumn)
                % Get data from the selected row and column in the Activity Log table.
                % The column should not be an input or output value column.

                value = [];

                isInputOrOutputColumn = ismember(selectedColumn, [obj.InputValueColumn, obj.OutputValueColumn]);

                if ~obj.StrictColumnSelection && ~isInputOrOutputColumn
                    value = obj.Table.Data{selectedRow, selectedColumn};
                    if isempty(value)
                        throw(MException(message("ividevapp:ividevapp:EmptyActivityLogCellSelected")));
                    end

                    % Convert char to string before returning
                    if ischar(value)
                        value = string(value);
                    end
                elseif obj.StrictColumnSelection && ~isInputOrOutputColumn
                    if any(selectedColumn == [obj.InputNameColumn, obj.OutputNameColumn])
                        value = obj.Table.Data{selectedRow, selectedColumn+1};
                    end
                end
            end

            function val = getInputValue(selectedTableDetails, selectedRow)
                % Find the input value based on the selected TableDetails
                % instance.

                args = selectedTableDetails.InputArgs;
                val = getValue(selectedTableDetails, selectedRow, args);
            end

            function val = getOutputValue(selectedTableDetails, selectedRow)
                % Find the output value based on the selected TableDetails
                % instance.

                args = selectedTableDetails.OutputArgs;
                val = getValue(selectedTableDetails, selectedRow, args);
            end

            function val = getValue(selectedTableDetails, selectedRow, args)
                % Find the value based on the selected TableDetails instance.
                values = args.Values;

                % Get the desired values column index from the selected TableDetails.
                index = find(selectedTableDetails.TableIndices == selectedRow);

                % Make sure the selected table cell has a value.
                if index > length(values) || isempty(values{index})
                    throw(MException(message("ividevapp:ividevapp:EmptyActivityLogCellSelected")));
                end

                val = values{index};
            end
        end

        function validateSPTLicense(~)
            % If the SPT toolbox is already installed but no SPT license is
            % found, throw an error.

            [checkoutLicense, ~] = builtin('license','checkout','Signal_Toolbox');
            if ~checkoutLicense
                throw(MException(message("transportapp:toolstrip:analyze:NoSPTLicense")));
            end
        end

        function validateBeforeExport(obj, workspaceVar)
            % Validates that the export variable is not empty and there is
            % data present in the table to export.

            % Make sure the user has entered a workspace variable.
            if string(workspaceVar) == ""
                throw(MException(message("ividevapp:ividevapp:WorkspaceVariableEmpty")));
            end

            % Make sure the Activity Log is not empty.
            if isempty(obj.Table.Data)
                throw(MException(message("ividevapp:ividevapp:ExportErrorTableEmpty")));
            end
        end
    end

    %% Getters
    methods
        function value = get.View(obj)
            value = obj.ViewConfiguration.View;
        end

        function value = get.Table(obj)
            value = obj.View.Table;
        end
    end
end
