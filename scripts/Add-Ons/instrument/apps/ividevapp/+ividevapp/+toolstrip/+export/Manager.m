classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances of the export section.

    % Copyright 2023 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(mediator, form)
            obj.View = ividevapp.toolstrip.export.View(form);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.toolstrip.export.Controller(mediator, viewConfiguration);

            % Set the prefix "driver" for the Export Variable ("driver_data1").
            obj.Controller.setTransportName("driver");
        end
    end
end
