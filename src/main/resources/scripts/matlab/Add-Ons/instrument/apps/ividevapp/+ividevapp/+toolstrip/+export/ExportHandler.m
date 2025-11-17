classdef ExportHandler < matlabshared.transportapp.internal.toolstrip.export.ExportHandlerBase & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogSource

    % EXPORTHANDLER handles the business logic for the ividev app
    % Toolstrip Export Section Controller class for operations that need to
    % be performed when user interacts with the View elements.

    % Copyright 2023 The MathWorks, Inc.

    properties (SetObservable)
        ExportSelectedCell
        ExportMATLABCodeLog (1, 1) logical = false
    end

    %% Lifetime
    methods
        function obj = ExportHandler(mediator, viewConfiguration)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
            end
            obj@matlabshared.transportapp.internal.toolstrip.export.ExportHandlerBase(mediator, viewConfiguration, "WorkspaceVariableEditField");
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);
        end
    end

    %% Hook methods
    methods
        function additionalSubscribeToMediatorPropertiesHook(obj)
            % Subscribe to additional observable properties specific to
            % this app - "ExportMenuItemPressed".
            obj.subscribe('ExportMenuItemPressed', ...
                @(src, event)obj.exportSelectedCell());
        end

        function saveExportVariableHook(obj, varName)
            % Used to save the exported variable that
            % contains the data selected in the Communication Log table.
            obj.ExportSelectedCell = varName;
        end

        function showWarningMessageHook(obj, warnObj)
            % Use matlabshared.testmeasapps.internal.dialoghandler.DialogSource
            % to show warnings in app.
            warnForm = matlabshared.testmeasapps.internal.dialoghandler.forms.WarningForm(warnObj.Identifier, warnObj.Message);
            obj.showWarningDialog(warnForm);
        end

        function showErrorMessageHook(obj, ex)
            % Use matlabshared.testmeasapps.internal.dialoghandler.DialogSource
            % to show errors in app.
            obj.showErrorDialog(ex);
        end

        function exportCodeLogPressed(obj, ~, ~)
            % Handler for when the "Export MATLAB Code" item is pressed.
            obj.ExportMATLABCodeLog = true;
        end
    end

    %% Handlers
    methods
        function exportSelectedCell(obj, ~, ~)
            % Handler for when the context menu option is right-clicked in
            % selected cell of the Communication Log table to export data.

            try
                % Before exporting, ensure that the workspace variable is
                % valid, else update the Workspace Variable value.
                updateWorkspaceVariableValue(obj);

                % Save the workspace variable that contains the data to be
                % exported.
                varName = ...
                    string(obj.ViewConfiguration.getViewProperty("WorkspaceVariableEditField", "Value"));

                obj.ExportSelectedCell = varName;
            catch ex
                showErrorMessage(obj, ex);
            end
        end
    end
end