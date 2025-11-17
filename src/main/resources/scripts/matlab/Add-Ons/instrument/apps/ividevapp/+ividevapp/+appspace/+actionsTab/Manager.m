classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances of the Actions tab section.

    % Copyright 2023 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(parentGrid, mediator, metaDataAdapter)
            obj.View = ividevapp.appspace.actionsTab.View(parentGrid);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.appspace.actionsTab.Controller(mediator, viewConfiguration);
            createBlankView(obj.Controller);
            obj.Controller.MetaDataAdapter = metaDataAdapter;
        end
    end

    %% API
    methods
        function injectRepCapMap(obj, repCapIDToGetNameFcnMap, getNameFcnToNodesMap)
            % Passes in map of Repeated capability values to GetNameFcns
            % and map of GetNameFcns to AttributeNodes(properties) to the
            % Controller so that the Controller can generate a map of
            % repeated capability values to AttributeNodes(properties).

            obj.Controller.generateRepCapMap(repCapIDToGetNameFcnMap, getNameFcnToNodesMap);
        end
    end
end
