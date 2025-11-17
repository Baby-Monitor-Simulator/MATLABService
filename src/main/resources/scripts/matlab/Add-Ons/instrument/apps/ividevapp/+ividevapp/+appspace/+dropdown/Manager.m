classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances of the dropdown section.

    % Copyright 2023 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(baseGrid, mediator, metaDataAdapter)
            % Creates View, ViewConfiguration and Controller instances.
            % Sets the metaDataAdapter property on the controller with the
            % information passed in.
            % Creates function/property tree using the metaDataAdapter
            % information.

            obj.View = ividevapp.appspace.dropdown.View(baseGrid);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.appspace.dropdown.Controller(mediator, viewConfiguration);
            obj.Controller.MetaDataAdapter = metaDataAdapter;
            obj.Controller.createFuncPropTree();
        end
    end

    %% API
    methods
        function map = getNameFcnToNodesMap(obj)
            % Obtain the GetNameFcnToPropNodesMap from the Controller to
            % pass on to other classes.
            map = obj.Controller.GetNameFcnToPropNodesMap;
        end
    end
end
