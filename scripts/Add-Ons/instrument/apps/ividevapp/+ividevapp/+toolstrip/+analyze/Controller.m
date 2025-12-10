classdef Controller < matlabshared.mediator.internal.Publisher & ...
        matlabshared.transportapp.internal.utilities.ITestable
    %CONTROLLER is the Toolstrip Analyze Controller class. It contains
    % business logic for operations that need to be performed when the user
    % interacts with the View elements.

    % Copyright 2023 The MathWorks, Inc.

    properties (SetObservable)
        PlotButtonPressed (1, 1) logical = false
        SignalAnalyzerButtonPressed (1, 1) logical = false
        ClearButtonPressed (1, 1) logical = false
    end

    properties (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        % The handle to the ViewConfiguration instance containing the View.
        ViewConfiguration

        % Listeners for the View events
        ViewListeners = event.listener.empty
    end

    properties (Dependent)
        View
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

            obj.ViewConfiguration = viewConfiguration;

            % Only for production mode
            if isa(obj.ViewConfiguration, ...
                    "matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration")
                obj.setupListeners();
            end
        end

        function delete(obj)
            delete(obj.ViewListeners);
        end
    end

    %% Listener Handler Functions
    methods
        function handleButtonPressed(obj, ~, ~, buttonName)
            % Handler for when the user presses either the "Plot",
            % "SignalAnalyzer" or "Clear" button.
            cleanup = onCleanup(@()obj.reEnableButton(buttonName));
            obj.ViewConfiguration.setViewProperty(buttonName, "Enabled", false);

            % Set observable property based on the button pressed.
            obj.(buttonName + "Pressed") = true;
        end
    end

    %% Helper Functions
    methods (Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        function setupListeners(obj)
            obj.ViewListeners(end+1) = listener(obj.View, "PlotButtonPressed", ...
                @(src, evt)obj.handleButtonPressed(src, evt, "PlotButton"));

            obj.ViewListeners(end+1) = listener(obj.View, "SignalAnalyzerButtonPressed", ...
                @(src, evt)obj.handleButtonPressed(src, evt, "SignalAnalyzerButton"));

            obj.ViewListeners(end+1) = listener(obj.View, "ClearButtonPressed", ...
                @(src, evt)obj.handleButtonPressed(src, evt, "ClearButton"));
        end

        function reEnableButton(obj, button)
            arguments
                obj
                button (1, 1) string {mustBeMember(button, ["PlotButton", "SignalAnalyzerButton", "ClearButton"])} = "PlotButton"
            end
            obj.ViewConfiguration.setViewProperty(button, "Enabled", true);
        end
    end

    %% Getters and setters
    methods
        function value = get.View(obj)
            value = obj.ViewConfiguration.View;
        end
    end
end