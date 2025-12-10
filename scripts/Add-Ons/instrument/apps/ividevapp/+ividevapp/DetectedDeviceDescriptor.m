classdef DetectedDeviceDescriptor < ividevapp.BaseDescriptor
    %DETECTEDDEVICEDESCRIPTOR is the descriptor class for enumerable
    % devices in the ividevapp.

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (Constant)
        % Path to the map file for the CSH page to be shown in hardware
        % manager while the user is entering parameters.
        InstrumentMapFile (1, 1) string = "instrument"

        % The topic ID for the CSH page shown in hardware manager while the
        % user is entering parameters.
        IvidevTopicID (1, 1) string = "ividevappcsh"

        % Name and tooltip for the configure hardware button in the app launch page.
        IvidevDescriptorName (1, 1) string = message("ividevapp:ividevapp:DetectedDeviceDescriptorName").string
        IvidevTooltipText (1, 1) string = message("ividevapp:ividevapp:DescriptorTooltip").string
    end

    %% Lifetime
    methods
        function obj = DetectedDeviceDescriptor()
            import ividevapp.DetectedDeviceDescriptor
            obj@ividevapp.BaseDescriptor( ...
                DetectedDeviceDescriptor.IvidevDescriptorName, ...
                DetectedDeviceDescriptor.InstrumentMapFile, ...
                DetectedDeviceDescriptor.IvidevTopicID, ...
                DetectedDeviceDescriptor.IvidevTooltipText);
        end

        % HWMGR method to configure devices after setting values using
        % descriptor. This function is called by HWMGR after user confirms
        % parameters in DetectedDeviceDescriptor.
        % Input Parameters:
        %   obj -> current object
        %   device -> HWMGR device which needs to be configured.
        %   paramValMap -> Map of descriptor fields and its values.
        function device = configureHwmgrDevice(obj, device, ~)
            device.CustomData.VendorDriver = obj.IvidevObjForm.VendorDriver;
            device.CustomData.Params = obj.IvidevObjForm.Params;
            device.CustomData.NVPairsChanged = obj.IvidevObjForm.NVPairsChanged;
            vendorDriverInfo = [message("ividevapp:ividevapp:Driver").string, device.CustomData.VendorDriver];

            if isempty(device.DeviceCardDisplayInfo) || ~all(ismember(vendorDriverInfo, device.DeviceCardDisplayInfo))
                device.DeviceCardDisplayInfo = [device.DeviceCardDisplayInfo; vendorDriverInfo];
            end

            device.DeviceEnumerableConfigData.NeedsConfiguration = false;
        end

        function val = deviceDetailsFcn(obj, ~, info)
            % VALUESFCN for populating the device ResourceName, Model or
            % SerialNumber on the toolstrip.

            arguments
                obj
                ~
                info (1, 1) string {mustBeMember(info, ["ResourceName", "Model", "SerialNumber"])}
            end

            val = obj.CurrentDevice.CustomData.(info);
        end
    end
end