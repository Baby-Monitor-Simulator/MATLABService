classdef Manager < handle
    %MANAGER creates and maintains the lifetime for the View and Controller
    % instances for the help section.

    % Copyright 2024 The MathWorks, Inc.

    properties
        View
        Controller
    end

    %% Lifetime
    methods
        function obj = Manager(mediator, form)
            obj.View = ividevapp.toolstrip.help.View(form);
            viewConfiguration = matlabshared.transportapp.internal.utilities.viewconfiguration.ViewConfiguration(obj.View);
            obj.Controller = ividevapp.toolstrip.help.Controller(mediator, viewConfiguration);
        end
    end

    methods
        function setHelpSectionVendorDriver(obj, vendorDriver)
            setVendorDriver(obj.Controller, vendorDriver);
        end
    end
end
