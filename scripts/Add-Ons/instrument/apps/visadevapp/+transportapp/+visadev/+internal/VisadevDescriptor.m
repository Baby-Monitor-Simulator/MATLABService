classdef VisadevDescriptor < matlab.hwmgr.internal.DeviceParamsDescriptor & ...
        matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin & ...
        matlabshared.testmeasapps.internal.dialoghandler.DescriptorDialogCompatibleMixin & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogMixin  & ...
        matlabshared.testmeasapps.internal.ITestable 

    %VISADEVDESCRIPTOR is the the descriptor class for the Visa Explorer
    %app.

    % Copyright 2022-2023 The MathWorks, Inc.

    properties (Constant)
        % Name of product Map file.
        InstrumentMapFile (1, 1) string = "instrument"

        % The topic ID for the CSH page shown in hardware manager while the
        % user is entering parameters
        VisadevTopicID (1, 1) string = "visdevappcsh"
        VisadevTooltipText (1, 1) string = message("transportapp:visadevapp:DescriptorTooltip").getString
        VisadevDescriptorName (1, 1) string = message("transportapp:visadevapp:DescriptorName").getString

        AllInterfaceTypes = transportapp.visadev.internal.VisadevDescriptor.getInterfaceType()
        GenerateResourceType = transportapp.visadev.internal.VisadevDescriptor.getTCPIPResourceTypes()

        FieldIDToFieldName = dictionary(["ResourceName", "Identification"], ... % Keys
            ["ResourceName", "IdentificationName"] ... % Values
            );

        DefaultIdentificationString (1, 1) string = message("transportapp:visadevapp:DefaultIdentificationString").string

        DeviceCardIcon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient", ...
            "VisaDeviceCard_Descriptor")
    end
 
    properties
        % Once the "Confirm Parameters" button is pressed, this contains
        % the visa identification details.
        FinalConnectionInfo matlabshared.transportapp.internal.visamodaldialog.ConnectionIdentificationForm = ...
            matlabshared.transportapp.internal.visamodaldialog.ConnectionIdentificationForm.empty
    end

    %% Lifetime
    methods
        function obj = VisadevDescriptor()
            import transportapp.visadev.internal.VisadevDescriptor
            mediator = matlabshared.mediator.internal.Mediator();
            obj@matlab.hwmgr.internal.DeviceParamsDescriptor( ...
                VisadevDescriptor.VisadevDescriptorName, ...
                VisadevDescriptor.InstrumentMapFile, ...
                VisadevDescriptor.VisadevTopicID, ...
                VisadevDescriptor.VisadevTooltipText);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogMixin(mediator);
            obj.DisplayName = getString(message("transportapp:visadevapp:DisplayName"));
        end
    end

    %% Implementing Abstract Methods from DeviceParamsDescriptor
    methods
        function validateParams(obj, paramMap)
            % Final validation when Confirm Parameters is pressed.

            checkEmptyField(obj, paramMap, "ResourceName", obj.FieldIDToFieldName("ResourceName"));

            % Get the resource name and identification details for the Visa
            % Resource.
            resourceStr = string(paramMap("ResourceName").NewValue);
            identificationStr = string(paramMap("Identification").NewValue);

            % For an empty identification string, we still want to test out
            % a visadev connection to get the model, vendor, and alias
            % information. For this case, use the default identification
            % string "*IDN?".
            if identificationStr == ""
                identificationStr = obj.DefaultIdentificationString;
            end

            vIdentification = transportapp.visadev.internal.VisadevIdentification;
            form = vIdentification.identify(resourceStr, identificationStr);

            if ~isempty(form.Error)
                throwAsCaller(form.Error);
            end

            obj.FinalConnectionInfo = form;
        end

        function device = createHwmgrDevice(obj, ~)
            % Create the hardware manager device for the configured visadev
            % resource.

            device = transportapp.visadev.internal.VisadevIdentification.getHwMgrDevice ...
                (obj.FinalConnectionInfo);
        end

        function icon = getIcon(obj)
            icon = obj.DeviceCardIcon;
        end
    end

    %% Modal Dialog Interaction Methods
    methods
        function newVal = identificationFcn(obj, paramMap)
            % Returns the updated Identification String by removing extra
            % spaces and quotes around the value. Also, sets the field
            % value to "*IDN?" if set to empty.

            elem = paramMap("Identification");
            newVal = stripQuotesAndSpaces(obj, elem);

            % Set the value to *IDN? when the field is empty
            if newVal == ""
                newVal = obj.DefaultIdentificationString;
            end
        end

        function val = interfaceValuesFcn(obj, ~)
            % Return the list of interfaces for the interfaces drop-down.

            val = obj.AllInterfaceTypes;
        end

        function flag = generateResourceNameEnableFcn(obj, paramMap)
            % Enable/Disable the "Generate Resource Name" button.

            flag = any(paramMap("Interface").NewValue == obj.GenerateResourceType);
        end

        function val = testConnectionValuesFcn(obj, paramMap)
            % When the test connection button is pressed.

            cleanup = onCleanup(@()obj.cleanupProperties);
            val = [];
            try
                % Error if the Resource Name or Identification fields are
                % empty.
                validateEmptyUserFields(obj, paramMap)
            catch ex
                handleErrorProxy(obj, ex);
                return
            end

            obj.setAppStateBusy();

            rsrc = paramMap("ResourceName");
            resourceString = string(rsrc.NewValue);

            identification = paramMap("Identification");
            identificationString = string(identification.NewValue);

            % Attempt to get the Visa Identification properties from the
            % resource string.
            vIdentify = transportapp.visadev.internal.VisadevIdentification;
            form = vIdentify.identify(resourceString, identificationString);

            obj.VisaIdentificationForm = form;
            obj.setIdentificationProperties(paramMap);

            if ~isempty(obj.VisaIdentificationForm.Error)
                handleErrorProxy(obj, form.Error);
            end
        end

        function val = generateResourceNameChangeFcn(obj, paramMap)
            % Returns the updated Resource Name by removing extra spaces
            % and quotes around the resource name value.

            elem = paramMap("ResourceName");
            val = stripQuotesAndSpaces(obj, elem);
        end
    end

    %% Private Helper Methods
    methods (Access = {?matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin, ...
            ?matlabshared.transportapp.internal.utilities.ITestable})

        function val = stripQuotesAndSpaces(~, elem)
            val = string(elem.NewValue);

            % Remove quotes from around the string.
            val = replace(val, ["'", """"], "");

            % Remove trailing and leading whitespaces
            val = strip(val);
        end

        function validateEmptyUserFields(obj, paramMap)
            % Validate that the resource name and identification strings
            % are not empty.

            allFields = obj.FieldIDToFieldName.keys';
            for fieldName = allFields
                checkEmptyField(obj, paramMap, fieldName, obj.FieldIDToFieldName(fieldName));
            end
        end

        function checkEmptyField(~, paramMap, name, resourceCatalogFieldName)
            % Check whether a given modal tab UI element's (defined by
            % "name") value is empty. If empty, this method throws an
            % error. The "resourceCatalogFieldName" is the UI element's
            % name to be queried from the resource catalog in case of the
            % error.
            arguments
                ~
                paramMap containers.Map
                name (1, 1) string
                resourceCatalogFieldName (1, 1) string
            end

            field = paramMap(name);
            if string(field.NewValue) == ""
                fieldName = message("transportapp:visadevapp:" + resourceCatalogFieldName).string;
                throwAsCaller(MException(message("transportapp:visadevapp:EmptyTestField", fieldName)));
            end
        end

        function setIdentificationProperties(obj, paramMap)
            % Populate the Visa Explorer modal dialog instance. This is
            % done either when -
            % 1. Exporting the contents from the generate
            % resource modal window, or
            %
            % 2. The test connection button is
            % pressed on the visa explorer app's toolstrip.
            %
            % It populates the contents of the modal tab Test Connection
            % section with the contents of the VisaIdentificationForm
            % object.

            arguments
                obj
                paramMap containers.Map
            end

            if isempty(obj.VisaIdentificationForm)
                return
            end

            % Populate the Model, Vendor, Resource Name, and Identification
            % fields
            fieldsToSet = ["Model", "Vendor", "ResourceName", "Identification"];
            for f = fieldsToSet
                value = paramMap(f);
                value.NewValue = obj.VisaIdentificationForm.(f);
                paramMap(f) = value;
            end

            % Populate the Connection Status field.
            if isempty(obj.VisaIdentificationForm.Error)
                status = "Success";
            else
                status = "Failed";
            end

            status = string(message("transportapp:visadevapp:" + status).getString);
            connectedField = paramMap("ConnectionStatus");
            connectedField.NewValue = status;
            paramMap("ConnectionStatus") = connectedField; %#ok<*NASGU>
        end
    end



    %% Static Helper Methods
    methods (Static)
        function types = getInterfaceType()
            % Get a list of all interface types.

            interfaceTypes = ["VXI11", "HiSlip", "Socket", "USB", "GPIB", "Serial", "VXI", "PXI"];
            types = matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin.getTypes(interfaceTypes);
        end

        function types = getTCPIPResourceTypes()
            % Get a list of all TCP/IP interface types that support
            % resource generation.

            interfaceTypes = ["VXI11", "HiSlip", "Socket"];
            types = matlabshared.transportapp.internal.visamodaldialog.ModalDialogMixin.getTypes(interfaceTypes);
        end
    end
end
