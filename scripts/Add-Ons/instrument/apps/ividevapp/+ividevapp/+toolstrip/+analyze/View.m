classdef View < handle
    %VIEW is the Toolstrip Analyze Section View Class. It creates all the
    % toolstrip analyze section UI Elements, and contains events for user
    % interactions with these UI elements.

    % Copyright 2023 The MathWorks, Inc.

    %% UI Elements
    properties
        ToolstripTabHandle
        AnalyzeSection
        PlotButton
        SignalAnalyzerButton
        ClearButton
    end

    %% Events that the Controller listens for
    events
        PlotButtonPressed
        SignalAnalyzerButtonPressed
        ClearButtonPressed
    end

    %% UI element properties
    properties
        SharedAppConstants = matlabshared.transportapp.internal.toolstrip.analyze.Constants
        Constants = ividevapp.toolstrip.analyze.Constants
    end

    %% Lifetime
    methods
        function obj = View(toolstripTabHandle)
            obj.ToolstripTabHandle = toolstripTabHandle;
            createView(obj);
            setupEvents(obj);
        end
    end

    %% API
    methods (Access = private)
        function createView(obj)
            % Create the analyze section view UI elements. The order of
            % creation of columns matters as the createAndAddColumn adds
            % the new column to the right of the current column with the
            % contained UI elements.

            import matlabshared.transportapp.internal.utilities.factories.ToolstripElementsFactory

            obj.AnalyzeSection = obj.ToolstripTabHandle.addSection(obj.SharedAppConstants.AnalyzeSectionName);

            %% ANALYZE SECTION Column 1
            obj.PlotButton = ToolstripElementsFactory.createPushButton(obj.Constants.PlotButtonProps);
            ToolstripElementsFactory.createAndAddColumn...
                (obj.AnalyzeSection, obj.Constants.Position, [obj.PlotButton]);

            %% ANALYZE SECTION Column 2
            obj.SignalAnalyzerButton = ToolstripElementsFactory.createPushButton(obj.Constants.SignalAnalyzerButtonProps);
            ToolstripElementsFactory.createAndAddColumn...
                (obj.AnalyzeSection, obj.Constants.Position, [obj.SignalAnalyzerButton]);

            %% ANALYZE SECTION Column 3
            obj.ClearButton = ToolstripElementsFactory.createPushButton(obj.Constants.ClearButtonProps);
            ToolstripElementsFactory.createAndAddColumn...
                (obj.AnalyzeSection, obj.Constants.Position, [obj.ClearButton]);
        end

        function setupEvents(obj)
            % Setup the UI elements event callback handlers.
            obj.PlotButton.ButtonPushedFcn = @obj.plotButtonPressedFcn;
            obj.SignalAnalyzerButton.ButtonPushedFcn = @obj.sigAnButtonPressedFcn;
            obj.ClearButton.ButtonPushedFcn = @obj.clearButtonPressedFcn;
        end
    end

    %% Event Callback Functions
    methods
        function plotButtonPressedFcn(obj, ~, ~)
            obj.notify("PlotButtonPressed");
        end

        function sigAnButtonPressedFcn(obj, ~, ~)
            obj.notify("SignalAnalyzerButtonPressed");
        end

        function clearButtonPressedFcn(obj, ~, ~)
            obj.notify("ClearButtonPressed");
        end
    end
end
