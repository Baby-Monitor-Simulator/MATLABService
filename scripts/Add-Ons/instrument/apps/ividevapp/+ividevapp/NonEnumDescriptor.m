classdef NonEnumDescriptor < ividevapp.BaseDescriptor & ...
        matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin
    %NONENUMDESCRIPTOR is the descriptor class for non-enumerable devices
    % in the ividevapp.

    % Copyright 2023 The MathWorks, Inc.

    properties (Constant)
        % Path to the map file for the CSH page to be shown in hardware
        % manager while the user is entering parameters.
        InstrumentMapFile (1, 1) string = "instrument"

        % The topic ID for the CSH page shown in hardware manager while the
        % user is entering parameters.
        IvidevTopicID (1, 1) string = "ividevappNonEnumcsh"

        % Name and tooltip for the configure hardware button in the app launch page.
        IvidevDescriptorName (1, 1) string = message("ividevapp:ividevapp:DescriptorName").string
        IvidevTooltipText (1, 1) string = message("ividevapp:ividevapp:DescriptorTooltip").string

        SupportedInteraces = ["TCP/IP VXI-11", "TCP/IP HiSLIP", "TCP/IP Socket"]
    end

    %% Lifetime
    methods
        function obj = NonEnumDescriptor()
            import ividevapp.NonEnumDescriptor
            obj@ividevapp.BaseDescriptor( ...
                NonEnumDescriptor.IvidevDescriptorName, ...
                NonEnumDescriptor.InstrumentMapFile, ...
                NonEnumDescriptor.IvidevTopicID, ...
                NonEnumDescriptor.IvidevTooltipText);
        end
    end

    %% Modal Dialog interaction functions
    methods (Access = {?matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin, ...
            ?matlabshared.transportapp.internal.utilities.ITestable})
        function setIdentificationProperties(obj, paramMap)
            % Populate the ividevapp modal dialog instance. This is
            % done when exporting the contents from the generate
            % resource modal window.

            arguments
                obj
                paramMap containers.Map
            end

            if isempty(obj.VisaIdentificationForm)
                return
            end

            % Update the Resource field in the ividevapp toolstrip with the
            % value confirmed from the modal dialog window.
            value = paramMap("ResourceName");
            value.NewValue = obj.VisaIdentificationForm.ResourceName;
            paramMap("ResourceName") = value; %#ok<*NASGU>
        end
    end

    %% Configuration tab parameter handler functions
    methods
        function val = interfaceValuesFcn(obj, ~)
            % Return the list of interfaces for the interfaces drop-down.
            val = obj.SupportedInteraces;
        end

        function val = generateResourceNameChangeFcn(obj, paramMap)
            % Returns the updated Resource Name by removing extra spaces
            % and quotes around the resource name value.
            elem = paramMap("ResourceName");
            val = stripQuotesAndSpaces(obj, elem.NewValue);
        end
    end
end
