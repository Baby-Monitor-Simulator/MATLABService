classdef UdpportDeviceProvider < matlab.hwmgr.internal.DeviceProviderBase
    %  UDPPORTDEVICEPROVIDER implements DeviceProviderBase abstract methods
    %  to return enumerable and non-enumerable devices. udpports are
    %  non-enumerable, and device parameters must be supplied.

    % Copyright 2021-2023 The MathWorks, Inc.

    %% Properties
    properties(Access = {?matlabshared.transportapp.internal.utilities.ITestable})
        Mediator

        % Descriptor used to describe the App's modal tab.
        UdpportDescriptor
    end

    properties (Constant)
        % Section label for configuring communication properties.
        PropertiesSection char = message("transportapp:udpportapp:PropertiesSection").getString();

        % Section label for configuring local endpoint properties.
        LocalSection char = message("transportapp:udpportapp:LocalSection").getString();

        % Section label for configuring remote endpoint properties.
        DestinationSection char = message("transportapp:udpportapp:DestinationSection").getString();
    end

    %% Abstract Method Implementation
    methods
        function devices = getDevices(~)
            % Returns the list empty list, UDP ports are non-enumerable devices
            devices = [];
        end

        function descriptor = getDeviceParamDescriptors(obj)
            % Returns a UdpportDeviceParamDescriptor object which
            % describes the UDP port device

            % If deviceParamDescriptor has not been created, create it.
            if isempty(obj.UdpportDescriptor)
                createUdpportDeviceDescriptor(obj);
            end

            descriptor = obj.UdpportDescriptor;
        end
    end

    %% Helper Methods
    methods(Access = {?matlabshared.transportapp.internal.utilities.ITestable})

        function createUdpportDeviceDescriptor(obj)
            % createUdpportDeviceDescriptor creates and connects the App's
            % Mediator, and instantiates the UdpportDeviceDescriptor.

            obj.Mediator = matlabshared.mediator.internal.Mediator;

            obj.UdpportDescriptor = createDescriptor(obj);

            obj.Mediator.connect;
        end

        function udpportDescriptor = createDescriptor(obj)
            % udpportDescriptor creates the Udpport Device Descriptor.

            udpportDescriptor = transportapp.udpport.internal.UdpportDescriptor( ...
                obj.Mediator, message("transportapp:udpportapp:DescriptorCardName").getString());

            udpportDescriptor = addParametersToDescriptor(obj, udpportDescriptor);
        end

        function udpportDescriptor = addParametersToDescriptor(obj, udpportDescriptor)
            % addParametersToDescriptor is used to populate device configuration tab parameters.
            % It adds the following fields:
            %   1) CommunicationMode (Byte Stream/Datagram)      (DropDown)
            %   2) IPAddressVersion (IPV4/IPV6)                 (DropDown)
            %   3) EnablePortSharing                            (DropDown)
            %   4) Address                                      (EditableDropDown)
            %   5) Port                                         (EditableDropDown)
            %
            %   These properties are sent to the property inspector
            %   instead of being used in the constructor. This is to make
            %   it obvious to the user what information they need to provide
            %   to immediately start communicating with a device.
            %
            %   6) DestinationAddress                           (EditableDropDown)
            %   7) DestinationPort                              (EditableDropDown)

            % Hardware manager allows a max of 3 fields per column.
            % Fills up each column in a first-come, first-served basis.

            %% Communication Section

            % Function handle for generating Label names for the modal tab
            % elements.
            generateLabel = @(labelName) message("transportapp:udpportapp:" + labelName).getString;

            udpportDescriptor.addParameter('CommunicationMode', generateLabel("CommunicationModeLabel"), ...
                'DropDown', @udpportDescriptor.communicationModeValuesFcn, ...
                function_handle.empty, obj.PropertiesSection);

            udpportDescriptor.addParameter('IPAddressVersion', generateLabel("IPVersionLabel"), 'DropDown', ...
                @udpportDescriptor.ipAddressVersionValuesFcn, function_handle.empty, obj.PropertiesSection);

            udpportDescriptor.addParameter('EnablePortSharing', generateLabel("PortSharingLabel"), 'DropDown', ...
                @udpportDescriptor.enablePortSharingValuesFcn, function_handle.empty, obj.PropertiesSection);

            %% Local Section
            udpportDescriptor.addParameter('LocalHost', generateLabel("LocalAddressLabel"), 'EditableDropDown', ...
                @udpportDescriptor.localHostValuesFcn, function_handle.empty, obj.LocalSection);

            udpportDescriptor.addParameter('LocalPort', generateLabel("LocalPortLabel"), 'EditableDropDown', ...
                @udpportDescriptor.localPortValuesFcn, function_handle.empty, obj.LocalSection);

            %% Destination Section
            udpportDescriptor.addParameter('DestinationAddress', generateLabel("DestinationAddressLabel"), ...
                'EditableDropDown', @udpportDescriptor.destinationAddressValuesFcn, ...
                function_handle.empty, obj.DestinationSection);

            udpportDescriptor.addParameter('DestinationPort', generateLabel("DestinationPortLabel"), ...
                'EditableDropDown', @udpportDescriptor.destinationPortValuesFcn, ...
                function_handle.empty, obj.DestinationSection);
        end
    end
end
