classdef View < handle
    %VIEW is the Toolstrip Help Section View Class. It creates all the
    % toolstrip analyze section UI Elements, and contains events for user
    % interactions with these UI elements.

    % Copyright 2024 The MathWorks, Inc.

    %% UI Elements
    properties
        ToolstripTabHandle
        HelpSection
        DriverDocButton
    end

    %% Events that the Controller listens for
    events
        DriverDocButtonPressed
    end

    %% UI element properties
    properties
        Constants = ividevapp.toolstrip.help.Constants
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

            obj.HelpSection = obj.ToolstripTabHandle.addSection(obj.Constants.HelpSectionName);

            %% ANALYZE SECTION Column 1
            obj.DriverDocButton = ToolstripElementsFactory.createPushButton(obj.Constants.DriverDocButtonProps);
            ToolstripElementsFactory.createAndAddColumn...
                (obj.HelpSection, obj.Constants.Position, [obj.DriverDocButton]);
        end

        function setupEvents(obj)
            % Setup the UI elements event callback handlers.
            obj.DriverDocButton.ButtonPushedFcn = @obj.driverDocButtonPressedFcn;
        end
    end

    %% Event Callback Functions
    methods
        function driverDocButtonPressedFcn(obj, ~, ~)
            obj.notify("DriverDocButtonPressed");
        end
    end
end
