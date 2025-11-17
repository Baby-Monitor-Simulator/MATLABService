classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances for the help section.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(parent, mediator, metaDataAdapter)
            obj.View = ividevapp.appspace.help.View(parent);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.appspace.help.Controller(mediator, viewConfiguration);
            obj.Controller.MetaDataAdapter = metaDataAdapter;
        end
    end

    %% API
    methods
        function setSideFigPanel(obj, sideFigPanel)
            setSideFigPanel(obj.Controller, sideFigPanel);
        end
    end
end
