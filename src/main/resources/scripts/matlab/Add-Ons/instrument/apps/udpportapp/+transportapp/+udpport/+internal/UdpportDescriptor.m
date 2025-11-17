classdef UdpportDescriptor < matlab.hwmgr.internal.DeviceParamsDescriptor & ...
        matlabshared.testmeasapps.internal.dialoghandler.DescriptorDialogCompatibleMixin & ...
        matlabshared.mediator.internal.Publisher & ...
        matlabshared.testmeasapps.internal.dialoghandler.DialogMixin

    % UDPPORTDESCRIPTOR defines the modal tab of the UDP App. It validates
    % the hardware parameters provided by the user, create the Hardware
    % Manager Device used by Hwmgr to represent the UDP transport object.

    % Copyright 2021-2024 The MathWorks, Inc.

    %% Properties
    properties (Constant)
        % Define options for dropdown lists and default options for
        % editabledropdowns.
        %
        % NOTE: The casting of messages to strings is required to avoid the
        % concatenation of the resource text, which are returned as char
        % arrays.

        CommunicationModeOptions (1,2) string = [...
            string(message("transportapp:udpportapp:ByteMode").getString), ...
            string(message("transportapp:udpportapp:DatagramMode").getString)]
        IPAddressVersionOptions (1,2) string = ["IPV4", "IPV6"]

        EnabledValue (1,1) string = message("transportapp:udpportapp:Enabled").getString
        DisabledValue (1,1) string = message("transportapp:udpportapp:Disabled").getString
        AutoValue (1,1) string = message("transportapp:udpportapp:Auto").getString
        OptionalValue (1,1) string = message("transportapp:udpportapp:Optional").getString

        EnablePortSharingOptions (1,2) string = [transportapp.udpport.internal.UdpportDescriptor.DisabledValue, ...
            transportapp.udpport.internal.UdpportDescriptor.EnabledValue]

        % Both LocalHost and LocalPort are populated with an
        % "Auto" string until the user provides a valid input.
        LocalHostDefault char = transportapp.udpport.internal.UdpportDescriptor.AutoValue
        LocalPortDefault char = transportapp.udpport.internal.UdpportDescriptor.AutoValue

        % Both Destination Field and Destination Port are populated with an
        % "Optional" string until the user provides a valid input.
        DestinationAddressDefault char = transportapp.udpport.internal.UdpportDescriptor.OptionalValue
        DestinationPortDefault char = transportapp.udpport.internal.UdpportDescriptor.OptionalValue

        % The maximum number of user provided values to retain during the
        % lifetime of the app.
        MaxCustomValues = 4

        DeviceCardIcon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient", "UDPDeviceCard")
    end

    properties(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        LocalHostList cell
        LocalPortList cell
        DestinationAddressList cell
        DestinationPortList cell
        Flag logical = true
    end

    %% Lifetime
    methods
        function obj = UdpportDescriptor(mediator, name)
            import transportapp.udpport.internal.DescriptorProperties

            narginchk(2,2);

            obj@matlabshared.mediator.internal.Publisher(mediator);
            obj@matlabshared.testmeasapps.internal.dialoghandler.DialogMixin(mediator);

            obj@matlab.hwmgr.internal.DeviceParamsDescriptor( ...
                name, ...
                DescriptorProperties.MapFile, ...
                DescriptorProperties.TopicID, ...
                DescriptorProperties.TooltipText, ...
                DescriptorProperties.Enabled);
            obj.DisplayName = getString(message("transportapp:udpportapp:DeviceCardName"));
        end
    end

    %% Abstract Method Implementation - Required by hwmgr DeviceParamsDescriptor
    methods

        function validateParams(obj, paramMap)
            % This function is called internally by Hardware Manager when
            % the "Confirm" button is clicked. If this method errors,
            % the Udpport object is not created and the user is returned to
            % the Modal Tab instead of entering the app.

            import transportapp.udpport.internal.DescriptorValidator

            % Check that no fields are left empty.
            isEmpty = DescriptorValidator.isFieldEmpty(paramMap);
            if isEmpty
                % Throw error to prevent entering the main app.
                throw(MException(message("transportapp:udpportapp:FieldsEmpty")));
            end

            [~, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "LocalHost", "transportapp:udpportapp:InvalidIPAddress", obj.LocalHostDefault);

            if ~isempty(ex)
                throw(ex);
            end

            [~, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "LocalPort", "transportapp:udpportapp:InvalidPort", obj.LocalPortDefault);

            if ~isempty(ex)
                throw(ex);
            end

            [~, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "DestinationAddress", "transportapp:udpportapp:InvalidIPAddress", obj.DestinationAddressDefault);

            if ~isempty(ex)
                throw(ex);
            end

            [~, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "DestinationPort", "transportapp:udpportapp:InvalidPort", obj.DestinationPortDefault);

            if ~isempty(ex)
                throw(ex);
            end

            % Create a udpport instance to validate the parameters. Each
            % field is validated in isolation by a callback function, this
            % is to check that the udpport can be instantiated.
            ex =  DescriptorValidator.validateUdpport( ...
                paramMap("IPAddressVersion").NewValue, ...
                paramMap("LocalHost").NewValue, ...
                paramMap("LocalPort").NewValue, ...
                obj.isPortSharingEnabled(paramMap));

            if ~isempty(ex)
                % Throw error to prevent entering the main app.
                throw(ex);
            end
        end

        function device = createHwmgrDevice(obj, paramMap)
            % Create the HwmgrDevice used to represent the transport
            % object. Custom properties of the HwMgrDevice are available
            % to the UDP App.

            import transportapp.udpport.internal.DescriptorValidator

            device = matlab.hwmgr.internal.Device(obj.DisplayName);

            device.IconID = obj.DeviceCardIcon;

            % Extract the transport properties from the parameter map.
            hostString = string(paramMap("LocalHost").NewValue);
            portString = string(paramMap("LocalPort").NewValue);
            ipAddressVersionString = string(paramMap("IPAddressVersion").NewValue);
            enablePortSharingValue = obj.isPortSharingEnabled(paramMap);
            communicationMode = string(paramMap("CommunicationMode").NewValue);

            % Populate Device Card Display Info
            device.DeviceCardDisplayInfo = [ ...
                [message("transportapp:udpportapp:DeviceCardCommunicationMode").getString(), communicationMode]; ...
                [message("transportapp:udpportapp:DeviceCardLocalHost").getString(), hostString]; ...
                [message("transportapp:udpportapp:DeviceCardLocalPort").getString(), portString]; ...
                ];

            if communicationMode == obj.CommunicationModeOptions(1)
                modeString = "byte";
            else
                modeString = "datagram";
            end

            % Populate Device Custom Info. These properties are available
            % to the UDP App and are used to construct the app components.
            device.CustomData.TransportProperties.CommunicationMode = modeString;
            device.CustomData.TransportProperties.IPAddressVersion = ipAddressVersionString;
            device.CustomData.TransportProperties.LocalHost = hostString;
            device.CustomData.TransportProperties.LocalPort = portString;
            device.CustomData.TransportProperties.EnablePortSharing = enablePortSharingValue;

            % Check if values are optional and substitute blank strings.
            if DescriptorValidator.isOptional(paramMap("DestinationAddress").NewValue)
                device.CustomData.TransportProperties.DestinationAddress = "";
            else
                device.CustomData.TransportProperties.DestinationAddress = string( ...
                    paramMap("DestinationAddress").NewValue);
            end

            if DescriptorValidator.isOptional(paramMap("DestinationPort").NewValue)
                device.CustomData.TransportProperties.DestinationPort = "";
            else
                device.CustomData.TransportProperties.DestinationPort = string( ...
                    paramMap("DestinationPort").NewValue);
            end

            device.DeviceAppletData = matlab.hwmgr.internal.data.DataFactory.createDeviceAppletData("transportapp.udpport.internal.UdpportApp","IC");
        end

        function icon = getIcon(~)
            % Returns the icon used in HardwareManager's device selection
            % menu.
            icon = matlabshared.testmeasapps.internal.themeableiconrepository.IconRepository.getIcon("hwmgrclient","UDPDeviceCard_Descriptor");
        end
    end

    %% Callback validation Functions
    methods
        function value = communicationModeValuesFcn(obj, paramMap)
            % Returns the two communication mode options to populate a
            % dropdown list: "Byte Stream" or "Datagram".
            if isempty(paramMap("CommunicationMode").NewValue)
                value = obj.CommunicationModeOptions;
            else
                value.Value = paramMap("CommunicationMode").NewValue;
                value.List = obj.CommunicationModeOptions;
            end
        end

        function value = ipAddressVersionValuesFcn(obj, paramMap)
            % Returns the two IPAddress versions to populate the
            % IPAddressVersion dropdown list: "IPV4"or "IPV6".
            if isempty(paramMap("IPAddressVersion").NewValue)
                value = obj.IPAddressVersionOptions;
            else
                value.Value = paramMap("IPAddressVersion").NewValue;
                value.List = obj.IPAddressVersionOptions;
            end
        end

        function value = enablePortSharingValuesFcn(obj, paramMap)
            % Returns the two EnablePortSharingValues to populate the
            % EnablePortSharing dropdown list: "Disabled" or "Enabled".
            if isempty(paramMap("EnablePortSharing").NewValue)
                value = obj.EnablePortSharingOptions;
            else
                value.Value = paramMap("EnablePortSharing").NewValue;
                value.List = obj.EnablePortSharingOptions;
            end
        end

        function value = destinationAddressValuesFcn(obj, paramMap)
            % Returns a struct containing a valid IP address and a list of
            % previously entered destinationAddress values.

            newValue = paramMap("DestinationAddress").NewValue;

            newValue = replace(newValue, ["""", "''"], "");
            value = obj.getEditableDropDownValue("DestinationAddressList", ...
                newValue, obj.DestinationAddressDefault);
        end

        function value = localHostValuesFcn(obj, paramMap)
            % Returns a struct containing a valid IP address and a list of
            % previously entered localhost values.
            newValue = paramMap("LocalHost").NewValue;
            newValue = replace(newValue, ["""", "''"], "");
            value = obj.getEditableDropDownValue("LocalHostList", newValue, obj.LocalHostDefault);
        end

        function value = localPortValuesFcn(obj, paramMap)
            % Returns a struct containing a valid port value and a list of
            % previously entered localport values.
            import transportapp.udpport.internal.DescriptorValidator

            [value, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "LocalPort", "transportapp:udpportapp:InvalidPort", obj.LocalPortDefault);

            if ~isempty(ex)
                handleErrorProxy(obj, ex);
            end

            value = obj.getEditableDropDownValue("LocalPortList", value, obj.LocalPortDefault);
        end

        function value = destinationPortValuesFcn(obj, paramMap)
            % Returns a struct containing a valid port value and a list of
            % previously entered localport values.

            import transportapp.udpport.internal.DescriptorValidator
            [value, ex] = DescriptorValidator.validateEditField(paramMap, ...
                "DestinationPort", "transportapp:udpportapp:InvalidPort", obj.DestinationPortDefault);

            if ~isempty(ex)
                handleErrorProxy(obj, ex);
            end
            value = obj.getEditableDropDownValue("DestinationPortList", ...
                value, obj.DestinationPortDefault);
        end
    end

    %% Helper Functions
    methods
        function value = getEditableDropDownValue(obj, listProperty, newValue, defaultValue)
            % Returns a stuct with two fields: Value (the value to populate
            % the edit field with), and List (the list of values to
            % populate the dropdown list).
            arguments
                obj
                listProperty char
                newValue char
                defaultValue char
            end

            if isempty(newValue) || isequal(newValue, defaultValue)
                % If the new value is empty or the default value, only add the
                % default value once to the dropdown list to avoid
                % redundant entries.
                value.Value = defaultValue;
                value.List = [defaultValue, obj.(listProperty)];
            else
                % If the new value is not the default value, add both the new
                % value and the default value to the front of the list.
                value.Value = newValue;

                % Add the new value to the dropdown list. Because the
                % new value is the first element in the list, use every
                % element but the first one to populate the remainder of
                % the dropdown list.
                obj.(listProperty) = obj.addValueToList(newValue, obj.(listProperty));
                value.List = [newValue, defaultValue, obj.(listProperty)(2:end)];
            end
        end

        function valueList = addValueToList(~, newValue, valueList)
            % Add the new value to the provided value list. If the value
            % is currently in the valueList, move it to the front of the
            % list.
            arguments
                ~
                newValue char
                valueList cell
            end

            if isempty(valueList)
                valueList = {newValue};
                return
            end

            % Add the newValue to the front of the list, and use unique
            % with the 'stable' parameter to ensure that only the first
            % instance of each value is saved.
            valueList = unique([newValue, valueList], "stable");

            % Truncate the list if the number of elements in the new list
            % is larger than the maximum number of elements defined by
            % MaxCustomValues.
            maxSize = min([transportapp.udpport.internal.UdpportDescriptor.MaxCustomValues,...
                numel(valueList)]);

            valueList = valueList(1:maxSize);
        end

        function value = isPortSharingEnabled(obj, paramMap)
            % Translates string input from EnablePortSharing field to
            % logical. Checkboxes are not currently available in the device
            % descriptor, so all user input is of type string

            value = string(paramMap("EnablePortSharing").NewValue) ...
                == obj.EnabledValue;
        end
    end
end
