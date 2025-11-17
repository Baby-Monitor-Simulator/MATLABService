classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances for the analyze section.

    % Copyright 2023 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(mediator, form)
            obj.View = ividevapp.toolstrip.analyze.View(form);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.toolstrip.analyze.Controller(mediator, viewConfiguration);
        end
    end
end
