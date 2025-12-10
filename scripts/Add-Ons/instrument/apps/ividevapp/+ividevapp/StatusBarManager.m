classdef StatusBarManager < matlabshared.mediator.internal.Subscriber
    %STATUSBARMANAGER class handles updating the app status bar text for
    % all app operations.

    % Copyright 2023 The MathWorks, Inc.

    properties
        AppStatusLabel
    end

    properties (Constant)
        PauseTimeSeconds (1, 1) double = 2
        ActionAndStatusMsgDictionary = dictionary(["plot", "sigAn", "exportCode"], ["PlotStatus", "SigAnStatus", "ExportCodeStatus"])
    end

    properties (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        LastAppStatusLabelValue
    end

    %% Lifetime
    methods
        function obj = StatusBarManager(mediator, appStatusLabel)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                appStatusLabel matlab.ui.internal.statusbar.StatusLabel
            end

            obj@matlabshared.mediator.internal.Subscriber(mediator);
            obj.AppStatusLabel = appStatusLabel;
            obj.AppStatusLabel.Text = "";
        end
    end

    %% Implement matlabshared.mediator.internal.Subscriber abstract methods
    methods
        function subscribeToMediatorProperties(obj, ~, ~)
            obj.subscribe("ExportVariable", ...
                @(src, evt)obj.exportDataStatusBarText(evt.AffectedObject.ExportVariable));

            obj.subscribe("ExportCodeStatusBar", ...
                @(src, evt)obj.updateStatusMsg(evt.AffectedObject.ExportCodeStatusBar, "exportCode"));

            obj.subscribe("PlotStatusBar", ...
                @(src, evt)obj.updateStatusMsg(evt.AffectedObject.PlotStatusBar, "plot"));

            obj.subscribe("ExportSignalAnStatusBar", ...
                @(src, evt)obj.updateStatusMsg(evt.AffectedObject.ExportSignalAnStatusBar, "sigAn"));

            obj.subscribe("FunctionPropertyStatusBar", ...
                @(src, evt)obj.functionPropertyStatusBarText(evt));
        end
    end

    %% Status Bar update handler functions
    methods (Access = ?matlabshared.transportapp.internal.utilities.ITestable)
        function functionPropertyStatusBarText(obj, evt)
            % Show status bar message while function or property is being
            % executed and then update the status message to mention if
            % operation was "Successful" or "Failed".
            % Then clear the message after 1 second.
            obj.AppStatusLabel.Text = message("ividevapp:ividevapp:FuncPropRunningStatus").string;

            % If the function or property has not finished executing then
            % return
            if evt.AffectedObject.FunctionPropertyStatusBar
                return
            end

            if evt.AffectedObject.ExecutionSuccessful
                id = "FuncPropSuccessStatus";
            else
                id = "FuncPropErrorStatus";
            end
            obj.AppStatusLabel.Text = message("ividevapp:ividevapp:" + id).string;
            obj.LastAppStatusLabelValue = obj.AppStatusLabel.Text;

            pause(obj.PauseTimeSeconds - 1);
            obj.AppStatusLabel.Text = "";
        end

        function updateStatusMsg(obj, flag, tag)
            % Show status bar message while operation is happening and then
            % clear the status message once the operation is done.
            if flag
                text = message("ividevapp:ividevapp:" + obj.ActionAndStatusMsgDictionary(tag)).string;
            else
                text = "";
            end
            obj.AppStatusLabel.Text = text;
        end

        function exportDataStatusBarText(obj, exportVariable)
            % Show status bar message while data is being exported and then
            % clear the status message after 2 seconds.
            obj.AppStatusLabel.Text = message("ividevapp:ividevapp:ExportDataStatus", exportVariable).string;
            obj.LastAppStatusLabelValue = obj.AppStatusLabel.Text;
            pause(obj.PauseTimeSeconds);
            obj.AppStatusLabel.Text = "";
        end
    end
end

