classdef FormFactory < transportapp.udpport.internal.common.utilities.factories.IFormFactory
    % FORMFACTORY is the concrete factory implementing the IFormFactory
    % interface for datagram communication.

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
            %   - WriteSectionView
            %   - ReadSectionController
            %   - ReadSectionView

            toolstripForm = matlabshared.transportapp.internal.utilities.forms.ToolstripForm;

            toolstripForm.TransportName = transportName;

            %% Write Section
            toolstripForm.WriteSectionController = matlabshared.transportapp.internal.utilities.forms.Entries( ...
                "transportapp.udpport.internal.datagram.toolstrip.write.Controller", ...
                {transportInstance, destinationAddress, destinationPort});

            toolstripForm.WriteSectionView = matlabshared.transportapp.internal.utilities.forms.Entries( ...
                "transportapp.udpport.internal.datagram.toolstrip.write.View");

            %% Read Section
            toolstripForm.ReadSectionController = matlabshared.transportapp.internal.utilities.forms.Entries( ...
                "transportapp.udpport.internal.datagram.toolstrip.read.Controller");

            toolstripForm.ReadSectionView = matlabshared.transportapp.internal.utilities.forms.Entries( ...
                "transportapp.udpport.internal.datagram.toolstrip.read.View");
        end

        function appSpaceForm = createAppSpaceForm()
            % Changes to following Shared-App form entries:
            %   - CommunicationLogSectionController
            %   - CommunicationLogSectionView
            %   - PropertyInspectorManager
            %   - ReadWarningIDs

            appSpaceForm = matlabshared.transportapp.internal.utilities.forms.AppSpaceForm;

            %% Communication Log
            appSpaceForm.CommunicationLogSectionController = matlabshared.transportapp.internal.utilities.forms.Entries(...
                "transportapp.udpport.internal.datagram.appspace.communicationlog.Controller");

            appSpaceForm.CommunicationLogSectionView = matlabshared.transportapp.internal.utilities.forms.Entries(...
                "transportapp.udpport.internal.datagram.appspace.communicationlog.View");

            %% Property Inspector
            appSpaceForm.PropertyInspectorManager = matlabshared.transportapp.internal.utilities.forms.Entries(...
                "transportapp.udpport.internal.datagram.appspace.propertyinspector.Manager");

            %% ReadWarningIDs
            appSpaceForm.ReadWarningIDs = ["transportlib:client:ReadWarning"];
        end
    end
end