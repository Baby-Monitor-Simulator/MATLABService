classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances for the logs section.

    % Copyright 2023 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(parent, mediator)
            obj.View = ividevapp.appspace.logs.View(parent);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.appspace.logs.Controller(mediator, viewConfiguration);
        end
    end
end
