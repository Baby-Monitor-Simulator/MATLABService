classdef FormFactory < transportapp.udpport.internal.common.utilities.factories.IFormFactory
    % FORMFACTORY is the concrete factory implementing the IFormFactory
    % interface for byte communication.

    % Copyright 2021 The MathWorks, Inc.

    methods(Access=private)
        function obj = FormFactory()
        end
    end

    %% Abstract Method Implementation
    methods(Static)
        function toolstripForm = createToolstripForm(transportName, transportInstance, ...
                destinationAddress, destinationPort)
            % Changes to following Shared-App form entries:
            %   - WriteSectionController

            toolstripForm = matlabshared.transportapp.internal.utilities.forms.ToolstripForm;

            toolstripForm.TransportName = transportName;

            %% Write Section
            toolstripForm.WriteSectionController = matlabshared.transportapp.internal.utilities.forms.Entries( ...
                "transportapp.udpport.internal.byte.toolstrip.write.Controller", ...
                {transportInstance, destinationAddress, destinationPort});
        end

        function appSpaceForm = createAppSpaceForm()
            % Changes to following Shared-App form entries:
            %   - PropertyInspectorManager
            %   - ReadWarningIDs

            appSpaceForm = matlabshared.transportapp.internal.utilities.forms.AppSpaceForm;

            %% Property Inspector
            appSpaceForm.PropertyInspectorManager = matlabshared.transportapp.internal.utilities.forms.Entries(...
                "transportapp.udpport.internal.byte.appspace.propertyinspector.Manager");

            %% ReadWarningIDs
            appSpaceForm.ReadWarningIDs = [...
                "transportlib:client:ReadWarning", ...
                "transportlib:client:ReadlineWarning"];
        end
    end
end