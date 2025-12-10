classdef Controller < matlabshared.transportapp.internal.toolstrip.export.IController

    %CONTROLLER is the Toolstrip Export Section Controller Class. It
    % contains business logic for operations that need to be performed when
    % user interacts with the View elements.

    % Copyright 2023 The MathWorks, Inc.

    properties
        % Instance of handler class that contains the business logic for
        % the ividev App Export Controller class.
        ExportHandler
    end

    %% Lifetime
    methods
        function obj = Controller(mediator, viewConfiguration, ~)
            arguments
                mediator matlabshared.mediator.internal.Mediator
                viewConfiguration matlabshared.transportapp.internal.utilities.viewconfiguration.IViewConfiguration
                ~
            end
            obj.ExportHandler = ividevapp.toolstrip.export.ExportHandler(mediator, viewConfiguration);
        end
    end

    %% Implementing Abstract methods from IController
    methods
        function setTransportName(obj, transportName)
            % Sets the beginning of the export variable name for the app.
            % Referred to transport name by shared app.
            obj.ExportHandler.setTransportName(transportName);
        end
    end
end