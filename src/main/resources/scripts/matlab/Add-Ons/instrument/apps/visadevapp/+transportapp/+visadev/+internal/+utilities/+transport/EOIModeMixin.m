classdef (Abstract) EOIModeMixin <  matlabshared.testmeasapps.internal.dialoghandler.DialogSource
    %EOIMODEMIXIN Mixin class to add EOIMode as an exposed property for a
    %TransportProxy class

    % Copyright 2022-2023 The MathWorks, Inc.

    properties(Dependent)
        EOIMode
    end
    %% LifeTime
methods
    function obj = EOIModeMixin()
        mediator = matlabshared.mediator.internal.Mediator();
        obj@matlabshared.testmeasapps.internal.dialoghandler.DialogSource(mediator);
    end
end

    methods
        function val = get.EOIMode(obj)
            val = logical(obj.OriginalObjects.EOIMode); %#ok<*MCNPN>
        end

        function set.EOIMode(obj, inspectorValue)
            if obj.InternalPropertySet
                return
            end
            try
                obj.setPropertyOnOriginalObject("EOIMode", inspectorValue);
            catch ex
                showErrorDialog(obj, ex);
            end
        end

        function setProxyPropertyGroups(obj)
            % Add EOIMode to Communication group.

            communicationGroup = obj.createGroup(obj.getGroupID("Communication"), "", "");
            communicationGroup.addProperties("EOIMode");
        end
    end
end
